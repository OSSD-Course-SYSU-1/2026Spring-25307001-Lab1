/**
 * 功能按钮组件
 */
import { PathUtils, ColorUtils, AdaptiveUtils } from '../utils/AdaptiveUtils';

// ==================== 喂食按钮 ====================
@Component
export struct FeedButton {
  @Prop btnSize: number = 60;
  @Prop isEnabled: boolean = true;
  onBtnClick: () => void = () => {};
  
  build() {
    Column() {
      Stack() {
        // 阴影层
        Shape() {
          Path()
            .width(this.btnSize)
            .height(this.btnSize)
            .commands(PathUtils.circle(this.btnSize / 2, this.btnSize / 2, this.btnSize / 2 - 2))
            .fill('rgba(255, 107, 107, 0.3)')
        }
        .width(this.btnSize)
        .height(this.btnSize)
        .position({ x: 0, y: 4 })
        .blur(8)
        
        // 主体
        Shape() {
          Path()
            .width(this.btnSize)
            .height(this.btnSize)
            .commands(PathUtils.circle(this.btnSize / 2, this.btnSize / 2, this.btnSize / 2 - 2))
            .fill(this.isEnabled ? '#FFE4E1' : '#E0E0E0')
        }
        .width(this.btnSize)
        .height(this.btnSize)
        
        this.drawUtensils()
      }
      .width(this.btnSize)
      .height(this.btnSize)
      
      Text('喂食')
        .fontSize(AdaptiveUtils.fontSize(10))
        .fontColor(this.isEnabled ? '#FF6B6B' : '#999999')
        .fontWeight(FontWeight.Medium)
        .margin({ top: AdaptiveUtils.spacing(3) })
    }
    .width(this.btnSize)
    .height(this.btnSize + AdaptiveUtils.scale(18))
    .opacity(this.isEnabled ? 1.0 : 0.5)
    .onClick(() => {
      if (this.isEnabled) {
        this.onBtnClick();
      }
    })
  }
  
  @Builder
  drawUtensils() {
    Stack() {
      Shape() {
        Path()
          .width(this.btnSize * 0.15)
          .height(this.btnSize * 0.5)
          .commands(this.getForkPath())
          .stroke(this.isEnabled ? '#FF6B6B' : '#999999')
          .strokeWidth(2)
      }
      .width(this.btnSize * 0.15)
      .height(this.btnSize * 0.5)
      .position({ x: this.btnSize * 0.2, y: this.btnSize * 0.25 })
      
      Shape() {
        Path()
          .width(this.btnSize * 0.2)
          .height(this.btnSize * 0.5)
          .commands(this.getSpoonPath())
          .stroke(this.isEnabled ? '#FF6B6B' : '#999999')
          .strokeWidth(2)
      }
      .width(this.btnSize * 0.2)
      .height(this.btnSize * 0.5)
      .position({ x: this.btnSize * 0.55, y: this.btnSize * 0.25 })
    }
    .width(this.btnSize)
    .height(this.btnSize)
  }
  
  private getForkPath(): string {
    let w = this.btnSize * 0.15;
    let h = this.btnSize * 0.5;
    return `M ${w * 0.3} 0 L ${w * 0.3} ${h * 0.3} M ${w * 0.5} 0 L ${w * 0.5} ${h * 0.3} M ${w * 0.7} 0 L ${w * 0.7} ${h * 0.3} M ${w * 0.5} ${h * 0.3} L ${w * 0.5} ${h}`;
  }
  
  private getSpoonPath(): string {
    let w = this.btnSize * 0.2;
    let h = this.btnSize * 0.5;
    return `M ${w * 0.5} ${h * 0.25} L ${w * 0.5} ${h} M ${w * 0.5} ${h * 0.25} Q 0 0 0 ${h * 0.15} Q 0 ${h * 0.25} ${w * 0.5} ${h * 0.25} Q ${w} ${h * 0.25} ${w} ${h * 0.15} Q ${w} 0 ${w * 0.5} ${h * 0.25}`;
  }
}

// ==================== 洗澡按钮 ====================
@Component
export struct BathButton {
  @Prop btnSize: number = 60;
  @Prop isEnabled: boolean = true;
  onBtnClick: () => void = () => {};
  
  build() {
    Column() {
      Stack() {
        // 阴影层
        Shape() {
          Path()
            .width(this.btnSize)
            .height(this.btnSize)
            .commands(PathUtils.circle(this.btnSize / 2, this.btnSize / 2, this.btnSize / 2 - 2))
            .fill('rgba(66, 165, 245, 0.3)')
        }
        .width(this.btnSize)
        .height(this.btnSize)
        .position({ x: 0, y: 4 })
        .blur(8)
        
        // 主体
        Shape() {
          Path()
            .width(this.btnSize)
            .height(this.btnSize)
            .commands(PathUtils.circle(this.btnSize / 2, this.btnSize / 2, this.btnSize / 2 - 2))
            .fill(this.isEnabled ? '#E3F2FD' : '#E0E0E0')
        }
        .width(this.btnSize)
        .height(this.btnSize)
        
        // 浴缸图标
        this.drawBathtub()
      }
      .width(this.btnSize)
      .height(this.btnSize)
      
      Text('洗澡')
        .fontSize(AdaptiveUtils.fontSize(10))
        .fontColor(this.isEnabled ? '#42A5F5' : '#999999')
        .fontWeight(FontWeight.Medium)
        .margin({ top: AdaptiveUtils.spacing(3) })
    }
    .width(this.btnSize)
    .height(this.btnSize + AdaptiveUtils.scale(18))
    .opacity(this.isEnabled ? 1.0 : 0.5)
    .onClick(() => {
      if (this.isEnabled) {
        this.onBtnClick();
      }
    })
  }
  
  @Builder
  drawBathtub() {
    Stack() {
      // 浴缸
      Shape() {
        Path()
          .width(this.btnSize * 0.6)
          .height(this.btnSize * 0.35)
          .commands(`M 0 ${this.btnSize * 0.15} Q 0 ${this.btnSize * 0.35} ${this.btnSize * 0.3} ${this.btnSize * 0.35} Q ${this.btnSize * 0.6} ${this.btnSize * 0.35} ${this.btnSize * 0.6} ${this.btnSize * 0.15}`)
          .stroke(this.isEnabled ? '#42A5F5' : '#999999')
          .strokeWidth(2)
      }
      .width(this.btnSize * 0.6)
      .height(this.btnSize * 0.35)
      .position({ x: this.btnSize * 0.2, y: this.btnSize * 0.35 })
      
      // 水滴
      ForEach([0, 1, 2], (index: number) => {
        Shape() {
          Path()
            .width(8)
            .height(10)
            .commands(`M 4 0 Q 0 6 4 10 Q 8 6 4 0 Z`)
            .fill(this.isEnabled ? '#87CEEB' : '#BDBDBD')
        }
        .width(8)
        .height(10)
        .position({
          x: this.btnSize * 0.3 + index * 10,
          y: this.btnSize * 0.25
        })
      })
    }
    .width(this.btnSize)
    .height(this.btnSize)
  }
}

// ==================== 装扮按钮 ====================
@Component
export struct DressButton {
  @Prop btnSize: number = 60;
  @Prop isEnabled: boolean = true;
  onBtnClick: () => void = () => {};
  
  build() {
    Column() {
      Stack() {
        // 阴影层
        Shape() {
          Path()
            .width(this.btnSize)
            .height(this.btnSize)
            .commands(PathUtils.circle(this.btnSize / 2, this.btnSize / 2, this.btnSize / 2 - 2))
            .fill('rgba(171, 71, 188, 0.3)')
        }
        .width(this.btnSize)
        .height(this.btnSize)
        .position({ x: 0, y: 4 })
        .blur(8)
        
        // 主体
        Shape() {
          Path()
            .width(this.btnSize)
            .height(this.btnSize)
            .commands(PathUtils.circle(this.btnSize / 2, this.btnSize / 2, this.btnSize / 2 - 2))
            .fill(this.isEnabled ? '#F3E5F5' : '#E0E0E0')
        }
        .width(this.btnSize)
        .height(this.btnSize)
        
        // 衣架图标
        this.drawHanger()
      }
      .width(this.btnSize)
      .height(this.btnSize)
      
      Text('装扮')
        .fontSize(AdaptiveUtils.fontSize(10))
        .fontColor(this.isEnabled ? '#AB47BC' : '#999999')
        .fontWeight(FontWeight.Medium)
        .margin({ top: AdaptiveUtils.spacing(3) })
    }
    .width(this.btnSize)
    .height(this.btnSize + AdaptiveUtils.scale(18))
    .opacity(this.isEnabled ? 1.0 : 0.5)
    .onClick(() => {
      if (this.isEnabled) {
        this.onBtnClick();
      }
    })
  }
  
  @Builder
  drawHanger() {
    Stack() {
      // 衣架钩
      Shape() {
        Path()
          .width(this.btnSize * 0.15)
          .height(this.btnSize * 0.2)
          .commands(`M ${this.btnSize * 0.075} 0 L ${this.btnSize * 0.075} ${this.btnSize * 0.1} Q ${this.btnSize * 0.15} ${this.btnSize * 0.15} ${this.btnSize * 0.075} ${this.btnSize * 0.2}`)
          .stroke(this.isEnabled ? '#AB47BC' : '#999999')
          .strokeWidth(2)
      }
      .width(this.btnSize * 0.15)
      .height(this.btnSize * 0.2)
      .position({ x: this.btnSize * 0.425, y: this.btnSize * 0.15 })
      
      // 衣架杆
      Shape() {
        Path()
          .width(this.btnSize * 0.6)
          .height(this.btnSize * 0.05)
          .commands(`M 0 ${this.btnSize * 0.025} Q ${this.btnSize * 0.3} ${this.btnSize * 0.05} ${this.btnSize * 0.6} ${this.btnSize * 0.025}`)
          .stroke(this.isEnabled ? '#AB47BC' : '#999999')
          .strokeWidth(2)
      }
      .width(this.btnSize * 0.6)
      .height(this.btnSize * 0.05)
      .position({ x: this.btnSize * 0.2, y: this.btnSize * 0.35 })
      
      // 小衣服
      Shape() {
        Path()
          .width(this.btnSize * 0.35)
          .height(this.btnSize * 0.25)
          .commands(`M ${this.btnSize * 0.175} 0 L 0 ${this.btnSize * 0.1} L 0 ${this.btnSize * 0.25} L ${this.btnSize * 0.35} ${this.btnSize * 0.25} L ${this.btnSize * 0.35} ${this.btnSize * 0.1} Z`)
          .fill(this.isEnabled ? '#E1BEE7' : '#BDBDBD')
      }
      .width(this.btnSize * 0.35)
      .height(this.btnSize * 0.25)
      .position({ x: this.btnSize * 0.325, y: this.btnSize * 0.4 })
    }
    .width(this.btnSize)
    .height(this.btnSize)
  }
}

// ==================== 睡觉按钮 ====================
@Component
export struct SleepButton {
  @Prop btnSize: number = 60;
  @Prop isSleeping: boolean = false;
  onBtnClick: () => void = () => {};
  
  build() {
    Column() {
      Stack() {
        // 阴影层
        Shape() {
          Path()
            .width(this.btnSize)
            .height(this.btnSize)
            .commands(PathUtils.circle(this.btnSize / 2, this.btnSize / 2, this.btnSize / 2 - 2))
            .fill(this.isSleeping ? 'rgba(255, 213, 79, 0.3)' : 'rgba(158, 158, 158, 0.2)')
        }
        .width(this.btnSize)
        .height(this.btnSize)
        .position({ x: 0, y: 4 })
        .blur(8)
        
        // 主体
        Shape() {
          Path()
            .width(this.btnSize)
            .height(this.btnSize)
            .commands(PathUtils.circle(this.btnSize / 2, this.btnSize / 2, this.btnSize / 2 - 2))
            .fill(this.isSleeping ? '#FFF9C4' : '#E8E8E8')
        }
        .width(this.btnSize)
        .height(this.btnSize)
        
        // 月亮和星星
        this.drawSleepIcon()
      }
      .width(this.btnSize)
      .height(this.btnSize)
      
      Text(this.isSleeping ? '起床' : '睡觉')
        .fontSize(AdaptiveUtils.fontSize(10))
        .fontColor(this.isSleeping ? '#FFD54F' : '#666666')
        .fontWeight(FontWeight.Medium)
        .margin({ top: AdaptiveUtils.spacing(3) })
    }
    .width(this.btnSize)
    .height(this.btnSize + AdaptiveUtils.scale(18))
    .onClick(() => {
      this.onBtnClick();
    })
  }
  
  @Builder
  drawSleepIcon() {
    Stack() {
      // 月亮
      Shape() {
        Path()
          .width(this.btnSize * 0.35)
          .height(this.btnSize * 0.35)
          .commands(`M ${this.btnSize * 0.35} ${this.btnSize * 0.1} Q ${this.btnSize * 0.35} 0 ${this.btnSize * 0.2} 0 Q 0 0 0 ${this.btnSize * 0.175} Q 0 ${this.btnSize * 0.35} ${this.btnSize * 0.2} ${this.btnSize * 0.35} Q ${this.btnSize * 0.35} ${this.btnSize * 0.35} ${this.btnSize * 0.35} ${this.btnSize * 0.175} Q ${this.btnSize * 0.25} ${this.btnSize * 0.25} ${this.btnSize * 0.35} ${this.btnSize * 0.1} Z`)
          .fill(this.isSleeping ? '#FFD54F' : '#BDBDBD')
      }
      .width(this.btnSize * 0.35)
      .height(this.btnSize * 0.35)
      .position({ x: this.btnSize * 0.35, y: this.btnSize * 0.25 })
      
      // Z字符
      Text('Z')
        .fontSize(16)
        .fontColor(this.isSleeping ? '#FFD54F' : '#999999')
        .fontWeight(FontWeight.Bold)
        .position({ x: this.btnSize * 0.6, y: this.btnSize * 0.2 })
      
      Text('z')
        .fontSize(12)
        .fontColor(this.isSleeping ? '#FFD54F' : '#999999')
        .fontWeight(FontWeight.Bold)
        .position({ x: this.btnSize * 0.7, y: this.btnSize * 0.3 })
    }
    .width(this.btnSize)
    .height(this.btnSize)
  }
}
