/**
 * 宠物动画控制器
 * 控制宠物的闲置动画和互动反应
 */

import { AnimationType, AnimationConfig, IdleActionSequence, AnimationCalculator } from '../managers/PetAnimationManager';

@Component
export struct PetAnimationController {
  // 当前动画状态
  @State currentAnimation: AnimationType = AnimationType.IDLE;
  @State animationProgress: number = 0;
  @State isAnimating: boolean = false;
  
  // 动画参数输出
  @Link @Watch('onBlinkChange') blinkProgress: number;
  @Link @Watch('onBounceChange') bounceOffset: number;
  @Link @Watch('onWobbleChange') wobbleAngle: number;
  @Link @Watch('onWaveChange') tentacleWave: number;
  
  // 闲置动作序列
  private idleSequence: IdleActionSequence = new IdleActionSequence();
  
  // 定时器ID
  private idleTimer: number = -1;
  private animationTimer: number = -1;
  
  // 动画开始时间
  private animationStartTime: number = 0;
  
  aboutToAppear() {
    // 启动闲置动画循环
    this.startIdleLoop();
    // 启动触手波动
    this.startTentacleWave();
  }
  
  aboutToDisappear() {
    this.stopAllAnimations();
  }
  
  // 启动闲置动画循环
  private startIdleLoop() {
    this.idleTimer = setInterval(() => {
      if (!this.isAnimating) {
        this.playIdleAnimation();
      }
    }, AnimationConfig.IDLE_INTERVAL);
  }
  
  // 启动触手波动
  private startTentacleWave() {
    this.animationTimer = setInterval(() => {
      this.tentacleWave = AnimationCalculator.calculateTentacleWave(Date.now());
    }, 50);
  }
  
  // 播放闲置动画
  private playIdleAnimation() {
    let action = this.idleSequence.getNextAction();
    this.playAnimation(action);
  }
  
  // 播放指定动画
  playAnimation(type: AnimationType) {
    if (this.isAnimating) {
      return;
    }
    
    this.currentAnimation = type;
    this.isAnimating = true;
    this.animationStartTime = Date.now();
    this.animationProgress = 0;
    
    let duration = this.getAnimationDuration(type);
    
    // 动画更新定时器
    let updateTimer = setInterval(() => {
      let elapsed = Date.now() - this.animationStartTime;
      this.animationProgress = Math.min(elapsed / duration, 1.0);
      
      this.updateAnimationParams();
      
      if (this.animationProgress >= 1.0) {
        clearInterval(updateTimer);
        this.isAnimating = false;
        this.resetAnimationParams();
      }
    }, 16); // 约60fps
  }
  
  // 获取动画时长
  private getAnimationDuration(type: AnimationType): number {
    switch (type) {
      case AnimationType.BLINK:
        return AnimationConfig.BLINK_DURATION;
      case AnimationType.BOUNCE:
        return AnimationConfig.BOUNCE_DURATION;
      case AnimationType.WOBBLE:
        return AnimationConfig.WOBBLE_DURATION;
      case AnimationType.YAWN:
        return AnimationConfig.YAWN_DURATION;
      case AnimationType.HAPPY:
        return AnimationConfig.HAPPY_DURATION;
      case AnimationType.EAT:
        return AnimationConfig.EAT_DURATION;
      case AnimationType.BATH:
        return AnimationConfig.BATH_DURATION;
      default:
        return 500;
    }
  }
  
  // 更新动画参数
  private updateAnimationParams() {
    switch (this.currentAnimation) {
      case AnimationType.BLINK:
        this.blinkProgress = AnimationCalculator.calculateBlink(this.animationProgress);
        break;
      case AnimationType.BOUNCE:
        this.bounceOffset = AnimationCalculator.calculateBounce(this.animationProgress, 15);
        break;
      case AnimationType.WOBBLE:
        this.wobbleAngle = AnimationCalculator.calculateWobble(this.animationProgress, 8);
        break;
    }
  }
  
  // 重置动画参数
  private resetAnimationParams() {
    this.blinkProgress = 0;
    this.bounceOffset = 0;
    this.wobbleAngle = 0;
  }
  
  // 停止所有动画
  stopAllAnimations() {
    if (this.idleTimer !== -1) {
      clearInterval(this.idleTimer);
      this.idleTimer = -1;
    }
    if (this.animationTimer !== -1) {
      clearInterval(this.animationTimer);
      this.animationTimer = -1;
    }
  }
  
  // 触发互动反应
  triggerReaction(type: AnimationType) {
    this.playAnimation(type);
  }
  
  // 监听器（空实现，用于触发更新）
  onBlinkChange() {}
  onBounceChange() {}
  onWobbleChange() {}
  onWaveChange() {}
  
  build() {
    // 空组件，仅用于逻辑控制
  }
}
