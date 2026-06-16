/**
 * 主页面组件
 * 显示数值、宠物、功能按钮
 */
import { PetType, GrowthStage, ValueConfig, GrowthConfig } from '../common/Constants';
import { PathUtils, ColorUtils, AdaptiveUtils } from '../utils/AdaptiveUtils';
import { EmojiPetShape, GrowthIndicator as EmojiGrowthIndicator } from './EmojiPetShape';
import { FeedButton, BathButton, DressButton, SleepButton } from './ButtonComponents';
import { HeartShape } from './BaseShapes';

// ==================== 数值显示组件 ====================
@Component
export struct ValueDisplay {
  @Prop displayWidth: number = 300;
  @Prop hunger: number = 80;
  @Prop happiness: number = 70;
  @Prop coins: number = 500;
  @Prop gameTime: string = '08:00';
  
  build() {
    Column() {
      // 顶部：时间 + 金币
      Row() {
        Row() {
          Text('⏰')
            .fontSize(AdaptiveUtils.fontSize(12))
          Text(this.gameTime)
            .fontSize(AdaptiveUtils.fontSize(11))
            .fontColor('#666666')
            .fontWeight(FontWeight.Medium)
            .margin({ left: AdaptiveUtils.spacing(3) })
        }
        
        Blank()
        
        Row() {
          Text('💰')
            .fontSize(AdaptiveUtils.fontSize(12))
          Text(`${this.coins}`)
            .fontSize(AdaptiveUtils.fontSize(12))
            .fontColor('#FFB347')
            .fontWeight(FontWeight.Bold)
            .margin({ left: AdaptiveUtils.spacing(3) })
        }
        .padding({ left: AdaptiveUtils.spacing(8), right: AdaptiveUtils.spacing(8), top: AdaptiveUtils.spacing(3), bottom: AdaptiveUtils.spacing(3) })
        .backgroundColor('#FFF8E7')
        .borderRadius(AdaptiveUtils.scale(10))
      }
      .width('100%')
      .margin({ bottom: AdaptiveUtils.spacing(12) })
      
      // 饥饿值
      this.buildProgressBar(
        '🍖',
        '饥饿值',
        this.hunger,
        ValueConfig.MAX_HUNGER,
        ValueConfig.LOW_HUNGER,
        ['#FF9800', '#FFB347'],  // 正常：橙色渐变
        ['#FF5722', '#FF8A65']   // 低值：红色渐变
      )
      
      Blank().height(AdaptiveUtils.spacing(8))
      
      // 开心值
      this.buildProgressBar(
        '💖',
        '开心值',
        this.happiness,
        ValueConfig.MAX_HAPPINESS,
        ValueConfig.LOW_HAPPINESS,
        ['#E91E63', '#F48FB1'],  // 正常：粉色渐变
        ['#9E9E9E', '#BDBDBD']   // 低值：灰色渐变
      )
    }
    .width(this.displayWidth)
    .padding(AdaptiveUtils.spacing(14))
    .linearGradient({
      angle: 135,
      colors: [['#FFFFFF', 0], ['#F8F5FF', 1]]
    })
    .borderRadius(AdaptiveUtils.scale(14))
    .shadow({
      radius: 12,
      color: 'rgba(139, 92, 246, 0.15)',
      offsetX: 0,
      offsetY: 4
    })
  }
  
  // 精致的进度条
  @Builder
  buildProgressBar(
    icon: string,
    label: string,
    value: number,
    maxValue: number,
    lowThreshold: number,
    normalColors: string[],
    lowColors: string[]
  ) {
    Row() {
      Text(icon)
        .fontSize(AdaptiveUtils.fontSize(16))
      
      Column() {
        Row() {
          Text(label)
            .fontSize(AdaptiveUtils.fontSize(11))
            .fontColor('#666666')
          
          Blank()
          
          Text(`${Math.floor(value)}/${maxValue}`)
            .fontSize(AdaptiveUtils.fontSize(11))
            .fontColor(value < lowThreshold ? lowColors[0] : normalColors[0])
            .fontWeight(FontWeight.Medium)
        }
        .width('100%')
        .margin({ bottom: AdaptiveUtils.spacing(5) })
        
        // 进度条容器
        Stack({ alignContent: Alignment.Start }) {
          // 背景
          Shape() {
            Path()
              .width(this.displayWidth - AdaptiveUtils.spacing(35))
              .height(AdaptiveUtils.scale(10))
              .commands(PathUtils.roundRect(0, 0, this.displayWidth - AdaptiveUtils.spacing(35), AdaptiveUtils.scale(10), AdaptiveUtils.scale(5)))
              .fill('#F0E6F6')
          }
          .width(this.displayWidth - AdaptiveUtils.spacing(35))
          .height(AdaptiveUtils.scale(10))
          
          // 进度（渐变）
          Column()
            .width((this.displayWidth - AdaptiveUtils.spacing(35)) * (value / maxValue))
            .height(AdaptiveUtils.scale(10))
            .borderRadius(AdaptiveUtils.scale(5))
            .linearGradient({
              angle: 90,
              colors: value < lowThreshold 
                ? [[lowColors[0], 0], [lowColors[1], 1]]
                : [[normalColors[0], 0], [normalColors[1], 1]]
            })
          
          // 高光
          Column()
            .width((this.displayWidth - AdaptiveUtils.spacing(35)) * (value / maxValue) - AdaptiveUtils.spacing(3))
            .height(AdaptiveUtils.scale(3))
            .borderRadius(AdaptiveUtils.scale(2))
            .backgroundColor('rgba(255, 255, 255, 0.4)')
            .position({ x: AdaptiveUtils.spacing(2), y: AdaptiveUtils.spacing(2) })
        }
        .width(this.displayWidth - AdaptiveUtils.spacing(35))
        .height(AdaptiveUtils.scale(10))
      }
      .layoutWeight(1)
      .margin({ left: AdaptiveUtils.spacing(8) })
    }
    .width('100%')
  }
}

// ==================== 宠物展示组件 ====================
@Component
export struct PetDisplay {
  @Prop petSize: number = 150;
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
  onPetClick: () => void = () => {};
  
  build() {
    Stack() {
      // 使用emoji宠物组件
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
    .width(this.petSize * 1.6)
    .height(this.petSize * 1.6)
    .onClick(() => {
      if (!this.isSleeping) {
        this.onPetClick();
      }
    })
  }
}

// ==================== 功能按钮栏 ====================
@Component
export struct FunctionButtonBar {
  @Prop barWidth: number = 300;
  @Prop canFeed: boolean = true;
  @Prop isSleeping: boolean = false;
  onFeed: () => void = () => {};
  onBath: () => void = () => {};
  onDress: () => void = () => {};
  onSleep: () => void = () => {};
  
  build() {
    Row() {
      FeedButton({
        btnSize: AdaptiveUtils.getButtonSize(),
        isEnabled: this.canFeed && !this.isSleeping,
        onBtnClick: () => {
          this.onFeed();
        }
      })
      
      Blank().width(AdaptiveUtils.spacing(6))
      
      BathButton({
        btnSize: AdaptiveUtils.getButtonSize(),
        isEnabled: !this.isSleeping,
        onBtnClick: () => {
          this.onBath();
        }
      })
      
      Blank().width(AdaptiveUtils.spacing(6))
      
      DressButton({
        btnSize: AdaptiveUtils.getButtonSize(),
        isEnabled: !this.isSleeping,
        onBtnClick: () => {
          this.onDress();
        }
      })
      
      Blank().width(AdaptiveUtils.spacing(6))
      
      SleepButton({
        btnSize: AdaptiveUtils.getButtonSize(),
        isSleeping: this.isSleeping,
        onBtnClick: () => {
          this.onSleep();
        }
      })
    }
    .width(this.barWidth)
    .justifyContent(FlexAlign.Center)
    .padding(AdaptiveUtils.spacing(8))
    .linearGradient({
      angle: 135,
      colors: [['#FFFFFF', 0], ['#F8F5FF', 1]]
    })
    .borderRadius(AdaptiveUtils.scale(14))
    .shadow({
      radius: 12,
      color: 'rgba(139, 92, 246, 0.15)',
      offsetX: 0,
      offsetY: 4
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
          .fontSize(AdaptiveUtils.fontSize(12))
        
        Text(this.getStageText())
          .fontSize(AdaptiveUtils.fontSize(11))
          .fontColor('#7C3AED')
          .fontWeight(FontWeight.Bold)
        
        Text(` (${this.feedCount}次喂食)`)
          .fontSize(AdaptiveUtils.fontSize(10))
          .fontColor('#9CA3AF')
      }
      
      // 8阶段进度条
      Row() {
        ForEach([1, 2, 3, 4, 5, 6, 7, 8], (level: number) => {
          Column()
            .width(AdaptiveUtils.scale(16))
            .height(AdaptiveUtils.scale(5))
            .borderRadius(AdaptiveUtils.scale(3))
            .backgroundColor(level <= this.getCurrentLevel() ? '#8B5CF6' : '#E5E7EB')
            .margin({ right: AdaptiveUtils.spacing(3) })
        })
      }
      .margin({ top: AdaptiveUtils.spacing(6) })
    }
    .padding({ left: AdaptiveUtils.spacing(10), right: AdaptiveUtils.spacing(10), top: AdaptiveUtils.spacing(6), bottom: AdaptiveUtils.spacing(6) })
    .linearGradient({
      angle: 135,
      colors: [['#F5F3FF', 0], ['#EDE9FE', 1]]
    })
    .borderRadius(AdaptiveUtils.scale(14))
    .shadow({
      radius: 6,
      color: 'rgba(139, 92, 246, 0.1)',
      offsetX: 0,
      offsetY: 2
    })
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
    return GrowthConfig.getStageLevel(this.growthStage);
  }
}
