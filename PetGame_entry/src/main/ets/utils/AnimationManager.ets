/**
 * 动画管理器
 */
import { AnimationType, ANIMATION_CONFIGS, AnimationConfig } from '../common/Constants';

// ==================== 动画参数接口 ====================
export interface ScaleParams {
  from: number;
  to: number;
}

export interface TranslateParams {
  fromX: number;
  fromY: number;
  toX: number;
  toY: number;
}

export interface RotateParams {
  from: number;
  to: number;
}

export interface AnimationParams {
  duration: number;
  curve: Curve;
  delay: number;
  iterations: number;
  scale: ScaleParams;
  translate: TranslateParams;
  rotate: RotateParams;
}

// ==================== 动画控制器 ====================
export class AnimationManager {
  currentAnimation: AnimationType = AnimationType.PACE;
  isPlaying: boolean = false;
  onAnimationUpdate: (type: AnimationType, progress: number) => void = () => {};
  
  playAnimation(type: AnimationType): void {
    this.currentAnimation = type;
    this.isPlaying = true;
  }
  
  stopAnimation(): void {
    this.isPlaying = false;
  }
  
  getConfig(type: AnimationType): AnimationConfig {
    const config = ANIMATION_CONFIGS.get(type);
    if (config) {
      return config;
    }
    const defaultConfig = ANIMATION_CONFIGS.get('pace');
    return defaultConfig ?? { duration: 1000 };
  }
}

// ==================== 互动动画配置 ====================
export const INTERACTION_ANIMATIONS: AnimationType[] = [
  AnimationType.JUMP,
  AnimationType.TILT,
  AnimationType.SHAKE,
  AnimationType.HEART
];

// ==================== 待机动画配置 ====================
export const IDLE_ANIMATIONS: AnimationType[] = [
  AnimationType.PACE,
  AnimationType.STRETCH,
  AnimationType.GROOM,
  AnimationType.DROWSY
];

// ==================== 动画参数工具函数 ====================
function createScaleParams(from: number, to: number): ScaleParams {
  return { from: from, to: to };
}

function createTranslateParams(fromX: number, fromY: number, toX: number, toY: number): TranslateParams {
  return { fromX: fromX, fromY: fromY, toX: toX, toY: toY };
}

function createRotateParams(from: number, to: number): RotateParams {
  return { from: from, to: to };
}

function createAnimationParams(
  duration: number,
  curve: Curve,
  delay: number,
  iterations: number,
  scale: ScaleParams,
  translate: TranslateParams,
  rotate: RotateParams
): AnimationParams {
  return {
    duration: duration,
    curve: curve,
    delay: delay,
    iterations: iterations,
    scale: scale,
    translate: translate,
    rotate: rotate
  };
}

// 预定义动画参数
export const ANIMATION_PARAMS: Map<string, AnimationParams> = new Map([
  ['jump', createAnimationParams(
    400, Curve.EaseOut, 0, 1,
    createScaleParams(1.0, 1.1),
    createTranslateParams(0, 0, 0, -30),
    createRotateParams(0, 0)
  )],
  ['tilt', createAnimationParams(
    500, Curve.EaseInOut, 0, 1,
    createScaleParams(1.0, 1.0),
    createTranslateParams(0, 0, 0, 0),
    createRotateParams(0, 15)
  )],
  ['shake', createAnimationParams(
    300, Curve.EaseInOut, 0, 3,
    createScaleParams(1.0, 1.0),
    createTranslateParams(-10, 0, 10, 0),
    createRotateParams(-10, 10)
  )],
  ['heart', createAnimationParams(
    800, Curve.EaseOut, 0, 1,
    createScaleParams(0.5, 1.5),
    createTranslateParams(0, 0, 0, -20),
    createRotateParams(0, 0)
  )],
  ['pace', createAnimationParams(
    2000, Curve.EaseInOut, 0, -1,
    createScaleParams(1.0, 1.0),
    createTranslateParams(-20, 0, 20, 0),
    createRotateParams(0, 0)
  )],
  ['stretch', createAnimationParams(
    1000, Curve.EaseInOut, 0, 1,
    createScaleParams(1.0, 1.15),
    createTranslateParams(0, 0, 0, -10),
    createRotateParams(0, 0)
  )],
  ['hatch', createAnimationParams(
    2000, Curve.EaseOut, 0, 1,
    createScaleParams(1.0, 1.2),
    createTranslateParams(0, 0, 0, 0),
    createRotateParams(0, 0)
  )],
  ['sad', createAnimationParams(
    1000, Curve.EaseInOut, 0, -1,
    createScaleParams(1.0, 0.95),
    createTranslateParams(0, 0, 0, 5),
    createRotateParams(0, -5)
  )],
  ['excited', createAnimationParams(
    300, Curve.EaseOut, 0, -1,
    createScaleParams(1.0, 1.05),
    createTranslateParams(0, 0, 0, -5),
    createRotateParams(-3, 3)
  )]
]);

// ==================== 工具函数 ====================
export function getRandomInteractionAnimation(): AnimationType {
  const index = Math.floor(Math.random() * INTERACTION_ANIMATIONS.length);
  return INTERACTION_ANIMATIONS[index];
}

export function getRandomIdleAnimation(): AnimationType {
  const index = Math.floor(Math.random() * IDLE_ANIMATIONS.length);
  return IDLE_ANIMATIONS[index];
}

export function formatTime(seconds: number): string {
  const mins = Math.floor(seconds / 60);
  const secs = Math.floor(seconds % 60);
  return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
}
