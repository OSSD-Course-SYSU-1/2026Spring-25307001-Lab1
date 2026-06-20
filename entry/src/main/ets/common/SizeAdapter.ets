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

import { BreakpointType, DeviceType, ResponsiveLayoutManager } from './ResponsiveLayoutManager';

/**
 * 尺寸配置接口
 */
export interface SizeConfig {
  // 视频播放器尺寸
  videoPlayerHeight: string;
  videoPlayerWidth: string;
  
  // 控制栏尺寸
  controlBarHeight: string;
  controlButtonSize: string;
  controlIconSize: string;
  
  // 字体尺寸
  titleFontSize: string;
  normalFontSize: string;
  smallFontSize: string;
  
  // 间距
  paddingLarge: string;
  paddingMedium: string;
  paddingSmall: string;
  
  // 弹幕相关
  danmakuInputHeight: string;
  danmakuFontSize: string;
  
  // 评论相关
  commentPanelHeight: string;
  commentItemHeight: string;
}

/**
 * 不同断点的尺寸配置
 */
const BREAKPOINT_SIZE_CONFIGS: Record<BreakpointType, SizeConfig> = {
  [BreakpointType.XS]: {
    // 手表等超小屏设备
    videoPlayerHeight: '50%',
    videoPlayerWidth: '100%',
    controlBarHeight: '40vp',
    controlButtonSize: '28vp',
    controlIconSize: '16vp',
    titleFontSize: '12fp',
    normalFontSize: '10fp',
    smallFontSize: '8fp',
    paddingLarge: '8vp',
    paddingMedium: '6vp',
    paddingSmall: '4vp',
    danmakuInputHeight: '32vp',
    danmakuFontSize: '10fp',
    commentPanelHeight: '30%',
    commentItemHeight: '40vp'
  },
  
  [BreakpointType.SM]: {
    // 手机竖屏
    videoPlayerHeight: '56%',
    videoPlayerWidth: '100%',
    controlBarHeight: '48vp',
    controlButtonSize: '36vp',
    controlIconSize: '20vp',
    titleFontSize: '16fp',
    normalFontSize: '14fp',
    smallFontSize: '12fp',
    paddingLarge: '16vp',
    paddingMedium: '12vp',
    paddingSmall: '8vp',
    danmakuInputHeight: '44vp',
    danmakuFontSize: '14fp',
    commentPanelHeight: '40%',
    commentItemHeight: '60vp'
  },
  
  [BreakpointType.MD]: {
    // 手机横屏、小平板
    videoPlayerHeight: '100%',
    videoPlayerWidth: '70%',
    controlBarHeight: '52vp',
    controlButtonSize: '40vp',
    controlIconSize: '22vp',
    titleFontSize: '18fp',
    normalFontSize: '15fp',
    smallFontSize: '13fp',
    paddingLarge: '20vp',
    paddingMedium: '16vp',
    paddingSmall: '10vp',
    danmakuInputHeight: '48vp',
    danmakuFontSize: '15fp',
    commentPanelHeight: '35%',
    commentItemHeight: '70vp'
  },
  
  [BreakpointType.LG]: {
    // 平板竖屏、折叠屏
    videoPlayerHeight: '100%',
    videoPlayerWidth: '60%',
    controlBarHeight: '56vp',
    controlButtonSize: '44vp',
    controlIconSize: '24vp',
    titleFontSize: '20fp',
    normalFontSize: '16fp',
    smallFontSize: '14fp',
    paddingLarge: '24vp',
    paddingMedium: '20vp',
    paddingSmall: '12vp',
    danmakuInputHeight: '52vp',
    danmakuFontSize: '16fp',
    commentPanelHeight: '30%',
    commentItemHeight: '80vp'
  },
  
  [BreakpointType.XL]: {
    // 平板横屏、TV、2in1
    videoPlayerHeight: '100%',
    videoPlayerWidth: '50%',
    controlBarHeight: '60vp',
    controlButtonSize: '48vp',
    controlIconSize: '26vp',
    titleFontSize: '22fp',
    normalFontSize: '18fp',
    smallFontSize: '15fp',
    paddingLarge: '32vp',
    paddingMedium: '24vp',
    paddingSmall: '16vp',
    danmakuInputHeight: '56vp',
    danmakuFontSize: '18fp',
    commentPanelHeight: '25%',
    commentItemHeight: '90vp'
  }
};

/**
 * 尺寸适配工具类
 * 提供根据设备和断点自动适配的尺寸值
 */
export class SizeAdapter {
  private static instance: SizeAdapter;
  private layoutManager: ResponsiveLayoutManager;
  private currentConfig: SizeConfig;
  
  private constructor() {
    this.layoutManager = ResponsiveLayoutManager.getInstance();
    this.currentConfig = BREAKPOINT_SIZE_CONFIGS[this.layoutManager.getCurrentBreakpoint()];
    
    // 监听断点变化
    this.layoutManager.onBreakpointChange((breakpoint: BreakpointType) => {
      this.currentConfig = BREAKPOINT_SIZE_CONFIGS[breakpoint];
    });
  }
  
  /**
   * 获取单例实例
   */
  static getInstance(): SizeAdapter {
    if (!SizeAdapter.instance) {
      SizeAdapter.instance = new SizeAdapter();
    }
    return SizeAdapter.instance;
  }
  
  /**
   * 获取当前尺寸配置
   */
  getConfig(): SizeConfig {
    return this.currentConfig;
  }
  
  /**
   * 根据设备类型获取视频播放器高度
   */
  getVideoPlayerHeight(): string {
    // 特殊处理可穿戴设备
    if (this.layoutManager.isWearableDevice()) {
      return '45%';
    }
    
    // 横屏时全屏显示
    const capability = this.layoutManager.getCurrentCapability();
    if (capability.orientation === 'landscape') {
      return '100%';
    }
    
    return this.currentConfig.videoPlayerHeight;
  }
  
  /**
   * 根据设备类型获取视频播放器宽度
   */
  getVideoPlayerWidth(): string {
    // 特殊处理可穿戴设备
    if (this.layoutManager.isWearableDevice()) {
      return '100%';
    }
    
    const capability = this.layoutManager.getCurrentCapability();
    
    // 平板横屏时，视频区域占65%
    if (capability.type === 'tablet' && capability.orientation === 'landscape') {
      return '65%';
    }
    
    // 大屏设备（平板竖屏、TV）显示侧边栏
    if (this.layoutManager.isLargeScreen()) {
      return '65%';
    }
    
    // 宽度足够时也显示侧边栏
    if (capability.screenWidth >= 840) {
      return '65%';
    }

    return this.currentConfig.videoPlayerWidth;
  }
  
  /**
   * 获取控制栏高度
   */
  getControlBarHeight(): string {
    return this.currentConfig.controlBarHeight;
  }
  
  /**
   * 获取控制按钮尺寸
   */
  getControlButtonSize(): string {
    return this.currentConfig.controlButtonSize;
  }
  
  /**
   * 获取控制图标尺寸
   */
  getControlIconSize(): string {
    return this.currentConfig.controlIconSize;
  }
  
  /**
   * 获取标题字体大小
   */
  getTitleFontSize(): string {
    return this.currentConfig.titleFontSize;
  }
  
  /**
   * 获取正常字体大小
   */
  getNormalFontSize(): string {
    return this.currentConfig.normalFontSize;
  }
  
  /**
   * 获取小字体大小
   */
  getSmallFontSize(): string {
    return this.currentConfig.smallFontSize;
  }
  
  /**
   * 获取大间距
   */
  getPaddingLarge(): string {
    return this.currentConfig.paddingLarge;
  }
  
  /**
   * 获取中等间距
   */
  getPaddingMedium(): string {
    return this.currentConfig.paddingMedium;
  }
  
  /**
   * 获取小间距
   */
  getPaddingSmall(): string {
    return this.currentConfig.paddingSmall;
  }
  
  /**
   * 获取弹幕输入框高度
   */
  getDanmakuInputHeight(): string {
    return this.currentConfig.danmakuInputHeight;
  }
  
  /**
   * 获取弹幕字体大小
   */
  getDanmakuFontSize(): string {
    return this.currentConfig.danmakuFontSize;
  }
  
  /**
   * 获取评论面板高度
   */
  getCommentPanelHeight(): string {
    return this.currentConfig.commentPanelHeight;
  }
  
  /**
   * 获取评论项高度
   */
  getCommentItemHeight(): string {
    return this.currentConfig.commentItemHeight;
  }
  
  /**
   * 计算相对尺寸
   * @param baseValue 基准值（在SM断点下的值）
   * @returns 适配后的尺寸
   */
  calculateRelativeSize(baseValue: number): string {
    const breakpoint = this.layoutManager.getCurrentBreakpoint();
    
    // 缩放因子
    const scaleFactors: Record<BreakpointType, number> = {
      [BreakpointType.XS]: 0.7,
      [BreakpointType.SM]: 1.0,
      [BreakpointType.MD]: 1.15,
      [BreakpointType.LG]: 1.3,
      [BreakpointType.XL]: 1.5
    };
    
    const scaledValue = baseValue * scaleFactors[breakpoint];
    return `${scaledValue}vp`;
  }
  
  /**
   * 获取网格列数
   * 根据屏幕宽度自动计算合适的列数
   */
  getGridColumns(): number {
    const breakpoint = this.layoutManager.getCurrentBreakpoint();
    
    const columns: Record<BreakpointType, number> = {
      [BreakpointType.XS]: 2,
      [BreakpointType.SM]: 3,
      [BreakpointType.MD]: 4,
      [BreakpointType.LG]: 5,
      [BreakpointType.XL]: 6
    };
    
    return columns[breakpoint];
  }
  
  /**
   * 是否显示侧边栏
   * 大屏设备显示侧边栏
   */
  shouldShowSidebar(): boolean {
    const capability = this.layoutManager.getCurrentCapability();
    // 平板横屏或大屏设备显示侧边栏
    const isTabletLandscape = capability.type === 'tablet' && capability.orientation === 'landscape';
    const isLargeScreen = this.layoutManager.isLargeScreen();
    const isWideEnough = capability.screenWidth >= 840;
    
    return isTabletLandscape || isLargeScreen || isWideEnough;
  }
  
  /**
   * 是否使用紧凑布局
   * 小屏设备使用紧凑布局
   */
  shouldUseCompactLayout(): boolean {
    return this.layoutManager.isSmallScreen() || 
           this.layoutManager.isWearableDevice();
  }
}
