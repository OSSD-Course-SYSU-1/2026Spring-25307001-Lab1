/**
 * 宠物动画管理器
 * 管理宠物的闲置动画和互动反应动画
 */

// 动画类型枚举
export enum AnimationType {
  IDLE = 'idle',           // 闲置
  BLINK = 'blink',         // 眨眼
  BOUNCE = 'bounce',       // 弹跳
  WOBBLE = 'wobble',       // 摇摆
  WAVE = 'wave',           // 挥手/触手波动
  YAWN = 'yawn',           // 打哈欠
  HAPPY = 'happy',         // 开心
  EXCITED = 'excited',     // 兴奋
  SAD = 'sad',             // 悲伤
  EAT = 'eat',             // 吃东西
  BATH = 'bath',           // 洗澡
  SLEEP = 'sleep',         // 睡眠
  WAKE = 'wake'            // 醒来
}

// 动画配置
export class AnimationConfig {
  // 闲置动画间隔（毫秒）
  static readonly IDLE_INTERVAL: number = 3000;
  
  // 眨眼动画时长
  static readonly BLINK_DURATION: number = 200;
  
  // 弹跳动画时长
  static readonly BOUNCE_DURATION: number = 400;
  
  // 摇摆动画时长
  static readonly WOBBLE_DURATION: number = 600;
  
  // 触手波动周期
  static readonly WAVE_PERIOD: number = 2000;
  
  // 打哈欠动画时长
  static readonly YAWN_DURATION: number = 800;
  
  // 开心动画时长
  static readonly HAPPY_DURATION: number = 600;
  
  // 吃东西动画时长
  static readonly EAT_DURATION: number = 1000;
  
  // 洗澡动画时长
  static readonly BATH_DURATION: number = 1500;
}

// 动画状态
export interface AnimationState {
  type: AnimationType;
  progress: number;        // 0-1 动画进度
  isActive: boolean;
  startTime: number;
}

// 闲置动作序列
export class IdleActionSequence {
  private actions: AnimationType[] = [
    AnimationType.BLINK,
    AnimationType.BOUNCE,
    AnimationType.WOBBLE,
    AnimationType.WAVE,
    AnimationType.YAWN,
    AnimationType.BLINK
  ];
  
  private currentIndex: number = 0;
  
  getNextAction(): AnimationType {
    let action = this.actions[this.currentIndex];
    this.currentIndex = (this.currentIndex + 1) % this.actions.length;
    return action;
  }
  
  reset(): void {
    this.currentIndex = 0;
  }
}

// 动画计算工具
export class AnimationCalculator {
  // 计算眨眼进度（正弦曲线）
  static calculateBlink(progress: number): number {
    return Math.sin(progress * Math.PI);
  }
  
  // 计算弹跳偏移（抛物线）
  static calculateBounce(progress: number, maxHeight: number): number {
    return -maxHeight * 4 * progress * (1 - progress);
  }
  
  // 计算摇摆角度（正弦曲线）
  static calculateWobble(progress: number, maxAngle: number): number {
    return maxAngle * Math.sin(progress * Math.PI * 2);
  }
  
  // 计算触手波动
  static calculateTentacleWave(time: number): number {
    return (time % AnimationConfig.WAVE_PERIOD) / AnimationConfig.WAVE_PERIOD * Math.PI * 2;
  }
  
  // 计算打哈欠（嘴巴张开程度）
  static calculateYawn(progress: number): number {
    if (progress < 0.3) {
      return progress / 0.3;
    } else if (progress < 0.7) {
      return 1.0;
    } else {
      return (1 - progress) / 0.3;
    }
  }
  
  // 计算开心效果（心跳缩放）
  static calculateHappyHeart(progress: number): number {
    return 1 + 0.2 * Math.sin(progress * Math.PI * 4);
  }
  
  // 计算吃东西动画
  static calculateEat(progress: number): number {
    // 咀嚼循环
    return Math.abs(Math.sin(progress * Math.PI * 4));
  }
}
