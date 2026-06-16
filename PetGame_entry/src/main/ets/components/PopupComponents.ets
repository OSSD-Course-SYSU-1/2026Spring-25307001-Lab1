/**
 * 弹窗组件
 */
import { PetType } from '../common/Constants';
import { PathUtils, ColorUtils, AdaptiveUtils } from '../utils/AdaptiveUtils';
import { PetEggShape, IncubatorShape } from './EggShapes';

// ==================== 基础弹窗容器 ====================
@Component
export struct PopupContainer {
  @Prop popupWidth: number = 300;
  @Prop popupHeight: number = 400;
  @Prop title: string = '';
  @Prop showClose: boolean = true;
  @Prop animationProgress: number = 1;
  @BuilderParam content: () => void;
  onClose: () => void = () => {};
  
  build() {
    Column() {
      if (this.title) {
        Row() {
          Text(this.title)
            .fontSize(AdaptiveUtils.fontSize(18))
            .fontColor('#5B21B6')
            .fontWeight(FontWeight.Bold)
          
          if (this.showClose) {
            Blank()
            
            Row() {
              Text('✕')
                .fontSize(AdaptiveUtils.fontSize(12))
                .fontColor('#9CA3AF')
            }
            .width(AdaptiveUtils.spacing(24))
            .height(AdaptiveUtils.spacing(24))
            .backgroundColor('#F3F4F6')
            .borderRadius(AdaptiveUtils.spacing(12))
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              this.onClose();
            })
          }
        }
        .width('100%')
        .padding({ 
          left: AdaptiveUtils.spacing(14), 
          right: AdaptiveUtils.spacing(14), 
          top: AdaptiveUtils.spacing(10), 
          bottom: AdaptiveUtils.spacing(10) 
        })
      }
      
      // 内容区域
      Column() {
        this.content();
      }
      .width('100%')
      .layoutWeight(1)
      .padding(AdaptiveUtils.spacing(14))
    }
    .width(this.popupWidth)
    .height(this.popupHeight)
    .linearGradient({
      angle: 135,
      colors: [['#FFFFFF', 0], ['#F5F3FF', 1]]
    })
    .borderRadius(AdaptiveUtils.spacing(16))
    .shadow({
      radius: 24,
      color: 'rgba(139, 92, 246, 0.25)',
      offsetX: 0,
      offsetY: 8
    })
    .translate({ x: this.popupWidth * (1 - this.animationProgress) })
    .opacity(this.animationProgress)
  }
}

// ==================== 包裹弹窗 ====================
@Component
export struct PackagePopup {
  @Prop popupWidth: number = 280;
  @Prop popupHeight: number = 350;
  @Prop animationProgress: number = 1;
  onOpen: () => void = () => {};
  onClose: () => void = () => {};
  
  build() {
    Column() {
      Stack() {
        Shape() {
          Path()
            .width(this.popupWidth * 0.6)
            .height(this.popupWidth * 0.5)
            .commands(PathUtils.roundRect(0, 0, this.popupWidth * 0.6, this.popupWidth * 0.5, 8))
            .fill('#8B4513')
        }
        .width(this.popupWidth * 0.6)
        .height(this.popupWidth * 0.5)
        .position({ x: this.popupWidth * 0.2, y: this.popupHeight * 0.25 })
        
        Shape() {
          Path()
            .width(this.popupWidth * 0.65)
            .height(15)
            .commands(PathUtils.roundRect(0, 0, this.popupWidth * 0.65, 15, 3))
            .fill('#FFD700')
        }
        .width(this.popupWidth * 0.65)
        .height(15)
        .position({ x: this.popupWidth * 0.175, y: this.popupHeight * 0.42 })
        
        Shape() {
          Path()
            .width(15)
            .height(this.popupWidth * 0.55)
            .commands(PathUtils.roundRect(0, 0, 15, this.popupWidth * 0.55, 3))
            .fill('#FFD700')
        }
        .width(15)
        .height(this.popupWidth * 0.55)
        .position({ x: this.popupWidth * 0.5 - 7.5, y: this.popupHeight * 0.22 })
        
        // 蝴蝶结
        this.drawBow()
        
        // 神秘光芒
        ForEach([0, 1, 2, 3, 4, 5, 6, 7], (index: number) => {
          Shape() {
            Path()
              .width(6)
              .height(6)
              .commands(PathUtils.star(3, 3, 3, 1.5, 4))
              .fill('#FFD700')
          }
          .width(6)
          .height(6)
          .position({
            x: this.popupWidth * 0.5 + Math.cos(index * Math.PI / 4) * this.popupWidth * 0.35 - 3,
            y: this.popupHeight * 0.4 + Math.sin(index * Math.PI / 4) * this.popupWidth * 0.25 - 3
          })
          .opacity(0.6)
        })
      }
      .width(this.popupWidth)
      .height(this.popupHeight * 0.7)
      
      Text('🎁 点击打开神秘包裹')
        .fontSize(AdaptiveUtils.fontSize(14))
        .fontColor('#6B7280')
        .margin({ top: AdaptiveUtils.spacing(14) })
      
      Button('打开包裹')
        .width(this.popupWidth * 0.5)
        .height(AdaptiveUtils.spacing(36))
        .linearGradient({
          angle: 90,
          colors: [['#F59E0B', 0], ['#FBBF24', 1]]
        })
        .fontColor('#FFFFFF')
        .fontWeight(FontWeight.Bold)
        .borderRadius(AdaptiveUtils.spacing(18))
        .margin({ top: AdaptiveUtils.spacing(10) })
        .onClick(() => {
          this.onOpen();
        })
    }
    .width(this.popupWidth)
    .height(this.popupHeight)
    .linearGradient({
      angle: 135,
      colors: [['#FEF3C7', 0], ['#FDE68A', 1]]
    })
    .borderRadius(AdaptiveUtils.spacing(16))
    .shadow({
      radius: 24,
      color: 'rgba(245, 158, 11, 0.3)',
      offsetX: 0,
      offsetY: 8
    })
    .translate({ x: this.popupWidth * (1 - this.animationProgress) })
    .opacity(this.animationProgress)
  }
  
  @Builder
  drawBow() {
    Stack() {
      Shape() {
        Path()
          .width(AdaptiveUtils.spacing(26))
          .height(AdaptiveUtils.spacing(18))
          .commands(`M 15 10 Q 0 0 0 10 Q 0 20 15 10`)
          .fill('#FFD700')
      }
      .width(AdaptiveUtils.spacing(26))
      .height(AdaptiveUtils.spacing(18))
      .position({ x: this.popupWidth * 0.5 - AdaptiveUtils.spacing(26), y: this.popupHeight * 0.22 })
      
      Shape() {
        Path()
          .width(AdaptiveUtils.spacing(26))
          .height(AdaptiveUtils.spacing(18))
          .commands(`M 0 10 Q 15 0 15 10 Q 15 20 0 10`)
          .fill('#FFD700')
      }
      .width(AdaptiveUtils.spacing(26))
      .height(AdaptiveUtils.spacing(18))
      .position({ x: this.popupWidth * 0.5, y: this.popupHeight * 0.22 })
      
      Shape() {
        Path()
          .width(AdaptiveUtils.spacing(10))
          .height(AdaptiveUtils.spacing(10))
          .commands(PathUtils.circle(AdaptiveUtils.spacing(5), AdaptiveUtils.spacing(5), AdaptiveUtils.spacing(5)))
          .fill('#DAA520')
      }
      .width(AdaptiveUtils.spacing(10))
      .height(AdaptiveUtils.spacing(10))
      .position({ x: this.popupWidth * 0.5 - AdaptiveUtils.spacing(5), y: this.popupHeight * 0.22 + AdaptiveUtils.spacing(4) })
    }
    .width(this.popupWidth)
    .height(AdaptiveUtils.spacing(36))
  }
}

// ==================== 选蛋弹窗 ====================
@Component
export struct SelectEggPopup {
  @Prop popupWidth: number = 320;
  @Prop popupHeight: number = 400;
  @Prop animationProgress: number = 1;
  @Link selectedEgg: PetType;
  onSelect: () => void = () => {};
  onClose: () => void = () => {};
  
  build() {
    Column() {
      Text('🥚 选择你的精灵蛋')
        .fontSize(AdaptiveUtils.fontSize(18))
        .fontColor('#5B21B6')
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: AdaptiveUtils.spacing(16) })
      
      Row() {
        Column() {
          PetEggShape({
            eggSize: AdaptiveUtils.minDimension() * 0.18,
            petType: PetType.OCTO,
            isSelected: this.selectedEgg === PetType.OCTO
          })
          .onClick(() => {
            this.selectedEgg = PetType.OCTO;
          })
          
          Text('Octo精灵')
            .fontSize(AdaptiveUtils.fontSize(11))
            .fontColor(this.selectedEgg === PetType.OCTO ? '#8B5CF6' : '#6B7280')
            .fontWeight(this.selectedEgg === PetType.OCTO ? FontWeight.Bold : FontWeight.Normal)
            .margin({ top: AdaptiveUtils.spacing(6) })
        }
        .width(this.popupWidth * 0.3)
        .height(this.popupHeight * 0.4)
        
        Column() {
          PetEggShape({
            eggSize: AdaptiveUtils.minDimension() * 0.18,
            petType: PetType.SERP,
            isSelected: this.selectedEgg === PetType.SERP
          })
          .onClick(() => {
            this.selectedEgg = PetType.SERP;
          })
          
          Text('Serp精灵')
            .fontSize(AdaptiveUtils.fontSize(11))
            .fontColor(this.selectedEgg === PetType.SERP ? '#8B5CF6' : '#6B7280')
            .fontWeight(this.selectedEgg === PetType.SERP ? FontWeight.Bold : FontWeight.Normal)
            .margin({ top: AdaptiveUtils.spacing(6) })
        }
        .width(this.popupWidth * 0.3)
        .height(this.popupHeight * 0.4)
        
        Column() {
          PetEggShape({
            eggSize: AdaptiveUtils.minDimension() * 0.18,
            petType: PetType.ROBIN,
            isSelected: this.selectedEgg === PetType.ROBIN
          })
          .onClick(() => {
            this.selectedEgg = PetType.ROBIN;
          })
          
          Text('Robin精灵')
            .fontSize(AdaptiveUtils.fontSize(11))
            .fontColor(this.selectedEgg === PetType.ROBIN ? '#8B5CF6' : '#6B7280')
            .fontWeight(this.selectedEgg === PetType.ROBIN ? FontWeight.Bold : FontWeight.Normal)
            .margin({ top: AdaptiveUtils.spacing(6) })
        }
        .width(this.popupWidth * 0.3)
        .height(this.popupHeight * 0.4)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
      
      Blank().height(AdaptiveUtils.spacing(16))
      
      Button('🐣 开始孵化')
        .width(this.popupWidth * 0.5)
        .height(AdaptiveUtils.spacing(36))
        .linearGradient({
          angle: 90,
          colors: [['#EC4899', 0], ['#F472B6', 1]]
        })
        .fontColor('#FFFFFF')
        .fontWeight(FontWeight.Bold)
        .borderRadius(AdaptiveUtils.spacing(18))
        .onClick(() => {
          this.onSelect();
        })
    }
    .width(this.popupWidth)
    .height(this.popupHeight)
    .linearGradient({
      angle: 135,
      colors: [['#FFFFFF', 0], ['#F5F3FF', 1]]
    })
    .borderRadius(AdaptiveUtils.spacing(16))
    .padding(AdaptiveUtils.spacing(14))
    .shadow({
      radius: 24,
      color: 'rgba(139, 92, 246, 0.25)',
      offsetX: 0,
      offsetY: 8
    })
    .translate({ x: this.popupWidth * (1 - this.animationProgress) })
    .opacity(this.animationProgress)
  }
}

// ==================== 孵化器弹窗 ====================
@Component
export struct IncubatorPopup {
  @Prop popupWidth: number = 300;
  @Prop popupHeight: number = 380;
  @Prop animationProgress: number = 1;
  @Prop petType: PetType = PetType.OCTO;
  @Prop progress: number = 0;
  @Prop remainingTime: string = '15:00';
  
  build() {
    Column() {
      Text('🔬 孵化器')
        .fontSize(AdaptiveUtils.fontSize(18))
        .fontColor('#5B21B6')
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: AdaptiveUtils.spacing(14) })
      
      Stack() {
        IncubatorShape({
          incSize: AdaptiveUtils.minDimension() * 0.35,
          hasEgg: true,
          eggType: this.petType,
          glowIntensity: 0.3 + this.progress * 0.5
        })
      }
      .width(AdaptiveUtils.minDimension() * 0.35)
      .height(this.popupHeight * 0.45)
      
      Column() {
        Row() {
          Text('孵化进度')
            .fontSize(AdaptiveUtils.fontSize(11))
            .fontColor('#6B7280')
          
          Blank()
          
          Text(`${Math.floor(this.progress * 100)}%`)
            .fontSize(AdaptiveUtils.fontSize(11))
            .fontColor('#EC4899')
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .margin({ bottom: AdaptiveUtils.spacing(6) })
        
        // 进度条
        Stack({ alignContent: Alignment.Start }) {
          // 背景
          Shape() {
            Path()
              .width(this.popupWidth - AdaptiveUtils.spacing(36))
              .height(AdaptiveUtils.spacing(10))
              .commands(PathUtils.roundRect(0, 0, this.popupWidth - AdaptiveUtils.spacing(36), AdaptiveUtils.spacing(10), AdaptiveUtils.spacing(5)))
              .fill('#F3E8FF')
          }
          .width(this.popupWidth - AdaptiveUtils.spacing(36))
          .height(AdaptiveUtils.spacing(10))
          
          // 进度
          Column()
            .width((this.popupWidth - AdaptiveUtils.spacing(36)) * this.progress)
            .height(AdaptiveUtils.spacing(10))
            .borderRadius(AdaptiveUtils.spacing(5))
            .linearGradient({
              angle: 90,
              colors: [['#EC4899', 0], ['#F472B6', 1]]
            })
          
          // 高光
          Column()
            .width((this.popupWidth - AdaptiveUtils.spacing(36)) * this.progress - AdaptiveUtils.spacing(4))
            .height(AdaptiveUtils.spacing(4))
            .borderRadius(AdaptiveUtils.spacing(2))
            .backgroundColor('rgba(255, 255, 255, 0.4)')
            .position({ x: AdaptiveUtils.spacing(2), y: AdaptiveUtils.spacing(2) })
        }
        .width(this.popupWidth - AdaptiveUtils.spacing(36))
        .height(AdaptiveUtils.spacing(10))
      }
      .width(this.popupWidth - AdaptiveUtils.spacing(36))
      .margin({ top: AdaptiveUtils.spacing(16) })
      
      Row() {
        Text('⏱️')
          .fontSize(AdaptiveUtils.fontSize(12))
        Text(`剩余时间: ${this.remainingTime}`)
          .fontSize(AdaptiveUtils.fontSize(11))
          .fontColor('#6B7280')
          .margin({ left: AdaptiveUtils.spacing(4) })
      }
      .margin({ top: AdaptiveUtils.spacing(14) })
    }
    .width(this.popupWidth)
    .height(this.popupHeight)
    .linearGradient({
      angle: 135,
      colors: [['#FFFFFF', 0], ['#F5F3FF', 1]]
    })
    .borderRadius(AdaptiveUtils.spacing(16))
    .padding(AdaptiveUtils.spacing(14))
    .shadow({
      radius: 24,
      color: 'rgba(139, 92, 246, 0.25)',
      offsetX: 0,
      offsetY: 8
    })
    .translate({ x: this.popupWidth * (1 - this.animationProgress) })
    .opacity(this.animationProgress)
  }
}
