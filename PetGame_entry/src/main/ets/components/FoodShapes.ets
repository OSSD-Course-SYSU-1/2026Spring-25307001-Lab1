/**
 * 食物绘制组件
 * 5种不同造型的食物
 */
import { PathUtils, ColorUtils } from '../utils/AdaptiveUtils';

// ==================== 食物1：基础口粮 ====================
@Component
export struct Food1Shape {
  @Prop foodSize: number = 60;
  
  build() {
    Stack() {
      Shape() {
        Path()
          .width(this.foodSize)
          .height(this.foodSize * 0.4)
          .commands(`M 0 ${this.foodSize * 0.2} Q ${this.foodSize * 0.5} ${this.foodSize * 0.5} ${this.foodSize} ${this.foodSize * 0.2} L ${this.foodSize * 0.9} ${this.foodSize * 0.35} Q ${this.foodSize * 0.5} ${this.foodSize * 0.45} ${this.foodSize * 0.1} ${this.foodSize * 0.35} Z`)
          .fill('#DEB887')
      }
      .width(this.foodSize)
      .height(this.foodSize * 0.4)
      .position({ x: 0, y: this.foodSize * 0.5 })
      
      ForEach([0, 1, 2, 3, 4], (index: number) => {
        Shape() {
          Path()
            .width(this.foodSize * 0.12)
            .height(this.foodSize * 0.1)
            .commands(PathUtils.ellipse(this.foodSize * 0.06, this.foodSize * 0.05, this.foodSize * 0.06, this.foodSize * 0.05))
            .fill('#8B4513')
        }
        .width(this.foodSize * 0.12)
        .height(this.foodSize * 0.1)
        .position({
          x: this.foodSize * 0.15 + (index % 3) * this.foodSize * 0.2,
          y: this.foodSize * 0.45 + Math.floor(index / 3) * this.foodSize * 0.12
        })
      })
    }
    .width(this.foodSize)
    .height(this.foodSize)
  }
}

// ==================== 食物2：鲜果丸子 ====================
@Component
export struct Food2Shape {
  @Prop foodSize: number = 60;
  
  build() {
    Stack() {
      Shape() {
        Path()
          .width(this.foodSize)
          .height(this.foodSize * 0.15)
          .commands(PathUtils.ellipse(this.foodSize * 0.5, this.foodSize * 0.075, this.foodSize * 0.5, this.foodSize * 0.075))
          .fill('#F5F5DC')
      }
      .width(this.foodSize)
      .height(this.foodSize * 0.15)
      .position({ x: 0, y: this.foodSize * 0.7 })
      
      ForEach([0, 1, 2], (index: number) => {
        Stack() {
          Shape() {
            Path()
              .width(this.foodSize * 0.25)
              .height(this.foodSize * 0.25)
              .commands(PathUtils.circle(this.foodSize * 0.125, this.foodSize * 0.125, this.foodSize * 0.125))
              .fill('#FFE4C4')
          }
          .width(this.foodSize * 0.25)
          .height(this.foodSize * 0.25)
          
          Shape() {
            Path()
              .width(this.foodSize * 0.08)
              .height(this.foodSize * 0.08)
              .commands(PathUtils.circle(this.foodSize * 0.04, this.foodSize * 0.04, this.foodSize * 0.04))
              .fill(index === 0 ? '#FF6B6B' : (index === 1 ? '#4ECDC4' : '#FFE66D'))
          }
          .width(this.foodSize * 0.08)
          .height(this.foodSize * 0.08)
          .position({ x: this.foodSize * 0.08, y: this.foodSize * 0.02 })
        }
        .width(this.foodSize * 0.25)
        .height(this.foodSize * 0.25)
        .position({
          x: this.foodSize * 0.12 + index * this.foodSize * 0.22,
          y: this.foodSize * 0.35
        })
      })
    }
    .width(this.foodSize)
    .height(this.foodSize)
  }
}

// ==================== 食物3：海鲜小餐 ====================
@Component
export struct Food3Shape {
  @Prop foodSize: number = 60;
  
  build() {
    Stack() {
      Shape() {
        Path()
          .width(this.foodSize)
          .height(this.foodSize * 0.2)
          .commands(PathUtils.ellipse(this.foodSize * 0.5, this.foodSize * 0.1, this.foodSize * 0.5, this.foodSize * 0.1))
          .fill('#FFFFFF')
          .stroke('#E0E0E0')
          .strokeWidth(2)
      }
      .width(this.foodSize)
      .height(this.foodSize * 0.2)
      .position({ x: 0, y: this.foodSize * 0.65 })
      
      Shape() {
        Path()
          .width(this.foodSize * 0.25)
          .height(this.foodSize * 0.2)
          .commands(`M 0 ${this.foodSize * 0.1} Q ${this.foodSize * 0.1} 0 ${this.foodSize * 0.2} ${this.foodSize * 0.05} Q ${this.foodSize * 0.25} ${this.foodSize * 0.1} ${this.foodSize * 0.2} ${this.foodSize * 0.15} Q ${this.foodSize * 0.1} ${this.foodSize * 0.2} 0 ${this.foodSize * 0.1} Z`)
          .fill('#FF7F50')
      }
      .width(this.foodSize * 0.25)
      .height(this.foodSize * 0.2)
      .position({ x: this.foodSize * 0.15, y: this.foodSize * 0.3 })
      
      Shape() {
        Path()
          .width(this.foodSize * 0.2)
          .height(this.foodSize * 0.18)
          .commands(`M 0 ${this.foodSize * 0.18} Q ${this.foodSize * 0.1} 0 ${this.foodSize * 0.2} ${this.foodSize * 0.18} Z`)
          .fill('#FFE4E1')
      }
      .width(this.foodSize * 0.2)
      .height(this.foodSize * 0.18)
      .position({ x: this.foodSize * 0.55, y: this.foodSize * 0.35 })
      
      Shape() {
        Path()
          .width(this.foodSize * 0.2)
          .height(this.foodSize * 0.15)
          .commands(PathUtils.ellipse(this.foodSize * 0.1, this.foodSize * 0.075, this.foodSize * 0.1, this.foodSize * 0.075))
          .fill('#FA8072')
      }
      .width(this.foodSize * 0.2)
      .height(this.foodSize * 0.15)
      .position({ x: this.foodSize * 0.4, y: this.foodSize * 0.5 })
    }
    .width(this.foodSize)
    .height(this.foodSize)
  }
}

// ==================== 食物4：营养浓汤 ====================
@Component
export struct Food4Shape {
  @Prop foodSize: number = 60;
  
  build() {
    Stack() {
      Shape() {
        Path()
          .width(this.foodSize * 0.8)
          .height(this.foodSize * 0.5)
          .commands(`M 0 ${this.foodSize * 0.15} Q 0 ${this.foodSize * 0.5} ${this.foodSize * 0.4} ${this.foodSize * 0.5} Q ${this.foodSize * 0.8} ${this.foodSize * 0.5} ${this.foodSize * 0.8} ${this.foodSize * 0.15} L ${this.foodSize * 0.7} ${this.foodSize * 0.1} Q ${this.foodSize * 0.4} ${this.foodSize * 0.05} ${this.foodSize * 0.1} ${this.foodSize * 0.1} Z`)
          .fill('#F5F5DC')
      }
      .width(this.foodSize * 0.8)
      .height(this.foodSize * 0.5)
      .position({ x: this.foodSize * 0.1, y: this.foodSize * 0.35 })
      
      Shape() {
        Path()
          .width(this.foodSize * 0.65)
          .height(this.foodSize * 0.15)
          .commands(PathUtils.ellipse(this.foodSize * 0.325, this.foodSize * 0.075, this.foodSize * 0.325, this.foodSize * 0.075))
          .fill('#DEB887')
      }
      .width(this.foodSize * 0.65)
      .height(this.foodSize * 0.15)
      .position({ x: this.foodSize * 0.175, y: this.foodSize * 0.4 })
      
      ForEach([0, 1, 2], (index: number) => {
        Shape() {
          Path()
            .width(this.foodSize * 0.08)
            .height(this.foodSize * 0.2)
            .commands(`M ${this.foodSize * 0.04} ${this.foodSize * 0.2} Q 0 ${this.foodSize * 0.1} ${this.foodSize * 0.04} 0 Q ${this.foodSize * 0.08} ${this.foodSize * 0.1} ${this.foodSize * 0.04} ${this.foodSize * 0.2} Z`)
            .fill('#FFFFFF')
        }
        .width(this.foodSize * 0.08)
        .height(this.foodSize * 0.2)
        .position({
          x: this.foodSize * 0.25 + index * this.foodSize * 0.18,
          y: this.foodSize * 0.1
        })
        .opacity(0.5)
      })
      
      ForEach([0, 1, 2, 3], (index: number) => {
        Shape() {
          Path()
            .width(6)
            .height(6)
            .commands(PathUtils.circle(3, 3, 3))
            .fill(index % 2 === 0 ? '#FF6347' : '#32CD32')
        }
        .width(6)
        .height(6)
        .position({
          x: this.foodSize * 0.2 + index * this.foodSize * 0.15,
          y: this.foodSize * 0.42
        })
      })
    }
    .width(this.foodSize)
    .height(this.foodSize)
  }
}

// ==================== 食物5：豪华大餐 ====================
@Component
export struct Food5Shape {
  @Prop foodSize: number = 60;
  
  build() {
    Stack() {
      Shape() {
        Path()
          .width(this.foodSize)
          .height(this.foodSize * 0.25)
          .commands(PathUtils.ellipse(this.foodSize * 0.5, this.foodSize * 0.125, this.foodSize * 0.5, this.foodSize * 0.125))
          .fill('#FFD700')
          .stroke('#DAA520')
          .strokeWidth(2)
      }
      .width(this.foodSize)
      .height(this.foodSize * 0.25)
      .position({ x: 0, y: this.foodSize * 0.65 })
      
      Shape() {
        Path()
          .width(this.foodSize * 0.35)
          .height(this.foodSize * 0.25)
          .commands(PathUtils.ellipse(this.foodSize * 0.175, this.foodSize * 0.125, this.foodSize * 0.175, this.foodSize * 0.125))
          .fill('#CD853F')
      }
      .width(this.foodSize * 0.35)
      .height(this.foodSize * 0.25)
      .position({ x: this.foodSize * 0.1, y: this.foodSize * 0.35 })
      
      ForEach([0, 1], (index: number) => {
        Shape() {
          Path()
            .width(this.foodSize * 0.15)
            .height(this.foodSize * 0.2)
            .commands(`M ${this.foodSize * 0.075} ${this.foodSize * 0.2} Q 0 ${this.foodSize * 0.1} ${this.foodSize * 0.075} 0 Q ${this.foodSize * 0.15} ${this.foodSize * 0.1} ${this.foodSize * 0.075} ${this.foodSize * 0.2} Z`)
            .fill(index === 0 ? '#90EE90' : '#FFA07A')
        }
        .width(this.foodSize * 0.15)
        .height(this.foodSize * 0.2)
        .position({
          x: this.foodSize * 0.5 + index * this.foodSize * 0.18,
          y: this.foodSize * 0.35
        })
      })
      
      Shape() {
        Path()
          .width(this.foodSize * 0.12)
          .height(this.foodSize * 0.12)
          .commands(PathUtils.star(this.foodSize * 0.06, this.foodSize * 0.06, this.foodSize * 0.06, this.foodSize * 0.03, 5))
          .fill('#FF69B4')
      }
      .width(this.foodSize * 0.12)
      .height(this.foodSize * 0.12)
      .position({ x: this.foodSize * 0.7, y: this.foodSize * 0.5 })
      
      ForEach([0, 1, 2, 3, 4], (index: number) => {
        Shape() {
          Path()
            .width(4)
            .height(4)
            .commands(PathUtils.circle(2, 2, 2))
            .fill('#228B22')
        }
        .width(4)
        .height(4)
        .position({
          x: this.foodSize * 0.15 + index * this.foodSize * 0.15,
          y: this.foodSize * 0.55
        })
      })
    }
    .width(this.foodSize)
    .height(this.foodSize)
  }
}

// ==================== 食物选择器组件 ====================
@Component
export struct FoodShapeSelector {
  @Prop foodId: number = 1;
  @Prop foodSize: number = 60;
  
  build() {
    if (this.foodId === 1) {
      Food1Shape({ foodSize: this.foodSize })
    } else if (this.foodId === 2) {
      Food2Shape({ foodSize: this.foodSize })
    } else if (this.foodId === 3) {
      Food3Shape({ foodSize: this.foodSize })
    } else if (this.foodId === 4) {
      Food4Shape({ foodSize: this.foodSize })
    } else {
      Food5Shape({ foodSize: this.foodSize })
    }
  }
}
