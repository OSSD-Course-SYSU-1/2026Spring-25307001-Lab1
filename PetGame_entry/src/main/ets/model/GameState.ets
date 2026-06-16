/**
 * 宠物养成游戏 - 状态管理模型
 */

import { PetType, GrowthStage, GameState as GState, DeviceType } from '../common/Constants';

// 序列化数据接口
interface PetSerializeData {
  petType: PetType;
  growthStage: GrowthStage;
  hunger: number;
  happiness: number;
  coins: number;
  feedCount: number;
  currentSkinId: number;
  ownedSkins: number[];
}

interface TimeSerializeData {
  totalGameTime: number;
  gameDays: number;
  gameHour: number;
}

interface FullSerializeData {
  pet: PetSerializeData;
  time: TimeSerializeData;
}

// ==================== 宠物数据模型 ====================
@Observed
export class PetData {
  // 宠物类型
  petType: PetType = PetType.OCTO;
  // 当前成长阶段
  growthStage: GrowthStage = GrowthStage.BABY;
  // 饥饿值 (0-100)
  hunger: number = 80;
  // 开心值 (0-100)
  happiness: number = 70;
  // 金币
  coins: number = 500;
  // 累计喂食次数
  feedCount: number = 0;
  // 当前穿戴的皮肤ID（0为原生）
  currentSkinId: number = 0;
  // 已拥有的皮肤ID列表
  ownedSkins: number[] = [0];
  // 是否在睡眠中
  isSleeping: boolean = false;
  // 游戏内时间（小时 0-23）
  gameHour: number = 8;
  
  // 计算是否处于低落状态
  isSad(): boolean {
    return this.hunger < 20 || this.happiness < 30;
  }
  
  // 计算是否处于兴奋状态
  isExcited(): boolean {
    return this.hunger > 70 && this.happiness > 80;
  }
}

// ==================== 游戏状态模型 ====================
@Observed
export class GameStatus {
  // 当前游戏状态
  currentState: GState = GState.INTRO;
  // 选中的宠物蛋类型
  selectedPetType: PetType = PetType.OCTO;
  // 孵化开始时间（现实时间戳）
  incubateStartTime: number = 0;
  // 孵化进度 (0-1)
  incubateProgress: number = 0;
  // 是否正在播放动画
  isAnimating: boolean = false;
  // 当前动画类型
  currentAnimation: string = '';
  // 设备类型
  deviceType: DeviceType = DeviceType.PHONE;
  // 屏幕宽度
  screenWidth: number = 360;
  // 屏幕高度
  screenHeight: number = 640;
  
  // 计算孵化是否完成
  isIncubateComplete(): boolean {
    return this.incubateProgress >= 1.0;
  }
}

// ==================== 动画状态模型 ====================
@Observed
export class AnimationState {
  // 当前缩放
  scale: number = 1.0;
  // X位移
  translateX: number = 0;
  // Y位移
  translateY: number = 0;
  // 旋转角度
  rotate: number = 0;
  // 透明度
  opacity: number = 1.0;
  // 是否显示爱心
  showHeart: boolean = false;
  // 爱心位置
  heartX: number = 0;
  heartY: number = 0;
  
  // 重置动画状态
  reset(): void {
    this.scale = 1.0;
    this.translateX = 0;
    this.translateY = 0;
    this.rotate = 0;
    this.opacity = 1.0;
    this.showHeart = false;
  }
}

// ==================== 弹窗状态模型 ====================
@Observed
export class PopupState {
  // 是否显示包裹弹窗
  showPackage: boolean = false;
  // 是否显示选蛋弹窗
  showSelectEgg: boolean = false;
  // 是否显示孵化器弹窗
  showIncubator: boolean = false;
  // 是否显示食物商店
  showFoodShop: boolean = false;
  // 是否显示皮肤商店
  showSkinShop: boolean = false;
  // 弹窗动画进度 (0-1, 用于滑入滑出)
  animationProgress: number = 0;
}

// ==================== 时间管理模型 ====================
@Observed
export class TimeManager {
  // 游戏启动时间（现实时间戳）
  gameStartTime: number = Date.now();
  // 累计游戏时间（现实毫秒）
  totalGameTime: number = 0;
  // 上次更新时间
  lastUpdateTime: number = Date.now();
  // 游戏内天数
  gameDays: number = 0;
  // 游戏内小时 (0-23)
  gameHour: number = 8; // 初始早上8点
  
  // 现实15分钟 = 游戏1天
  static readonly REAL_MS_PER_GAME_DAY: number = 15 * 60 * 1000;
  
  // 更新游戏时间
  update(): void {
    const now = Date.now();
    const elapsed = now - this.lastUpdateTime;
    this.lastUpdateTime = now;
    this.totalGameTime += elapsed;
    
    // 计算游戏内天数和小时
    const gameDaysTotal = this.totalGameTime / TimeManager.REAL_MS_PER_GAME_DAY;
    this.gameDays = Math.floor(gameDaysTotal);
    
    // 游戏内小时 = (天数小数部分 * 24)
    const dayProgress = gameDaysTotal - this.gameDays;
    this.gameHour = Math.floor(dayProgress * 24);
  }
  
  // 判断是否是睡眠时间 (22:00-06:00)
  isSleepTime(): boolean {
    return this.gameHour >= 22 || this.gameHour < 6;
  }
  
  // 获取格式化的游戏时间字符串
  getTimeString(): string {
    const hour = this.gameHour.toString().padStart(2, '0');
    return `${hour}:00`;
  }
}

// ==================== 全局游戏数据 ====================
/**
 * 【分布式流转说明】
 * 此类数据需要支持跨设备同步
 * 通过continuable配置实现数据接续
 */
@Observed
export class GlobalGameData {
  // 宠物数据
  pet: PetData = new PetData();
  // 游戏状态
  status: GameStatus = new GameStatus();
  // 动画状态
  animation: AnimationState = new AnimationState();
  // 弹窗状态
  popup: PopupState = new PopupState();
  // 时间管理
  time: TimeManager = new TimeManager();
  
  // 初始化新游戏
  initNewGame(petType: PetType): void {
    this.pet.petType = petType;
    this.pet.growthStage = GrowthStage.BABY;
    this.pet.hunger = 80;
    this.pet.happiness = 70;
    this.pet.coins = 500;
    this.pet.feedCount = 0;
    this.pet.currentSkinId = 0;
    this.pet.ownedSkins = [0];
    this.pet.isSleeping = false;
    this.status.currentState = GState.MAIN;
  }
  
  // 序列化数据（用于分布式流转）
  serialize(): string {
    const petData: PetSerializeData = {
      petType: this.pet.petType,
      growthStage: this.pet.growthStage,
      hunger: this.pet.hunger,
      happiness: this.pet.happiness,
      coins: this.pet.coins,
      feedCount: this.pet.feedCount,
      currentSkinId: this.pet.currentSkinId,
      ownedSkins: this.pet.ownedSkins
    };
    const timeData: TimeSerializeData = {
      totalGameTime: this.time.totalGameTime,
      gameDays: this.time.gameDays,
      gameHour: this.time.gameHour
    };
    const fullData: FullSerializeData = {
      pet: petData,
      time: timeData
    };
    return JSON.stringify(fullData);
  }
  
  // 反序列化数据（用于分布式流转接收）
  deserialize(jsonStr: string): void {
    try {
      const data: Record<string, Object> = JSON.parse(jsonStr) as Record<string, Object>;
      const petData = data['pet'] as Record<string, Object>;
      const timeData = data['time'] as Record<string, Object>;
      if (petData) {
        this.pet.petType = petData['petType'] as PetType;
        this.pet.growthStage = petData['growthStage'] as GrowthStage;
        this.pet.hunger = petData['hunger'] as number;
        this.pet.happiness = petData['happiness'] as number;
        this.pet.coins = petData['coins'] as number;
        this.pet.feedCount = petData['feedCount'] as number;
        this.pet.currentSkinId = petData['currentSkinId'] as number;
        this.pet.ownedSkins = petData['ownedSkins'] as number[];
      }
      if (timeData) {
        this.time.totalGameTime = timeData['totalGameTime'] as number;
        this.time.gameDays = timeData['gameDays'] as number;
        this.time.gameHour = timeData['gameHour'] as number;
      }
    } catch (e) {
      console.error('Deserialize game data failed:');
    }
  }
}
