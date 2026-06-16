/**
 * 宠物养成游戏 - 多端适配与绘制工具
 * 
 * 【适配原则】
 * 1. 使用屏幕百分比分配空间，而非固定值缩放
 * 2. 根据设备类型调整布局策略
 * 3. 考虑屏幕宽高比
 * 4. 元素大小有合理范围限制
 */

import { DeviceType } from '../common/Constants';

// RGB颜色接口
export interface RgbColor {
  r: number;
  g: number;
  b: number;
}

// 主页面布局接口
export interface MainPageLayout {
  topPadding: number;      // 顶部留白
  valuePanelHeight: number; // 数值面板高度
  growthHeight: number;     // 成长指示器高度
  petAreaHeight: number;    // 宠物区域高度
  buttonBarHeight: number;  // 按钮栏高度
  bottomPadding: number;    // 底部留白
}

// ==================== 屏幕适配工具 ====================
export class AdaptiveUtils {
  // 设备信息
  static deviceType: DeviceType = DeviceType.PHONE;
  static screenWidth: number = 360;
  static screenHeight: number = 640;
  static aspectRatio: number = 0.5625; // 宽高比 (9:16)
  
  // 初始化 - 必须在页面aboutToAppear中调用
  static init(width: number, height: number): void {
    AdaptiveUtils.screenWidth = width;
    AdaptiveUtils.screenHeight = height;
    AdaptiveUtils.aspectRatio = width / height;
    
    // 判断设备类型
    // 手表：小屏幕或接近正方形
    if (width < 200 || (width < 280 && height < 280)) {
      AdaptiveUtils.deviceType = DeviceType.WATCH;
    } else if (width > 600) {
      AdaptiveUtils.deviceType = DeviceType.TABLET;
    } else {
      AdaptiveUtils.deviceType = DeviceType.PHONE;
    }
    
    console.log(`[AdaptiveUtils] 设备初始化: ${width}x${height}, 类型=${AdaptiveUtils.deviceType}, 宽高比=${AdaptiveUtils.aspectRatio.toFixed(2)}`);
  }
  
  // ==================== 基础尺寸获取 ====================
  
  // 宽度百分比
  static widthPercent(percent: number): number {
    return Math.round(AdaptiveUtils.screenWidth * percent / 100);
  }
  
  // 高度百分比
  static heightPercent(percent: number): number {
    return Math.round(AdaptiveUtils.screenHeight * percent / 100);
  }
  
  // 屏幕较小边（适合正方形/圆形元素）
  static minDimension(): number {
    return Math.min(AdaptiveUtils.screenWidth, AdaptiveUtils.screenHeight);
  }
  
  // 屏幕较大边
  static maxDimension(): number {
    return Math.max(AdaptiveUtils.screenWidth, AdaptiveUtils.screenHeight);
  }
  
  // ==================== 设备类型判断 ====================
  
  static isWatch(): boolean {
    return AdaptiveUtils.deviceType === DeviceType.WATCH;
  }
  
  static isTablet(): boolean {
    return AdaptiveUtils.deviceType === DeviceType.TABLET;
  }
  
  static isPhone(): boolean {
    return AdaptiveUtils.deviceType === DeviceType.PHONE;
  }
  
  // ==================== 内容区域 ====================
  
  // 内容区域宽度 - 根据设备类型
  static contentWidth(): number {
    if (AdaptiveUtils.isWatch()) {
      return AdaptiveUtils.widthPercent(90);
    } else if (AdaptiveUtils.isTablet()) {
      // 平板上内容区域限制宽度，避免过宽
      return Math.min(AdaptiveUtils.widthPercent(55), 400);
    }
    return AdaptiveUtils.widthPercent(90);
  }
  
  // 内容区域高度 - 可用高度（减去状态栏等）
  static contentHeight(): number {
    if (AdaptiveUtils.isWatch()) {
      return AdaptiveUtils.heightPercent(85);
    }
    return AdaptiveUtils.heightPercent(90);
  }
  
  // ==================== 字体大小 ====================
  
  // 字体大小 - 基于屏幕宽度，但有合理范围
  static fontSize(baseSize: number): number {
    // 基准：360px宽度时使用baseSize
    // 平板上最大放大1.3倍，手表上缩小
    let scale = AdaptiveUtils.screenWidth / 360;
    
    if (AdaptiveUtils.isWatch()) {
      scale = Math.min(scale, 0.85); // 手表上稍小
    } else if (AdaptiveUtils.isTablet()) {
      scale = Math.min(scale, 1.3); // 平板上限制放大
    } else {
      scale = Math.min(scale, 1.2); // 手机上限制放大
    }
    
    return Math.round(baseSize * scale);
  }
  
  // ==================== 间距 ====================
  
  // 间距 - 基于屏幕高度比例
  static spacing(baseSpacing: number): number {
    // 基准：640px高度时使用baseSpacing
    let scale = AdaptiveUtils.screenHeight / 640;
    
    if (AdaptiveUtils.isWatch()) {
      scale = Math.min(scale, 0.7); // 手表上紧凑
    } else if (AdaptiveUtils.isTablet()) {
      scale = Math.min(scale, 1.5); // 平板上宽松
    } else {
      scale = Math.min(scale, 1.3);
    }
    
    return Math.round(baseSpacing * scale);
  }
  
  // ==================== 主要元素尺寸 ====================
  
  // 宠物大小 - 基于屏幕高度比例
  static getPetSize(): number {
    if (AdaptiveUtils.isWatch()) {
      // 手表：占屏幕高度的25%
      return AdaptiveUtils.heightPercent(25);
    } else if (AdaptiveUtils.isTablet()) {
      // 平板：占屏幕高度的28%，但限制最大值
      return Math.min(AdaptiveUtils.heightPercent(28), 280);
    }
    // 手机：占屏幕高度的22%
    return AdaptiveUtils.heightPercent(22);
  }
  
  // 按钮大小 - 基于屏幕较小边
  static getButtonSize(): number {
    if (AdaptiveUtils.isWatch()) {
      return AdaptiveUtils.minDimension() * 0.18;
    } else if (AdaptiveUtils.isTablet()) {
      // 平板上按钮保持适中大小，不要太大
      return Math.min(AdaptiveUtils.minDimension() * 0.06, 50);
    }
    return AdaptiveUtils.minDimension() * 0.12;
  }
  
  // 图标大小
  static getIconSize(): number {
    if (AdaptiveUtils.isWatch()) {
      return AdaptiveUtils.minDimension() * 0.08;
    }
    return AdaptiveUtils.fontSize(24);
  }
  
  // ==================== 弹窗尺寸 ====================
  
  // 弹窗宽度
  static popupWidth(): number {
    if (AdaptiveUtils.isWatch()) {
      return AdaptiveUtils.widthPercent(95);
    } else if (AdaptiveUtils.isTablet()) {
      return Math.min(AdaptiveUtils.widthPercent(60), 450);
    }
    return AdaptiveUtils.widthPercent(85);
  }
  
  // 弹窗高度
  static popupHeight(baseRatio: number = 0.6): number {
    if (AdaptiveUtils.isWatch()) {
      return AdaptiveUtils.heightPercent(80);
    } else if (AdaptiveUtils.isTablet()) {
      return Math.min(AdaptiveUtils.heightPercent(70), 500);
    }
    return AdaptiveUtils.heightPercent(65);
  }
  
  // ==================== 兼容旧API ====================
  
  // 保留旧方法以兼容现有代码，但内部使用新逻辑
  static scale(value: number): number {
    // 根据值的大小判断是宽度相关还是通用尺寸
    if (value > 200) {
      // 大值（如弹窗宽度）使用内容宽度比例
      return Math.min(value * AdaptiveUtils.screenWidth / 360, AdaptiveUtils.contentWidth());
    }
    // 小值使用字体缩放逻辑
    return AdaptiveUtils.fontSize(value);
  }
  
  static scaleH(value: number): number {
    // 高度相关值
    return AdaptiveUtils.spacing(value);
  }
  
  static getScale(): number {
    return AdaptiveUtils.screenWidth / 360;
  }
  
  // ==================== 布局辅助 ====================
  
  // 获取主游戏页面各区域高度分配
  static getMainPageLayout(): MainPageLayout {
    const totalHeight = AdaptiveUtils.contentHeight();
    
    if (AdaptiveUtils.isWatch()) {
      // 手表：紧凑布局
      const layout: MainPageLayout = {
        topPadding: AdaptiveUtils.heightPercent(2),
        valuePanelHeight: AdaptiveUtils.heightPercent(15),
        growthHeight: AdaptiveUtils.heightPercent(8),
        petAreaHeight: AdaptiveUtils.heightPercent(40),
        buttonBarHeight: AdaptiveUtils.heightPercent(20),
        bottomPadding: AdaptiveUtils.heightPercent(2)
      };
      return layout;
    } else if (AdaptiveUtils.isTablet()) {
      // 平板：宽松布局
      const layout: MainPageLayout = {
        topPadding: AdaptiveUtils.heightPercent(3),
        valuePanelHeight: AdaptiveUtils.heightPercent(12),
        growthHeight: AdaptiveUtils.heightPercent(6),
        petAreaHeight: AdaptiveUtils.heightPercent(45),
        buttonBarHeight: AdaptiveUtils.heightPercent(15),
        bottomPadding: AdaptiveUtils.heightPercent(3)
      };
      return layout;
    }
    // 手机：标准布局
    const layout: MainPageLayout = {
      topPadding: AdaptiveUtils.heightPercent(2),
      valuePanelHeight: AdaptiveUtils.heightPercent(12),
      growthHeight: AdaptiveUtils.heightPercent(7),
      petAreaHeight: AdaptiveUtils.heightPercent(42),
      buttonBarHeight: AdaptiveUtils.heightPercent(18),
      bottomPadding: AdaptiveUtils.heightPercent(2)
    };
    return layout;
  }
}

// ==================== 颜色工具 ====================
export class ColorUtils {
  static readonly PRIMARY: string = '#FF6B9D';
  static readonly SECONDARY: string = '#87CEEB';
  static readonly ACCENT: string = '#FFD700';
  static readonly BG_LIGHT: string = '#FFF5F8';
  // 主游戏背景渐变 - 柔和紫色系（向起始页面风格靠拢）
  static readonly BG_GRADIENT_START: string = '#B8B8E8';  // 柔和蓝紫
  static readonly BG_GRADIENT_END: string = '#D8A8D8';    // 柔和紫粉
  
  static readonly OCTO_COLOR: string = '#FF8C69';
  static readonly OCTO_COLOR_LIGHT: string = '#FFB8A3';
  static readonly SERP_COLOR: string = '#98D8C8';
  static readonly SERP_COLOR_LIGHT: string = '#B8E8DC';
  static readonly ROBIN_COLOR: string = '#87CEEB';
  static readonly ROBIN_COLOR_LIGHT: string = '#B0E0E6';
  
  static readonly EGG_OCTO: string = '#FFB6C1';
  static readonly EGG_SERP: string = '#98FB98';
  static readonly EGG_ROBIN: string = '#87CEEB';
  
  static readonly HUNGER_COLOR: string = '#FFA500';
  static readonly HAPPY_COLOR: string = '#FF69B4';
  static readonly COIN_COLOR: string = '#FFD700';
  
  static gradientColors(startColor: string, endColor: string, steps: number): string[] {
    const colors: string[] = [];
    const start = ColorUtils.hexToRgb(startColor);
    const end = ColorUtils.hexToRgb(endColor);
    
    for (let i = 0; i < steps; i++) {
      const ratio = i / (steps - 1);
      const r = Math.round(start.r + (end.r - start.r) * ratio);
      const g = Math.round(start.g + (end.g - start.g) * ratio);
      const b = Math.round(start.b + (end.b - start.b) * ratio);
      colors.push(ColorUtils.rgbToHex(r, g, b));
    }
    return colors;
  }
  
  static hexToRgb(hex: string): RgbColor {
    const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    if (result) {
      const rgb: RgbColor = {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
      };
      return rgb;
    }
    const defaultRgb: RgbColor = { r: 0, g: 0, b: 0 };
    return defaultRgb;
  }
  
  static rgbToHex(r: number, g: number, b: number): string {
    const toHex = (x: number): string => {
      const hex = x.toString(16);
      return hex.length === 1 ? '0' + hex : hex;
    };
    return '#' + toHex(r) + toHex(g) + toHex(b);
  }
}

// ==================== 绘制路径工具 ====================
export class PathUtils {
  static circle(cx: number, cy: number, r: number): string {
    return `M ${cx - r} ${cy} A ${r} ${r} 0 1 0 ${cx + r} ${cy} A ${r} ${r} 0 1 0 ${cx - r} ${cy} Z`;
  }
  
  static ellipse(cx: number, cy: number, rx: number, ry: number): string {
    return `M ${cx - rx} ${cy} A ${rx} ${ry} 0 1 0 ${cx + rx} ${cy} A ${rx} ${ry} 0 1 0 ${cx - rx} ${cy} Z`;
  }
  
  static roundRect(x: number, y: number, w: number, h: number, r: number): string {
    return `M ${x + r} ${y} L ${x + w - r} ${y} Q ${x + w} ${y} ${x + w} ${y + r} ` +
           `L ${x + w} ${y + h - r} Q ${x + w} ${y + h} ${x + w - r} ${y + h} ` +
           `L ${x + r} ${y + h} Q ${x} ${y + h} ${x} ${y + h - r} ` +
           `L ${x} ${y + r} Q ${x} ${y} ${x + r} ${y} Z`;
  }
  
  static heart(cx: number, cy: number, size: number): string {
    const s = size;
    return `M ${cx} ${cy + s * 0.3} ` +
           `C ${cx} ${cy + s * 0.1} ${cx - s * 0.5} ${cy - s * 0.4} ${cx - s * 0.5} ${cy - s * 0.1} ` +
           `C ${cx - s * 0.5} ${cy - s * 0.5} ${cx} ${cy - s * 0.5} ${cx} ${cy - s * 0.2} ` +
           `C ${cx} ${cy - s * 0.5} ${cx + s * 0.5} ${cy - s * 0.5} ${cx + s * 0.5} ${cy - s * 0.1} ` +
           `C ${cx + s * 0.5} ${cy - s * 0.4} ${cx} ${cy + s * 0.1} ${cx} ${cy + s * 0.3} Z`;
  }
  
  static star(cx: number, cy: number, outerR: number, innerR: number, points: number): string {
    let path = '';
    const angleStep = Math.PI / points;
    for (let i = 0; i < points * 2; i++) {
      const r = i % 2 === 0 ? outerR : innerR;
      const angle = i * angleStep - Math.PI / 2;
      const x = cx + r * Math.cos(angle);
      const y = cy + r * Math.sin(angle);
      path += i === 0 ? `M ${x} ${y} ` : `L ${x} ${y} `;
    }
    return path + 'Z';
  }
  
  static wave(y: number, w: number, amplitude: number, frequency: number): string {
    let path = `M 0 ${y}`;
    for (let x = 0; x <= w; x += 5) {
      const yOffset = Math.sin(x * frequency) * amplitude;
      path += ` L ${x} ${y + yOffset}`;
    }
    return path;
  }
}

// ==================== 动画缓动函数 ====================
export class Easing {
  static linear(t: number): number {
    return t;
  }
  
  static easeIn(t: number): number {
    return t * t;
  }
  
  static easeOut(t: number): number {
    return t * (2 - t);
  }
  
  static easeInOut(t: number): number {
    return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
  }
  
  static bounce(t: number): number {
    if (t < 1 / 2.75) {
      return 7.5625 * t * t;
    } else if (t < 2 / 2.75) {
      const t1 = t - 1.5 / 2.75;
      return 7.5625 * t1 * t1 + 0.75;
    } else if (t < 2.5 / 2.75) {
      const t2 = t - 2.25 / 2.75;
      return 7.5625 * t2 * t2 + 0.9375;
    } else {
      const t3 = t - 2.625 / 2.75;
      return 7.5625 * t3 * t3 + 0.984375;
    }
  }
}
