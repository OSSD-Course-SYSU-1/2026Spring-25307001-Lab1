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

import { resourceManager } from '@kit.LocalizationKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { common } from '@kit.AbilityKit';
import { VideoPlayView } from '../view/VideoPlayView';
import { VideoPlayViewModel } from '../viewmodel/VideoPlayViewModel';
import { DistributedStateManager, PlayStateData } from '../common/DistributedStateManager';

const VIDEO_NAMES = ['1.mp4', '2.mp4', '3.mp4'];
const TAG = 'INDEX';

@Entry
@Component
struct Index {
  @State videoResources : resourceManager.RawFileDescriptor[] = [];
  @State viewModel: VideoPlayViewModel = new VideoPlayViewModel();
  @State isFullScreen: boolean = false;
  
  // 分布式状态管理器
  private distributedStateManager: DistributedStateManager = DistributedStateManager.getInstance();
  private context: common.UIAbilityContext | null = null;

  aboutToAppear(): void {
    try {
      // 获取UIAbility上下文
      this.context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      
      this.videoResources.length = 0;
      for (let i = 0; i< VIDEO_NAMES.length; i++) {
        let rawDes = this.getUIContext().getHostContext()?.resourceManager.getRawFdSync(VIDEO_NAMES[i]);
        if (rawDes) {
          this.videoResources.push(rawDes);
        }
      }
      
      // 注册流转事件监听
      this.registerContinuationEvents();
    } catch (error) {
      hilog.error(0x0000, TAG, `aboutToAppear catch error, code: ${error.code}, message: ${error.message}`);
    }
  }

  aboutToDisappear(): void {
    try {
      for (let i = 0; i< VIDEO_NAMES.length; i++) {
        this.getUIContext().getHostContext()?.resourceManager.closeRawFdSync(VIDEO_NAMES[i]);
      }
      
      // 取消流转事件监听
      this.unregisterContinuationEvents();
    } catch (error) {
      hilog.error(0x0000, TAG, `aboutToDisappear catch error, code: ${error.code}, message: ${error.message}`);
    }
  }
  
  /**
   * 注册流转事件监听
   */
  private registerContinuationEvents(): void {
    if (!this.context) {
      return;
    }
    
    // 监听状态恢复事件
    this.context.eventHub.on('restorePlayState', (stateData: string) => {
      hilog.info(0x0000, TAG, 'Received restorePlayState event');
      this.handleRestorePlayState(stateData);
    });
    
    // 监听状态保存事件
    this.context.eventHub.on('savePlayState', () => {
      hilog.info(0x0000, TAG, 'Received savePlayState event');
      this.handleSavePlayState();
    });
  }
  
  /**
   * 取消流转事件监听
   */
  private unregisterContinuationEvents(): void {
    if (!this.context) {
      return;
    }
    
    this.context.eventHub.off('restorePlayState');
    this.context.eventHub.off('savePlayState');
  }
  
  /**
   * 处理播放状态恢复
   */
  private handleRestorePlayState(stateData: string): void {
    const playState = this.distributedStateManager.deserializePlayState(stateData);
    if (playState) {
      // 通知ViewModel恢复状态
      this.viewModel.restorePlayState(playState);
      hilog.info(0x0000, TAG, `Play state restored: time=${playState.currentTime}, playing=${playState.isPlaying}`);
    }
  }
  
  /**
   * 处理播放状态保存
   */
  private handleSavePlayState(): void {
    const playState = this.viewModel.getCurrentPlayState();
    if (playState) {
      this.distributedStateManager.savePlayState(playState);
      hilog.info(0x0000, TAG, 'Play state saved');
    }
  }

  onBackPress(): boolean | void {
    if (this.isFullScreen) {
      this.isFullScreen = false;
      return true;
    }
    return false;
  }

  build() {
    Column() {
      VideoPlayView({
        viewModel: this.viewModel,
        videoSources: $videoResources,
        isFullScreen: this.isFullScreen
      });
    }
    .width('100%')
    .height('100%')
  }
}