/**
 * Serp精灵绘制 - 蛇形宠物（精细版）
 */
import { GrowthStage } from '../common/Constants';
import { PathUtils, ColorUtils } from '../utils/AdaptiveUtils';

interface PetColors {
  main: string;
  light: string;
  dark: string;
  pattern: string; // 花纹颜色
}

function createPetColors(main: string, light: string, dark: string, pattern: string = '#FFFFFF'): PetColors {
  const colors: PetColors = { main: main, light: light, dark: dark, pattern: pattern };
  return colors;
}

@Component
export struct SerpPetShape {
  @Prop petSize: number = 100;
  @Prop growthStage: GrowthStage = GrowthStage.BABY;
  @Prop isSad: boolean = false;
  @Prop isExcited: boolean = false;
  @Prop isSleeping: boolean = false;
  @Prop skinId: number = 0;
  
  private getGrowthScale(): number {
    switch (this.growthStage) {
      case GrowthStage.BABY: return 0.6;
      case GrowthStage.YOUTH: return 0.8;
      case GrowthStage.ADULT: return 1.0;
      default: return 0.6;
    }
  }
  
  private getColors(): PetColors {
    switch (this.skinId) {
      case 1: return createPetColors('#9B59B6', '#D7BDE2', '#7D3C98', '#E8DAEF');
      case 2: return createPetColors('#FFB6C1', '#FFDDE1', '#FF69B4', '#FFC0CB');
      case 3: return createPetColors('#E74C3C', '#F5B7B1', '#C0392B', '#FADBD8');
      case 4: return createPetColors('#1ABC9C', '#A3E4D7', '#16A085', '#D1F2EB');
      default: return createPetColors(ColorUtils.SERP_COLOR, ColorUtils.SERP_COLOR_LIGHT, '#6BC5A8', '#E8F8F5');
    }
  }
  
  build() {
    Stack() {
      // 蛇身体（蜿蜒的S形）
      this.drawWindingBody(this.petSize * this.getGrowthScale(), this.getColors());
      
      // 鳞片纹理
      this.drawScales(this.petSize * this.getGrowthScale(), this.getColors());
      
      // 蛇头
      this.drawSnakeHead(this.petSize * this.getGrowthScale(), this.getColors());
      
      // 眼睛
      this.drawSnakeEyes(this.petSize * this.getGrowthScale());
      
      // 舌头（蛇的信子）
      if (!this.isSleeping && !this.isSad) {
        this.drawSnakeTongue(this.petSize * this.getGrowthScale());
      }
      
      // 尾巴尖
      this.drawTailTip(this.petSize * this.getGrowthScale(), this.getColors());
    }
    .width(this.petSize * 1.4)
    .height(this.petSize * 1.2)
  }
  
  // 蜿蜒的身体（S形曲线）
  @Builder
  drawWindingBody(size: number, colors: PetColors) {
    // 身体主体 - 使用多层椭圆模拟蜿蜒效果
    Stack() {
      // 尾部（最细）
      Shape() {
        Path()
          .width(size * 0.15)
          .height(size * 0.08)
          .commands(PathUtils.ellipse(size * 0.075, size * 0.04, size * 0.075, size * 0.04))
          .fill(colors.dark)
      }
      .width(size * 0.15)
      .height(size * 0.08)
      .position({ x: size * 0.1, y: size * 0.55 })
      
      // 身体段1（向右下）
      Shape() {
        Path()
          .width(size * 0.5)
          .height(size * 0.18)
          .commands(PathUtils.ellipse(size * 0.25, size * 0.09, size * 0.25, size * 0.09))
          .fill(colors.main)
      }
      .width(size * 0.5)
      .height(size * 0.18)
      .position({ x: size * 0.15, y: size * 0.45 })
      .rotate({ angle: -15 })
      
      // 身体段2（中间隆起）
      Shape() {
        Path()
          .width(size * 0.55)
          .height(size * 0.22)
          .commands(PathUtils.ellipse(size * 0.275, size * 0.11, size * 0.275, size * 0.11))
          .fill(colors.main)
      }
      .width(size * 0.55)
      .height(size * 0.22)
      .position({ x: size * 0.35, y: size * 0.35 })
      .rotate({ angle: 10 })
      
      // 身体段3（向右上）
      Shape() {
        Path()
          .width(size * 0.45)
          .height(size * 0.16)
          .commands(PathUtils.ellipse(size * 0.225, size * 0.08, size * 0.225, size * 0.08))
          .fill(colors.main)
      }
      .width(size * 0.45)
      .height(size * 0.16)
      .position({ x: size * 0.65, y: size * 0.25 })
      .rotate({ angle: -20 })
      
      // 高光（身体上部）
      Shape() {
        Path()
          .width(size * 0.5)
          .height(size * 0.08)
          .commands(PathUtils.ellipse(size * 0.25, size * 0.04, size * 0.25, size * 0.04))
          .fill(colors.light)
      }
      .width(size * 0.5)
      .height(size * 0.08)
      .position({ x: size * 0.35, y: size * 0.32 })
      .opacity(0.6)
    }
    .width(size * 1.2)
    .height(size * 0.8)
  }
  
  // 鳞片纹理
  @Builder
  drawScales(size: number, colors: PetColors) {
    Stack() {
      // 鳞片行1
      this.drawScaleRow(size, colors, size * 0.25, size * 0.42, 5, size * 0.04)
      // 鳞片行2
      this.drawScaleRow(size, colors, size * 0.35, size * 0.38, 6, size * 0.035)
      // 鳞片行3
      this.drawScaleRow(size, colors, size * 0.45, size * 0.35, 5, size * 0.038)
      // 鳞片行4
      this.drawScaleRow(size, colors, size * 0.55, size * 0.32, 4, size * 0.032)
    }
    .width(size * 1.2)
    .height(size * 0.6)
  }
  
  // 绘制一行鳞片
  @Builder
  drawScaleRow(size: number, colors: PetColors, startX: number, y: number, count: number, scaleSize: number) {
    Row({ space: scaleSize * 0.5 }) {
      ForEach(Array.from({ length: count }), (_: number, index: number) => {
        // 半圆形鳞片
        Shape() {
          Path()
            .width(scaleSize * 2)
            .height(scaleSize)
            .commands(`M 0 ${scaleSize} Q ${scaleSize} 0 ${scaleSize * 2} ${scaleSize}`)
            .fill(colors.pattern)
        }
        .width(scaleSize * 2)
        .height(scaleSize)
        .opacity(0.4)
      })
    }
    .position({ x: startX, y: y })
  }
  
  // 蛇头
  @Builder
  drawSnakeHead(size: number, colors: PetColors) {
    Stack() {
      // 头部主体（椭圆形，稍微尖一点）
      Shape() {
        Path()
          .width(size * 0.32)
          .height(size * 0.28)
          .commands(PathUtils.ellipse(size * 0.16, size * 0.14, size * 0.16, size * 0.14))
          .fill(colors.main)
      }
      .width(size * 0.32)
      .height(size * 0.28)
      .position({ x: size * 0.85, y: size * 0.1 })
      
      // 头部高光
      Shape() {
        Path()
          .width(size * 0.2)
          .height(size * 0.12)
          .commands(PathUtils.ellipse(size * 0.1, size * 0.06, size * 0.1, size * 0.06))
          .fill(colors.light)
      }
      .width(size * 0.2)
      .height(size * 0.12)
      .position({ x: size * 0.9, y: size * 0.12 })
      .opacity(0.5)
      
      // 头顶花纹
      Shape() {
        Path()
          .width(size * 0.15)
          .height(size * 0.08)
          .commands(PathUtils.ellipse(size * 0.075, size * 0.04, size * 0.075, size * 0.04))
          .fill(colors.dark)
      }
      .width(size * 0.15)
      .height(size * 0.08)
      .position({ x: size * 0.93, y: size * 0.1 })
      .opacity(0.3)
    }
    .width(size * 1.2)
    .height(size * 0.5)
  }
  
  // 蛇眼（竖瞳）
  @Builder
  drawSnakeEyes(size: number) {
    Row() {
      // 左眼
      Stack() {
        if (this.isSleeping) {
          // 睡眠时闭眼
          Shape() {
            Path()
              .width(size * 0.1)
              .height(size * 0.03)
              .commands(`M 0 ${size * 0.015} Q ${size * 0.05} ${size * 0.03} ${size * 0.1} ${size * 0.015}`)
              .stroke('#333333')
              .strokeWidth(2)
          }
          .width(size * 0.1)
          .height(size * 0.03)
        } else {
          // 眼白
          Shape() {
            Path()
              .width(size * 0.12)
              .height(size * 0.14)
              .commands(PathUtils.ellipse(size * 0.06, size * 0.07, size * 0.06, size * 0.07))
              .fill('#FFFFFF')
          }
          .width(size * 0.12)
          .height(size * 0.14)
          
          // 竖瞳（蛇的标志性特征）
          Shape() {
            Path()
              .width(size * 0.04)
              .height(size * 0.1)
              .commands(PathUtils.ellipse(size * 0.02, size * 0.05, size * 0.015, size * 0.05))
              .fill(this.isSad ? '#666666' : '#2C1810')
          }
          .width(size * 0.04)
          .height(size * 0.1)
          .position({ x: size * 0.04, y: size * 0.02 })
          
          // 眼睛高光
          Shape() {
            Path()
              .width(size * 0.03)
              .height(size * 0.03)
              .commands(PathUtils.ellipse(size * 0.015, size * 0.015, size * 0.015, size * 0.015))
              .fill('#FFFFFF')
          }
          .width(size * 0.03)
          .height(size * 0.03)
          .position({ x: size * 0.02, y: size * 0.02 })
        }
      }
      .width(size * 0.12)
      .height(size * 0.14)
      
      Blank().width(size * 0.08)
      
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
          .width(size * 0.1)
          .height(size * 0.03)
        } else {
          Shape() {
            Path()
              .width(size * 0.12)
              .height(size * 0.14)
              .commands(PathUtils.ellipse(size * 0.06, size * 0.07, size * 0.06, size * 0.07))
              .fill('#FFFFFF')
          }
          .width(size * 0.12)
          .height(size * 0.14)
          
          Shape() {
            Path()
              .width(size * 0.04)
              .height(size * 0.1)
              .commands(PathUtils.ellipse(size * 0.02, size * 0.05, size * 0.015, size * 0.05))
              .fill(this.isSad ? '#666666' : '#2C1810')
          }
          .width(size * 0.04)
          .height(size * 0.1)
          .position({ x: size * 0.04, y: size * 0.02 })
          
          Shape() {
            Path()
              .width(size * 0.03)
              .height(size * 0.03)
              .commands(PathUtils.ellipse(size * 0.015, size * 0.015, size * 0.015, size * 0.015))
              .fill('#FFFFFF')
          }
          .width(size * 0.03)
          .height(size * 0.03)
          .position({ x: size * 0.02, y: size * 0.02 })
        }
      }
      .width(size * 0.12)
      .height(size * 0.14)
    }
    .width(size * 0.32)
    .height(size * 0.14)
    .position({ x: size * 0.9, y: size * 0.15 })
  }
  
  // 蛇的信子（分叉舌头）
  @Builder
  drawSnakeTongue(size: number) {
    Stack() {
      // 舌头主体
      Shape() {
        Path()
          .width(size * 0.15)
          .height(size * 0.03)
          .commands(`M 0 ${size * 0.015} L ${size * 0.15} ${size * 0.015}`)
          .stroke('#FF6B6B')
          .strokeWidth(2)
      }
      .width(size * 0.15)
      .height(size * 0.03)
      
      // 分叉左支
      Shape() {
        Path()
          .width(size * 0.04)
          .height(size * 0.05)
          .commands(`M 0 ${size * 0.025} L ${size * 0.04} 0`)
          .stroke('#FF6B6B')
          .strokeWidth(1.5)
      }
      .width(size * 0.04)
      .height(size * 0.05)
      .position({ x: size * 0.15, y: 0 })
      
      // 分叉右支
      Shape() {
        Path()
          .width(size * 0.04)
          .height(size * 0.05)
          .commands(`M 0 ${size * 0.025} L ${size * 0.04} ${size * 0.05}`)
          .stroke('#FF6B6B')
          .strokeWidth(1.5)
      }
      .width(size * 0.04)
      .height(size * 0.05)
      .position({ x: size * 0.15, y: 0 })
    }
    .width(size * 0.2)
    .height(size * 0.08)
    .position({ x: size * 1.1, y: size * 0.25 })
  }
  
  // 尾巴尖
  @Builder
  drawTailTip(size: number, colors: PetColors) {
    // 尾巴尖（逐渐变细）
    Shape() {
      Path()
        .width(size * 0.12)
        .height(size * 0.06)
        .commands(`M ${size * 0.12} ${size * 0.03} Q ${size * 0.06} 0 0 ${size * 0.03} Q ${size * 0.06} ${size * 0.06} ${size * 0.12} ${size * 0.03}`)
        .fill(colors.dark)
    }
    .width(size * 0.12)
    .height(size * 0.06)
    .position({ x: size * 0.05, y: size * 0.58 })
  }
}
