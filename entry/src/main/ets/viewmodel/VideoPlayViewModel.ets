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
import { window } from '@kit.ArkUI';
import { resourceManager } from '@kit.LocalizationKit';
import { PlayerState } from '../model/PlayerStateModel';
import { DanmakuItem, DanmakuType, DanmakuSettings, DanmakuColorPreset } from '../model/DanmakuModel';
import { CommentItem } from '../model/CommentModel';
import { CommonConstants as Const } from '../common/CommonConstants';
import { VideoFilterType, VideoFilterManager, FilterInfo } from '../model/VideoFilterModel';
import { PlayStateData } from '../common/DistributedStateManager';
import player from 'libplayer.so';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo as fs } from '@kit.CoreFileKit';

const DOMAIN = 0x0000;
const TAG = 'VideoPlayViewModel';

@Observed
export class VideoPlayViewModel {
  @Track chooseNumber: number = -1;
  @Track chooseSpeed: number = Const.VIDEO_DEFAULT_SPEED;
  @Track isUse: boolean = false;
  @Track isSpeedListVisible: boolean = false;
  @Track isSwitchEnable: boolean = true;
  @Track currentTime: number = 0;
  @Track durationTime: number = 0;
  @Track speedText: string | Resource = $r('app.string.Default_speed_text');
  @Track isSeek: boolean = false;
  @Track playState: PlayerState = PlayerState.IDLE;

  // Danmaku related states
  @Track danmakuList: DanmakuItem[] = [];
  @Track danmakuSettings: DanmakuSettings = new DanmakuSettings();
  @Track isDanmakuInputVisible: boolean = false;
  @Track currentDanmakuText: string = '';
  @Track selectedDanmakuColor: string = '#FFFFFF';
  @Track selectedDanmakuType: DanmakuType = DanmakuType.NORMAL;
  @Track isDanmakuEnabled: boolean = true;
  @Track colorPresets: DanmakuColorPreset[] = DanmakuColorPreset.getDefaultPresets();
  
  // Screen width for danmaku positioning
  @Track screenWidth: number = 0;
  
  // Comment related states
  @Track commentList: CommentItem[] = [];
  @Track isCommentVisible: boolean = false;
  @Track currentCommentText: string = '';
  
  // Filter related states
  @Track isFilterPanelVisible: boolean = false;
  @Track currentFilterType: VideoFilterType = VideoFilterType.NONE;
  @Track currentFilterName: string = '原图';
  private filterManager: VideoFilterManager = VideoFilterManager.getInstance();
  @Track allFilters: FilterInfo[] = [];

  public videoSources: resourceManager.RawFileDescriptor[] = [];
  public nativePlayerObj: bigint = BigInt(0);
  
  private timerId: number = -1;
  private hostContext: Context | undefined = undefined;
  private danmakuTimerId: number = -1;

  setUIContext(uiContext: UIContext): void {
    this.hostContext = uiContext.getHostContext();
  }

  async initialize(): Promise<void> {
    try {
      await this.setWindowProperties();
      this.registerEventListeners();
      this.startTimer();
      this.initializeDanmaku();
      this.initializeFilters();
    } catch (error) {
      hilog.error(DOMAIN, TAG, `initialize catch error, code: ${error.code}, message: ${error.message}`);
    }
  }

  async setWindowProperties(): Promise<void> {
    if (!this.hostContext) {
      return;
    }
    
    try {
      const topWindow = await window.getLastWindow(this.hostContext);
      await topWindow.setWindowSystemBarProperties({
        statusBarContentColor: '#FFFFFF'
      });
      
      await topWindow.setWindowKeepScreenOn(true);
      
      // Get screen width for danmaku positioning
      const windowProperties = await topWindow.getWindowProperties();
      this.screenWidth = windowProperties.windowRect.width;
      hilog.info(DOMAIN, TAG, `Screen width: ${this.screenWidth}px`);
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Failed to set window properties. Cause: ${error.code}, message: ${error.message}`);
    }
  }

  registerEventListeners(): void {
    if (!this.hostContext) {
      return;
    }
    
    this.hostContext.eventHub.on('onBackground', () => this.onBackground());
    this.hostContext.eventHub.on('onForeground', () => this.onForeground());
  }

  unregisterEventListeners(): void {
    if (!this.hostContext) {
      return;
    }
    
    this.hostContext.eventHub.off('onBackground');
    this.hostContext.eventHub.off('onForeground');
  }

  startTimer(): void {
    this.stopTimer();
    this.timerId = setInterval(() => {
      if (this.nativePlayerObj === BigInt(0)) {
        return;
      }
      if (!this.isSeek) {
        try {
          const renderTime = player.getRenderTime(this.nativePlayerObj);
          this.currentTime = renderTime / Const.TIME_RATIO;
        } catch (error) {
          hilog.error(DOMAIN, TAG, `getRenderTime failed: ${error.code}, message: ${error.message}`);
        }
      }
    }, Const.TIME_INTERVAL);
  }

  stopTimer(): void {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
  }

  onBackground(): void {
    if (this.nativePlayerObj !== BigInt(0)) {
      player.pause(this.nativePlayerObj);
    }
  }

  onForeground(): void {
    if (this.playState === PlayerState.PLAYING) {
      if (this.nativePlayerObj !== BigInt(0)) {
        player.resume(this.nativePlayerObj);
      }
    }
  }

  togglePlayPause(playState: PlayerState): PlayerState {
    if (this.nativePlayerObj === BigInt(0)) {
      return playState;
    }
    
    if (playState === PlayerState.PLAYING) {
      player.pause(this.nativePlayerObj);
      return PlayerState.PAUSE;
    } else if (playState === PlayerState.PAUSE) {
      player.resume(this.nativePlayerObj);
      return PlayerState.PLAYING;
    }
    return playState;
  }

  onSliderChange(value: number, mode: SliderChangeMode): void {
    this.currentTime = value;
    
    if (this.durationTime > 0) {
      if (mode === SliderChangeMode.Begin) {
        this.isSeek = true;
      }
      
      if (mode === SliderChangeMode.End) {
        this.performSeek(value);
      }
    }
  }

  async performSeek(value: number): Promise<void> {
    if (this.nativePlayerObj === BigInt(0)) {
      return;
    }
    
    try {
      await player.seekVideo(this.nativePlayerObj, value);
      setTimeout(() => {
        this.isSeek = false;
      }, Const.RELOAD_TIME);
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Seek failed: ${error.code}, message: ${error.message}`);
    }
  }

  toggleSpeedList(): void {
    this.isSpeedListVisible = true;
  }

  hideSpeedList(): void {
    if (this.isSpeedListVisible) {
      this.isSpeedListVisible = false;
    }
  }

  onSpeedSelected(speed: number, index: number): void {
    if (this.chooseSpeed !== speed) {
      this.chooseSpeed = speed;
      if (this.nativePlayerObj !== BigInt(0)) {
        player.setSpeed(this.nativePlayerObj, speed);
      }
      this.speedText = Const.VIDEO_SPEED_TEXT_ARR[index];
      this.isSpeedListVisible = false;
    }
  }

  async onVideoSelected(index: number, rawDes: resourceManager.RawFileDescriptor): Promise<PlayerState | null> {
    if (this.chooseNumber === index) {
      return null;
    }
    
    this.isSwitchEnable = false;
    this.durationTime = 0;
    this.chooseNumber = index;
    this.isUse = false;
    this.chooseSpeed = Const.VIDEO_DEFAULT_SPEED;
    this.speedText = $r('app.string.Default_speed_text');
    
    if (!rawDes) {
      hilog.error(DOMAIN, TAG, 'player inputFile is null');
      this.isSwitchEnable = true;
      return null;
    }
    
    try {
      await this.releasePlayer();
      this.nativePlayerObj = player.createPlayer();
      const data = await player.init(this.nativePlayerObj, rawDes.fd, rawDes.offset, rawDes.length);
      this.isSeek = false;
      
      if (data.code === 0) {
        this.durationTime = data.durationTime / Const.TIME_RATIO;
        this.isUse = true;
        this.isSwitchEnable = true;
        
        player.play(this.nativePlayerObj);
        return PlayerState.PLAYING;
      } else {
        hilog.error(DOMAIN, TAG, 'player init failed, err code is ' + data.code);
        await this.releasePlayer();
      }
      
      this.isSwitchEnable = true;
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Switch video failed: ${error.code}, message: ${error.message}`);
      await this.releasePlayer();
      this.isSwitchEnable = true;
    }
    
    return null;
  }

  async releasePlayer(): Promise<void> {
    if (this.nativePlayerObj !== BigInt(0)) {
      try {
        player.releasePlayer(this.nativePlayerObj);
        this.nativePlayerObj = BigInt(0);
      } catch (error) {
        hilog.error(DOMAIN, TAG, `Release player failed: ${error.code}, message: ${error.message}`);
      }
    }
  }

  // Danmaku related methods
  toggleDanmakuInput(): void {
    hilog.info(DOMAIN, TAG, `Toggling danmaku input visibility. Current: ${this.isDanmakuInputVisible}, New: ${!this.isDanmakuInputVisible}`);
    this.isDanmakuInputVisible = !this.isDanmakuInputVisible;
  }

  hideDanmakuInput(): void {
    this.isDanmakuInputVisible = false;
  }

  updateDanmakuText(text: string): void {
    this.currentDanmakuText = text;
  }

  updateDanmakuColor(color: string): void {
    hilog.info(DOMAIN, TAG, `Updating danmaku color to: ${color}`);
    this.selectedDanmakuColor = color;
  }

  updateDanmakuType(type: DanmakuType): void {
    this.selectedDanmakuType = type;
  }

  toggleDanmakuEnabled(): void {
    this.isDanmakuEnabled = !this.isDanmakuEnabled;
    if (!this.isDanmakuEnabled) {
      this.stopDanmakuTimer();
    } else {
      this.startDanmakuTimer();
    }
  }

  sendDanmaku(): void {
    if (!this.currentDanmakuText.trim()) {
      hilog.info(DOMAIN, TAG, 'Cannot send empty danmaku');
      return;
    }

    // Ensure screenWidth is valid, use default 1080 if not set
    const actualScreenWidth = this.screenWidth > 0 ? this.screenWidth : 1080;
    
    hilog.info(DOMAIN, TAG, `Sending danmaku: "${this.currentDanmakuText}", color: ${this.selectedDanmakuColor}, type: ${this.selectedDanmakuType}, screenWidth: ${actualScreenWidth}`);
    
    const danmaku = new DanmakuItem(
      this.currentDanmakuText,
      this.selectedDanmakuColor,
      this.currentTime * 1000, // Convert to milliseconds
      this.selectedDanmakuType,
      this.danmakuSettings.defaultFontSize,
      this.danmakuSettings.defaultDuration,
      actualScreenWidth
    );

    // Set initial position for scrolling danmaku
    if (danmaku.type === DanmakuType.NORMAL) {
      // Start from right edge OUTSIDE the screen
      // positionX = screenWidth means the LEFT edge of danmaku is at the right edge of screen
      // To have danmaku start completely outside, we need: positionX = screenWidth
      danmaku.positionX = actualScreenWidth;
      danmaku.createdAt = Date.now(); // Reset creation time to now
      hilog.info(DOMAIN, TAG, `Scrolling danmaku initial position: ${danmaku.positionX}, screenWidth: ${actualScreenWidth}, speed: ${danmaku.speed}`);
    }

    this.danmakuList = this.danmakuList.concat([danmaku]);
    
    // Limit the number of danmaku to prevent memory issues
    if (this.danmakuList.length > this.danmakuSettings.maxConcurrentDanmaku * 2) {
      this.danmakuList = this.danmakuList.slice(-this.danmakuSettings.maxConcurrentDanmaku);
    }

    hilog.info(DOMAIN, TAG, `Danmaku sent successfully. Total danmaku: ${this.danmakuList.length}, positionX: ${danmaku.positionX}, screenWidth: ${danmaku.screenWidth}`);

    // Clear input
    this.currentDanmakuText = '';
    this.isDanmakuInputVisible = false;
  }

  clearAllDanmaku(): void {
    this.danmakuList = [];
  }

  removeDanmakuById(id: string): void {
    this.danmakuList = this.danmakuList.filter(danmaku => danmaku.id !== id);
  }

  startDanmakuTimer(): void {
    this.stopDanmakuTimer();
    this.danmakuTimerId = setInterval(() => {
      this.updateDanmakuPositions();
      this.cleanupExpiredDanmaku();
    }, 16); // Update every 16ms for smooth 60fps animation
  }

  stopDanmakuTimer(): void {
    if (this.danmakuTimerId !== -1) {
      clearInterval(this.danmakuTimerId);
      this.danmakuTimerId = -1;
    }
  }

  updateDanmakuPositions(): void {
    if (!this.isDanmakuEnabled || this.danmakuList.length === 0) {
      return;
    }

    const updatedDanmakuList = this.danmakuList.slice();
    const currentTime = Date.now();
    
    for (let i = 0; i < updatedDanmakuList.length; i++) {
      const danmaku = updatedDanmakuList[i];
      
      if (danmaku.type === DanmakuType.NORMAL) {
        // Update position for scrolling danmaku
        const elapsedTime = currentTime - danmaku.createdAt;
        const speed = danmaku.speed * this.danmakuSettings.speedMultiplier;
        
        // Calculate position: start from screenWidth, move left at speed pixels per second
        // Position = screenWidth - (speed * elapsedSeconds)
        const elapsedSeconds = elapsedTime / 1000;
        const distance = speed * elapsedSeconds;
        danmaku.positionX = danmaku.screenWidth - distance;
        
        // Log for debugging first 500ms
        if (elapsedTime < 500) {
          hilog.info(DOMAIN, TAG, `Danmaku "${danmaku.content}" pos: ${danmaku.positionX.toFixed(1)}, elapsed: ${elapsedTime}ms, speed: ${speed}, screenWidth: ${danmaku.screenWidth}`);
        }
        
        // Mark as not visible only when completely scrolled out of view (left side)
        //弹幕完全移出屏幕左侧后才标记为不可见
        if (danmaku.positionX < -danmaku.estimatedWidth - 50) {
          danmaku.isVisible = false;
        }
      } else {
        // For TOP and BOTTOM danmaku, check duration-based expiration
        if (currentTime - danmaku.createdAt > danmaku.duration) {
          danmaku.isVisible = false;
        }
      }
    }
    
    this.danmakuList = updatedDanmakuList;
  }

  cleanupExpiredDanmaku(): void {
    // Only remove danmaku that are marked as not visible
    this.danmakuList = this.danmakuList.filter(danmaku => {
      return danmaku.isVisible;
    });
  }

  addColorPreset(color: string, name: string = 'Custom Color'): void {
    const newPreset = new DanmakuColorPreset(name, color, true);
    this.colorPresets = this.colorPresets.filter(p => !p.isCustom).concat([newPreset]);
  }

  removeCustomColorPreset(index: number): void {
    if (index >= 0 && index < this.colorPresets.length && this.colorPresets[index].isCustom) {
      const updatedPresets = this.colorPresets.slice();
      updatedPresets.splice(index, 1);
      this.colorPresets = updatedPresets;
    }
  }

  updateDanmakuSettings(settings: DanmakuSettings): void {
    // Update danmaku settings
    this.danmakuSettings.opacity = settings.opacity;
    this.danmakuSettings.speedMultiplier = settings.speedMultiplier;
    this.danmakuSettings.maxConcurrentDanmaku = settings.maxConcurrentDanmaku;
  }

  // Initialize danmaku system
  initializeDanmaku(): void {
    this.startDanmakuTimer();
  }
  
  // ========== Comment Management Methods ==========
  
  /**
   * Toggle comment panel visibility
   */
  toggleCommentPanel(): void {
    this.isCommentVisible = !this.isCommentVisible;
    hilog.info(DOMAIN, TAG, `Comment panel visibility: ${this.isCommentVisible}`);
  }
  
  /**
   * Send a new comment
   */
  sendComment(): void {
    if (this.currentCommentText.trim() === '') {
      hilog.warn(DOMAIN, TAG, 'Comment text is empty');
      return;
    }
    
    const comment = new CommentItem(this.currentCommentText.trim());
    
    // Add new comment to the beginning of the list (newest first)
    this.commentList = [comment, ...this.commentList];
    
    hilog.info(DOMAIN, TAG, `Comment sent: "${comment.content}", time: ${comment.getFormattedTime()}, total: ${this.commentList.length}`);
    
    // Clear input
    this.currentCommentText = '';
  }
  
  /**
   * Clear all comments
   */
  clearAllComments(): void {
    this.commentList = [];
    hilog.info(DOMAIN, TAG, 'All comments cleared');
  }
  
  /**
   * Delete a comment by ID
   */
  deleteCommentById(id: string): void {
    this.commentList = this.commentList.filter(comment => comment.id !== id);
    hilog.info(DOMAIN, TAG, `Comment deleted: ${id}, remaining: ${this.commentList.length}`);
  }
  
  /**
   * Upload video from gallery
   */
  async uploadVideo(): Promise<void> {
    try {
      hilog.info(DOMAIN, TAG, 'Starting video upload from gallery');
      
      // Create photo picker options
      const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE;
      photoSelectOptions.maxSelectNumber = 1;
      
      // Create photo picker
      const photoPicker = new photoAccessHelper.PhotoViewPicker();
      
      // Select video from gallery
      const selectResult = await photoPicker.select(photoSelectOptions);
      
      if (selectResult && selectResult.photoUris && selectResult.photoUris.length > 0) {
        const videoUri = selectResult.photoUris[0];
        hilog.info(DOMAIN, TAG, `Selected video URI: ${videoUri}`);
        
        // Open the video file
        const file = fs.openSync(videoUri, fs.OpenMode.READ_ONLY);
        hilog.info(DOMAIN, TAG, `Opened video file, fd: ${file.fd}`);
        
        // Get file info
        const stat = fs.statSync(file.fd);
        hilog.info(DOMAIN, TAG, `Video file size: ${stat.size} bytes`);
        
        // Close the file
        fs.closeSync(file);
        
        hilog.info(DOMAIN, TAG, 'Video upload completed successfully');
        
        // Show success message
        if (this.hostContext) {
          hilog.info(DOMAIN, TAG, 'Video selected successfully, ready to play');
        }
      } else {
        hilog.warn(DOMAIN, TAG, 'No video selected');
      }
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Failed to upload video: ${JSON.stringify(error)}`);
    }
  }
  
  /**
   * Initialize filters
   */
  initializeFilters(): void {
    this.allFilters = this.filterManager.getAllFilters();
    hilog.info(DOMAIN, TAG, `Initialized ${this.allFilters.length} filters`);
  }
  
  /**
   * Toggle filter panel visibility
   */
  toggleFilterPanel(): void {
    this.isFilterPanelVisible = !this.isFilterPanelVisible;
    hilog.info(DOMAIN, TAG, `Filter panel visibility: ${this.isFilterPanelVisible}`);
  }
  
  /**
   * Apply filter to video
   */
  applyFilter(filterType: VideoFilterType): void {
    try {
      this.currentFilterType = filterType;
      this.filterManager.setFilter(filterType);
      
      // Update filter name
      const filterInfo = this.allFilters.find(f => f.type === filterType);
      if (filterInfo) {
        this.currentFilterName = filterInfo.name;
      }
      
      hilog.info(DOMAIN, TAG, `Applied filter: ${this.currentFilterName} (${filterType})`);
      
      // Close filter panel after selection
      this.isFilterPanelVisible = false;
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Failed to apply filter: ${JSON.stringify(error)}`);
    }
  }
  
  /**
   * Get current filter color matrix (for rendering)
   */
  getCurrentFilterMatrix(): number[] {
    const config = this.filterManager.getFilterConfig(this.currentFilterType);
    return config ? config.colorMatrix : [
      1, 0, 0, 0, 0,
      0, 1, 0, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 0, 1, 0
    ];
  }

  async cleanup(): Promise<void> {
    try {
      this.stopTimer();
      this.stopDanmakuTimer();
      this.unregisterEventListeners();
      await this.releasePlayer();
    } catch (error) {
      hilog.error(0x0000, TAG, `cleanup catch error, code: ${error.code}, message: ${error.message}`);
    }
  }
  
  /**
   * 恢复播放状态（用于流转恢复）
   */
  async restorePlayState(state: PlayStateData): Promise<void> {
    try {
      hilog.info(DOMAIN, TAG, `Restoring play state: videoIndex=${state.videoIndex}, time=${state.currentTime}`);
      
      // 1. 切换到指定视频
      if (state.videoIndex >= 0 && state.videoIndex < this.videoSources.length) {
        const rawDes = this.videoSources[state.videoIndex];
        await this.onVideoSelected(state.videoIndex, rawDes);
        
        // 2. 等待视频加载完成
        await new Promise<void>(resolve => setTimeout(resolve, 300));
        
        // 3. 恢复播放进度
        if (this.nativePlayerObj !== BigInt(0)) {
          await player.seekVideo(this.nativePlayerObj, state.currentTime * Const.TIME_RATIO);
          this.currentTime = state.currentTime;
        }
        
        // 4. 恢复播放速度
        if (state.playSpeed !== Const.VIDEO_DEFAULT_SPEED) {
          const speedIndex = Const.VIDEO_SPEED_ARR.indexOf(state.playSpeed);
          if (speedIndex !== -1) {
            this.onSpeedSelected(state.playSpeed, speedIndex);
          }
        }
        
        // 5. 恢复播放状态
        if (!state.isPlaying && this.playState === PlayerState.PLAYING) {
          player.pause(this.nativePlayerObj);
          this.playState = PlayerState.PAUSE;
        } else if (state.isPlaying && this.playState !== PlayerState.PLAYING) {
          player.resume(this.nativePlayerObj);
          this.playState = PlayerState.PLAYING;
        }
        
        // 6. 恢复弹幕设置
        this.isDanmakuEnabled = state.isDanmakuEnabled;
        this.danmakuSettings.opacity = state.danmakuOpacity;
        this.danmakuSettings.defaultFontSize = state.danmakuFontSize;
        this.danmakuSettings.speedMultiplier = state.danmakuSpeed;
        
        hilog.info(DOMAIN, TAG, 'Play state restored successfully');
      }
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Failed to restore play state: ${JSON.stringify(error)}`);
    }
  }
  
  /**
   * 获取当前播放状态（用于流转保存）
   */
  getCurrentPlayState(): PlayStateData | null {
    try {
      // 只有在播放器已初始化时才返回状态
      if (this.nativePlayerObj === BigInt(0) || this.chooseNumber < 0) {
        return null;
      }
      
      return {
        currentTime: this.currentTime,
        durationTime: this.durationTime,
        isPlaying: this.playState === PlayerState.PLAYING,
        playSpeed: this.chooseSpeed,
        videoIndex: this.chooseNumber,
        volume: 1.0, // 当前版本未实现音量控制，使用默认值
        isDanmakuEnabled: this.isDanmakuEnabled,
        danmakuOpacity: this.danmakuSettings.opacity,
        danmakuFontSize: this.danmakuSettings.defaultFontSize,
        danmakuSpeed: this.danmakuSettings.speedMultiplier,
        timestamp: Date.now()
      };
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Failed to get current play state: ${JSON.stringify(error)}`);
      return null;
    }
  }
}
