/**
 * 蛋和孵化器绘制组件
 */
import { PetType } from '../common/Constants';
import { PathUtils, ColorUtils } from '../utils/AdaptiveUtils';

// 蛋颜色接口
interface EggColors {
  main: string;
  pattern: string;
  dark: string;
}

// 创建蛋颜色
function createEggColors(main: string, pattern: string, dark: string): EggColors {
  const colors: EggColors = { main: main, pattern: pattern, dark: dark };
  return colors;
}

// ==================== 宠物蛋组件 ====================
@Component
export struct PetEggShape {
  @Prop eggSize: number = 80;
  @Prop petType: PetType = PetType.OCTO;
  @Prop crackProgress: number = 0;
  @Prop isSelected: boolean = false;
  
  build() {
    Stack() {
      Shape() {
        Path()
          .width(this.eggSize)
          .height(this.eggSize * 1.3)
          .commands(this.getEggPath())
          .fill(this.getEggColors().main)
      }
      .width(this.eggSize)
      .height(this.eggSize * 1.3)
      
      this.drawEggPattern(this.getEggColors())
      
      Shape() {
        Path()
          .width(this.eggSize * 0.3)
          .height(this.eggSize * 0.25)
          .commands(PathUtils.ellipse(this.eggSize * 0.15, this.eggSize * 0.125, this.eggSize * 0.15, this.eggSize * 0.125))
          .fill('#FFFFFF')
      }
      .width(this.eggSize * 0.3)
      .height(this.eggSize * 0.25)
      .position({ x: this.eggSize * 0.15, y: this.eggSize * 0.15 })
      .opacity(0.4)
      
      if (this.crackProgress > 0) {
        this.drawCracks()
      }
      
      if (this.isSelected) {
        Shape() {
          Path()
            .width(this.eggSize + 10)
            .height(this.eggSize * 1.3 + 10)
            .commands(PathUtils.ellipse((this.eggSize + 10) / 2, (this.eggSize * 1.3 + 10) / 2, (this.eggSize + 10) / 2, (this.eggSize * 1.3 + 10) / 2))
            .stroke('#FFD700')
            .strokeWidth(3)
        }
        .width(this.eggSize + 10)
        .height(this.eggSize * 1.3 + 10)
        .position({ x: -5, y: -5 })
      }
    }
    .width(this.eggSize * 1.2)
    .height(this.eggSize * 1.5)
  }
  
  private getEggColors(): EggColors {
    switch (this.petType) {
      case PetType.OCTO:
        return createEggColors('#FFB6C1', '#FF69B4', '#DB7093');
      case PetType.SERP:
        return createEggColors('#98FB98', '#32CD32', '#228B22');
      case PetType.ROBIN:
        return createEggColors('#87CEEB', '#4169E1', '#1E90FF');
      default:
        return createEggColors('#FFB6C1', '#FF69B4', '#DB7093');
    }
  }
  
  private getEggPath(): string {
    let w = this.eggSize;
    let h = this.eggSize * 1.3;
    return `M ${w * 0.5} 0 C ${w * 0.8} ${h * 0.2} ${w} ${h * 0.5} ${w * 0.85} ${h * 0.8} C ${w * 0.8} ${h} ${w * 0.2} ${h} ${w * 0.15} ${h * 0.8} C 0 ${h * 0.5} ${w * 0.2} ${h * 0.2} ${w * 0.5} 0 Z`;
  }
  
  @Builder
  drawEggPattern(colors: EggColors) {
    if (this.petType === PetType.OCTO) {
      ForEach([0, 1, 2], (index: number) => {
        Shape() {
          Path()
            .width(this.eggSize * 0.7)
            .height(5)
            .commands(`M 0 2.5 ${this.getWavePattern(this.eggSize * 0.7)}`)
            .stroke(colors.pattern)
            .strokeWidth(2)
        }
        .width(this.eggSize * 0.7)
        .height(5)
        .position({ x: this.eggSize * 0.15, y: this.eggSize * 0.4 + index * this.eggSize * 0.2 })
        .opacity(0.5)
      })
    } else if (this.petType === PetType.SERP) {
      Shape() {
        Path()
          .width(this.eggSize * 0.4)
          .height(this.eggSize * 0.6)
          .commands(this.getSpiralPath())
          .stroke(colors.pattern)
          .strokeWidth(2)
      }
      .width(this.eggSize * 0.4)
      .height(this.eggSize * 0.6)
      .position({ x: this.eggSize * 0.3, y: this.eggSize * 0.3 })
      .opacity(0.5)
    } else {
      ForEach([0, 1, 2, 3, 4], (index: number) => {
        Shape() {
          Path()
            .width(8)
            .height(8)
            .commands(PathUtils.ellipse(4, 4, 4, 3))
            .fill(colors.pattern)
        }
        .width(8)
        .height(8)
        .position({
          x: this.eggSize * 0.2 + (index % 3) * this.eggSize * 0.2,
          y: this.eggSize * 0.4 + Math.floor(index / 3) * this.eggSize * 0.3
        })
        .opacity(0.6)
      })
    }
  }
  
  private getWavePattern(w: number): string {
    let path = '';
    for (let x = 0; x <= w; x += 5) {
      let y = Math.sin(x * 0.1) * 2;
      path += ` L ${x} ${2.5 + y}`;
    }
    return path;
  }
  
  private getSpiralPath(): string {
    let path = `M ${this.eggSize * 0.2} ${this.eggSize * 0.3}`;
    for (let t = 0; t <= 4; t += 0.1) {
      let r = t * 5;
      let x = this.eggSize * 0.2 + r * Math.cos(t);
      let y = this.eggSize * 0.3 + r * Math.sin(t);
      path += ` L ${x} ${y}`;
    }
    return path;
  }
  
  @Builder
  drawCracks() {
    Shape() {
      Path()
        .width(this.eggSize * 0.6)
        .height(this.eggSize * 0.8)
        .commands(`M ${this.eggSize * 0.3} 0 L ${this.eggSize * 0.35} ${this.eggSize * 0.3 * this.crackProgress} L ${this.eggSize * 0.25} ${this.eggSize * 0.5 * this.crackProgress} L ${this.eggSize * 0.4} ${this.eggSize * 0.8 * this.crackProgress}`)
        .stroke('#8B4513')
        .strokeWidth(2)
    }
    .width(this.eggSize * 0.6)
    .height(this.eggSize * 0.8)
    .position({ x: this.eggSize * 0.2, y: this.eggSize * 0.2 })
    
    if (this.crackProgress > 0.3) {
      Shape() {
        Path()
          .width(this.eggSize * 0.4)
          .height(this.eggSize * 0.5)
          .commands(`M ${this.eggSize * 0.1} ${this.eggSize * 0.2} L ${this.eggSize * 0.3} ${this.eggSize * 0.4 * (this.crackProgress - 0.3) / 0.7}`)
          .stroke('#8B4513')
          .strokeWidth(1.5)
      }
      .width(this.eggSize * 0.4)
      .height(this.eggSize * 0.5)
      .position({ x: this.eggSize * 0.5, y: this.eggSize * 0.3 })
    }
  }
}

// ==================== 孵化器组件 ====================
@Component
export struct IncubatorShape {
  @Prop incSize: number = 200;
  @Prop hasEgg: boolean = true;
  @Prop eggType: PetType = PetType.OCTO;
  @Prop glowIntensity: number = 0.5;
  
  build() {
    Stack() {
      this.drawBase()
      this.drawDome()
      this.drawGlow()
      
      if (this.hasEgg) {
        PetEggShape({
          eggSize: this.incSize * 0.35,
          petType: this.eggType
        })
        .position({ x: this.incSize * 0.35, y: this.incSize * 0.25 })
      }
      
      this.drawControlPanel()
    }
    .width(this.incSize)
    .height(this.incSize * 0.9)
  }
  
  @Builder
  drawBase() {
    Shape() {
      Path()
        .width(this.incSize)
        .height(this.incSize * 0.25)
        .commands(PathUtils.roundRect(0, 0, this.incSize, this.incSize * 0.25, 10))
        .fill('#E8E8E8')
    }
    .width(this.incSize)
    .height(this.incSize * 0.25)
    .position({ x: 0, y: this.incSize * 0.65 })
    
    Shape() {
      Path()
        .width(this.incSize * 0.9)
        .height(8)
        .commands(PathUtils.roundRect(0, 0, this.incSize * 0.9, 8, 4))
        .fill('#C0C0C0')
    }
    .width(this.incSize * 0.9)
    .height(8)
    .position({ x: this.incSize * 0.05, y: this.incSize * 0.72 })
  }
  
  @Builder
  drawDome() {
    Shape() {
      Path()
        .width(this.incSize * 0.85)
        .height(this.incSize * 0.6)
        .commands(this.getDomePath())
        .fill('#E0F7FA')
        .stroke('#80DEEA')
        .strokeWidth(2)
    }
    .width(this.incSize * 0.85)
    .height(this.incSize * 0.6)
    .position({ x: this.incSize * 0.075, y: this.incSize * 0.1 })
    .opacity(0.6)
    
    Shape() {
      Path()
        .width(this.incSize * 0.3)
        .height(this.incSize * 0.35)
        .commands(this.getDomeHighlightPath())
        .fill('#FFFFFF')
    }
    .width(this.incSize * 0.3)
    .height(this.incSize * 0.35)
    .position({ x: this.incSize * 0.15, y: this.incSize * 0.15 })
    .opacity(0.3)
  }
  
  private getDomePath(): string {
    let s = this.incSize;
    return `M 0 ${s * 0.6} Q 0 0 ${s * 0.425} 0 Q ${s * 0.85} 0 ${s * 0.85} ${s * 0.6} Z`;
  }
  
  private getDomeHighlightPath(): string {
    let s = this.incSize;
    return `M 0 ${s * 0.35} Q 0 0 ${s * 0.15} 0 Q ${s * 0.3} 0 ${s * 0.3} ${s * 0.35} Z`;
  }
  
  @Builder
  drawGlow() {
    Shape() {
      Path()
        .width(this.incSize * 0.6)
        .height(this.incSize * 0.4)
        .commands(PathUtils.ellipse(this.incSize * 0.3, this.incSize * 0.2, this.incSize * 0.3, this.incSize * 0.2))
        .fill('#FFE4B5')
    }
    .width(this.incSize * 0.6)
    .height(this.incSize * 0.4)
    .position({ x: this.incSize * 0.2, y: this.incSize * 0.3 })
    .opacity(this.glowIntensity * 0.5)
  }
  
  @Builder
  drawControlPanel() {
    Row() {
      Shape() {
        Path()
          .width(12)
          .height(12)
          .commands(PathUtils.circle(6, 6, 6))
          .fill('#4CAF50')
      }
      .width(12)
      .height(12)
      
      Blank().width(10)
      
      Shape() {
        Path()
          .width(this.incSize * 0.25)
          .height(20)
          .commands(PathUtils.roundRect(0, 0, this.incSize * 0.25, 20, 5))
          .fill('#333333')
      }
      .width(this.incSize * 0.25)
      .height(20)
    }
    .width(this.incSize * 0.4)
    .height(25)
    .position({ x: this.incSize * 0.3, y: this.incSize * 0.78 })
  }
}
