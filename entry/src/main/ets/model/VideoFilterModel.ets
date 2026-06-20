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

/**
 * Video Filter Types
 */
export enum VideoFilterType {
  NONE = 'none',           // No filter
  GRAYSCALE = 'grayscale', // Black and white
  SEPIA = 'sepia',         // Vintage/sepia
  VINTAGE = 'vintage',     // Retro film
  WARM = 'warm',           // Warm tones
  COOL = 'cool',           // Cool tones
  CONTRAST = 'contrast',   // High contrast
  BRIGHTNESS = 'brightness', // High brightness
  SATURATE = 'saturate',   // High saturation
  DESATURATE = 'desaturate', // Low saturation
  INVERT = 'invert',       // Color invert
  VIGNETTE = 'vignette',   // Vignette effect
  SHARPEN = 'sharpen',     // Sharpen
  BLUR = 'blur',           // Blur
  POSTERIZE = 'posterize', // Posterize
  EMBOSS = 'emboss',       // Emboss
  SKETCH = 'sketch',       // Sketch effect
  OIL_PAINT = 'oil_paint', // Oil paint effect
  CROSS_PROCESS = 'cross_process' // Cross process
}

/**
 * Filter Display Information
 */
export class FilterInfo {
  type: VideoFilterType;
  name: string;
  description: string;
  icon: string;

  constructor(type: VideoFilterType, name: string, description: string, icon: string) {
    this.type = type;
    this.name = name;
    this.description = description;
    this.icon = icon;
  }
}

/**
 * Filter Configuration
 */
export class FilterConfig {
  // Color matrix parameters (4x5 matrix for color transformation)
  colorMatrix: number[] = [
    1, 0, 0, 0, 0,  // Red
    0, 1, 0, 0, 0,  // Green
    0, 0, 1, 0, 0,  // Blue
    0, 0, 0, 1, 0   // Alpha
  ];
  
  // Additional effect parameters
  brightness: number = 1.0;    // 0.0 - 2.0
  contrast: number = 1.0;      // 0.0 - 2.0
  saturation: number = 1.0;    // 0.0 - 2.0
  hue: number = 0;             // -180 - 180
  
  constructor(matrix?: number[]) {
    if (matrix && matrix.length === 20) {
      this.colorMatrix = matrix;
    }
  }
}

/**
 * Video Filter Manager
 */
export class VideoFilterManager {
  private static instance: VideoFilterManager;
  private currentFilter: VideoFilterType = VideoFilterType.NONE;
  private filterConfigs: Map<VideoFilterType, FilterConfig> = new Map();

  private constructor() {
    this.initializeFilters();
  }

  static getInstance(): VideoFilterManager {
    if (!VideoFilterManager.instance) {
      VideoFilterManager.instance = new VideoFilterManager();
    }
    return VideoFilterManager.instance;
  }

  /**
   * Initialize all filter configurations
   */
  private initializeFilters(): void {
    // None - Original
    this.filterConfigs.set(VideoFilterType.NONE, new FilterConfig([
      1, 0, 0, 0, 0,
      0, 1, 0, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 0, 1, 0
    ]));

    // Grayscale - Black and white
    this.filterConfigs.set(VideoFilterType.GRAYSCALE, new FilterConfig([
      0.299, 0.587, 0.114, 0, 0,
      0.299, 0.587, 0.114, 0, 0,
      0.299, 0.587, 0.114, 0, 0,
      0, 0, 0, 1, 0
    ]));

    // Sepia - Vintage brown tones
    this.filterConfigs.set(VideoFilterType.SEPIA, new FilterConfig([
      0.393, 0.769, 0.189, 0, 0,
      0.349, 0.686, 0.168, 0, 0,
      0.272, 0.534, 0.131, 0, 0,
      0, 0, 0, 1, 0
    ]));

    // Vintage - Retro film effect
    this.filterConfigs.set(VideoFilterType.VINTAGE, new FilterConfig([
      0.6, 0.3, 0.1, 0, 20,
      0.2, 0.5, 0.1, 0, 10,
      0.1, 0.2, 0.4, 0, 0,
      0, 0, 0, 1, 0
    ]));

    // Warm - Warm color tones
    this.filterConfigs.set(VideoFilterType.WARM, new FilterConfig([
      1.2, 0.1, 0, 0, 10,
      0.1, 1.0, 0, 0, 5,
      0, 0, 0.8, 0, 0,
      0, 0, 0, 1, 0
    ]));

    // Cool - Cool color tones
    this.filterConfigs.set(VideoFilterType.COOL, new FilterConfig([
      0.8, 0, 0.1, 0, 0,
      0, 1.0, 0.1, 0, 5,
      0.1, 0.1, 1.2, 0, 10,
      0, 0, 0, 1, 0
    ]));

    // Contrast - High contrast
    this.filterConfigs.set(VideoFilterType.CONTRAST, new FilterConfig([
      1.5, 0, 0, 0, -25,
      0, 1.5, 0, 0, -25,
      0, 0, 1.5, 0, -25,
      0, 0, 0, 1, 0
    ]));

    // Brightness - High brightness
    this.filterConfigs.set(VideoFilterType.BRIGHTNESS, new FilterConfig([
      1.2, 0, 0, 0, 30,
      0, 1.2, 0, 0, 30,
      0, 0, 1.2, 0, 30,
      0, 0, 0, 1, 0
    ]));

    // Saturate - High saturation
    this.filterConfigs.set(VideoFilterType.SATURATE, new FilterConfig([
      1.5, -0.2, -0.2, 0, 0,
      -0.2, 1.5, -0.2, 0, 0,
      -0.2, -0.2, 1.5, 0, 0,
      0, 0, 0, 1, 0
    ]));

    // Desaturate - Low saturation
    this.filterConfigs.set(VideoFilterType.DESATURATE, new FilterConfig([
      0.7, 0.1, 0.1, 0, 0,
      0.1, 0.7, 0.1, 0, 0,
      0.1, 0.1, 0.7, 0, 0,
      0, 0, 0, 1, 0
    ]));

    // Invert - Color invert
    this.filterConfigs.set(VideoFilterType.INVERT, new FilterConfig([
      -1, 0, 0, 0, 255,
      0, -1, 0, 0, 255,
      0, 0, -1, 0, 255,
      0, 0, 0, 1, 0
    ]));

    // Vignette - Dark edges
    this.filterConfigs.set(VideoFilterType.VIGNETTE, new FilterConfig([
      0.8, 0, 0, 0, -20,
      0, 0.8, 0, 0, -20,
      0, 0, 0.8, 0, -20,
      0, 0, 0, 1, 0
    ]));

    // Sharpen - Sharpen effect
    this.filterConfigs.set(VideoFilterType.SHARPEN, new FilterConfig([
      1.5, -0.25, -0.25, 0, 0,
      -0.25, 1.5, -0.25, 0, 0,
      -0.25, -0.25, 1.5, 0, 0,
      0, 0, 0, 1, 0
    ]));

    // Blur - Soft blur
    this.filterConfigs.set(VideoFilterType.BLUR, new FilterConfig([
      0.8, 0.1, 0.1, 0, 0,
      0.1, 0.8, 0.1, 0, 0,
      0.1, 0.1, 0.8, 0, 0,
      0, 0, 0, 1, 0
    ]));

    // Posterize - Reduce color levels
    this.filterConfigs.set(VideoFilterType.POSTERIZE, new FilterConfig([
      0.5, 0, 0, 0, 64,
      0, 0.5, 0, 0, 64,
      0, 0, 0.5, 0, 64,
      0, 0, 0, 1, 0
    ]));

    // Emboss - 3D emboss effect
    this.filterConfigs.set(VideoFilterType.EMBOSS, new FilterConfig([
      2, -1, 0, 0, 128,
      -1, 1, 0, 0, 128,
      0, 0, 1, 0, 128,
      0, 0, 0, 1, 0
    ]));

    // Sketch - Pencil sketch effect
    this.filterConfigs.set(VideoFilterType.SKETCH, new FilterConfig([
      0.3, 0.6, 0.1, 0, 0,
      0.3, 0.6, 0.1, 0, 0,
      0.3, 0.6, 0.1, 0, 0,
      0, 0, 0, 1, 0
    ]));

    // Oil Paint - Oil painting effect
    this.filterConfigs.set(VideoFilterType.OIL_PAINT, new FilterConfig([
      0.9, 0.05, 0.05, 0, 0,
      0.05, 0.9, 0.05, 0, 0,
      0.05, 0.05, 0.9, 0, 0,
      0, 0, 0, 1, 0
    ]));

    // Cross Process - Cross processing effect
    this.filterConfigs.set(VideoFilterType.CROSS_PROCESS, new FilterConfig([
      1.2, 0.1, 0, 0, 10,
      0, 1.1, 0.1, 0, 5,
      0.1, 0, 1.3, 0, -10,
      0, 0, 0, 1, 0
    ]));
  }

  /**
   * Get current filter type
   */
  getCurrentFilter(): VideoFilterType {
    return this.currentFilter;
  }

  /**
   * Set current filter
   */
  setFilter(filterType: VideoFilterType): void {
    this.currentFilter = filterType;
  }

  /**
   * Get filter configuration
   */
  getFilterConfig(filterType: VideoFilterType): FilterConfig | undefined {
    return this.filterConfigs.get(filterType);
  }

  /**
   * Get all available filters
   */
  getAllFilters(): FilterInfo[] {
    return [
      new FilterInfo(VideoFilterType.NONE, '原图', '无滤镜', '🎨'),
      new FilterInfo(VideoFilterType.GRAYSCALE, '黑白', '经典黑白效果', '⚫'),
      new FilterInfo(VideoFilterType.SEPIA, '复古', '怀旧棕褐色', '📜'),
      new FilterInfo(VideoFilterType.VINTAGE, '老电影', '复古胶片感', '🎬'),
      new FilterInfo(VideoFilterType.WARM, '暖色调', '温暖阳光感', '☀️'),
      new FilterInfo(VideoFilterType.COOL, '冷色调', '清冷蓝色调', '❄️'),
      new FilterInfo(VideoFilterType.CONTRAST, '高对比', '强烈对比度', '⚡'),
      new FilterInfo(VideoFilterType.BRIGHTNESS, '明亮', '提高亮度', '💡'),
      new FilterInfo(VideoFilterType.SATURATE, '高饱和', '鲜艳色彩', '🌈'),
      new FilterInfo(VideoFilterType.DESATURATE, '低饱和', '柔和色彩', '🌫️'),
      new FilterInfo(VideoFilterType.INVERT, '反色', '颜色反转', '🔄'),
      new FilterInfo(VideoFilterType.VIGNETTE, '暗角', '边缘暗化', '🔲'),
      new FilterInfo(VideoFilterType.SHARPEN, '锐化', '增强细节', '🔪'),
      new FilterInfo(VideoFilterType.BLUR, '模糊', '柔和模糊', '💨'),
      new FilterInfo(VideoFilterType.POSTERIZE, '海报', '色块效果', '🖼️'),
      new FilterInfo(VideoFilterType.EMBOSS, '浮雕', '3D浮雕', '🗿'),
      new FilterInfo(VideoFilterType.SKETCH, '素描', '铅笔素描', '✏️'),
      new FilterInfo(VideoFilterType.OIL_PAINT, '油画', '油画质感', '🎭'),
      new FilterInfo(VideoFilterType.CROSS_PROCESS, '交叉冲印', '胶片冲印', '🎞️')
    ];
  }

  /**
   * Apply filter to pixel data (for future frame processing)
   */
  applyFilter(r: number, g: number, b: number, a: number): [number, number, number, number] {
    const config = this.getFilterConfig(this.currentFilter);
    if (!config) {
      return [r, g, b, a];
    }

    const matrix = config.colorMatrix;
    
    // Apply color matrix transformation
    const newR = Math.max(0, Math.min(255, 
      matrix[0] * r + matrix[1] * g + matrix[2] * b + matrix[3] * a + matrix[4]
    ));
    const newG = Math.max(0, Math.min(255, 
      matrix[5] * r + matrix[6] * g + matrix[7] * b + matrix[8] * a + matrix[9]
    ));
    const newB = Math.max(0, Math.min(255, 
      matrix[10] * r + matrix[11] * g + matrix[12] * b + matrix[13] * a + matrix[14]
    ));
    const newA = Math.max(0, Math.min(255, 
      matrix[15] * r + matrix[16] * g + matrix[17] * b + matrix[18] * a + matrix[19]
    ));

    return [newR, newG, newB, newA];
  }
}
