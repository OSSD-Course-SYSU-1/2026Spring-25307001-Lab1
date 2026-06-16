/**
 * 宠物养成游戏 - 基础绘制组件
 * 
 * 【Shape绘制说明】
 * 所有图形使用ArkTS的Shape、Path组件绘制
 * 不依赖任何外部图片资源
 */

import { PathUtils, ColorUtils } from '../utils/AdaptiveUtils';

// ==================== 圆形组件 ====================
@Component
export struct CircleShape {
  @Prop radius: number = 20;
  @Prop color: string = '#FF6B9D';
  @Prop strokeColor: string = '';
  @Prop strokeWidth: number = 0;
  
  build() {
    Shape() {
      Path()
        .width(this.radius * 2)
        .height(this.radius * 2)
        .commands(PathUtils.circle(this.radius, this.radius, this.radius))
        .fill(this.color)
        .stroke(this.strokeColor)
        .strokeWidth(this.strokeWidth)
    }
    .width(this.radius * 2)
    .height(this.radius * 2)
  }
}

// ==================== 椭圆组件 ====================
@Component
export struct EllipseShape {
  @Prop radiusX: number = 30;
  @Prop radiusY: number = 20;
  @Prop color: string = '#FF6B9D';
  
  build() {
    Shape() {
      Path()
        .width(this.radiusX * 2)
        .height(this.radiusY * 2)
        .commands(PathUtils.ellipse(this.radiusX, this.radiusY, this.radiusX, this.radiusY))
        .fill(this.color)
    }
    .width(this.radiusX * 2)
    .height(this.radiusY * 2)
  }
}

// ==================== 圆角矩形组件 ====================
@Component
export struct RoundRectShape {
  @Prop rectWidth: number = 60;
  @Prop rectHeight: number = 40;
  @Prop radius: number = 8;
  @Prop color: string = '#FF6B9D';
  @Prop strokeColor: string = '';
  @Prop strokeWidth: number = 0;
  
  build() {
    Shape() {
      Path()
        .width(this.rectWidth)
        .height(this.rectHeight)
        .commands(PathUtils.roundRect(0, 0, this.rectWidth, this.rectHeight, this.radius))
        .fill(this.color)
        .stroke(this.strokeColor)
        .strokeWidth(this.strokeWidth)
    }
    .width(this.rectWidth)
    .height(this.rectHeight)
  }
}

// ==================== 心形组件 ====================
@Component
export struct HeartShape {
  @Prop heartSize: number = 30;
  @Prop color: string = '#FF69B4';
  @Prop heartOpacity: number = 1.0;
  
  build() {
    Shape() {
      Path()
        .width(this.heartSize)
        .height(this.heartSize)
        .commands(PathUtils.heart(this.heartSize / 2, this.heartSize / 2, this.heartSize * 0.5))
        .fill(this.color)
    }
    .width(this.heartSize)
    .height(this.heartSize)
    .opacity(this.heartOpacity)
  }
}

// ==================== 星形组件 ====================
@Component
export struct StarShape {
  @Prop starSize: number = 30;
  @Prop color: string = '#FFD700';
  @Prop points: number = 5;
  
  build() {
    Shape() {
      Path()
        .width(this.starSize)
        .height(this.starSize)
        .commands(PathUtils.star(this.starSize / 2, this.starSize / 2, this.starSize / 2, this.starSize / 4, this.points))
        .fill(this.color)
    }
    .width(this.starSize)
    .height(this.starSize)
  }
}

// ==================== 渐变背景组件 ====================
@Component
export struct GradientBackground {
  @Prop bgWidth: number = 360;
  @Prop bgHeight: number = 640;
  @Prop startColor: string = ColorUtils.BG_GRADIENT_START;
  @Prop endColor: string = ColorUtils.BG_GRADIENT_END;
  
  build() {
    Column() {
    }
    .width(this.bgWidth)
    .height(this.bgHeight)
    .linearGradient({
      angle: 135,
      colors: [[this.startColor, 0.0], [this.endColor, 1.0]]
    })
  }
}

// ==================== 波浪背景组件 ====================
@Component
export struct WaveBackground {
  @Prop waveWidth: number = 360;
  @Prop waveHeight: number = 100;
  @Prop y: number = 0;
  @Prop color: string = '#FFE5EC';
  @Prop amplitude: number = 10;
  @Prop frequency: number = 0.02;
  
  build() {
    Shape() {
      Path()
        .width(this.waveWidth)
        .height(this.waveHeight)
        .commands(this.getWavePath())
        .fill(this.color)
    }
    .width(this.waveWidth)
    .height(this.waveHeight)
  }
  
  private getWavePath(): string {
    let path = `M 0 ${this.y}`;
    for (let x = 0; x <= this.waveWidth; x += 3) {
      const yOffset = Math.sin(x * this.frequency) * this.amplitude;
      path += ` L ${x} ${this.y + yOffset}`;
    }
    path += ` L ${this.waveWidth} ${this.waveHeight} L 0 ${this.waveHeight} Z`;
    return path;
  }
}

// ==================== 进度条组件 ====================
@Component
export struct ProgressBar {
  @Prop barWidth: number = 200;
  @Prop barHeight: number = 20;
  @Prop progress: number = 0.5; // 0-1
  @Prop bgColor: string = '#E0E0E0';
  @Prop fillColor: string = '#FF6B9D';
  @Prop radius: number = 10;
  
  build() {
    Stack({ alignContent: Alignment.Start }) {
      // 背景条
      Shape() {
        Path()
          .width(this.barWidth)
          .height(this.barHeight)
          .commands(PathUtils.roundRect(0, 0, this.barWidth, this.barHeight, this.radius))
          .fill(this.bgColor)
      }
      .width(this.barWidth)
      .height(this.barHeight)
      
      // 填充条
      if (this.progress > 0) {
        Shape() {
          Path()
            .width(this.barWidth * this.progress)
            .height(this.barHeight)
            .commands(PathUtils.roundRect(0, 0, this.barWidth * this.progress, this.barHeight, this.radius))
            .fill(this.fillColor)
        }
        .width(this.barWidth * this.progress)
        .height(this.barHeight)
      }
    }
    .width(this.barWidth)
    .height(this.barHeight)
    .clip(true)
  }
}

// ==================== 金币图标组件 ====================
@Component
export struct CoinIcon {
  @Prop coinSize: number = 24;
  
  build() {
    Stack() {
      // 金币主体
      Shape() {
        Path()
          .width(this.coinSize)
          .height(this.coinSize)
          .commands(PathUtils.circle(this.coinSize / 2, this.coinSize / 2, this.coinSize / 2 - 1))
          .fill('#FFD700')
          .stroke('#DAA520')
          .strokeWidth(1.5)
      }
      .width(this.coinSize)
      .height(this.coinSize)
      
      // 金币上的$符号
      Text('$')
        .fontSize(this.coinSize * 0.5)
        .fontColor('#DAA520')
        .fontWeight(FontWeight.Bold)
    }
    .width(this.coinSize)
    .height(this.coinSize)
  }
}

// ==================== 闪光效果组件 ====================
@Component
export struct SparkleEffect {
  @Prop sparkleSize: number = 100;
  @Prop sparkleOpacity: number = 0.6;
  @Prop color: string = '#FFFFFF';
  
  build() {
    Stack() {
      // 多个小闪光点
      ForEach([0, 1, 2, 3, 4], (index: number) => {
        Shape() {
          Path()
            .width(8)
            .height(8)
            .commands(PathUtils.star(4, 4, 4, 2, 4))
            .fill(this.color)
        }
        .width(8)
        .height(8)
        .position({
          x: this.getSparkleX(index),
          y: this.getSparkleY(index)
        })
        .opacity(this.sparkleOpacity * (0.5 + Math.random() * 0.5))
      })
    }
    .width(this.sparkleSize)
    .height(this.sparkleSize)
  }
  
  private getSparkleX(index: number): number {
    const positions = [0.2, 0.8, 0.5, 0.1, 0.9];
    return this.sparkleSize * positions[index];
  }
  
  private getSparkleY(index: number): number {
    const positions = [0.1, 0.2, 0.6, 0.8, 0.7];
    return this.sparkleSize * positions[index];
  }
}
