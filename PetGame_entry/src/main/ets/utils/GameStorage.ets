/**
 * 游戏多存档管理工具
 * 支持创建、加载、删除、切换多个存档
 */

import preferences from '@ohos.data.preferences';

// 存档元数据（用于存档列表显示）
export interface SaveSlot {
  id: number;                    // 存档ID
  name: string;                  // 存档名称
  createTime: number;            // 创建时间
  lastSaveTime: number;          // 最后保存时间
  petType: string;               // 宠物类型
  growthStage: string;           // 成长阶段
  gameState: string;             // 游戏状态
}

// 完整游戏数据
export interface GameData {
  gameState: string;
  petType: string;
  selectedEgg: string;
  growthStage: string;
  hunger: number;
  happiness: number;
  coins: number;
  ownedSkins: number[];
  currentSkinId: number;
  incubateStartTime: number;
  incubateProgress: number;
  isSleeping: boolean;
  lastSaveTime: number;
}

export class GameStorage {
  private static INSTANCE: GameStorage | null = null;
  private context: Context | null = null;
  private metaPreferences: preferences.Preferences | null = null;
  private currentSaveId: number = -1; // 当前存档ID
  
  static getInstance(): GameStorage {
    if (!GameStorage.INSTANCE) {
      GameStorage.INSTANCE = new GameStorage();
    }
    return GameStorage.INSTANCE;
  }
  
  // 初始化
  async init(context: Context): Promise<void> {
    try {
      this.context = context;
      // 加载存档元数据
      this.metaPreferences = await preferences.getPreferences(context, 'save_meta');
      console.log('=== GameStorage初始化成功 ===');
    } catch (error) {
      console.error('=== GameStorage初始化失败: ' + JSON.stringify(error) + ' ===');
    }
  }
  
  // 获取所有存档列表
  async getSaveList(): Promise<SaveSlot[]> {
    if (!this.metaPreferences) {
      return [];
    }
    
    try {
      const saveListStr = await this.metaPreferences.get('saveList', '[]') as string;
      const saveList: SaveSlot[] = JSON.parse(saveListStr);
      // 按最后保存时间倒序排列
      saveList.sort((a, b) => b.lastSaveTime - a.lastSaveTime);
      return saveList;
    } catch (error) {
      console.error('=== 获取存档列表失败: ' + JSON.stringify(error) + ' ===');
      return [];
    }
  }
  
  // 创建新存档
  async createNewSave(saveName: string): Promise<number> {
    if (!this.metaPreferences || !this.context) {
      return -1;
    }
    
    try {
      const saveList = await this.getSaveList();
      
      // 生成新存档ID（使用时间戳）
      const newId = Date.now();
      
      // 创建存档元数据
      const newSlot: SaveSlot = {
        id: newId,
        name: saveName,
        createTime: newId,
        lastSaveTime: newId,
        petType: 'Octo',
        growthStage: 'baby',
        gameState: 'intro'
      };
      
      // 添加到存档列表
      saveList.push(newSlot);
      await this.metaPreferences.put('saveList', JSON.stringify(saveList));
      await this.metaPreferences.flush();
      
      console.log('=== 创建新存档成功: id=' + newId + ', name=' + saveName + ' ===');
      return newId;
    } catch (error) {
      console.error('=== 创建新存档失败: ' + JSON.stringify(error) + ' ===');
      return -1;
    }
  }
  
  // 删除存档
  async deleteSave(saveId: number): Promise<boolean> {
    if (!this.metaPreferences || !this.context) {
      return false;
    }
    
    try {
      // 从存档列表中移除
      const saveList = await this.getSaveList();
      const newList = saveList.filter(slot => slot.id !== saveId);
      
      await this.metaPreferences.put('saveList', JSON.stringify(newList));
      await this.metaPreferences.flush();
      
      // 删除存档数据
      const prefs = await preferences.getPreferences(this.context, 'save_' + saveId);
      await prefs.clear();
      await prefs.flush();
      
      console.log('=== 删除存档成功: id=' + saveId + ' ===');
      return true;
    } catch (error) {
      console.error('=== 删除存档失败: ' + JSON.stringify(error) + ' ===');
      return false;
    }
  }
  
  // 设置当前存档
  setCurrentSave(saveId: number): void {
    this.currentSaveId = saveId;
    console.log('=== 设置当前存档: id=' + saveId + ' ===');
  }
  
  // 获取当前存档ID
  getCurrentSaveId(): number {
    return this.currentSaveId;
  }
  
  // 保存游戏数据到当前存档
  async saveGameData(data: GameData): Promise<void> {
    if (!this.context || this.currentSaveId === -1) {
      console.error('=== 未设置当前存档 ===');
      return;
    }
    
    try {
      // 保存到存档文件
      const prefs = await preferences.getPreferences(this.context, 'save_' + this.currentSaveId);
      
      await prefs.put('gameState', data.gameState);
      await prefs.put('petType', data.petType);
      await prefs.put('selectedEgg', data.selectedEgg);
      await prefs.put('growthStage', data.growthStage);
      await prefs.put('hunger', data.hunger);
      await prefs.put('happiness', data.happiness);
      await prefs.put('coins', data.coins);
      await prefs.put('ownedSkins', data.ownedSkins.join(','));
      await prefs.put('currentSkinId', data.currentSkinId);
      await prefs.put('incubateStartTime', data.incubateStartTime);
      await prefs.put('incubateProgress', data.incubateProgress);
      await prefs.put('isSleeping', data.isSleeping);
      await prefs.put('lastSaveTime', Date.now());
      
      await prefs.flush();
      
      // 更新存档元数据
      await this.updateSaveMeta(data);
      
      console.log('=== 游戏数据保存成功 ===');
    } catch (error) {
      console.error('=== 保存游戏数据失败: ' + JSON.stringify(error) + ' ===');
    }
  }
  
  // 更新存档元数据
  private async updateSaveMeta(data: GameData): Promise<void> {
    if (!this.metaPreferences) {
      return;
    }
    
    try {
      const saveList = await this.getSaveList();
      const index = saveList.findIndex(slot => slot.id === this.currentSaveId);
      
      if (index !== -1) {
        saveList[index].lastSaveTime = Date.now();
        saveList[index].petType = data.petType;
        saveList[index].growthStage = data.growthStage;
        saveList[index].gameState = data.gameState;
        
        await this.metaPreferences.put('saveList', JSON.stringify(saveList));
        await this.metaPreferences.flush();
      }
    } catch (error) {
      console.error('=== 更新存档元数据失败: ' + JSON.stringify(error) + ' ===');
    }
  }
  
  // 从当前存档加载游戏数据
  async loadGameData(): Promise<GameData | null> {
    if (!this.context || this.currentSaveId === -1) {
      console.error('=== 未设置当前存档 ===');
      return null;
    }
    
    try {
      const prefs = await preferences.getPreferences(this.context, 'save_' + this.currentSaveId);
      
      const gameState = await prefs.get('gameState', 'intro') as string;
      
      // 如果是初始状态，说明是新存档
      if (gameState === 'intro') {
        console.log('=== 新存档，开始新游戏 ===');
        return null;
      }
      
      // 加载所有游戏数据
      const data: GameData = {
        gameState: gameState,
        petType: await prefs.get('petType', 'Octo') as string,
        selectedEgg: await prefs.get('selectedEgg', 'Octo') as string,
        growthStage: await prefs.get('growthStage', 'baby') as string,
        hunger: await prefs.get('hunger', 50) as number,
        happiness: await prefs.get('happiness', 50) as number,
        coins: await prefs.get('coins', 100) as number,
        ownedSkins: (await prefs.get('ownedSkins', '0') as string).split(',').map(s => parseInt(s)),
        currentSkinId: await prefs.get('currentSkinId', 0) as number,
        incubateStartTime: await prefs.get('incubateStartTime', 0) as number,
        incubateProgress: await prefs.get('incubateProgress', 0) as number,
        isSleeping: await prefs.get('isSleeping', false) as boolean,
        lastSaveTime: await prefs.get('lastSaveTime', 0) as number
      };
      
      console.log('=== 游戏数据加载成功: gameState=' + data.gameState + ' ===');
      return data;
    } catch (error) {
      console.error('=== 加载游戏数据失败: ' + JSON.stringify(error) + ' ===');
      return null;
    }
  }
}
