/**
 * 开场动画组件 - 使用Button确保点击响应
 */

@Component
export struct IntroDoorAnimation {
  @Prop doorWidth: number = 200;
  @Prop doorHeight: number = 320;
  @State showBox: boolean = false;
  private timer: number = -1;
  
  onBoxClick?: () => void;
  
  aboutToAppear() {
    this.timer = setTimeout(() => {
      this.showBox = true;
    }, 1000);
  }
  
  aboutToDisappear() {
    if (this.timer !== -1) {
      clearTimeout(this.timer);
    }
  }
  
  build() {
    Column() {
      Blank().height('15%')
      
      // 标题
      Column() {
        Text('宠物养成游戏')
          .fontSize(36)
          .fontWeight(FontWeight.Bold)
          .linearGradient({
            angle: 90,
            colors: [['#EC4899', 0], ['#8B5CF6', 1]]
          })
      }
      .height(60)
      
      Blank().height('8%')
      
      // 箱子
      if (this.showBox) {
        Button({ type: ButtonType.Normal }) {
          Column() {
            // 箱子主体
            Column()
              .width(140)
              .height(110)
              .linearGradient({
                angle: 135,
                colors: [['#D4A574', 0], ['#CD853F', 1]]
              })
              .border({ width: 4, color: '#8B4513' })
              .borderRadius(12)
              .shadow({
                radius: 12,
                color: 'rgba(139, 69, 19, 0.3)',
                offsetX: 0,
                offsetY: 4
              })
          }
          .width(180)
          .height(150)
          .justifyContent(FlexAlign.Center)
        }
        .width(180)
        .height(150)
        .backgroundColor('transparent')
        .borderRadius(0)
        .onClick(() => {
          console.log('=== Button被点击 ===');
          if (this.onBoxClick) {
            this.onBoxClick();
          }
        })
      } else {
        Column()
          .width(180)
          .height(150)
      }
      
      Blank().height('8%')
      
      // 提示文字
      if (this.showBox) {
        Row() {
          Text('🎁 ')
            .fontSize(16)
          Text('点击箱子开始游戏')
            .fontSize(16)
            .fontColor('#7C3AED')
            .fontWeight(FontWeight.Medium)
        }
        .height(40)
      } else {
        Row() {
          Text('✨ ')
            .fontSize(14)
          Text('加载中...')
            .fontSize(14)
            .fontColor('#9CA3AF')
        }
        .height(40)
      }
      
      Blank().layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .linearGradient({
      angle: 135,
      colors: [['#FFF5E6', 0], ['#FDE8D8', 1]]
    })
  }
}
