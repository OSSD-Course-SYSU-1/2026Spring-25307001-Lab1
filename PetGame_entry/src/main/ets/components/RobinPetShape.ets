/**
 * Robin精灵绘制 - 鸟形宠物
 */
import { GrowthStage } from '../common/Constants';
import { PathUtils, ColorUtils } from '../utils/AdaptiveUtils';

interface RobinColors {
  main: string;
  light: string;
  dark: string;
  accent: string;
}

function createRobinColors(main: string, light: string, dark: string, accent: string): RobinColors {
  const colors: RobinColors = { main: main, light: light, dark: dark, accent: accent };
  return colors;
}

@Component
export struct RobinPetShape {
  @Prop petSize: number = 100;
  @Prop growthStage: GrowthStage = GrowthStage.BABY;
  @Prop isSad: boolean = false;
  @Prop isExcited: boolean = false;
  @Prop isSleeping: boolean = false;
  @Prop skinId: number = 0;
  
  private getGrowthScale(): number {
    switch (this.growthStage) {
      case GrowthStage.BABY: return 0.55;
      case GrowthStage.YOUTH: return 0.8;
      case GrowthStage.ADULT: return 1.0;
      default: return 0.55;
    }
  }
  
  private getColors(): RobinColors {
    switch (this.skinId) {
      case 1: return createRobinColors('#9B59B6', '#D7BDE2', '#7D3C98', '#E8DAEF');
      case 2: return createRobinColors('#FFB6C1', '#FFDDE1', '#FF69B4', '#FFC0CB');
      case 3: return createRobinColors('#E74C3C', '#F5B7B1', '#C0392B', '#F1948A');
      case 4: return createRobinColors('#1ABC9C', '#A3E4D7', '#16A085', '#76D7C4');
      default: return createRobinColors(ColorUtils.ROBIN_COLOR, ColorUtils.ROBIN_COLOR_LIGHT, '#5DADE2', '#AED6F1');
    }
  }
  
  build() {
    Stack() {
      this.drawTail(this.petSize * this.getGrowthScale(), this.getColors())
      this.drawBody(this.petSize * this.getGrowthScale(), this.getColors())
      this.drawWings(this.petSize * this.getGrowthScale(), this.getColors())
      this.drawHead(this.petSize * this.getGrowthScale(), this.getColors())
      this.drawEyes(this.petSize * this.getGrowthScale())
      this.drawBeak(this.petSize * this.getGrowthScale())
      this.drawCrest(this.petSize * this.getGrowthScale(), this.getColors())
      this.drawCheeks(this.petSize * this.getGrowthScale())
    }
    .width(this.petSize * 1.3)
    .height(this.petSize * 1.2)
  }
  
  @Builder
  drawTail(size: number, colors: RobinColors) {
    ForEach([0, 1, 2], (index: number) => {
      Shape() {
        Path()
          .width(size * 0.25)
          .height(size * 0.4)
          .commands(`M 0 ${size * 0.4} Q ${size * 0.1} ${size * 0.2} ${size * 0.15} 0 L ${size * 0.2} 0 Q ${size * 0.15} ${size * 0.2} ${size * 0.25} ${size * 0.4} Z`)
          .fill(index === 1 ? colors.light : colors.dark)
      }
      .width(size * 0.25)
      .height(size * 0.4)
      .position({
        x: this.petSize * 0.05 + index * size * 0.08,
        y: size * 0.5
      })
      .rotate({ angle: -15 + index * 15 })
    })
  }
  
  @Builder
  drawBody(size: number, colors: RobinColors) {
    Shape() {
      Path()
        .width(size * 0.7)
        .height(size * 0.6)
        .commands(PathUtils.ellipse(size * 0.35, size * 0.3, size * 0.35, size * 0.3))
        .fill(colors.main)
    }
    .width(size * 0.7)
    .height(size * 0.6)
    .position({ x: this.petSize * 0.3, y: size * 0.35 })
    
    Shape() {
      Path()
        .width(size * 0.45)
        .height(size * 0.4)
        .commands(PathUtils.ellipse(size * 0.225, size * 0.2, size * 0.225, size * 0.2))
        .fill(colors.accent)
    }
    .width(size * 0.45)
    .height(size * 0.4)
    .position({ x: this.petSize * 0.42, y: size * 0.45 })
    .opacity(0.8)
  }
  
  @Builder
  drawWings(size: number, colors: RobinColors) {
    // 左翅膀
    Shape() {
      Path()
        .width(size * 0.3)
        .height(size * 0.35)
        .commands(`M ${size * 0.3} ${size * 0.1} Q ${size * 0.15} 0 0 ${size * 0.15} Q ${size * 0.1} ${size * 0.25} ${size * 0.2} ${size * 0.35} Q ${size * 0.25} ${size * 0.25} ${size * 0.3} ${size * 0.1} Z`)
        .fill(colors.dark)
    }
    .width(size * 0.3)
    .height(size * 0.35)
    .position({ x: this.petSize * 0.25, y: size * 0.35 })
    
    Shape() {
      Path()
        .width(size * 0.3)
        .height(size * 0.35)
        .commands(`M 0 ${size * 0.1} Q ${size * 0.15} 0 ${size * 0.3} ${size * 0.15} Q ${size * 0.2} ${size * 0.25} ${size * 0.1} ${size * 0.35} Q ${size * 0.05} ${size * 0.25} 0 ${size * 0.1} Z`)
        .fill(colors.dark)
    }
    .width(size * 0.3)
    .height(size * 0.35)
    .position({ x: this.petSize * 0.75, y: size * 0.35 })
  }
  
  @Builder
  drawHead(size: number, colors: RobinColors) {
    Shape() {
      Path()
        .width(size * 0.45)
        .height(size * 0.4)
        .commands(PathUtils.ellipse(size * 0.225, size * 0.2, size * 0.225, size * 0.2))
        .fill(colors.main)
    }
    .width(size * 0.45)
    .height(size * 0.4)
    .position({ x: this.petSize * 0.45, y: size * 0.05 })
    
    Shape() {
      Path()
        .width(size * 0.2)
        .height(size * 0.12)
        .commands(PathUtils.ellipse(size * 0.1, size * 0.06, size * 0.1, size * 0.06))
        .fill(colors.light)
    }
    .width(size * 0.2)
    .height(size * 0.12)
    .position({ x: this.petSize * 0.58, y: size * 0.08 })
    .opacity(0.5)
  }
  
  @Builder
  drawEyes(size: number) {
    Row() {
      // 左眼
      Stack() {
        if (this.isSleeping) {
          Shape() {
            Path()
              .width(size * 0.1)
              .height(size * 0.03)
              .commands(`M 0 ${size * 0.015} Q ${size * 0.05} ${size * 0.03} ${size * 0.1} ${size * 0.015}`)
              .stroke('#333333')
              .strokeWidth(2)
          }
        } else {
          Shape() {
            Path()
              .width(size * 0.12)
              .height(size * 0.14)
              .commands(PathUtils.ellipse(size * 0.06, size * 0.07, size * 0.06, size * 0.07))
              .fill('#FFFFFF')
          }
          Shape() {
            Path()
              .width(size * 0.06)
              .height(size * 0.08)
              .commands(PathUtils.ellipse(size * 0.03, size * 0.04, size * 0.03, size * 0.04))
              .fill(this.isSad ? '#666666' : '#333333')
          }
          .position({ x: size * 0.03, y: size * 0.03 })
          // 高光
          Shape() {
            Path()
              .width(size * 0.025)
              .height(size * 0.025)
              .commands(PathUtils.circle(size * 0.0125, size * 0.0125, size * 0.0125))
              .fill('#FFFFFF')
          }
          .position({ x: size * 0.02, y: size * 0.015 })
        }
      }
      .width(size * 0.12)
      .height(size * 0.14)
      
      Blank().width(size * 0.1)
      
      // 右眼
      Stack() {
        if (this.isSleeping) {
          Shape() {
            Path()
              .width(size * 0.1)
              .height(size * 0.03)
              .commands(`M 0 ${size * 0.015} Q ${size * 0.05} ${size * 0.03} ${size * 0.1} ${size * 0.015}`)
              .stroke('#333333')
              .strokeWidth(2)
          }
        } else {
          Shape() {
            Path()
              .width(size * 0.12)
              .height(size * 0.14)
              .commands(PathUtils.ellipse(size * 0.06, size * 0.07, size * 0.06, size * 0.07))
              .fill('#FFFFFF')
          }
          Shape() {
            Path()
              .width(size * 0.06)
              .height(size * 0.08)
              .commands(PathUtils.ellipse(size * 0.03, size * 0.04, size * 0.03, size * 0.04))
              .fill(this.isSad ? '#666666' : '#333333')
          }
          .position({ x: size * 0.03, y: size * 0.03 })
          Shape() {
            Path()
              .width(size * 0.025)
              .height(size * 0.025)
              .commands(PathUtils.circle(size * 0.0125, size * 0.0125, size * 0.0125))
              .fill('#FFFFFF')
          }
          .position({ x: size * 0.02, y: size * 0.015 })
        }
      }
      .width(size * 0.12)
      .height(size * 0.14)
    }
    .width(size * 0.34)
    .height(size * 0.14)
    .position({ x: this.petSize * 0.5, y: size * 0.15 })
  }
  
  @Builder
  drawBeak(size: number) {
    Shape() {
      Path()
        .width(size * 0.15)
        .height(size * 0.12)
        .commands(`M 0 ${size * 0.06} L ${size * 0.15} ${size * 0.12} L 0 ${size * 0.12} Z`)
        .fill('#FFA500')
    }
    .width(size * 0.15)
    .height(size * 0.12)
    .position({ x: this.petSize * 0.9, y: size * 0.22 })
  }
  
  @Builder
  drawCrest(size: number, colors: RobinColors) {
    ForEach([0, 1, 2], (index: number) => {
      Shape() {
        Path()
          .width(size * 0.06)
          .height(size * 0.15)
          .commands(`M ${size * 0.03} ${size * 0.15} Q ${size * 0.05} ${size * 0.07} ${size * 0.03} 0 Q ${size * 0.01} ${size * 0.07} ${size * 0.03} ${size * 0.15} Z`)
          .fill(colors.dark)
      }
      .width(size * 0.06)
      .height(size * 0.15)
      .position({
        x: this.petSize * 0.6 + index * size * 0.05,
        y: -size * 0.05
      })
      .rotate({ angle: -20 + index * 20 })
    })
  }
  
  @Builder
  drawCheeks(size: number) {
    Shape() {
      Path()
        .width(size * 0.08)
        .height(size * 0.05)
        .commands(PathUtils.ellipse(size * 0.04, size * 0.025, size * 0.04, size * 0.025))
        .fill('#FFB6C1')
    }
    .width(size * 0.08)
    .height(size * 0.05)
    .position({ x: this.petSize * 0.48, y: size * 0.28 })
    .opacity(0.6)
    
    Shape() {
      Path()
        .width(size * 0.08)
        .height(size * 0.05)
        .commands(PathUtils.ellipse(size * 0.04, size * 0.025, size * 0.04, size * 0.025))
        .fill('#FFB6C1')
    }
    .width(size * 0.08)
    .height(size * 0.05)
    .position({ x: this.petSize * 0.78, y: size * 0.28 })
    .opacity(0.6)
  }
}
