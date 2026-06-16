/**
 * 宠物养成游戏 - 宠物绘制组件
 * 精细可爱的宠物形象，支持多种动画状态
 */

import { PetType, GrowthStage } from '../common/Constants';
import { PathUtils, ColorUtils, AdaptiveUtils } from '../utils/AdaptiveUtils';

// 宠物颜色接口
interface PetColors {
  main: string;
  light: string;
  dark: string;
  accent: string; // 强调色
}

// 点位置接口
interface DotPosition {
  x: number;
  y: number;
  s: number;
}

// 星星位置接口
interface StarPosition {
  x: number;
  y: number;
  s: number;
}

// 创建宠物颜色
function createPetColors(main: string, light: string, dark: string, accent: string = '#FFFFFF'): PetColors {
  const colors: PetColors = { main: main, light: light, dark: dark, accent: accent };
  return colors;
}

// ==================== Octo精灵绘制组件 ====================
/**
 * 可爱的章鱼精灵
 * 特点：圆润身体、大眼睛、柔软触手、可爱表情
 */
@Component
export struct OctoPetShape {
  @Prop petSize: number = 100;
  @Prop growthStage: GrowthStage = GrowthStage.BABY;
  @Prop isSad: boolean = false;
  @Prop isExcited: boolean = false;
  @Prop isSleeping: boolean = false;
  @Prop skinId: number = 0;
  
  // 动画状态参数
  @Prop blinkProgress: number = 0; // 眨眼进度 0-1
  @Prop bounceOffset: number = 0; // 弹跳偏移
  @Prop wobbleAngle: number = 0; // 摇摆角度
  @Prop tentacleWave: number = 0; // 触手波动
  
  private getGrowthScale(): number {
    switch (this.growthStage) {
      case GrowthStage.BABY: return 0.6;
      case GrowthStage.YOUTH: return 0.85;
      case GrowthStage.ADULT: return 1.0;
      default: return 0.6;
    }
  }
  
  private getColors(): PetColors {
    switch (this.skinId) {
      case 1: return createPetColors('#9B59B6', '#D7BDE2', '#7D3C98', '#E8DAEF');
      case 2: return createPetColors('#FFB6C1', '#FFDDE1', '#FF69B4', '#FFF0F5');
      case 3: return createPetColors('#E74C3C', '#F5B7B1', '#C0392B', '#FADBD8');
      case 4: return createPetColors('#1ABC9C', '#A3E4D7', '#16A085', '#E8F8F5');
      default: return createPetColors('#FF8C69', '#FFDAB9', '#E07050', '#FFF5EE');
    }
  }
  
  build() {
    Stack() {
      // 触手（底层）
      this.drawTentacles(this.petSize * this.getGrowthScale(), this.getColors())
      
      // 身体阴影
      this.drawBodyShadow(this.petSize * this.getGrowthScale())
      
      // 身体
      this.drawBody(this.petSize * this.getGrowthScale(), this.getColors())
      
      // 花纹装饰
      this.drawPatterns(this.petSize * this.getGrowthScale(), this.getColors())
      
      // 眼睛
      this.drawEyes(this.petSize * this.getGrowthScale())
      
      // 嘴巴
      this.drawMouth(this.petSize * this.getGrowthScale())
      
      // 腮红
      this.drawCheeks(this.petSize * this.getGrowthScale())
      
      // 触角
      this.drawAntennae(this.petSize * this.getGrowthScale(), this.getColors())
      
      // 兴奋效果
      if (this.isExcited) {
        this.drawExcitedEffect(this.petSize * this.getGrowthScale())
      }
      
      // 睡眠效果
      if (this.isSleeping) {
        this.drawSleepEffect(this.petSize * this.getGrowthScale())
      }
    }
    .width(this.petSize * 1.2)
    .height(this.petSize * 1.4)
    .translate({ y: this.bounceOffset })
    .rotate({ angle: this.wobbleAngle })
  }
  
  // 触手绘制（更自然、更可爱）
  @Builder
  drawTentacles(size: number, colors: PetColors) {
    ForEach([0, 1, 2, 3, 4, 5, 6, 7], (index: number) => {
      Stack() {
        // 触手主体
        Shape() {
          Path()
            .width(size * 0.12)
            .height(size * 0.55)
            .commands(this.getTentaclePath(size * 0.12, size * 0.55, index))
            .fill(colors.main)
        }
        .width(size * 0.12)
        .height(size * 0.55)
        
        // 触手吸盘
        ForEach([0, 1, 2, 3], (suckIndex: number) => {
          Shape() {
            Path()
              .width(size * 0.06)
              .height(size * 0.025)
              .commands(PathUtils.ellipse(size * 0.03, size * 0.0125, size * 0.03, size * 0.0125))
              .fill(colors.light)
          }
          .width(size * 0.06)
          .height(size * 0.025)
          .position({ 
            x: size * 0.03, 
            y: size * 0.1 + suckIndex * size * 0.12 
          })
        })
        
        // 触手尖端（可爱的圆球）
        Shape() {
          Path()
            .width(size * 0.1)
            .height(size * 0.1)
            .commands(PathUtils.ellipse(size * 0.05, size * 0.05, size * 0.05, size * 0.05))
            .fill(colors.light)
        }
        .width(size * 0.1)
        .height(size * 0.1)
        .position({ x: size * 0.01, y: size * 0.48 })
      }
      .width(size * 0.12)
      .height(size * 0.6)
      .position({
        x: size * 0.22 + index * size * 0.08,
        y: size * 0.5
      })
    })
  }
  
  // 触手路径（更自然的波浪形）
  private getTentaclePath(w: number, h: number, index: number): string {
    let path = `M 0 0`;
    let wavePhase = this.tentacleWave + index * 0.8;
    for (let y = 0; y <= h; y += 3) {
      let progress = y / h;
      let wave = Math.sin(progress * 3 + wavePhase) * 4 * (1 - progress * 0.5);
      let xOffset = w / 2 + wave;
      path += ` L ${xOffset} ${y}`;
    }
    path += ` L ${w} ${h} L 0 ${h} Z`;
    return path;
  }
  
  // 身体阴影
  @Builder
  drawBodyShadow(size: number) {
    Shape() {
      Path()
        .width(size * 0.9)
        .height(size * 0.25)
        .commands(PathUtils.ellipse(size * 0.45, size * 0.125, size * 0.45, size * 0.125))
        .fill('rgba(0, 0, 0, 0.1)')
    }
    .width(size * 0.9)
    .height(size * 0.25)
    .position({ x: size * 0.15, y: size * 0.55 })
  }
  
  // 身体绘制（更圆润可爱）
  @Builder
  drawBody(size: number, colors: PetColors) {
    Stack() {
      // 主体（椭圆形）
      Shape() {
        Path()
          .width(size)
          .height(size * 0.75)
          .commands(PathUtils.ellipse(size / 2, size * 0.375, size / 2, size * 0.375))
          .fill(colors.main)
      }
      .width(size)
      .height(size * 0.75)
      
      // 高光层（顶部）
      Shape() {
        Path()
          .width(size * 0.7)
          .height(size * 0.35)
          .commands(PathUtils.ellipse(size * 0.35, size * 0.175, size * 0.35, size * 0.175))
          .fill(colors.light)
      }
      .width(size * 0.7)
      .height(size * 0.35)
      .position({ x: size * 0.15, y: size * 0.02 })
      .opacity(0.6)
      
      // 次高光层
      Shape() {
        Path()
          .width(size * 0.5)
          .height(size * 0.25)
          .commands(PathUtils.ellipse(size * 0.25, size * 0.125, size * 0.25, size * 0.125))
          .fill(colors.accent)
      }
      .width(size * 0.5)
      .height(size * 0.25)
      .position({ x: size * 0.25, y: size * 0.05 })
      .opacity(0.4)
      
      // 底部阴影
      Shape() {
        Path()
          .width(size * 0.8)
          .height(size * 0.15)
          .commands(PathUtils.ellipse(size * 0.4, size * 0.075, size * 0.4, size * 0.075))
          .fill(colors.dark)
      }
      .width(size * 0.8)
      .height(size * 0.15)
      .position({ x: size * 0.1, y: size * 0.58 })
      .opacity(0.2)
    }
    .width(size)
    .height(size * 0.75)
    .position({ x: this.petSize * 0.1, y: 0 })
  }
  
  // 花纹装饰
  @Builder
  drawPatterns(size: number, colors: PetColors) {
    Stack() {
      // 圆点花纹 - 左上
      Shape() {
        Path()
          .width(size * 0.06)
          .height(size * 0.06)
          .commands(PathUtils.ellipse(size * 0.03, size * 0.03, size * 0.03, size * 0.03))
          .fill(colors.light)
      }
      .width(size * 0.06)
      .height(size * 0.06)
      .position({ x: size * 0.2, y: size * 0.25 })
      .opacity(0.5)
      
      // 右上
      Shape() {
        Path()
          .width(size * 0.06)
          .height(size * 0.06)
          .commands(PathUtils.ellipse(size * 0.03, size * 0.03, size * 0.03, size * 0.03))
          .fill(colors.light)
      }
      .width(size * 0.06)
      .height(size * 0.06)
      .position({ x: size * 0.75, y: size * 0.25 })
      .opacity(0.5)
      
      // 左下
      Shape() {
        Path()
          .width(size * 0.05)
          .height(size * 0.05)
          .commands(PathUtils.ellipse(size * 0.025, size * 0.025, size * 0.025, size * 0.025))
          .fill(colors.light)
      }
      .width(size * 0.05)
      .height(size * 0.05)
      .position({ x: size * 0.35, y: size * 0.45 })
      .opacity(0.5)
      
      // 右下
      Shape() {
        Path()
          .width(size * 0.05)
          .height(size * 0.05)
          .commands(PathUtils.ellipse(size * 0.025, size * 0.025, size * 0.025, size * 0.025))
          .fill(colors.light)
      }
      .width(size * 0.05)
      .height(size * 0.05)
      .position({ x: size * 0.6, y: size * 0.45 })
      .opacity(0.5)
      
      // 中间
      Shape() {
        Path()
          .width(size * 0.04)
          .height(size * 0.04)
          .commands(PathUtils.ellipse(size * 0.02, size * 0.02, size * 0.02, size * 0.02))
          .fill(colors.light)
      }
      .width(size * 0.04)
      .height(size * 0.04)
      .position({ x: size * 0.48, y: size * 0.35 })
      .opacity(0.5)
    }
    .width(size)
    .height(size * 0.75)
    .position({ x: this.petSize * 0.1, y: 0 })
  }
  
  // 腮红
  @Builder
  drawCheeks(size: number) {
    Stack() {
      // 左腮红
      Shape() {
        Path()
          .width(size * 0.15)
          .height(size * 0.1)
          .commands(PathUtils.ellipse(size * 0.075, size * 0.05, size * 0.075, size * 0.05))
          .fill('#FFB6C1')
      }
      .width(size * 0.15)
      .height(size * 0.1)
      .position({ x: size * 0.12, y: size * 0.32 })
      .opacity(this.isSad ? 0.3 : 0.7)
      
      // 右腮红
      Shape() {
        Path()
          .width(size * 0.15)
          .height(size * 0.1)
          .commands(PathUtils.ellipse(size * 0.075, size * 0.05, size * 0.075, size * 0.05))
          .fill('#FFB6C1')
      }
      .width(size * 0.15)
      .height(size * 0.1)
      .position({ x: size * 0.73, y: size * 0.32 })
      .opacity(this.isSad ? 0.3 : 0.7)
    }
    .width(size)
    .height(size * 0.5)
    .position({ x: this.petSize * 0.1, y: 0 })
  }
  
  // 眼睛绘制（更有神、更可爱）
  @Builder
  drawEyes(size: number) {
    Row() {
      // 左眼
      Stack() {
        if (this.isSleeping) {
          // 睡眠时的闭眼
          Shape() {
            Path()
              .width(size * 0.14)
              .height(size * 0.04)
              .commands(`M 0 ${size * 0.02} Q ${size * 0.07} ${size * 0.04} ${size * 0.14} ${size * 0.02}`)
              .stroke('#333333')
              .strokeWidth(2.5)
          }
          .width(size * 0.14)
          .height(size * 0.04)
        } else if (this.blinkProgress > 0 && this.blinkProgress < 1) {
          // 眨眼动画
          Shape() {
            Path()
              .width(size * 0.16)
              .height(size * 0.18 * (1 - this.blinkProgress))
              .commands(PathUtils.ellipse(size * 0.08, size * 0.09 * (1 - this.blinkProgress), size * 0.08, size * 0.09 * (1 - this.blinkProgress)))
              .fill('#FFFFFF')
          }
          .width(size * 0.16)
          .height(size * 0.18)
        } else {
          // 正常眼睛
          // 眼白
          Shape() {
            Path()
              .width(size * 0.16)
              .height(size * 0.2)
              .commands(PathUtils.ellipse(size * 0.08, size * 0.1, size * 0.08, size * 0.1))
              .fill('#FFFFFF')
          }
          .width(size * 0.16)
          .height(size * 0.2)
          
          // 眼珠
          Shape() {
            Path()
              .width(size * 0.1)
              .height(size * 0.12)
              .commands(PathUtils.ellipse(size * 0.05, size * 0.06, size * 0.05, size * 0.06))
              .fill(this.isSad ? '#666666' : '#2C1810')
          }
          .width(size * 0.1)
          .height(size * 0.12)
          .position({ x: size * 0.03, y: size * 0.04 })
          
          // 眼睛高光（大）
          Shape() {
            Path()
              .width(size * 0.05)
              .height(size * 0.05)
              .commands(PathUtils.ellipse(size * 0.025, size * 0.025, size * 0.025, size * 0.025))
              .fill('#FFFFFF')
          }
          .width(size * 0.05)
          .height(size * 0.05)
          .position({ x: size * 0.02, y: size * 0.02 })
          
          // 眼睛高光（小）
          Shape() {
            Path()
              .width(size * 0.025)
              .height(size * 0.025)
              .commands(PathUtils.ellipse(size * 0.0125, size * 0.0125, size * 0.0125, size * 0.0125))
              .fill('#FFFFFF')
          }
          .width(size * 0.025)
          .height(size * 0.025)
          .position({ x: size * 0.08, y: size * 0.08 })
        }
      }
      .width(size * 0.16)
      .height(size * 0.2)
      
      Blank().width(size * 0.18)
      
      // 右眼
      Stack() {
        if (this.isSleeping) {
          Shape() {
            Path()
              .width(size * 0.14)
              .height(size * 0.04)
              .commands(`M 0 ${size * 0.02} Q ${size * 0.07} ${size * 0.04} ${size * 0.14} ${size * 0.02}`)
              .stroke('#333333')
              .strokeWidth(2.5)
          }
          .width(size * 0.14)
          .height(size * 0.04)
        } else if (this.blinkProgress > 0 && this.blinkProgress < 1) {
          Shape() {
            Path()
              .width(size * 0.16)
              .height(size * 0.18 * (1 - this.blinkProgress))
              .commands(PathUtils.ellipse(size * 0.08, size * 0.09 * (1 - this.blinkProgress), size * 0.08, size * 0.09 * (1 - this.blinkProgress)))
              .fill('#FFFFFF')
          }
          .width(size * 0.16)
          .height(size * 0.18)
        } else {
          Shape() {
            Path()
              .width(size * 0.16)
              .height(size * 0.2)
              .commands(PathUtils.ellipse(size * 0.08, size * 0.1, size * 0.08, size * 0.1))
              .fill('#FFFFFF')
          }
          .width(size * 0.16)
          .height(size * 0.2)
          
          Shape() {
            Path()
              .width(size * 0.1)
              .height(size * 0.12)
              .commands(PathUtils.ellipse(size * 0.05, size * 0.06, size * 0.05, size * 0.06))
              .fill(this.isSad ? '#666666' : '#2C1810')
          }
          .width(size * 0.1)
          .height(size * 0.12)
          .position({ x: size * 0.03, y: size * 0.04 })
          
          Shape() {
            Path()
              .width(size * 0.05)
              .height(size * 0.05)
              .commands(PathUtils.ellipse(size * 0.025, size * 0.025, size * 0.025, size * 0.025))
              .fill('#FFFFFF')
          }
          .width(size * 0.05)
          .height(size * 0.05)
          .position({ x: size * 0.02, y: size * 0.02 })
          
          Shape() {
            Path()
              .width(size * 0.025)
              .height(size * 0.025)
              .commands(PathUtils.ellipse(size * 0.0125, size * 0.0125, size * 0.0125, size * 0.0125))
              .fill('#FFFFFF')
          }
          .width(size * 0.025)
          .height(size * 0.025)
          .position({ x: size * 0.08, y: size * 0.08 })
        }
      }
      .width(size * 0.16)
      .height(size * 0.2)
    }
    .width(size * 0.5)
    .height(size * 0.2)
    .position({ x: size * 0.35, y: size * 0.12 })
  }
  
  // 嘴巴绘制（更丰富的表情）
  @Builder
  drawMouth(size: number) {
    Stack() {
      if (this.isSad) {
        // 悲伤表情（倒弧形）
        Shape() {
          Path()
            .width(size * 0.12)
            .height(size * 0.08)
            .commands(`M 0 0 Q ${size * 0.06} ${size * 0.1} ${size * 0.12} 0`)
            .stroke('#333333')
            .strokeWidth(2.5)
        }
        .width(size * 0.12)
        .height(size * 0.08)
      } else if (this.isExcited) {
        // 兴奋表情（大笑）
        Shape() {
          Path()
            .width(size * 0.15)
            .height(size * 0.12)
            .commands(`M 0 0 Q ${size * 0.075} ${size * 0.15} ${size * 0.15} 0`)
            .fill('#FF6B6B')
            .stroke('#333333')
            .strokeWidth(2)
        }
        .width(size * 0.15)
        .height(size * 0.12)
        
        // 舌头
        Shape() {
          Path()
            .width(size * 0.08)
            .height(size * 0.05)
            .commands(PathUtils.ellipse(size * 0.04, size * 0.025, size * 0.04, size * 0.025))
            .fill('#FF8B9B')
        }
        .width(size * 0.08)
        .height(size * 0.05)
        .position({ x: size * 0.035, y: size * 0.05 })
      } else {
        // 正常微笑
        Shape() {
          Path()
            .width(size * 0.1)
            .height(size * 0.06)
            .commands(`M 0 0 Q ${size * 0.05} ${size * 0.08} ${size * 0.1} 0`)
            .stroke('#333333')
            .strokeWidth(2.5)
        }
        .width(size * 0.1)
        .height(size * 0.06)
      }
    }
    .width(size * 0.15)
    .height(size * 0.12)
    .position({ x: this.petSize * 0.55, y: size * 0.36 })
  }
  
  // 触角绘制（更精致）
  @Builder
  drawAntennae(size: number, colors: PetColors) {
    Stack() {
      // 左触角
      Stack() {
        // 触角杆
        Shape() {
          Path()
          .width(size * 0.06)
          .height(size * 0.22)
          .commands(`M ${size * 0.03} ${size * 0.22} Q 0 ${size * 0.12} ${size * 0.03} 0`)
          .stroke(colors.dark)
          .strokeWidth(4)
        }
        .width(size * 0.06)
        .height(size * 0.22)
        
        // 触角顶端圆球
        Shape() {
          Path()
            .width(size * 0.08)
            .height(size * 0.08)
            .commands(PathUtils.ellipse(size * 0.04, size * 0.04, size * 0.04, size * 0.04))
            .fill(colors.light)
        }
        .width(size * 0.08)
        .height(size * 0.08)
        .position({ x: -size * 0.01, y: -size * 0.04 })
        
        // 圆球高光
        Shape() {
          Path()
            .width(size * 0.03)
            .height(size * 0.03)
            .commands(PathUtils.ellipse(size * 0.015, size * 0.015, size * 0.015, size * 0.015))
            .fill('#FFFFFF')
        }
        .width(size * 0.03)
        .height(size * 0.03)
        .position({ x: size * 0.01, y: -size * 0.02 })
        .opacity(0.8)
      }
      .width(size * 0.08)
      .height(size * 0.25)
      
      // 右触角
      Stack() {
        Shape() {
          Path()
            .width(size * 0.06)
            .height(size * 0.22)
            .commands(`M ${size * 0.03} ${size * 0.22} Q ${size * 0.06} ${size * 0.12} ${size * 0.03} 0`)
            .stroke(colors.dark)
            .strokeWidth(4)
        }
        .width(size * 0.06)
        .height(size * 0.22)
        
        Shape() {
          Path()
            .width(size * 0.08)
            .height(size * 0.08)
            .commands(PathUtils.ellipse(size * 0.04, size * 0.04, size * 0.04, size * 0.04))
            .fill(colors.light)
        }
        .width(size * 0.08)
        .height(size * 0.08)
        .position({ x: -size * 0.01, y: -size * 0.04 })
        
        Shape() {
          Path()
            .width(size * 0.03)
            .height(size * 0.03)
            .commands(PathUtils.ellipse(size * 0.015, size * 0.015, size * 0.015, size * 0.015))
            .fill('#FFFFFF')
        }
        .width(size * 0.03)
        .height(size * 0.03)
        .position({ x: size * 0.01, y: -size * 0.02 })
        .opacity(0.8)
      }
      .width(size * 0.08)
      .height(size * 0.25)
      .position({ x: size * 0.15, y: 0 })
    }
    .width(size * 0.25)
    .height(size * 0.25)
    .position({ x: this.petSize * 0.48, y: -size * 0.18 })
  }
  
  // 兴奋效果（星星闪烁）
  @Builder
  drawExcitedEffect(size: number) {
    Stack() {
      // 星星1
      Shape() {
        Path()
          .width(12)
          .height(12)
          .commands(this.getStarPath(12))
          .fill('#FFD700')
      }
      .width(12)
      .height(12)
      .position({ x: size * 0.1 - 6, y: size * 0.05 - 6 })
      
      // 星星2
      Shape() {
        Path()
          .width(10)
          .height(10)
          .commands(this.getStarPath(10))
          .fill('#FFD700')
      }
      .width(10)
      .height(10)
      .position({ x: size * 0.3 - 5, y: size * -0.05 - 5 })
      
      // 星星3
      Shape() {
        Path()
          .width(14)
          .height(14)
          .commands(this.getStarPath(14))
          .fill('#FFD700')
      }
      .width(14)
      .height(14)
      .position({ x: size * 0.5 - 7, y: size * 0.0 - 7 })
      
      // 星星4
      Shape() {
        Path()
          .width(11)
          .height(11)
          .commands(this.getStarPath(11))
          .fill('#FFD700')
      }
      .width(11)
      .height(11)
      .position({ x: size * 0.7 - 5, y: size * -0.03 - 5 })
      
      // 星星5
      Shape() {
        Path()
          .width(13)
          .height(13)
          .commands(this.getStarPath(13))
          .fill('#FFD700')
      }
      .width(13)
      .height(13)
      .position({ x: size * 0.85 - 6, y: size * 0.08 - 6 })
    }
    .width(size)
    .height(size * 0.3)
    .position({ x: this.petSize * 0.15, y: -size * 0.1 })
  }
  
  // 睡眠效果（Z字符飘动）
  @Builder
  drawSleepEffect(size: number) {
    Stack() {
      Text('Z')
        .fontSize(16)
        .fontColor('#87CEEB')
        .fontWeight(FontWeight.Bold)
        .opacity(0.8)
        .position({ x: size * 0.7, y: -size * 0.1 })
      
      Text('z')
        .fontSize(20)
        .fontColor('#87CEEB')
        .fontWeight(FontWeight.Bold)
        .opacity(0.6)
        .position({ x: size * 0.8, y: -size * 0.2 })
      
      Text('z')
        .fontSize(24)
        .fontColor('#87CEEB')
        .fontWeight(FontWeight.Bold)
        .opacity(0.4)
        .position({ x: size * 0.9, y: -size * 0.35 })
    }
    .width(size)
    .height(size * 0.5)
    .position({ x: this.petSize * 0.1, y: 0 })
  }
  
  // 星形路径
  private getStarPath(size: number): string {
    let cx = size / 2;
    let cy = size / 2;
    let r = size / 2;
    let innerR = r * 0.4;
    let path = `M ${cx} ${cy - r} `;
    for (let i = 0; i < 5; i++) {
      let angle = (i * 72 - 90) * Math.PI / 180;
      let innerAngle = ((i * 72) + 36 - 90) * Math.PI / 180;
      let outerX = cx + r * Math.cos(angle);
      let outerY = cy + r * Math.sin(angle);
      let innerX = cx + innerR * Math.cos(innerAngle);
      let innerY = cy + innerR * Math.sin(innerAngle);
      path += `L ${outerX} ${outerY} L ${innerX} ${innerY} `;
    }
    path += 'Z';
    return path;
  }
}
