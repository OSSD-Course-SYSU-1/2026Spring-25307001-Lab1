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

import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { DistributedStateManager } from '../common/DistributedStateManager';
import { ResponsiveLayoutManager } from '../common/ResponsiveLayoutManager';

const DOMAIN = 0x0000;
const TAG = 'ENTRY';

export default class EntryAbility extends UIAbility {
  // 分布式状态管理器
  private distributedStateManager: DistributedStateManager = DistributedStateManager.getInstance();
  
  // 响应式布局管理器
  private layoutManager: ResponsiveLayoutManager = ResponsiveLayoutManager.getInstance();
  
  // 存储恢复的状态数据
  private restoreStateData: string = '';

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
      hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onCreate');
      
      // 初始化分布式状态管理器
      this.distributedStateManager.initialize(this.context);
      
      // 处理接续恢复
      if (launchParam.launchReason === AbilityConstant.LaunchReason.CONTINUATION) {
        hilog.info(DOMAIN, TAG, 'Ability launched by continuation');
        // 从want中获取保存的状态数据
        if (want.parameters) {
          const stateData = want.parameters['playState'] as string;
          if (stateData) {
            this.restoreStateData = stateData;
            hilog.info(DOMAIN, TAG, 'Restored play state from continuation');
          }
        }
      }
    } catch (error) {
      hilog.error(0x0000, TAG, `onCreate catch error, code: ${error.code}, message: ${error.message}`);
      return;
    }
  }

  onDestroy(): void {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onDestroy');
    
    // 清理资源
    this.distributedStateManager.destroy();
    this.layoutManager.destroy();
  }
  
  /**
   * 应用接续 - 保存状态
   * 当应用从一个设备迁移到另一个设备时调用
   */
  onContinue(wantParam: Record<string, Object>): AbilityConstant.OnContinueResult {
    hilog.info(DOMAIN, TAG, 'onContinue called');
    
    try {
      // 获取当前播放状态
      const playStateData = this.distributedStateManager.serializePlayState();
      
      if (playStateData) {
        // 将状态数据保存到wantParam中
        wantParam['playState'] = playStateData;
        hilog.info(DOMAIN, TAG, 'Play state saved for continuation');
        return AbilityConstant.OnContinueResult.AGREE;
      } else {
        hilog.info(DOMAIN, TAG, 'No play state to save');
        return AbilityConstant.OnContinueResult.AGREE;
      }
    } catch (error) {
      hilog.error(DOMAIN, TAG, `onContinue error: ${error}`);
      return AbilityConstant.OnContinueResult.REJECT;
    }
  }
  
  /**
   * 新Want进入 - 处理接续恢复
   */
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, TAG, 'onNewWant called');
    
    // 处理接续恢复
    if (launchParam.launchReason === AbilityConstant.LaunchReason.CONTINUATION) {
      hilog.info(DOMAIN, TAG, 'onNewWant by continuation');
      
      if (want.parameters) {
        const stateData = want.parameters['playState'] as string;
        if (stateData) {
          this.restoreStateData = stateData;
          
          // 通知UI恢复状态
          this.context.eventHub.emit('restorePlayState', stateData);
          hilog.info(DOMAIN, TAG, 'Play state restored');
        }
      }
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, TAG, 'Succeeded in loading the content.');
      
      // 如果有恢复的状态数据，延迟发送恢复事件
      if (this.restoreStateData) {
        setTimeout(() => {
          this.context.eventHub.emit('restorePlayState', this.restoreStateData);
          this.restoreStateData = '';
        }, 500);
      }
    });

    try {
      windowStage.on('windowStageEvent', (data)=>{
        if (data === window.WindowStageEventType.RESUMED) {
          this.context.eventHub.emit('onForeground');
        } else if (data === window.WindowStageEventType.PAUSED) {
          this.context.eventHub.emit('onBackground');
        } else {
          hilog.info(DOMAIN, TAG, 'The window stage is not paused or resume');
        }
      })
    } catch (error) {
      hilog.error(0x0000, TAG, `windowStageEvent catch error, code: ${error.code}, message: ${error.message}`);
      return;
    }
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onBackground');
    
    // 保存当前状态
    this.context.eventHub.emit('savePlayState');
  }
}
