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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { distributedDeviceManager } from '@kit.DistributedServiceKit';
import { Want } from '@kit.AbilityKit';

const DOMAIN = 0xFF00;
const TAG = 'DistributedStateManager';

/**
 * 播放状态数据接口
 * 用于跨设备同步
 */
export interface PlayStateData {
  // 播放进度
  currentTime: number;
  durationTime: number;
  
  // 播放状态
  isPlaying: boolean;
  playSpeed: number;
  
  // 视频索引
  videoIndex: number;
  
  // 音量
  volume: number;
  
  // 弹幕设置
  isDanmakuEnabled: boolean;
  danmakuOpacity: number;
  danmakuFontSize: number;
  danmakuSpeed: number;
  
  // 时间戳（用于同步）
  timestamp: number;
}

/**
 * 设备状态变化数据
 */
interface DeviceStateChangeData {
  action: distributedDeviceManager.DeviceStateChange;
  device: distributedDeviceManager.DeviceBasicInfo;
}

/**
 * 设备发现数据
 */
interface DeviceDiscoverData {
  device: distributedDeviceManager.DeviceBasicInfo;
}

/**
 * 分布式状态管理器
 * 实现跨设备状态同步和应用接续
 */
export class DistributedStateManager {
  private static instance: DistributedStateManager;
  
  // 设备管理器
  private deviceManager: distributedDeviceManager.DeviceManager | null = null;
  
  // 当前播放状态
  private currentPlayState: PlayStateData | null = null;
  
  // 状态变化回调
  private stateChangeCallbacks: ((state: PlayStateData) => void)[] = [];
  
  // 设备连接状态回调
  private deviceConnectCallbacks: ((isConnected: boolean) => void)[] = [];
  
  // 是否已初始化
  private isInitialized: boolean = false;
  
  // 状态同步定时器
  private stateSyncTimerId: number = -1;
  
  // 是否启用自动同步
  private isAutoSyncEnabled: boolean = false;
  
  private constructor() {}
  
  /**
   * 获取单例实例
   */
  static getInstance(): DistributedStateManager {
    if (!DistributedStateManager.instance) {
      DistributedStateManager.instance = new DistributedStateManager();
    }
    return DistributedStateManager.instance;
  }
  
  /**
   * 初始化分布式能力
   */
  async initialize(context: Context): Promise<void> {
    if (this.isInitialized) {
      return;
    }
    
    try {
      // 创建设备管理器
      const deviceManager = distributedDeviceManager.createDeviceManager('VideoPlayer');
      this.deviceManager = deviceManager;
      
      // 注册设备状态监听
      deviceManager.on('deviceStateChange', (data: DeviceStateChangeData) => {
        hilog.info(DOMAIN, TAG, `Device state changed: ${data.device.deviceName}, action: ${data.action}`);
        this.handleDeviceStateChange(data);
      });
      
      // 注册设备发现监听
      deviceManager.on('discoverSuccess', (data: DeviceDiscoverData) => {
        hilog.info(DOMAIN, TAG, `Device found: ${data.device.deviceName}`);
      });
      
      this.isInitialized = true;
      hilog.info(DOMAIN, TAG, 'Distributed state manager initialized');
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Failed to initialize: ${error}`);
    }
  }
  
  /**
   * 处理设备状态变化
   */
  private handleDeviceStateChange(data: DeviceStateChangeData): void {
    // 设备可用（上线）
    if (data.action === distributedDeviceManager.DeviceStateChange.AVAILABLE) {
      hilog.info(DOMAIN, TAG, `Device available: ${data.device.deviceName}`);
      this.notifyDeviceConnect(true);
    }
    // 设备不可用（离线）
    else if (data.action === distributedDeviceManager.DeviceStateChange.UNAVAILABLE) {
      hilog.info(DOMAIN, TAG, `Device unavailable: ${data.device.deviceName}`);
      this.notifyDeviceConnect(false);
    }
  }
  
  /**
   * 保存当前播放状态
   */
  savePlayState(state: PlayStateData): void {
    this.currentPlayState = {
      currentTime: state.currentTime,
      durationTime: state.durationTime,
      isPlaying: state.isPlaying,
      playSpeed: state.playSpeed,
      videoIndex: state.videoIndex,
      volume: state.volume,
      isDanmakuEnabled: state.isDanmakuEnabled,
      danmakuOpacity: state.danmakuOpacity,
      danmakuFontSize: state.danmakuFontSize,
      danmakuSpeed: state.danmakuSpeed,
      timestamp: Date.now()
    };
    
    hilog.info(DOMAIN, TAG, `Play state saved: time=${state.currentTime}, playing=${state.isPlaying}`);
  }
  
  /**
   * 获取当前播放状态
   */
  getPlayState(): PlayStateData | null {
    return this.currentPlayState;
  }
  
  /**
   * 清除播放状态
   */
  clearPlayState(): void {
    this.currentPlayState = null;
    hilog.info(DOMAIN, TAG, 'Play state cleared');
  }
  
  /**
   * 序列化播放状态为JSON字符串
   * 用于应用接续
   */
  serializePlayState(): string {
    if (!this.currentPlayState) {
      return '';
    }
    
    try {
      return JSON.stringify(this.currentPlayState);
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Failed to serialize: ${error}`);
      return '';
    }
  }
  
  /**
   * 反序列化播放状态
   * 用于应用接续恢复
   */
  deserializePlayState(jsonStr: string): PlayStateData | null {
    if (!jsonStr) {
      return null;
    }
    
    try {
      const state = JSON.parse(jsonStr) as PlayStateData;
      return state;
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Failed to deserialize: ${error}`);
      return null;
    }
  }
  
  /**
   * 注册状态变化监听
   */
  onStateChange(callback: (state: PlayStateData) => void): void {
    this.stateChangeCallbacks.push(callback);
  }
  
  /**
   * 取消状态变化监听
   */
  offStateChange(callback: (state: PlayStateData) => void): void {
    const index = this.stateChangeCallbacks.indexOf(callback);
    if (index > -1) {
      this.stateChangeCallbacks.splice(index, 1);
    }
  }
  
  /**
   * 注册设备连接状态监听
   */
  onDeviceConnect(callback: (isConnected: boolean) => void): void {
    this.deviceConnectCallbacks.push(callback);
  }
  
  /**
   * 取消设备连接状态监听
   */
  offDeviceConnect(callback: (isConnected: boolean) => void): void {
    const index = this.deviceConnectCallbacks.indexOf(callback);
    if (index > -1) {
      this.deviceConnectCallbacks.splice(index, 1);
    }
  }
  
  /**
   * 通知状态变化
   */
  private notifyStateChange(state: PlayStateData): void {
    this.stateChangeCallbacks.forEach(callback => {
      callback(state);
    });
  }
  
  /**
   * 通知设备连接状态
   */
  private notifyDeviceConnect(isConnected: boolean): void {
    this.deviceConnectCallbacks.forEach(callback => {
      callback(isConnected);
    });
  }
  
  /**
   * 获取可用设备列表
   */
  getAvailableDeviceList(): distributedDeviceManager.DeviceBasicInfo[] {
    if (!this.deviceManager) {
      return [];
    }
    
    try {
      return this.deviceManager.getAvailableDeviceListSync();
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Failed to get available devices: ${error}`);
      return [];
    }
  }
  
  /**
   * 获取本地设备ID
   */
  getLocalDeviceId(): string {
    if (!this.deviceManager) {
      return '';
    }
    
    try {
      return this.deviceManager.getLocalDeviceId();
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Failed to get local device id: ${error}`);
      return '';
    }
  }
  
  /**
   * 销毁资源
   */
  destroy(): void {
    if (this.deviceManager) {
      this.deviceManager.off('deviceStateChange');
      this.deviceManager.off('discoverSuccess');
      this.deviceManager = null;
    }
    
    // 停止自动同步
    this.stopAutoSync();
    
    this.stateChangeCallbacks = [];
    this.deviceConnectCallbacks = [];
    this.currentPlayState = null;
    this.isInitialized = false;
    
    hilog.info(DOMAIN, TAG, 'Distributed state manager destroyed');
  }
  
  /**
   * 启动自动状态同步
   */
  startAutoSync(interval: number = 3000): void {
    if (this.isAutoSyncEnabled) {
      return;
    }
    
    this.isAutoSyncEnabled = true;
    this.stateSyncTimerId = setInterval(() => {
      this.syncStateToDevices();
    }, interval);
    
    hilog.info(DOMAIN, TAG, `Auto sync started, interval: ${interval}ms`);
  }
  
  /**
   * 停止自动状态同步
   */
  stopAutoSync(): void {
    if (this.stateSyncTimerId !== -1) {
      clearInterval(this.stateSyncTimerId);
      this.stateSyncTimerId = -1;
    }
    this.isAutoSyncEnabled = false;
    
    hilog.info(DOMAIN, TAG, 'Auto sync stopped');
  }
  
  /**
   * 同步状态到设备
   */
  private syncStateToDevices(): void {
    if (!this.currentPlayState) {
      return;
    }
    
    // 通知所有监听者状态已更新
    this.notifyStateChange(this.currentPlayState);
  }
  
  /**
   * 检查是否有可用设备
   */
  hasAvailableDevices(): boolean {
    const devices = this.getAvailableDeviceList();
    return devices.length > 0;
  }
}
