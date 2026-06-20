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
 * Danmaku position enum.
 */
export enum DanmakuPosition {
  TOP = 0,
  BOTTOM = 1,
  SCROLL = 2
}

/**
 * Danmaku type enum.
 */
export enum DanmakuType {
  NORMAL = 0,
  TOP = 1,
  BOTTOM = 2
}

/**
 * Danmaku data model.
 */
@Observed
export class DanmakuItem {
  // Unique identifier for the danmaku
  id: string = '';
  
  // Danmaku content text
  content: string = '';
  
  // Danmaku color in hex format (e.g., '#FFFFFF')
  color: string = '#FFFFFF';
  
  // Timestamp when the danmaku should appear (in milliseconds)
  timestamp: number = 0;
  
  // Danmaku type (normal, top, bottom)
  type: DanmakuType = DanmakuType.NORMAL;
  
  // Font size (in fp)
  fontSize: number = 14;
  
  // Display duration (in milliseconds)
  duration: number = 5000;
  
  // Current position for scrolling danmaku
  positionX: number = 0;
  
  // Speed of scrolling (pixels per second)
  speed: number = 300;
  
  // Estimated width based on content length and font size
  estimatedWidth: number = 0;
  
  // Screen width when danmaku was created (for positioning)
  screenWidth: number = 0;
  
  // Whether the danmaku is visible
  isVisible: boolean = true;
  
  // Creation time
  createdAt: number = Date.now();

  constructor(
    content: string,
    color: string = '#FFFFFF',
    timestamp: number = 0,
    type: DanmakuType = DanmakuType.NORMAL,
    fontSize: number = 14,
    duration: number = 5000,
    screenWidth: number = 0
  ) {
    this.id = `danmaku_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    this.content = content;
    this.color = color;
    this.timestamp = timestamp;
    this.type = type;
    this.fontSize = fontSize;
    this.duration = duration;
    this.screenWidth = screenWidth;
    
    // Estimate width based on content length and font size
    // Rough estimation: each character ~0.6 * fontSize in pixels
    this.estimatedWidth = content.length * fontSize * 0.6;
    
    // For scrolling danmaku, start from right side of screen
    if (type === DanmakuType.NORMAL && screenWidth > 0) {
      this.positionX = screenWidth; // Start from right edge
    }
  }

  /**
   * Creates a danmaku item with default values.
   */
  static createDefault(): DanmakuItem {
    return new DanmakuItem('', '#FFFFFF');
  }

  /**
   * Creates a danmaku item with random color.
   */
  static createWithRandomColor(content: string, timestamp: number = 0): DanmakuItem {
    const colors = [
      '#FF0000', // Red
      '#00FF00', // Green
      '#0000FF', // Blue
      '#FFFF00', // Yellow
      '#FF00FF', // Magenta
      '#00FFFF', // Cyan
      '#FFA500', // Orange
      '#FF69B4', // Pink
      '#8A2BE2', // BlueViolet
      '#00FF7F'  // SpringGreen
    ];
    const randomColor = colors[Math.floor(Math.random() * colors.length)];
    return new DanmakuItem(content, randomColor, timestamp);
  }
}

/**
 * Danmaku settings model.
 */
export class DanmakuSettings {
  // Whether danmaku is enabled
  enabled: boolean = true;
  
  // Default danmaku color
  defaultColor: string = '#FFFFFF';
  
  // Default font size (in fp)
  defaultFontSize: number = 14;
  
  // Default danmaku type
  defaultType: DanmakuType = DanmakuType.NORMAL;
  
  // Default display duration (in milliseconds)
  defaultDuration: number = 10000;
  
  // Opacity (0.0 - 1.0)
  opacity: number = 0.8;
  
  // Whether to show danmaku in fullscreen mode
  showInFullscreen: boolean = true;
  
  // Maximum number of danmaku displayed at the same time
  maxConcurrentDanmaku: number = 50;
  
  // Danmaku speed multiplier
  speedMultiplier: number = 1.0;

  constructor() {
    // Default constructor
  }

  /**
   * Creates default danmaku settings.
   */
  static createDefault(): DanmakuSettings {
    return new DanmakuSettings();
  }
}

/**
 * Danmaku color preset model.
 */
export class DanmakuColorPreset {
  // Color name
  name: string = '';
  
  // Color value in hex format
  value: string = '';
  
  // Whether this is a custom color
  isCustom: boolean = false;

  constructor(name: string, value: string, isCustom: boolean = false) {
    this.name = name;
    this.value = value;
    this.isCustom = isCustom;
  }

  /**
   * Get default color presets.
   */
  static getDefaultPresets(): DanmakuColorPreset[] {
    return [
      new DanmakuColorPreset('White', '#FFFFFF'),
      new DanmakuColorPreset('Red', '#FF0000'),
      new DanmakuColorPreset('Green', '#00FF00'),
      new DanmakuColorPreset('Blue', '#0000FF'),
      new DanmakuColorPreset('Yellow', '#FFFF00'),
      new DanmakuColorPreset('Magenta', '#FF00FF'),
      new DanmakuColorPreset('Cyan', '#00FFFF'),
      new DanmakuColorPreset('Orange', '#FFA500'),
      new DanmakuColorPreset('Pink', '#FF69B4'),
      new DanmakuColorPreset('Purple', '#8A2BE2'),
      new DanmakuColorPreset('Custom', '#FFFFFF', true)
    ];
  }
}