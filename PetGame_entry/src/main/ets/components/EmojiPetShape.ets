/**
 * Emoji宠物形象组件
 * 使用emoji展示宠物形象，支持8个成长阶段
 * 支持丰富的动画效果：缩放、旋转、变色、弹跳等
 */

import { PetType, GrowthStage } from '../common/Constants';
import { AdaptiveUtils } from '../utils/AdaptiveUtils';

// ==================== 宠物Emoji配置 ====================
// 根据宠物类型和成长阶段返回对应的emoji
function getPetEmoji(petType: PetType, stage: GrowthStage): string {
  switch (petType) {
    case PetType.OCTO: // 章鱼精灵
      switch (stage) {
        case GrowthStage.EGG: return '🥚';
        case GrowthStage.BABY: return '🐙';
        case GrowthStage.CHILD: return '🐙';
        case GrowthStage.TEEN: return '🐙';
        case GrowthStage.YOUTH: return '🐙';
        case GrowthStage.ADULT: return '🐙';
        case GrowthStage.ELDER: return '🐙';
        case GrowthStage.MASTER: return '🐙';
        default: return '🐙';
      }
    case PetType.SERP: // 蛇形精灵
      switch (stage) {
        case GrowthStage.EGG: return '🥚';
        case GrowthStage.BABY: return '🐍';
        case GrowthStage.CHILD: return '🐍';
        case GrowthStage.TEEN: return '🐲';
        case GrowthStage.YOUTH: return '🐲';
        case GrowthStage.ADULT: return '🐉';
        case GrowthStage.ELDER: return '🐉';
        case GrowthStage.MASTER: return '🐉';
        default: return '🐍';
      }
    case PetType.ROBIN: // 鸟形精灵
      switch (stage) {
        case GrowthStage.EGG: return '🥚';
        case GrowthStage.BABY: return '🐣';
        case GrowthStage.CHILD: return '🐥';
        case GrowthStage.TEEN: return '🐦';
        case GrowthStage.YOUTH: return '🐦';
        case GrowthStage.ADULT: return '🦅';
        case GrowthStage.ELDER: return '🦅';
        case GrowthStage.MASTER: return '🦚';
        default: return '🐣';
      }
    default:
      return '🐾';
  }
}

// 获取成长阶段对应的尺寸缩放
function getGrowthScale(stage: GrowthStage): number {
  switch (stage) {
    case GrowthStage.EGG: return 0.5;
    case GrowthStage.BABY: return 0.6;
    case GrowthStage.CHILD: return 0.7;
    case GrowthStage.TEEN: return 0.8;
    case GrowthStage.YOUTH: return 0.9;
    case GrowthStage.ADULT: return 1.0;
    case GrowthStage.ELDER: return 1.1;
    case GrowthStage.MASTER: return 1.2;
    default: return 0.6;
  }
}

// 获取皮肤对应的颜色滤镜
function getSkinColor(skinId: number): string {
  switch (skinId) {
    case 1: return '#9B59B6'; // 星空幻彩 - 紫色
    case 2: return '#FFB6C1'; // 樱花粉嫩 - 粉色
    case 3: return '#E74C3C'; // 烈焰赤红 - 红色
    case 4: return '#1ABC9C'; // 极光幻境 - 青色
    default: return '#FF8C69'; // 原生 - 橙色
  }
}

// ==================== Emoji宠物主组件 ====================
@Component
export struct EmojiPetShape {
  @Prop petSize: number = 100;
  @Prop petType: PetType = PetType.OCTO;
  @Prop growthStage: GrowthStage = GrowthStage.BABY;
  @Prop isSad: boolean = false;
  @Prop isExcited: boolean = false;
  @Prop isSleeping: boolean = false;
  @Prop skinId: number = 0;
  
  // 动画状态参数
  @Prop petScale: number = 1.0;
  @Prop translateX: number = 0;
  @Prop translateY: number = 0;
  @Prop petRotate: number = 0;
  @Prop showHeart: boolean = false;
  
  // 互动动画状态
  @State interactionScale: number = 1.0;
  @State interactionRotate: number = 0;
  @State interactionHue: number = 0;
  @State bounceHeight: number = 0;
  
  build() {
    Stack() {
      // 主宠物emoji
      Column() {
        Text(getPetEmoji(this.petType, this.growthStage))
          .fontSize(this.petSize * getGrowthScale(this.growthStage) * this.petScale * this.interactionScale)
          .fontColor(this.isSad ? '#888888' : getSkinColor(this.skinId))
          .rotate({ angle: this.petRotate + this.interactionRotate })
          .translate({ 
            x: this.translateX, 
            y: this.translateY + this.bounceHeight 
          })
          .hueRotate(this.interactionHue)
          .animation({
            duration: 300,
            curve: Curve.EaseInOut
          })
      }
      .justifyContent(FlexAlign.Center)
      
      // 爱心特效
      if (this.showHeart) {
        Text('❤️')
          .fontSize(this.petSize * 0.4)
          .position({ x: this.petSize * 0.3, y: -this.petSize * 0.3 })
          .opacity(0.9)
          .scale({ x: 1.2, y: 1.2 })
      }
      
      // 兴奋特效
      if (this.isExcited) {
        this.buildExcitedEffect()
      }
      
      // 睡眠特效
      if (this.isSleeping) {
        Text('💤')
          .fontSize(this.petSize * 0.35)
          .position({ x: this.petSize * 0.5, y: -this.petSize * 0.2 })
      }
      
      // 悲伤特效
      if (this.isSad) {
        Text('💧')
          .fontSize(this.petSize * 0.25)
          .position({ x: this.petSize * 0.4, y: this.petSize * 0.3 })
      }
    }
    .width(this.petSize * 1.5)
    .height(this.petSize * 1.5)
  }
  
  // 兴奋特效（星星环绕）
  @Builder
  buildExcitedEffect() {
    Stack() {
      Text('✨')
        .fontSize(this.petSize * 0.25)
        .position({ x: -this.petSize * 0.2, y: -this.petSize * 0.1 })
      
      Text('⭐')
        .fontSize(this.petSize * 0.2)
        .position({ x: this.petSize * 0.8, y: -this.petSize * 0.2 })
      
      Text('🌟')
        .fontSize(this.petSize * 0.22)
        .position({ x: this.petSize * 0.1, y: this.petSize * 0.7 })
    }
    .width(this.petSize * 1.2)
    .height(this.petSize * 1.2)
  }
}

// ==================== 宠物展示组件（带点击互动） ====================
@Component
export struct PetDisplay {
  @Prop petSize: number = 100;
  @Prop petType: PetType = PetType.OCTO;
  @Prop growthStage: GrowthStage = GrowthStage.BABY;
  @Prop isSad: boolean = false;
  @Prop isExcited: boolean = false;
  @Prop isSleeping: boolean = false;
  @Prop skinId: number = 0;
  @Prop petScale: number = 1.0;
  @Prop translateX: number = 0;
  @Prop translateY: number = 0;
  @Prop petRotate: number = 0;
  @Prop showHeart: boolean = false;
  
  onPetClick?: () => void;
  
  build() {
    Column() {
      EmojiPetShape({
        petSize: this.petSize,
        petType: this.petType,
        growthStage: this.growthStage,
        isSad: this.isSad,
        isExcited: this.isExcited,
        isSleeping: this.isSleeping,
        skinId: this.skinId,
        petScale: this.petScale,
        translateX: this.translateX,
        translateY: this.translateY,
        petRotate: this.petRotate,
        showHeart: this.showHeart
      })
    }
    .width(this.petSize * 1.5)
    .height(this.petSize * 1.5)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      if (this.onPetClick) {
        this.onPetClick();
      }
    })
  }
}

// ==================== 成长阶段指示器 ====================
@Component
export struct GrowthIndicator {
  @Prop growthStage: GrowthStage = GrowthStage.BABY;
  @Prop feedCount: number = 0;
  
  build() {
    Column() {
      Row() {
        Text('📊 ')
          .fontSize(14)
        
        Text(this.getStageText())
          .fontSize(AdaptiveUtils.fontSize(14))
          .fontColor('#7C3AED')
          .fontWeight(FontWeight.Bold)
        
        Text(` (${this.feedCount}次喂食)`)
          .fontSize(AdaptiveUtils.fontSize(12))
          .fontColor('#9CA3AF')
      }
      
      // 进度条显示当前阶段进度
      Row() {
        ForEach([1, 2, 3, 4, 5, 6, 7, 8], (level: number) => {
          Column()
            .width(20)
            .height(6)
            .borderRadius(3)
            .backgroundColor(level <= this.getCurrentLevel() ? '#8B5CF6' : '#E5E7EB')
            .margin({ right: 4 })
        })
      }
      .margin({ top: 8 })
    }
    .padding({ left: 16, right: 16, top: 8, bottom: 8 })
    .backgroundColor('#F5F3FF')
    .borderRadius(12)
  }
  
  private getStageText(): string {
    switch (this.growthStage) {
      case GrowthStage.EGG: return '🥚 蛋期';
      case GrowthStage.BABY: return '🐣 幼儿期';
      case GrowthStage.CHILD: return '🐥 儿童期';
      case GrowthStage.TEEN: return '🎒 少年期';
      case GrowthStage.YOUTH: return '🌟 青年期';
      case GrowthStage.ADULT: return '💪 成年期';
      case GrowthStage.ELDER: return '👑 壮年期';
      case GrowthStage.MASTER: return '🏆 大师期';
      default: return '❓ 未知';
    }
  }
  
  private getCurrentLevel(): number {
    switch (this.growthStage) {
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
