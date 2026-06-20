/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { mediaquery, display } from '@kit.ArkUI';

/**
 * 设备类型枚举
 */
export enum DeviceType {
  PHONE = 'phone',
  TABLET = 'tablet',
  FOLDABLE = 'foldable',
  WEARABLE = 'wearable',
  TV = 'tv',
  UNKNOWN = 'unknown'
}

/**
 * 断点类型枚举
 * 遵循HarmonyOS设计规范
 */
export enum BreakpointType {
  XS = 'xs',    // < 320vp (手表等小屏设备)
  SM = 'sm',    // 320-600vp (手机竖屏)
  MD = 'md',    // 600-840vp (手机横屏、小平板)
  LG = 'lg',    // 840-1024vp (平板竖屏、折叠屏)
  XL = 'xl'     // > 1024vp (平板横屏、TV、2in1)
}

/**
 * 屏幕方向枚举
 */
export enum Orientation {
  PORTRAIT = 'portrait',
  LANDSCAPE = 'landscape'
}

/**
 * 设备能力接口
 */
export interface DeviceCapability {
  type: DeviceType;
  breakpoint: BreakpointType;
  orientation: Orientation;
  screenWidth: number;
  screenHeight: number;
  density: number;
  isFoldable: boolean;
  isWearable: boolean;
}

/**
 * 断点条件接口
 */
interface BreakpointCondition {
  breakpoint: BreakpointType;
  condition: string;
}

/**
 * 响应式布局管理器
 * 提供多设备适配的核心能力
 */
export class ResponsiveLayoutManager {
  private static instance: ResponsiveLayoutManager;
  
  // 当前设备能力
  @Track currentCapability: DeviceCapability = {
    type: DeviceType.PHONE,
    breakpoint: BreakpointType.SM,
    orientation: Orientation.PORTRAIT,
    screenWidth: 360,
    screenHeight: 640,
    density: 1.0,
    isFoldable: false,
    isWearable: false
  };
  
  // 媒体查询监听器
  private mediaQueryListeners: mediaquery.MediaQueryListener[] = [];
  
  // 断点变化回调
  private breakpointChangeCallbacks: ((breakpoint: BreakpointType) => void)[] = [];
  
  private constructor() {}
  
  /**
   * 获取单例实例
   */
  static getInstance(): ResponsiveLayoutManager {
    if (!ResponsiveLayoutManager.instance) {
      ResponsiveLayoutManager.instance = new ResponsiveLayoutManager();
    }
    return ResponsiveLayoutManager.instance;
  }
  
  /**
   * 初始化响应式布局系统
   */
  initialize(context: Context): void {
    this.detectDeviceType(context);
    this.setupMediaQueryListeners(context);
    this.updateScreenInfo(context);
  }
  
  /**
   * 检测设备类型
   */
  private detectDeviceType(context: Context): void {
    const displayInfo = display.getDefaultDisplaySync();
    
    // 根据屏幕尺寸判断设备类型
    const screenWidth = displayInfo.width;
    const screenHeight = displayInfo.height;
    const minDimension = Math.min(screenWidth, screenHeight);
    const maxDimension = Math.max(screenWidth, screenHeight);
    
    if (minDimension < 320) {
      this.currentCapability.type = DeviceType.WEARABLE;
      this.currentCapability.isWearable = true;
    } else if (maxDimension >= 1280) {
      this.currentCapability.type = DeviceType.TV;
    } else if (minDimension >= 600 && maxDimension >= 900) {
      this.currentCapability.type = DeviceType.TABLET;
    } else {
      this.currentCapability.type = DeviceType.PHONE;
    }
    
    // 检测是否为折叠屏
    this.currentCapability.isFoldable = this.checkFoldable();
  }
  
  /**
   * 检测是否为折叠屏设备
   */
  private checkFoldable(): boolean {
    // 通过屏幕密度和尺寸特征判断
    const displayInfo = display.getDefaultDisplaySync();
    const aspectRatio = Math.max(displayInfo.width, displayInfo.height) /
                        Math.min(displayInfo.width, displayInfo.height);
    
    // 折叠屏通常有较大的屏幕和特殊的宽高比
    return aspectRatio > 2.0 && displayInfo.densityDPI >= 320;
  }
  
  /**
   * 设置媒体查询监听器
   */
  private setupMediaQueryListeners(context: Context): void {
    // 清理旧的监听器
    this.mediaQueryListeners.forEach(listener => {
      listener.off('change');
    });
    this.mediaQueryListeners = [];
    
    // 定义断点媒体查询条件
    const breakpointConditions: BreakpointCondition[] = [
      { breakpoint: BreakpointType.XS, condition: '(width < 320vp)' },
      { breakpoint: BreakpointType.SM, condition: '(320vp <= width < 600vp)' },
      { breakpoint: BreakpointType.MD, condition: '(600vp <= width < 840vp)' },
      { breakpoint: BreakpointType.LG, condition: '(840vp <= width < 1024vp)' },
      { breakpoint: BreakpointType.XL, condition: '(width >= 1024vp)' }
    ];
    
    // 为每个断点创建监听器
    breakpointConditions.forEach((item: BreakpointCondition) => {
      const listener = mediaquery.matchMediaSync(item.condition);
      
      listener.on('change', (result: mediaquery.MediaQueryResult) => {
        if (result.matches) {
          this.updateBreakpoint(item.breakpoint);
        }
      });
      
      // 初始检查
      if (listener.matches) {
        this.currentCapability.breakpoint = item.breakpoint;
      }
      
      this.mediaQueryListeners.push(listener);
    });
  }
  
  /**
   * 更新屏幕信息
   */
  private updateScreenInfo(context: Context): void {
    const displayInfo = display.getDefaultDisplaySync();
    
    this.currentCapability.screenWidth = displayInfo.width;
    this.currentCapability.screenHeight = displayInfo.height;
    this.currentCapability.density = displayInfo.densityDPI / 160;
    
    // 判断屏幕方向
    this.currentCapability.orientation =
      displayInfo.width > displayInfo.height
        ? Orientation.LANDSCAPE 
        : Orientation.PORTRAIT;
  }
  
  /**
   * 更新断点
   */
  private updateBreakpoint(breakpoint: BreakpointType): void {
    if (this.currentCapability.breakpoint !== breakpoint) {
      this.currentCapability.breakpoint = breakpoint;
      
      // 通知所有监听者
      this.breakpointChangeCallbacks.forEach(callback => {
        callback(breakpoint);
      });
    }
  }
  
  /**
   * 注册断点变化监听
   */
  onBreakpointChange(callback: (breakpoint: BreakpointType) => void): void {
    this.breakpointChangeCallbacks.push(callback);
  }
  
  /**
   * 取消断点变化监听
   */
  offBreakpointChange(callback: (breakpoint: BreakpointType) => void): void {
    const index = this.breakpointChangeCallbacks.indexOf(callback);
    if (index > -1) {
      this.breakpointChangeCallbacks.splice(index, 1);
    }
  }
  
  /**
   * 获取当前设备能力
   */
  getCurrentCapability(): DeviceCapability {
    return this.currentCapability;
  }
  
  /**
   * 获取当前断点
   */
  getCurrentBreakpoint(): BreakpointType {
    return this.currentCapability.breakpoint;
  }
  
  /**
   * 获取当前设备类型
   */
  getCurrentDeviceType(): DeviceType {
    return this.currentCapability.type;
  }
  
  /**
   * 是否为小屏设备（手表、小手机）
   */
  isSmallScreen(): boolean {
    return this.currentCapability.breakpoint === BreakpointType.XS ||
           this.currentCapability.breakpoint === BreakpointType.SM;
  }
  
  /**
   * 是否为大屏设备（平板、TV、2in1）
   */
  isLargeScreen(): boolean {
    return this.currentCapability.breakpoint === BreakpointType.LG ||
           this.currentCapability.breakpoint === BreakpointType.XL;
  }
  
  /**
   * 是否为可穿戴设备
   */
  isWearableDevice(): boolean {
    return this.currentCapability.isWearable;
  }
  
  /**
   * 销毁资源
   */
  destroy(): void {
    this.mediaQueryListeners.forEach(listener => {
      listener.off('change');
    });
    this.mediaQueryListeners = [];
    this.breakpointChangeCallbacks = [];
  }
}
