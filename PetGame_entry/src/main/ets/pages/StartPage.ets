/**
 * 游戏入口页面
 * 显示"新游戏"和"存档"两个选项
 */

import router from '@ohos.router';
import { GameStorage } from '../utils/GameStorage';
import { AdaptiveUtils } from '../utils/AdaptiveUtils';
import common from '@ohos.app.ability.common';

@Entry
@Component
struct StartPage {
  @State buttonScale1: number = 1.0;
  @State buttonScale2: number = 1.0;
  @State titleScale: number = 0.5;
  @State showAnimation: boolean = true;
  
  aboutToAppear() {
    // 初始化GameStorage
    const context = getContext(this) as common.UIAbilityContext;
    GameStorage.getInstance().init(context);
    
    // 初始化屏幕适配（使用默认值，实际运行时自适应）
    AdaptiveUtils.init(360, 640);
    
    // 启动入场动画
    setTimeout(() => {
      animateTo({
        duration: 800,
        curve: Curve.EaseOut
      }, () => {
        this.titleScale = 1.0;
      });
    }, 200);
  }
  
  build() {
    Stack() {
      // 背景渐变
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: 135,
          colors: [['#667eea', 0], ['#764ba2', 1]]
        })
      
      // 主内容
      Column() {
        // 顶部装饰
        Row() {
          Text('✨')
            .fontSize(AdaptiveUtils.fontSize(24))
            .opacity(0.6)
          
          Blank().width(AdaptiveUtils.spacing(15))
          
          Text('🌟')
            .fontSize(AdaptiveUtils.fontSize(20))
            .opacity(0.5)
        }
        .margin({ top: AdaptiveUtils.spacing(60) })
        
        Blank().height(AdaptiveUtils.spacing(20))
        
        // 游戏标题
        Column() {
          Text('宠物养成')
            .fontSize(AdaptiveUtils.fontSize(36))
            .fontColor('#ffffff')
            .fontWeight(FontWeight.Bold)
            .textShadow({
              radius: 10,
              color: 'rgba(0,0,0,0.3)',
              offsetX: 0,
              offsetY: 5
            })
          
          Text('Pet Game')
            .fontSize(AdaptiveUtils.fontSize(16))
            .fontColor('#ffffff')
            .opacity(0.8)
            .margin({ top: AdaptiveUtils.spacing(8) })
            .letterSpacing(3)
        }
        .scale({ x: this.titleScale, y: this.titleScale })
        .margin({ top: AdaptiveUtils.spacing(40) })
        
        Blank().height(AdaptiveUtils.spacing(60))
        
        // 宠物图标装饰
        Row() {
          this.PetIcon('🐙', '#FF6B9D')
          Blank().width(AdaptiveUtils.spacing(25))
          this.PetIcon('🐍', '#4ECDC4')
          Blank().width(AdaptiveUtils.spacing(25))
          this.PetIcon('🐦', '#FFE66D')
        }
        .margin({ bottom: AdaptiveUtils.spacing(50) })
        
        // 按钮区域
        Column() {
          // 新游戏按钮
          this.GameButton('🎮  新游戏', '#FF6B9D', () => {
            router.pushUrl({
              url: 'pages/SaveListPage',
              params: { mode: 'new' }
            });
          })
          
          Blank().height(AdaptiveUtils.spacing(15))
          
          // 存档按钮
          this.GameButton('📁  存档', '#4ECDC4', () => {
            router.pushUrl({
              url: 'pages/SaveListPage',
              params: { mode: 'load' }
            });
          })
        }
        .width(AdaptiveUtils.isTablet() ? '50%' : '80%')
        
        Blank().layoutWeight(1)
        
        // 底部信息
        Text('v1.0.0')
          .fontSize(AdaptiveUtils.fontSize(12))
          .fontColor('#ffffff')
          .opacity(0.5)
          .margin({ bottom: AdaptiveUtils.spacing(25) })
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
  
  // 游戏按钮组件
  @Builder
  GameButton(text: string, color: string, onClick: () => void) {
    Button(text)
      .width('100%')
      .height(AdaptiveUtils.scale(50))
      .fontSize(AdaptiveUtils.fontSize(18))
      .fontColor('#ffffff')
      .fontWeight(FontWeight.Medium)
      .backgroundColor(color)
      .borderRadius(AdaptiveUtils.scale(25))
      .shadow({
        radius: 15,
        color: color,
        offsetX: 0,
        offsetY: 8
      })
      .onClick(() => {
        animateTo({
          duration: 100,
          curve: Curve.EaseOut
        }, () => {
          this.buttonScale1 = 0.95;
        });
        
        setTimeout(() => {
          animateTo({
            duration: 100,
            curve: Curve.EaseIn
          }, () => {
            this.buttonScale1 = 1.0;
          });
        }, 100);
        
        onClick();
      })
  }
  
  // 宠物图标装饰
  @Builder
  PetIcon(emoji: string, bgColor: string) {
    Column() {
      Text(emoji)
        .fontSize(AdaptiveUtils.fontSize(32))
    }
    .width(AdaptiveUtils.scale(55))
    .height(AdaptiveUtils.scale(55))
    .backgroundColor(bgColor)
    .borderRadius(AdaptiveUtils.scale(28))
    .justifyContent(FlexAlign.Center)
    .shadow({
      radius: 10,
      color: bgColor,
      offsetX: 0,
      offsetY: 5
    })
  }
}
