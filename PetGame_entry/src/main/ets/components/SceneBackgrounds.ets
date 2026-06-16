/**
 * 场景背景组件
 * 为不同游戏状态提供精美的背景场景
 * 
 * 【设计原则】
 * 1. 使用Shape和Path全代码绘制，无外部图片
 * 2. 场景温馨、美观、有细节
 * 3. 支持多端适配
 */

import { PathUtils } from '../utils/AdaptiveUtils';

// ==================== 孵化室背景 ====================
/**
 * 温馨的孵化室场景
 * 包含：柔和光线、孵化台、装饰植物、窗户
 */
@Component
export struct IncubatorRoomBackground {
  @Prop bgWidth: number = 360;
  @Prop bgHeight: number = 640;
  @State lightPulse: number = 0; // 光线脉动动画
  private animationTimer: number = -1;
  
  aboutToAppear() {
    // 启动光线脉动动画
    this.animationTimer = setInterval(() => {
      this.lightPulse = (this.lightPulse + 0.05) % (Math.PI * 2);
    }, 50);
  }
  
  aboutToDisappear() {
    if (this.animationTimer !== -1) {
      clearInterval(this.animationTimer);
    }
  }
  
  build() {
    Stack() {
      // 基础背景：温暖的室内渐变
      Column()
        .width(this.bgWidth)
        .height(this.bgHeight)
        .linearGradient({
          angle: 180,
          colors: [
            ['#FFF8E7', 0.0],   // 温暖米色天花板
            ['#FFECD2', 0.3],   // 柔和橙色
            ['#FFE4C4', 0.7],   // 淡橙色
            ['#FFDAB9', 1.0]    // 桃色地板
          ]
        })
      
      // 墙壁装饰
      this.buildWallDecorations()
      
      // 窗户（左侧）
      this.buildWindow()
      
      // 孵化台（中央）
      this.buildIncubationTable()
      
      // 装饰植物（右侧）
      this.buildDecorativePlant()
      
      // 柔和光线效果
      this.buildSoftLight()
    }
    .width(this.bgWidth)
    .height(this.bgHeight)
  }
  
  // 墙壁装饰
  @Builder
  buildWallDecorations() {
    Stack() {
      // 墙裙
      Shape() {
        Path()
          .width(this.bgWidth)
          .height(this.bgHeight * 0.3)
          .commands(`M 0 ${this.bgHeight * 0.7} L ${this.bgWidth} ${this.bgHeight * 0.7} L ${this.bgWidth} ${this.bgHeight} L 0 ${this.bgHeight} Z`)
          .fill('#E8DCC8')
          .stroke('#D4C4B0')
          .strokeWidth(2)
      }
      .width(this.bgWidth)
      .height(this.bgHeight)
      
      // 墙裙装饰线
      Shape() {
        Path()
          .width(this.bgWidth)
          .height(4)
          .commands(`M 0 0 L ${this.bgWidth} 0`)
          .stroke('#C9B896')
          .strokeWidth(2)
      }
      .width(this.bgWidth)
      .height(4)
      .position({ x: 0, y: this.bgHeight * 0.7 })
      
      // 墙上的画框
      this.buildWallFrame()
    }
    .width(this.bgWidth)
    .height(this.bgHeight)
  }
  
  // 墙上的画框
  @Builder
  buildWallFrame() {
    Stack() {
      // 画框外框
      Shape() {
        Path()
          .width(80)
          .height(60)
          .commands(PathUtils.roundRect(0, 0, 80, 60, 3))
          .fill('#8B7355')
          .stroke('#6B5344')
          .strokeWidth(3)
      }
      .width(80)
      .height(60)
      
      // 画框内容（简单的风景画）
      Column() {
        // 天空
        Column()
          .width(70)
          .height(25)
          .linearGradient({
            angle: 180,
            colors: [['#87CEEB', 0.0], ['#B0E0E6', 1.0]]
          })
        
        // 草地
        Shape() {
          Path()
            .width(70)
            .height(25)
            .commands(`M 0 0 Q 17 10 35 5 Q 52 0 70 8 L 70 25 L 0 25 Z`)
            .fill('#90EE90')
        }
        .width(70)
        .height(25)
      }
      .width(70)
      .height(50)
      .position({ x: 5, y: 5 })
    }
    .width(80)
    .height(60)
    .position({ x: this.bgWidth - 100, y: 80 })
  }
  
  // 窗户
  @Builder
  buildWindow() {
    Stack() {
      // 窗框
      Shape() {
        Path()
          .width(90)
          .height(120)
          .commands(PathUtils.roundRect(0, 0, 90, 120, 8))
          .fill('#F5F5DC')
          .stroke('#8B7355')
          .strokeWidth(4)
      }
      .width(90)
      .height(120)
      
      // 窗户玻璃（透出外面的天空）
      Column()
        .width(78)
        .height(108)
        .linearGradient({
          angle: 180,
          colors: [
            ['#87CEEB', 0.0],   // 蓝天
            ['#B0E0E6', 0.5],   // 淡蓝
            ['#FFE4B5', 1.0]    // 暖阳
          ]
        })
        .position({ x: 6, y: 6 })
      
      // 窗户十字格
      Shape() {
        Path()
          .width(78)
          .height(108)
          .commands(`M 39 0 L 39 108 M 0 54 L 78 54`)
          .stroke('#8B7355')
          .strokeWidth(3)
      }
      .width(78)
      .height(108)
      .position({ x: 6, y: 6 })
      
      // 窗帘（左侧）
      Shape() {
        Path()
          .width(20)
          .height(130)
          .commands(this.getCurtainPath(20, 130))
          .fill('#FFE4E1')
          .stroke('#FFB6C1')
          .strokeWidth(1)
      }
      .width(20)
      .height(130)
      .position({ x: -15, y: -5 })
      
      // 窗帘（右侧）
      Shape() {
        Path()
          .width(20)
          .height(130)
          .commands(this.getCurtainPath(20, 130))
          .fill('#FFE4E1')
          .stroke('#FFB6C1')
          .strokeWidth(1)
      }
      .width(20)
      .height(130)
      .position({ x: 85, y: -5 })
    }
    .width(100)
    .height(130)
    .position({ x: 20, y: 60 })
  }
  
  // 窗帘路径
  private getCurtainPath(w: number, h: number): string {
    return `M 0 0 Q ${w * 0.3} ${h * 0.1} ${w * 0.2} ${h * 0.15} 
            Q ${w * 0.5} ${h * 0.2} ${w * 0.4} ${h * 0.3}
            Q ${w * 0.6} ${h * 0.35} ${w * 0.5} ${h * 0.45}
            Q ${w * 0.7} ${h * 0.5} ${w * 0.6} ${h * 0.6}
            Q ${w * 0.8} ${h * 0.65} ${w * 0.7} ${h * 0.75}
            Q ${w * 0.9} ${h * 0.8} ${w * 0.8} ${h * 0.9}
            Q ${w * 0.95} ${h * 0.95} ${w} ${h}
            L 0 ${h} Z`;
  }
  
  // 孵化台
  @Builder
  buildIncubationTable() {
    Stack() {
      // 桌子主体
      Shape() {
        Path()
          .width(140)
          .height(80)
          .commands(this.getTablePath(140, 80))
          .fill('#DEB887')
          .stroke('#CD853F')
          .strokeWidth(2)
      }
      .width(140)
      .height(80)
      .position({ x: 0, y: 20 })
      
      // 桌腿
      Shape() {
        Path()
          .width(140)
          .height(120)
          .commands(`M 10 0 L 15 0 L 18 120 L 7 120 Z 
                     M ${140 - 10} 0 L ${140 - 15} 0 L ${140 - 18} 120 L ${140 - 7} 120 Z`)
          .fill('#CD853F')
          .stroke('#8B4513')
          .strokeWidth(1)
      }
      .width(140)
      .height(120)
      .position({ x: 0, y: 100 })
      
      // 孵化器（发光的容器）
      this.buildIncubator()
    }
    .width(160)
    .height(220)
    .position({ x: (this.bgWidth - 160) / 2, y: this.bgHeight * 0.35 })
  }
  
  // 桌子路径
  private getTablePath(w: number, h: number): string {
    return `M 0 ${h * 0.3} L 0 0 L ${w} 0 L ${w} ${h * 0.3} 
            L ${w * 0.95} ${h * 0.5} L ${w * 0.05} ${h * 0.5} Z`;
  }
  
  // 孵化器
  @Builder
  buildIncubator() {
    Stack() {
      // 孵化器底座
      Shape() {
        Path()
          .width(80)
          .height(15)
          .commands(PathUtils.roundRect(0, 0, 80, 15, 3))
          .fill('#D3D3D3')
          .stroke('#A9A9A9')
          .strokeWidth(1)
      }
      .width(80)
      .height(15)
      .position({ x: 30, y: 5 })
      
      // 孵化器玻璃罩
      Shape() {
        Path()
          .width(70)
          .height(50)
          .commands(`M 5 50 Q 0 50 0 45 L 5 10 Q 35 -5 65 10 L 70 45 Q 70 50 65 50 Z`)
          .fill('rgba(255, 255, 255, 0.3)')
          .stroke('#C0C0C0')
          .strokeWidth(2)
      }
      .width(70)
      .height(50)
      .position({ x: 35, y: -45 })
      
      // 发光效果
      Shape() {
        Path()
          .width(60)
          .height(40)
          .commands(PathUtils.ellipse(30, 20, 30, 20))
          .fill(`rgba(255, 223, 186, ${0.3 + Math.sin(this.lightPulse) * 0.15})`)
      }
      .width(60)
      .height(40)
      .position({ x: 40, y: -35 })
    }
    .width(140)
    .height(60)
  }
  
  // 装饰植物
  @Builder
  buildDecorativePlant() {
    Stack() {
      // 花盆
      Shape() {
        Path()
          .width(40)
          .height(35)
          .commands(this.getPotPath(40, 35))
          .fill('#CD853F')
          .stroke('#8B4513')
          .strokeWidth(2)
      }
      .width(40)
      .height(35)
      .position({ x: 0, y: 60 })
      
      // 植物叶子
      Shape() {
        Path()
          .width(60)
          .height(80)
          .commands(this.getPlantLeafPath(60, 80))
          .fill('#228B22')
          .stroke('#006400')
          .strokeWidth(1)
      }
      .width(60)
      .height(80)
      .position({ x: -10, y: -15 })
      
      // 小花
      Shape() {
        Path()
          .width(20)
          .height(20)
          .commands(this.getFlowerPath(20, 20))
          .fill('#FF69B4')
          .stroke('#FF1493')
          .strokeWidth(1)
      }
      .width(20)
      .height(20)
      .position({ x: 10, y: -25 })
    }
    .width(60)
    .height(100)
    .position({ x: this.bgWidth - 80, y: this.bgHeight * 0.5 })
  }
  
  // 花盆路径
  private getPotPath(w: number, h: number): string {
    return `M ${w * 0.1} 0 L ${w * 0.9} 0 L ${w} ${h} L 0 ${h} Z`;
  }
  
  // 植物叶子路径
  private getPlantLeafPath(w: number, h: number): string {
    return `M ${w / 2} ${h} 
            Q ${w * 0.2} ${h * 0.7} ${w * 0.3} ${h * 0.4}
            Q ${w * 0.35} ${h * 0.2} ${w / 2} 0
            Q ${w * 0.65} ${h * 0.2} ${w * 0.7} ${h * 0.4}
            Q ${w * 0.8} ${h * 0.7} ${w / 2} ${h}`;
  }
  
  // 小花路径
  private getFlowerPath(w: number, h: number): string {
    let cx = w / 2;
    let cy = h / 2;
    let r = w / 3;
    return `M ${cx} ${cy - r} 
            Q ${cx + r} ${cy - r} ${cx + r} ${cy}
            Q ${cx + r} ${cy + r} ${cx} ${cy + r}
            Q ${cx - r} ${cy + r} ${cx - r} ${cy}
            Q ${cx - r} ${cy - r} ${cx} ${cy - r} Z
            M ${cx} ${cy - r * 0.5}
            Q ${cx + r * 0.5} ${cy - r * 0.5} ${cx + r * 0.5} ${cy}
            Q ${cx + r * 0.5} ${cy + r * 0.5} ${cx} ${cy + r * 0.5}
            Q ${cx - r * 0.5} ${cy + r * 0.5} ${cx - r * 0.5} ${cy}
            Q ${cx - r * 0.5} ${cy - r * 0.5} ${cx} ${cy - r * 0.5} Z`;
  }
  
  // 柔和光线效果
  @Builder
  buildSoftLight() {
    Stack() {
      // 从窗户射入的光线
      Shape() {
        Path()
          .width(this.bgWidth * 0.6)
          .height(this.bgHeight * 0.5)
          .commands(`M 0 0 L ${this.bgWidth * 0.6} ${this.bgHeight * 0.2} 
                     L ${this.bgWidth * 0.5} ${this.bgHeight * 0.5} 
                     L ${-this.bgWidth * 0.1} ${this.bgHeight * 0.3} Z`)
          .fill(`rgba(255, 248, 220, ${0.15 + Math.sin(this.lightPulse) * 0.05})`)
      }
      .width(this.bgWidth)
      .height(this.bgHeight)
      .position({ x: 60, y: 100 })
      
      // 整体柔和光晕
      Shape() {
        Path()
          .width(this.bgWidth)
          .height(this.bgHeight)
          .commands(`M 0 0 L ${this.bgWidth} 0 L ${this.bgWidth} ${this.bgHeight} L 0 ${this.bgHeight} Z`)
          .fill(`rgba(255, 255, 240, ${0.1 + Math.sin(this.lightPulse) * 0.03})`)
      }
      .width(this.bgWidth)
      .height(this.bgHeight)
    }
    .width(this.bgWidth)
    .height(this.bgHeight)
  }
}

// ==================== 互动花园背景 ====================
/**
 * 温馨的花园场景
 * 包含：天空、草地、小径、花朵、树木、栅栏
 */
@Component
export struct GardenBackground {
  @Prop bgWidth: number = 360;
  @Prop bgHeight: number = 640;
  @State cloudOffset: number = 0; // 云朵飘动动画
  private animationTimer: number = -1;
  
  aboutToAppear() {
    // 启动云朵飘动动画
    this.animationTimer = setInterval(() => {
      this.cloudOffset = (this.cloudOffset + 0.5) % this.bgWidth;
    }, 100);
  }
  
  aboutToDisappear() {
    if (this.animationTimer !== -1) {
      clearInterval(this.animationTimer);
    }
  }
  
  build() {
    Stack() {
      // 天空渐变
      this.buildSky()
      
      // 云朵
      this.buildClouds()
      
      // 草地
      this.buildGrass()
      
      // 小径
      this.buildPath()
      
      // 栅栏
      this.buildFence()
      
      // 花朵装饰
      this.buildFlowers()
      
      // 树木
      this.buildTrees()
    }
    .width(this.bgWidth)
    .height(this.bgHeight)
  }
  
  // 天空
  @Builder
  buildSky() {
    Column()
      .width(this.bgWidth)
      .height(this.bgHeight * 0.6)
      .linearGradient({
        angle: 180,
        colors: [
          ['#87CEEB', 0.0],   // 天蓝色
          ['#B0E0E6', 0.5],   // 淡蓝色
          ['#E0F7FA', 1.0]    // 浅青色
        ]
      })
  }
  
  // 云朵
  @Builder
  buildClouds() {
    Stack() {
      // 云朵1
      this.buildSingleCloud(60, 50, 0.8)
      
      // 云朵2
      this.buildSingleCloud(180, 80, 0.6)
      
      // 云朵3
      this.buildSingleCloud(280, 40, 0.7)
    }
    .width(this.bgWidth)
    .height(150)
  }
  
  // 单个云朵
  @Builder
  buildSingleCloud(x: number, y: number, opacity: number) {
    Stack() {
      // 云朵主体（多个椭圆组合）
      Shape() {
        Path()
          .width(80)
          .height(40)
          .commands(PathUtils.ellipse(40, 20, 40, 20))
          .fill('rgba(255, 255, 255, 0.9)')
      }
      .width(80)
      .height(40)
      
      Shape() {
        Path()
          .width(50)
          .height(30)
          .commands(PathUtils.ellipse(25, 15, 25, 15))
          .fill('rgba(255, 255, 255, 0.9)')
      }
      .width(50)
      .height(30)
      .position({ x: -20, y: 10 })
      
      Shape() {
        Path()
          .width(45)
          .height(25)
          .commands(PathUtils.ellipse(22, 12, 22, 12))
          .fill('rgba(255, 255, 255, 0.9)')
      }
      .width(45)
      .height(25)
      .position({ x: 50, y: 8 })
    }
    .width(100)
    .height(50)
    .position({ x: (x - this.cloudOffset + this.bgWidth) % this.bgWidth - 50, y: y })
    .opacity(opacity)
  }
  
  // 草地
  @Builder
  buildGrass() {
    Stack() {
      // 草地主体
      Shape() {
        Path()
          .width(this.bgWidth)
          .height(this.bgHeight * 0.5)
          .commands(`M 0 0 
                     Q ${this.bgWidth * 0.25} 20 ${this.bgWidth * 0.5} 5
                     Q ${this.bgWidth * 0.75} -10 ${this.bgWidth} 15
                     L ${this.bgWidth} ${this.bgHeight * 0.5}
                     L 0 ${this.bgHeight * 0.5} Z`)
          .fill('#90EE90')
      }
      .width(this.bgWidth)
      .height(this.bgHeight * 0.5)
      .position({ x: 0, y: this.bgHeight * 0.5 })
      
      // 草地深色层
      Shape() {
        Path()
          .width(this.bgWidth)
          .height(this.bgHeight * 0.4)
          .commands(`M 0 30
                     Q ${this.bgWidth * 0.3} 10 ${this.bgWidth * 0.6} 25
                     Q ${this.bgWidth * 0.8} 35 ${this.bgWidth} 20
                     L ${this.bgWidth} ${this.bgHeight * 0.4}
                     L 0 ${this.bgHeight * 0.4} Z`)
          .fill('#7CCD7C')
      }
      .width(this.bgWidth)
      .height(this.bgHeight * 0.4)
      .position({ x: 0, y: this.bgHeight * 0.55 })
    }
    .width(this.bgWidth)
    .height(this.bgHeight)
  }
  
  // 小径
  @Builder
  buildPath() {
    Stack() {
      // 弯曲的小径
      Shape() {
        Path()
          .width(60)
          .height(this.bgHeight * 0.4)
          .commands(`M 30 0 
                     Q 10 ${this.bgHeight * 0.1} 20 ${this.bgHeight * 0.2}
                     Q 40 ${this.bgHeight * 0.3} 25 ${this.bgHeight * 0.35}
                     Q 15 ${this.bgHeight * 0.38} 35 ${this.bgHeight * 0.4}
                     L 45 ${this.bgHeight * 0.4}
                     Q 55 ${this.bgHeight * 0.38} 45 ${this.bgHeight * 0.35}
                     Q 60 ${this.bgHeight * 0.3} 40 ${this.bgHeight * 0.2}
                     Q 50 ${this.bgHeight * 0.1} 30 0 Z`)
          .fill('#DEB887')
          .stroke('#D2B48C')
          .strokeWidth(2)
      }
      .width(60)
      .height(this.bgHeight * 0.4)
      .position({ x: this.bgWidth / 2 - 30, y: this.bgHeight * 0.55 })
      
      // 小径上的石子装饰
      this.buildPathStones()
    }
    .width(this.bgWidth)
    .height(this.bgHeight)
  }
  
  // 小径石子
  @Builder
  buildPathStones() {
    Stack() {
      // 石子1
      Shape() {
        Path()
          .width(8)
          .height(6)
          .commands(PathUtils.ellipse(4, 3, 4, 3))
          .fill('#A0522D')
      }
      .width(8)
      .height(6)
      .position({ x: this.bgWidth / 2 - 2, y: this.bgHeight * 0.6 })
      
      // 石子2
      Shape() {
        Path()
          .width(6)
          .height(5)
          .commands(PathUtils.ellipse(3, 2.5, 3, 2.5))
          .fill('#8B4513')
      }
      .width(6)
      .height(5)
      .position({ x: this.bgWidth / 2 + 8, y: this.bgHeight * 0.65 })
      
      // 石子3
      Shape() {
        Path()
          .width(7)
          .height(5)
          .commands(PathUtils.ellipse(3.5, 2.5, 3.5, 2.5))
          .fill('#A0522D')
      }
      .width(7)
      .height(5)
      .position({ x: this.bgWidth / 2 - 5, y: this.bgHeight * 0.72 })
    }
    .width(this.bgWidth)
    .height(this.bgHeight)
  }
  
  // 栅栏
  @Builder
  buildFence() {
    Stack() {
      // 栅栏横杆
      Shape() {
        Path()
          .width(this.bgWidth)
          .height(8)
          .commands(`M 0 4 L ${this.bgWidth} 4`)
          .stroke('#8B4513')
          .strokeWidth(6)
      }
      .width(this.bgWidth)
      .height(8)
      .position({ x: 0, y: this.bgHeight * 0.48 })
      
      Shape() {
        Path()
          .width(this.bgWidth)
          .height(8)
          .commands(`M 0 4 L ${this.bgWidth} 4`)
          .stroke('#8B4513')
          .strokeWidth(6)
      }
      .width(this.bgWidth)
      .height(8)
      .position({ x: 0, y: this.bgHeight * 0.52 })
      
      // 栅栏竖杆
      this.buildFencePosts()
    }
    .width(this.bgWidth)
    .height(this.bgHeight)
  }
  
  // 栅栏竖杆
  @Builder
  buildFencePosts() {
    Stack() {
      ForEach([0, 1, 2, 3, 4, 5, 6], (index: number) => {
        Shape() {
          Path()
            .width(8)
            .height(50)
            .commands(`M 4 0 L 4 50`)
            .stroke('#A0522D')
            .strokeWidth(8)
        }
        .width(8)
        .height(50)
        .position({ x: index * (this.bgWidth / 6) + 20, y: this.bgHeight * 0.46 })
      })
    }
    .width(this.bgWidth)
    .height(this.bgHeight)
  }
  
  // 花朵装饰
  @Builder
  buildFlowers() {
    Stack() {
      // 左侧花丛
      this.buildFlowerCluster(30, this.bgHeight * 0.62, '#FF69B4', '#FFB6C1')
      
      // 中间花朵
      this.buildSingleFlower(this.bgWidth * 0.35, this.bgHeight * 0.65, '#FFD700', 12)
      
      // 右侧花丛
      this.buildFlowerCluster(this.bgWidth - 80, this.bgHeight * 0.6, '#DA70D6', '#DDA0DD')
      
      // 小雏菊
      this.buildDaisy(this.bgWidth * 0.2, this.bgHeight * 0.7, 8)
      this.buildDaisy(this.bgWidth * 0.75, this.bgHeight * 0.68, 7)
    }
    .width(this.bgWidth)
    .height(this.bgHeight)
  }
  
  // 花丛
  @Builder
  buildFlowerCluster(x: number, y: number, color1: string, color2: string) {
    Stack() {
      // 花茎
      Shape() {
        Path()
          .width(40)
          .height(30)
          .commands(`M 20 30 Q 15 15 20 0 M 20 30 Q 25 20 30 5 M 20 30 Q 10 20 5 8`)
          .stroke('#228B22')
          .strokeWidth(2)
      }
      .width(40)
      .height(30)
      
      // 花朵1
      Shape() {
        Path()
          .width(16)
          .height(16)
          .commands(this.getPetalPath(16))
          .fill(color1)
          .stroke('#FF1493')
          .strokeWidth(1)
      }
      .width(16)
      .height(16)
      .position({ x: 12, y: -8 })
      
      // 花朵2
      Shape() {
        Path()
          .width(14)
          .height(14)
          .commands(this.getPetalPath(14))
          .fill(color2)
          .stroke('#FF69B4')
          .strokeWidth(1)
      }
      .width(14)
      .height(14)
      .position({ x: 25, y: -3 })
      
      // 花朵3
      Shape() {
        Path()
          .width(12)
          .height(12)
          .commands(this.getPetalPath(12))
          .fill(color1)
          .stroke('#FF1493')
          .strokeWidth(1)
      }
      .width(12)
      .height(12)
      .position({ x: 0, y: -2 })
    }
    .width(50)
    .height(40)
    .position({ x: x, y: y })
  }
  
  // 花瓣路径
  private getPetalPath(size: number): string {
    let r = size / 2;
    return `M ${r} 0 
            Q ${size} 0 ${size} ${r} 
            Q ${size} ${size} ${r} ${size} 
            Q 0 ${size} 0 ${r} 
            Q 0 0 ${r} 0 Z`;
  }
  
  // 单朵花
  @Builder
  buildSingleFlower(x: number, y: number, color: string, size: number) {
    Stack() {
      // 花茎
      Shape() {
        Path()
          .width(2)
          .height(25)
          .commands(`M 1 0 L 1 25`)
          .stroke('#228B22')
          .strokeWidth(3)
      }
      .width(2)
      .height(25)
      .position({ x: size / 2 - 1, y: size })
      
      // 花朵
      Shape() {
        Path()
          .width(size)
          .height(size)
          .commands(this.getPetalPath(size))
          .fill(color)
          .stroke('#FFA500')
          .strokeWidth(1)
      }
      .width(size)
      .height(size)
      
      // 花心
      Shape() {
        Path()
          .width(size * 0.4)
          .height(size * 0.4)
          .commands(PathUtils.ellipse(size * 0.2, size * 0.2, size * 0.2, size * 0.2))
          .fill('#8B4513')
      }
      .width(size * 0.4)
      .height(size * 0.4)
      .position({ x: size * 0.3, y: size * 0.3 })
    }
    .width(size + 5)
    .height(size + 30)
    .position({ x: x, y: y })
  }
  
  // 雏菊
  @Builder
  buildDaisy(x: number, y: number, size: number) {
    Stack() {
      // 花茎
      Shape() {
        Path()
          .width(2)
          .height(20)
          .commands(`M 1 0 L 1 20`)
          .stroke('#228B22')
          .strokeWidth(2)
      }
      .width(2)
      .height(20)
      .position({ x: size / 2 - 1, y: size })
      
      // 白色花瓣
      ForEach([0, 45, 90, 135, 180, 225, 270, 315], (angle: number) => {
        Shape() {
          Path()
            .width(size * 0.3)
            .height(size * 0.6)
            .commands(PathUtils.ellipse(size * 0.15, size * 0.3, size * 0.15, size * 0.3))
            .fill('#FFFFFF')
            .stroke('#F0F0F0')
            .strokeWidth(0.5)
        }
        .width(size * 0.3)
        .height(size * 0.6)
        .position({ x: size * 0.35, y: size * 0.2 })
        .rotate({ angle: angle, centerX: size * 0.15, centerY: size * 0.3 })
      })
      
      // 黄色花心
      Shape() {
        Path()
          .width(size * 0.4)
          .height(size * 0.4)
          .commands(PathUtils.ellipse(size * 0.2, size * 0.2, size * 0.2, size * 0.2))
          .fill('#FFD700')
      }
      .width(size * 0.4)
      .height(size * 0.4)
      .position({ x: size * 0.3, y: size * 0.3 })
    }
    .width(size + 5)
    .height(size + 25)
    .position({ x: x, y: y })
  }
  
  // 树木
  @Builder
  buildTrees() {
    Stack() {
      // 左侧大树
      this.buildTree(20, this.bgHeight * 0.35, 50, 80)
      
      // 右侧小树
      this.buildTree(this.bgWidth - 70, this.bgHeight * 0.4, 35, 60)
    }
    .width(this.bgWidth)
    .height(this.bgHeight)
  }
  
  // 单棵树
  @Builder
  buildTree(x: number, y: number, crownWidth: number, crownHeight: number) {
    Stack() {
      // 树干
      Shape() {
        Path()
          .width(crownWidth * 0.3)
          .height(crownHeight * 0.6)
          .commands(`M ${crownWidth * 0.1} 0 
                     L 0 ${crownHeight * 0.6} 
                     L ${crownWidth * 0.3} ${crownHeight * 0.6} 
                     L ${crownWidth * 0.2} 0 Z`)
          .fill('#8B4513')
          .stroke('#654321')
          .strokeWidth(1)
      }
      .width(crownWidth * 0.3)
      .height(crownHeight * 0.6)
      .position({ x: crownWidth * 0.35, y: crownHeight * 0.4 })
      
      // 树冠（多层圆形）
      Shape() {
        Path()
          .width(crownWidth)
          .height(crownHeight * 0.7)
          .commands(PathUtils.ellipse(crownWidth / 2, crownHeight * 0.35, crownWidth / 2, crownHeight * 0.35))
          .fill('#228B22')
      }
      .width(crownWidth)
      .height(crownHeight * 0.7)
      .position({ x: 0, y: 0 })
      
      // 树冠高光层
      Shape() {
        Path()
          .width(crownWidth * 0.8)
          .height(crownHeight * 0.5)
          .commands(PathUtils.ellipse(crownWidth * 0.4, crownHeight * 0.25, crownWidth * 0.4, crownHeight * 0.25))
          .fill('#32CD32')
      }
      .width(crownWidth * 0.8)
      .height(crownHeight * 0.5)
      .position({ x: crownWidth * 0.1, y: crownHeight * 0.05 })
    }
    .width(crownWidth)
    .height(crownHeight)
    .position({ x: x, y: y })
  }
}

// ==================== 餐厅背景 ====================
/**
 * 温馨的餐厅场景
 * 包含：餐桌、椅子、吊灯、装饰画、窗户
 */
@Component
export struct RestaurantBackground {
  @Prop bgWidth: number = 360;
  @Prop bgHeight: number = 640;
  @State lightFlicker: number = 0; // 灯光闪烁动画
  private animationTimer: number = -1;
  
  aboutToAppear() {
    // 启动灯光闪烁动画
    this.animationTimer = setInterval(() => {
      this.lightFlicker = (this.lightFlicker + 0.1) % (Math.PI * 2);
    }, 80);
  }
  
  aboutToDisappear() {
    if (this.animationTimer !== -1) {
      clearInterval(this.animationTimer);
    }
  }
  
  build() {
    Stack() {
      // 墙壁背景
      this.buildWalls()
      
      // 地板
      this.buildFloor()
      
      // 窗户
      this.buildWindow()
      
      // 吊灯
      this.buildCeilingLamp()
      
      // 餐桌
      this.buildDiningTable()
      
      // 装饰画
      this.buildWallArt()
    }
    .width(this.bgWidth)
    .height(this.bgHeight)
  }
  
  // 墙壁
  @Builder
  buildWalls() {
    Stack() {
      // 主墙壁
      Column()
        .width(this.bgWidth)
        .height(this.bgHeight * 0.7)
        .linearGradient({
          angle: 180,
          colors: [
            ['#FFF8DC', 0.0],   // 玉米丝色
            ['#FFEFD5', 0.5],   // 木瓜色
            ['#FFE4C4', 1.0]    // 浅橙色
          ]
        })
      
      // 墙壁纹理线条
      Shape() {
        Path()
          .width(this.bgWidth)
          .height(this.bgHeight * 0.7)
          .commands(`M 0 0 L ${this.bgWidth} 0`)
          .stroke('#E8DCC8')
          .strokeWidth(3)
      }
      .width(this.bgWidth)
      .height(this.bgHeight * 0.7)
      .position({ x: 0, y: this.bgHeight * 0.25 })
    }
    .width(this.bgWidth)
    .height(this.bgHeight)
  }
  
  // 地板
  @Builder
  buildFloor() {
    Stack() {
      // 地板主体
      Shape() {
        Path()
          .width(this.bgWidth)
          .height(this.bgHeight * 0.35)
          .commands(`M 0 0 L ${this.bgWidth} 0 L ${this.bgWidth} ${this.bgHeight * 0.35} L 0 ${this.bgHeight * 0.35} Z`)
          .fill('#DEB887')
      }
      .width(this.bgWidth)
      .height(this.bgHeight * 0.35)
      .position({ x: 0, y: this.bgHeight * 0.65 })
      
      // 地板木纹
      ForEach([0, 1, 2, 3, 4], (index: number) => {
        Shape() {
          Path()
            .width(this.bgWidth)
            .height(2)
            .commands(`M 0 0 L ${this.bgWidth} 0`)
            .stroke('#C9B896')
            .strokeWidth(1)
        }
        .width(this.bgWidth)
        .height(2)
        .position({ x: 0, y: this.bgHeight * 0.65 + index * 40 })
      })
    }
    .width(this.bgWidth)
    .height(this.bgHeight)
  }
  
  // 窗户
  @Builder
  buildWindow() {
    Stack() {
      // 窗框
      Shape() {
        Path()
          .width(100)
          .height(80)
          .commands(PathUtils.roundRect(0, 0, 100, 80, 5))
          .fill('#F5F5DC')
          .stroke('#8B7355')
          .strokeWidth(4)
      }
      .width(100)
      .height(80)
      
      // 窗户玻璃
      Column()
        .width(90)
        .height(70)
        .linearGradient({
          angle: 180,
          colors: [
            ['#87CEEB', 0.0],
            ['#B0E0E6', 0.5],
            ['#FFE4B5', 1.0]
          ]
        })
        .position({ x: 5, y: 5 })
      
      // 窗户格子
      Shape() {
        Path()
          .width(90)
          .height(70)
          .commands(`M 45 0 L 45 70 M 0 35 L 90 35`)
          .stroke('#8B7355')
          .strokeWidth(2)
      }
      .width(90)
      .height(70)
      .position({ x: 5, y: 5 })
    }
    .width(100)
    .height(80)
    .position({ x: this.bgWidth - 120, y: 50 })
  }
  
  // 吊灯
  @Builder
  buildCeilingLamp() {
    Stack() {
      // 灯线
      Shape() {
        Path()
          .width(2)
          .height(40)
          .commands(`M 1 0 L 1 40`)
          .stroke('#333333')
          .strokeWidth(2)
      }
      .width(2)
      .height(40)
      .position({ x: 49, y: 0 })
      
      // 灯罩
      Shape() {
        Path()
          .width(80)
          .height(35)
          .commands(`M 10 0 L 70 0 L 80 35 L 0 35 Z`)
          .fill('#FFF8DC')
          .stroke('#DEB887')
          .strokeWidth(2)
      }
      .width(80)
      .height(35)
      .position({ x: 10, y: 40 })
      
      // 灯光效果
      Shape() {
        Path()
          .width(120)
          .height(150)
          .commands(`M 60 0 L 120 150 L 0 150 Z`)
          .fill(`rgba(255, 248, 220, ${0.2 + Math.sin(this.lightFlicker) * 0.05})`)
      }
      .width(120)
      .height(150)
      .position({ x: -10, y: 75 })
      
      // 灯泡光晕
      Shape() {
        Path()
          .width(30)
          .height(30)
          .commands(PathUtils.ellipse(15, 15, 15, 15))
          .fill(`rgba(255, 255, 200, ${0.6 + Math.sin(this.lightFlicker) * 0.1})`)
      }
      .width(30)
      .height(30)
      .position({ x: 35, y: 50 })
    }
    .width(100)
    .height(200)
    .position({ x: this.bgWidth / 2 - 50, y: 0 })
  }
  
  // 餐桌
  @Builder
  buildDiningTable() {
    Stack() {
      // 桌面
      Shape() {
        Path()
          .width(180)
          .height(20)
          .commands(`M 0 10 L 10 0 L 170 0 L 180 10 L 170 20 L 10 20 Z`)
          .fill('#8B4513')
          .stroke('#654321')
          .strokeWidth(2)
      }
      .width(180)
      .height(20)
      .position({ x: 0, y: 0 })
      
      // 桌腿
      Shape() {
        Path()
          .width(180)
          .height(100)
          .commands(`M 15 0 L 20 0 L 22 100 L 13 100 Z
                     M 160 0 L 165 0 L 167 100 L 158 100 Z`)
          .fill('#8B4513')
          .stroke('#654321')
          .strokeWidth(1)
      }
      .width(180)
      .height(100)
      .position({ x: 0, y: 20 })
      
      // 桌布
      Shape() {
        Path()
          .width(160)
          .height(15)
          .commands(PathUtils.roundRect(0, 0, 160, 15, 3))
          .fill('#FFE4E1')
          .stroke('#FFB6C1')
          .strokeWidth(1)
      }
      .width(160)
      .height(15)
      .position({ x: 10, y: 3 })
      
      // 餐具装饰
      this.buildTableware()
    }
    .width(180)
    .height(120)
    .position({ x: this.bgWidth / 2 - 90, y: this.bgHeight * 0.45 })
  }
  
  // 餐具
  @Builder
  buildTableware() {
    Stack() {
      // 盘子
      Shape() {
        Path()
          .width(40)
          .height(40)
          .commands(PathUtils.ellipse(20, 20, 20, 20))
          .fill('#FFFFFF')
          .stroke('#D3D3D3')
          .strokeWidth(2)
      }
      .width(40)
      .height(40)
      .position({ x: 70, y: -25 })
      
      // 杯子
      Shape() {
        Path()
          .width(20)
          .height(25)
          .commands(`M 2 0 L 18 0 L 16 25 L 4 25 Z`)
          .fill('#87CEEB')
          .stroke('#5F9EA0')
          .strokeWidth(1)
      }
      .width(20)
      .height(25)
      .position({ x: 130, y: -25 })
    }
    .width(160)
    .height(40)
  }
  
  // 墙上装饰画
  @Builder
  buildWallArt() {
    Stack() {
      // 画框
      Shape() {
        Path()
          .width(70)
          .height(50)
          .commands(PathUtils.roundRect(0, 0, 70, 50, 3))
          .fill('#8B7355')
          .stroke('#6B5344')
          .strokeWidth(3)
      }
      .width(70)
      .height(50)
      
      // 画内容（水果静物）
      Column() {
        // 背景
        Column()
          .width(60)
          .height(40)
          .linearGradient({
            angle: 180,
            colors: [['#FFF8DC', 0.0], ['#FFEFD5', 1.0]]
          })
        
        // 苹果
        Shape() {
          Path()
            .width(15)
            .height(15)
            .commands(PathUtils.ellipse(7.5, 7.5, 7.5, 7.5))
            .fill('#FF6347')
        }
        .width(15)
        .height(15)
        .position({ x: 15, y: 15 })
        
        // 橙子
        Shape() {
          Path()
            .width(12)
            .height(12)
            .commands(PathUtils.ellipse(6, 6, 6, 6))
            .fill('#FFA500')
        }
        .width(12)
        .height(12)
        .position({ x: 35, y: 18 })
      }
      .width(60)
      .height(40)
      .position({ x: 5, y: 5 })
    }
    .width(70)
    .height(50)
    .position({ x: 30, y: 80 })
  }
}

// ==================== 卧室背景 ====================
/**
 * 温馨的卧室场景
 * 包含：床、床头柜、台灯、窗帘、地毯
 */
@Component
export struct BedroomBackground {
  @Prop bgWidth: number = 360;
  @Prop bgHeight: number = 640;
  @State lampGlow: number = 0; // 台灯光晕动画
  private animationTimer: number = -1;
  
  aboutToAppear() {
    // 启动台灯光晕动画
    this.animationTimer = setInterval(() => {
      this.lampGlow = (this.lampGlow + 0.08) % (Math.PI * 2);
    }, 60);
  }
  
  aboutToDisappear() {
    if (this.animationTimer !== -1) {
      clearInterval(this.animationTimer);
    }
  }
  
  build() {
    Stack() {
      // 墙壁
      this.buildWalls()
      
      // 地板
      this.buildFloor()
      
      // 窗帘
      this.buildCurtains()
      
      // 床
      this.buildBed()
      
      // 床头柜
      this.buildNightstand()
      
      // 台灯
      this.buildLamp()
      
      // 地毯
      this.buildCarpet()
    }
    .width(this.bgWidth)
    .height(this.bgHeight)
  }
  
  // 墙壁
  @Builder
  buildWalls() {
    Stack() {
      // 主墙壁
      Column()
        .width(this.bgWidth)
        .height(this.bgHeight * 0.65)
        .linearGradient({
          angle: 180,
          colors: [
            ['#E6E6FA', 0.0],   // 淡紫色
            ['#F0F8FF', 0.5],   // 爱丽丝蓝
            ['#F5F5F5', 1.0]    // 烟白色
          ]
        })
      
      // 墙壁装饰线
      Shape() {
        Path()
          .width(this.bgWidth)
          .height(3)
          .commands(`M 0 0 L ${this.bgWidth} 0`)
          .stroke('#D8BFD8')
          .strokeWidth(2)
      }
      .width(this.bgWidth)
      .height(3)
      .position({ x: 0, y: this.bgHeight * 0.3 })
    }
    .width(this.bgWidth)
    .height(this.bgHeight)
  }
  
  // 地板
  @Builder
  buildFloor() {
    Stack() {
      // 地板主体
      Shape() {
        Path()
          .width(this.bgWidth)
          .height(this.bgHeight * 0.4)
          .commands(`M 0 0 L ${this.bgWidth} 0 L ${this.bgWidth} ${this.bgHeight * 0.4} L 0 ${this.bgHeight * 0.4} Z`)
          .fill('#DEB887')
      }
      .width(this.bgWidth)
      .height(this.bgHeight * 0.4)
      .position({ x: 0, y: this.bgHeight * 0.6 })
      
      // 地板纹理
      ForEach([0, 1, 2, 3], (index: number) => {
        Shape() {
          Path()
            .width(this.bgWidth)
            .height(1)
            .commands(`M 0 0 L ${this.bgWidth} 0`)
            .stroke('#C9B896')
            .strokeWidth(1)
        }
        .width(this.bgWidth)
        .height(1)
        .position({ x: 0, y: this.bgHeight * 0.6 + index * 50 })
      })
    }
    .width(this.bgWidth)
    .height(this.bgHeight)
  }
  
  // 窗帘
  @Builder
  buildCurtains() {
    Stack() {
      // 窗户背景
      Column()
        .width(100)
        .height(90)
        .linearGradient({
          angle: 180,
          colors: [
            ['#191970', 0.0],   // 深蓝色夜空
            ['#000080', 0.5],   // 海军蓝
            ['#2F4F4F', 1.0]    // 深灰色
          ]
        })
      
      // 星星
      ForEach([10, 30, 50, 70, 85], (x: number) => {
        Shape() {
          Path()
            .width(4)
            .height(4)
            .commands(PathUtils.ellipse(2, 2, 2, 2))
            .fill('#FFFFFF')
        }
        .width(4)
        .height(4)
        .position({ x: x, y: 10 + (x % 3) * 15 })
      })
      
      // 左侧窗帘
      Shape() {
        Path()
          .width(35)
          .height(110)
          .commands(this.getDrapedCurtainPath(35, 110, true))
          .fill('#DDA0DD')
          .stroke('#BA55D3')
          .strokeWidth(2)
      }
      .width(35)
      .height(110)
      .position({ x: -15, y: -10 })
      
      // 右侧窗帘
      Shape() {
        Path()
          .width(35)
          .height(110)
          .commands(this.getDrapedCurtainPath(35, 110, false))
          .fill('#DDA0DD')
          .stroke('#BA55D3')
          .strokeWidth(2)
      }
      .width(35)
      .height(110)
      .position({ x: 80, y: -10 })
      
      // 窗帘杆
      Shape() {
        Path()
          .width(130)
          .height(8)
          .commands(PathUtils.roundRect(0, 0, 130, 8, 4))
          .fill('#8B4513')
          .stroke('#654321')
          .strokeWidth(1)
      }
      .width(130)
      .height(8)
      .position({ x: -15, y: -15 })
    }
    .width(100)
    .height(90)
    .position({ x: this.bgWidth / 2 - 50, y: 40 })
  }
  
  // 垂坠窗帘路径
  private getDrapedCurtainPath(w: number, h: number, isLeft: boolean): string {
    let folds = 4;
    let path = `M 0 0 `;
    for (let i = 0; i <= folds; i++) {
      let x = (w / folds) * i;
      let offsetX = isLeft ? Math.sin(i * 1.5) * 3 : Math.sin(i * 1.5 + Math.PI) * 3;
      path += `L ${x + offsetX} ${h} `;
    }
    path += `L ${w} 0 Z`;
    return path;
  }
  
  // 床
  @Builder
  buildBed() {
    Stack() {
      // 床架
      Shape() {
        Path()
          .width(200)
          .height(30)
          .commands(`M 0 30 L 0 10 L 10 0 L 190 0 L 200 10 L 200 30 Z`)
          .fill('#8B4513')
          .stroke('#654321')
          .strokeWidth(2)
      }
      .width(200)
      .height(30)
      .position({ x: 0, y: 70 })
      
      // 床垫
      Shape() {
        Path()
          .width(190)
          .height(20)
          .commands(PathUtils.roundRect(0, 0, 190, 20, 5))
          .fill('#FFF8DC')
          .stroke('#F5DEB3')
          .strokeWidth(1)
      }
      .width(190)
      .height(20)
      .position({ x: 5, y: 50 })
      
      // 枕头
      Shape() {
        Path()
          .width(50)
          .height(25)
          .commands(PathUtils.roundRect(0, 0, 50, 25, 8))
          .fill('#E6E6FA')
          .stroke('#D8BFD8')
          .strokeWidth(1)
      }
      .width(50)
      .height(25)
      .position({ x: 10, y: 25 })
      
      // 被子
      Shape() {
        Path()
          .width(170)
          .height(60)
          .commands(`M 5 0 Q 0 0 0 10 L 0 55 Q 0 60 10 60 L 160 60 Q 170 60 170 55 L 170 10 Q 170 0 165 0 Z`)
          .fill('#FFE4E1')
          .stroke('#FFB6C1')
          .strokeWidth(2)
      }
      .width(170)
      .height(60)
      .position({ x: 15, y: 0 })
      
      // 被子花纹
      Shape() {
        Path()
          .width(150)
          .height(40)
          .commands(`M 10 10 Q 40 20 70 10 Q 100 0 130 10 Q 140 15 150 10
                     M 10 30 Q 40 40 70 30 Q 100 20 130 30 Q 140 35 150 30`)
          .stroke('#FFC0CB')
          .strokeWidth(2)
          .fill('transparent')
      }
      .width(150)
      .height(40)
      .position({ x: 20, y: 10 })
      
      // 床头板
      Shape() {
        Path()
          .width(200)
          .height(80)
          .commands(`M 0 80 L 0 10 Q 100 -20 200 10 L 200 80 Z`)
          .fill('#8B4513')
          .stroke('#654321')
          .strokeWidth(3)
      }
      .width(200)
      .height(80)
      .position({ x: 0, y: -10 })
    }
    .width(200)
    .height(100)
    .position({ x: this.bgWidth / 2 - 100, y: this.bgHeight * 0.45 })
  }
  
  // 床头柜
  @Builder
  buildNightstand() {
    Stack() {
      // 柜子主体
      Shape() {
        Path()
          .width(50)
          .height(60)
          .commands(PathUtils.roundRect(0, 0, 50, 60, 3))
          .fill('#8B4513')
          .stroke('#654321')
          .strokeWidth(2)
      }
      .width(50)
      .height(60)
      
      // 抽屉
      Shape() {
        Path()
          .width(44)
          .height(25)
          .commands(PathUtils.roundRect(0, 0, 44, 25, 2))
          .fill('#A0522D')
          .stroke('#8B4513')
          .strokeWidth(1)
      }
      .width(44)
      .height(25)
      .position({ x: 3, y: 5 })
      
      // 抽屉把手
      Shape() {
        Path()
          .width(10)
          .height(4)
          .commands(PathUtils.roundRect(0, 0, 10, 4, 2))
          .fill('#D4AF37')
      }
      .width(10)
      .height(4)
      .position({ x: 20, y: 15 })
      
      // 柜腿
      Shape() {
        Path()
          .width(50)
          .height(15)
          .commands(`M 5 0 L 8 15 L 3 15 Z M 45 0 L 48 15 L 43 15 Z`)
          .fill('#654321')
      }
      .width(50)
      .height(15)
      .position({ x: 0, y: 60 })
    }
    .width(50)
    .height(75)
    .position({ x: 30, y: this.bgHeight * 0.5 })
  }
  
  // 台灯
  @Builder
  buildLamp() {
    Stack() {
      // 灯座
      Shape() {
        Path()
          .width(25)
          .height(5)
          .commands(PathUtils.roundRect(0, 0, 25, 5, 2))
          .fill('#D4AF37')
          .stroke('#B8860B')
          .strokeWidth(1)
      }
      .width(25)
      .height(5)
      .position({ x: 12, y: 40 })
      
      // 灯杆
      Shape() {
        Path()
          .width(4)
          .height(35)
          .commands(`M 2 0 L 2 35`)
          .stroke('#D4AF37')
          .strokeWidth(4)
      }
      .width(4)
      .height(35)
      .position({ x: 23, y: 5 })
      
      // 灯罩
      Shape() {
        Path()
          .width(40)
          .height(25)
          .commands(`M 5 0 L 35 0 L 40 25 L 0 25 Z`)
          .fill('#FFF8DC')
          .stroke('#F5DEB3')
          .strokeWidth(2)
      }
      .width(40)
      .height(25)
      .position({ x: 5, y: -20 })
      
      // 灯光
      Shape() {
        Path()
          .width(60)
          .height(80)
          .commands(`M 30 0 L 60 80 L 0 80 Z`)
          .fill(`rgba(255, 255, 200, ${0.15 + Math.sin(this.lampGlow) * 0.05})`)
      }
      .width(60)
      .height(80)
      .position({ x: -5, y: 5 })
    }
    .width(50)
    .height(50)
    .position({ x: 30, y: this.bgHeight * 0.42 })
  }
  
  // 地毯
  @Builder
  buildCarpet() {
    Stack() {
      // 地毯主体
      Shape() {
        Path()
          .width(150)
          .height(80)
          .commands(PathUtils.roundRect(0, 0, 150, 80, 10))
          .fill('#E6E6FA')
          .stroke('#D8BFD8')
          .strokeWidth(3)
      }
      .width(150)
      .height(80)
      
      // 地毯花纹
      Shape() {
        Path()
          .width(130)
          .height(60)
          .commands(`M 10 10 L 120 10 L 120 50 L 10 50 Z`)
          .fill('transparent')
          .stroke('#DDA0DD')
          .strokeWidth(2)
      }
      .width(130)
      .height(60)
      .position({ x: 10, y: 10 })
      
      // 中心图案
      Shape() {
        Path()
          .width(40)
          .height(40)
          .commands(PathUtils.ellipse(20, 20, 20, 20))
          .fill('#DDA0DD')
          .stroke('#BA55D3')
          .strokeWidth(2)
      }
      .width(40)
      .height(40)
      .position({ x: 55, y: 20 })
    }
    .width(150)
    .height(80)
    .position({ x: this.bgWidth / 2 - 75, y: this.bgHeight * 0.8 })
  }
}
