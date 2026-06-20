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
import { DistributedStateManager } from '../common/DistributedStateManager';

const DOMAIN = 0xFF00;
const TAG = 'DistributedControlView';

/**
 * 分布式流转控制视图
 * 提供设备选择和流转控制功能
 */
@Component
export struct DistributedControlView {
  // 分布式状态管理器
  private distributedStateManager: DistributedStateManager = DistributedStateManager.getInstance();
  
  // 设备列表
  @State private deviceList: distributedDeviceManager.DeviceBasicInfo[] = [];
  
  // 是否显示设备列表
  @State private isDeviceListVisible: boolean = false;
  
  // 是否正在流转
  @State private isContinuing: boolean = false;
  
  // 选中的设备ID
  @State private selectedDeviceId: string = '';
  
  aboutToAppear(): void {
    // 获取可信设备列表
    this.refreshDeviceList();
  }
  
  /**
   * 刷新设备列表
   */
  private refreshDeviceList(): void {
    this.deviceList = this.distributedStateManager.getAvailableDeviceList();
    hilog.info(DOMAIN, TAG, `Device list refreshed, count: ${this.deviceList.length}`);
  }
  
  /**
   * 切换设备列表显示
   */
  toggleDeviceList(): void {
    this.isDeviceListVisible = !this.isDeviceListVisible;
    if (this.isDeviceListVisible) {
      this.refreshDeviceList();
    }
  }
  
  build() {
    Column() {
      // 流转控制按钮
      Row() {
        // 设备图标
        Image($r('app.media.ic_public_play'))
          .width(24)
          .height(24)
          .fillColor('#FFFFFF')
        
        // 流转状态指示
        if (this.isContinuing) {
          LoadingProgress()
            .width(16)
            .height(16)
            .color('#FFFFFF')
            .margin({ left: 8 })
        }
      }
      .width(48)
      .height(48)
      .borderRadius(24)
      .backgroundColor('rgba(255, 255, 255, 0.2)')
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        this.toggleDeviceList();
      })
      
      // 设备列表弹窗
      if (this.isDeviceListVisible) {
        Column() {
          // 标题
          Text('选择设备')
            .fontSize(16)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Medium)
            .margin({ bottom: 12 })
          
          // 设备列表
          if (this.deviceList.length > 0) {
            ForEach(this.deviceList, (device: distributedDeviceManager.DeviceBasicInfo) => {
              Row() {
                // 设备图标
                Image($r('app.media.ic_public_play'))
                  .width(20)
                  .height(20)
                  .fillColor('#FFFFFF')
                
                // 设备名称
                Text(device.deviceName)
                  .fontSize(14)
                  .fontColor('#FFFFFF')
                  .margin({ left: 8 })
                  .layoutWeight(1)
                
                // 选中状态
                if (this.selectedDeviceId === device.deviceId) {
                  Image($r('app.media.ic_public_play'))
                    .width(16)
                    .height(16)
                    .fillColor('#00FF00')
                }
              }
              .width('100%')
              .height(48)
              .padding({ left: 16, right: 16 })
              .borderRadius(8)
              .backgroundColor('rgba(255, 255, 255, 0.1)')
              .onClick(() => {
                this.selectedDeviceId = device.deviceId;
                hilog.info(DOMAIN, TAG, `Device selected: ${device.deviceName}`);
              })
            }, (device: distributedDeviceManager.DeviceBasicInfo) => device.deviceId)
          } else {
            // 无设备提示
            Column() {
              Image($r('app.media.ic_public_play'))
                .width(48)
                .height(48)
                .fillColor('rgba(255, 255, 255, 0.5)')
              
              Text('暂无可流转设备')
                .fontSize(14)
                .fontColor('rgba(255, 255, 255, 0.7)')
                .margin({ top: 8 })
              
              Text('请确保其他设备已登录同一华为账号')
                .fontSize(12)
                .fontColor('rgba(255, 255, 255, 0.5)')
                .margin({ top: 4 })
            }
            .width('100%')
            .height(120)
            .justifyContent(FlexAlign.Center)
          }
          
          // 刷新按钮
          Row() {
            Image($r('app.media.ic_public_play'))
              .width(16)
              .height(16)
              .fillColor('#FFFFFF')
            
            Text('刷新设备列表')
              .fontSize(14)
              .fontColor('#FFFFFF')
              .margin({ left: 8 })
          }
          .width('100%')
          .height(40)
          .justifyContent(FlexAlign.Center)
          .borderRadius(8)
          .backgroundColor('rgba(255, 255, 255, 0.1)')
          .margin({ top: 12 })
          .onClick(() => {
            this.refreshDeviceList();
          })
        }
        .width(240)
        .padding(16)
        .borderRadius(12)
        .backgroundColor('rgba(0, 0, 0, 0.8)')
        .margin({ top: 8 })
      }
    }
    .alignItems(HorizontalAlign.End)
  }
}
