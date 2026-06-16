/**
 * 宠物养成游戏 - 常量配置与类型定义
 * 
 * 【游戏时间规则】
 * 现实15分钟 = 游戏内1整天
 * 孵化需要1分钟
 */

// ==================== 游戏时间配置 ====================
export class GameTimeConfig {
  // 孵化时间：1分钟（毫秒）
  static readonly REAL_TIME_PER_GAME_DAY: number = 1 * 60 * 1000; // 60000ms
  // 孵化时间对应的现实秒数
  static readonly REAL_SECONDS_PER_GAME_DAY: number = 1 * 60; // 60秒
  // 数值更新间隔（现实毫秒）
  static readonly VALUE_UPDATE_INTERVAL: number = 1000; // 1秒更新一次
  // 睡眠时段（游戏内时间 22:00-06:00）
  static readonly SLEEP_START_HOUR: number = 22;
  static readonly SLEEP_END_HOUR: number = 6;
}

// ==================== 宠物类型枚举 ====================
export enum PetType {
  OCTO = 'Octo',   // 章鱼精灵
  SERP = 'Serp',   // 蛇形精灵
  ROBIN = 'Robin'  // 鸟形精灵
}

// ==================== 成长阶段枚举 ====================
export enum GrowthStage {
  EGG = 'egg',         // 蛋期（0次喂食）
  BABY = 'baby',       // 幼儿期（1-3次喂食）
  CHILD = 'child',     // 儿童期（4-8次喂食）
  TEEN = 'teen',       // 少年期（9-15次喂食）
  YOUTH = 'youth',     // 青年期（16-25次喂食）
  ADULT = 'adult',     // 成年期（26-40次喂食）
  ELDER = 'elder',     // 壮年期（41-60次喂食）
  MASTER = 'master'    // 大师期（61次以上）
}

// ==================== 游戏状态枚举 ====================
export enum GameState {
  INTRO = 'intro',           // 开场包裹
  SELECT_EGG = 'selectEgg',  // 选蛋界面
  INCUBATING = 'incubating', // 孵化中
  HATCHING = 'hatching',     // 孵化动画
  MAIN = 'main',            // 主养成页面
  FOOD_SHOP = 'foodShop',   // 食物商店
  SKIN_SHOP = 'skinShop',   // 皮肤商店
  BATHING = 'bathing'       // 洗澡中
}

// ==================== 动画类型枚举 ====================
export enum AnimationType {
  // 互动动画
  JUMP = 'jump',           // 原地蹦跳
  TILT = 'tilt',           // 歪头转圈
  SHAKE = 'shake',         // 左右摇晃
  HEART = 'heart',         // 爱心特效
  // 待机动画
  PACE = 'pace',           // 原地踱步
  STRETCH = 'stretch',     // 伸懒腰
  GROOM = 'groom',         // 梳理身体
  DROWSY = 'drowsy',       // 眯眼犯困
  // 状态动画
  SAD = 'sad',             // 低落
  EXCITED = 'excited',     // 兴奋
  SLEEP = 'sleep',         // 睡眠
  HATCH = 'hatch'          // 孵化
}

// ==================== 动画参数配置 ====================
export interface AnimationConfig {
  duration: number;
  scale?: number;
  translateX?: number;
  translateY?: number;
  rotate?: number;
  curve?: string;
}

// 辅助函数：创建动画配置
function createAnimConfig(duration: number, scale?: number, translateX?: number, 
                          translateY?: number, rotate?: number, curve?: string): AnimationConfig {
  const config: AnimationConfig = { duration: duration };
  if (scale !== undefined) config.scale = scale;
  if (translateX !== undefined) config.translateX = translateX;
  if (translateY !== undefined) config.translateY = translateY;
  if (rotate !== undefined) config.rotate = rotate;
  if (curve !== undefined) config.curve = curve;
  return config;
}

// 预定义动画参数
export const ANIMATION_CONFIGS: Map<string, AnimationConfig> = new Map();
ANIMATION_CONFIGS.set('jump', createAnimConfig(400, 1.1, undefined, -30, undefined, 'ease-out'));
ANIMATION_CONFIGS.set('tilt', createAnimConfig(500, undefined, undefined, undefined, 15, 'ease-in-out'));
ANIMATION_CONFIGS.set('shake', createAnimConfig(300, undefined, 10, undefined, 10, 'ease-in-out'));
ANIMATION_CONFIGS.set('heart', createAnimConfig(800, 1.5, undefined, -20, undefined, 'ease-out'));
ANIMATION_CONFIGS.set('pace', createAnimConfig(2000, undefined, 20, undefined, undefined, 'ease-in-out'));
ANIMATION_CONFIGS.set('stretch', createAnimConfig(1000, 1.15, undefined, -10, undefined, 'ease-in-out'));
ANIMATION_CONFIGS.set('hatch', createAnimConfig(2000, 1.2, undefined, undefined, undefined, 'ease-out'));

// ==================== 食物配置 ====================
export interface FoodItem {
  id: number;
  name: string;
  price: number;
  hungerValue: number;
  description: string;
}

// 辅助函数：创建食物项
function createFoodItem(id: number, name: string, price: number, hungerValue: number, description: string): FoodItem {
  const item: FoodItem = {
    id: id,
    name: name,
    price: price,
    hungerValue: hungerValue,
    description: description
  };
  return item;
}

export const FOOD_LIST: FoodItem[] = [
  createFoodItem(1, '基础口粮', 10, 15, '简单营养'),
  createFoodItem(2, '鲜果丸子', 30, 35, '水果风味'),
  createFoodItem(3, '海鲜小餐', 65, 60, '鲜美可口'),
  createFoodItem(4, '营养浓汤', 120, 100, '滋补佳品'),
  createFoodItem(5, '豪华大餐', 260, 180, '顶级盛宴')
];

// ==================== 皮肤配置 ====================
export interface SkinItem {
  id: number;
  name: string;
  price: number;
  description: string;
  owned: boolean;
}

// 辅助函数：创建皮肤项
function createSkinItem(id: number, name: string, price: number, description: string, owned: boolean): SkinItem {
  const item: SkinItem = {
    id: id,
    name: name,
    price: price,
    description: description,
    owned: owned
  };
  return item;
}

export const SKIN_LIST: SkinItem[] = [
  createSkinItem(0, '原生皮肤', 0, '默认外观', true),
  createSkinItem(1, '星空幻彩', 200, '梦幻星空', false),
  createSkinItem(2, '樱花粉嫩', 350, '春日浪漫', false),
  createSkinItem(3, '烈焰赤红', 500, '热情似火', false),
  createSkinItem(4, '极光幻境', 800, '北极光效', false)
];

// ==================== 数值边界配置 ====================
export class ValueConfig {
  static readonly MAX_HUNGER: number = 100;      // 最大饥饿值
  static readonly MAX_HAPPINESS: number = 100;   // 最大开心值
  static readonly LOW_HUNGER: number = 20;       // 低饥饿阈值
  static readonly LOW_HAPPINESS: number = 30;    // 低开心阈值
  static readonly HUNGER_DECAY_RATE: number = 0.5; // 饥饿值下降速率（每游戏小时）
  static readonly HAPPINESS_COIN_RATE: number = 5; // 开心满值产金币速率
  static readonly CLICK_HAPPINESS: number = 3;   // 点击增加开心值
  static readonly BATH_HAPPINESS: number = 15;   // 洗澡增加开心值
}

// ==================== 成长阶段配置 ====================
export class GrowthConfig {
  // 喂食次数阈值（8个阶段）
  static readonly EGG_MAX: number = 0;      // 蛋期：0次
  static readonly BABY_MAX: number = 3;     // 幼儿期：1-3次
  static readonly CHILD_MAX: number = 8;    // 儿童期：4-8次
  static readonly TEEN_MAX: number = 15;    // 少年期：9-15次
  static readonly YOUTH_MAX: number = 25;   // 青年期：16-25次
  static readonly ADULT_MAX: number = 40;   // 成年期：26-40次
  static readonly ELDER_MAX: number = 60;   // 壮年期：41-60次
  
  // 根据喂食次数获取成长阶段
  static getStage(feedCount: number): GrowthStage {
    if (feedCount <= GrowthConfig.EGG_MAX) return GrowthStage.EGG;
    if (feedCount <= GrowthConfig.BABY_MAX) return GrowthStage.BABY;
    if (feedCount <= GrowthConfig.CHILD_MAX) return GrowthStage.CHILD;
    if (feedCount <= GrowthConfig.TEEN_MAX) return GrowthStage.TEEN;
    if (feedCount <= GrowthConfig.YOUTH_MAX) return GrowthStage.YOUTH;
    if (feedCount <= GrowthConfig.ADULT_MAX) return GrowthStage.ADULT;
    if (feedCount <= GrowthConfig.ELDER_MAX) return GrowthStage.ELDER;
    return GrowthStage.MASTER;
  }
  
  // 获取阶段名称
  static getStageName(stage: GrowthStage): string {
    switch (stage) {
      case GrowthStage.EGG: return '蛋期';
      case GrowthStage.BABY: return '幼儿期';
      case GrowthStage.CHILD: return '儿童期';
      case GrowthStage.TEEN: return '少年期';
      case GrowthStage.YOUTH: return '青年期';
      case GrowthStage.ADULT: return '成年期';
      case GrowthStage.ELDER: return '壮年期';
      case GrowthStage.MASTER: return '大师期';
      default: return '未知';
    }
  }
  
  // 获取阶段等级（1-8）
  static getStageLevel(stage: GrowthStage): number {
    switch (stage) {
      case GrowthStage.EGG: return 1;
      case GrowthStage.BABY: return 2;
      case GrowthStage.CHILD: return 3;
      case GrowthStage.TEEN: return 4;
      case GrowthStage.YOUTH: return 5;
      case GrowthStage.ADULT: return 6;
      case GrowthStage.ELDER: return 7;
      case GrowthStage.MASTER: return 8;
      default: return 1;
    }
  }
}

// ==================== 设备类型 ====================
export enum DeviceType {
  PHONE = 'phone',
  TABLET = 'tablet',
  WATCH = 'watch'
}
