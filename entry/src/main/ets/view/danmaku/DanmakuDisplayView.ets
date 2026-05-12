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

import { DanmakuItem, DanmakuType } from '../../model/DanmakuModel';
import { VideoPlayViewModel } from '../../viewmodel/VideoPlayViewModel';

@Component
export struct DanmakuDisplayView {
  @ObjectLink viewModel: VideoPlayViewModel;
  @Link isFullScreen: boolean;

  @Builder
  DanmakuItemView(danmaku: DanmakuItem, index: number) {
    if (danmaku.isVisible) {
      Text(danmaku.content)
        .fontSize(`${danmaku.fontSize}fp`)
        .fontColor(danmaku.color)
        .fontWeight(FontWeight.Medium)
        .opacity(this.viewModel.danmakuSettings.opacity)
        .width('auto')
        .height('auto')
        .padding({ left: '8vp', right: '8vp', top: '4vp', bottom: '4vp' })
        .backgroundColor('#1A000000')
        .borderRadius('4vp')
        .position({
          x: danmaku.type === DanmakuType.NORMAL ? `${danmaku.positionX}vp` : '0vp',
          y: this.getDanmakuYPosition(danmaku, index)
        })
    }
  }

  private getDanmakuYPosition(danmaku: DanmakuItem, index: number): string {
    switch (danmaku.type) {
      case DanmakuType.TOP:
        return '10%';
      case DanmakuType.BOTTOM:
        return '90%';
      case DanmakuType.NORMAL:
      default:
        // Distribute danmaku vertically for scrolling type
        const positionPercentage = 10 + (index % 8) * 10; // 8 rows max
        return `${positionPercentage}%`;
    }
  }

  @Builder
  DanmakuLayer() {
    Stack({ alignContent: Alignment.TopStart }) {
      ForEach(this.viewModel.danmakuList, (danmaku: DanmakuItem, index: number) => {
        this.DanmakuItemView(danmaku, index)
      }, (danmaku: DanmakuItem) => danmaku.id)
    }
    .width('100%')
    .height(this.isFullScreen ? '100%' : '35%')
    .visibility(this.viewModel.isDanmakuEnabled ? Visibility.Visible : Visibility.Hidden)
  }

  @Builder
  ControlOverlay() {
    if (this.viewModel.isDanmakuEnabled) {
      Column({ space: '8vp' }) {
      // Danmaku toggle button
      Row() {
        Text(this.viewModel.isDanmakuEnabled ? '弹幕开' : '弹幕关')
          .fontSize('12fp')
          .fontColor(Color.White)
          .onClick(() => {
            this.viewModel.toggleDanmakuEnabled();
          })
      }
      .width('auto')
      .height('auto')
      .padding({ left: '12vp', right: '12vp', top: '6vp', bottom: '6vp' })
      .backgroundColor('#4D000000')
      .borderRadius('16vp')
      .alignItems(VerticalAlign.Center)

      // Send danmaku button
      Row() {
        Text('发弹幕')
          .fontSize('12fp')
          .fontColor(Color.White)
          .onClick(() => {
            this.viewModel.toggleDanmakuInput();
          })
      }
      .width('auto')
      .height('auto')
      .padding({ left: '12vp', right: '12vp', top: '6vp', bottom: '6vp' })
      .backgroundColor('#4D000000')
      .borderRadius('16vp')
      .alignItems(VerticalAlign.Center)

      // Clear danmaku button
      Row() {
        Text('清空')
          .fontSize('12fp')
          .fontColor(Color.White)
          .onClick(() => {
            this.viewModel.clearAllDanmaku();
          })
      }
      .width('auto')
      .height('auto')
      .padding({ left: '12vp', right: '12vp', top: '6vp', bottom: '6vp' })
      .backgroundColor('#4D000000')
      .borderRadius('16vp')
      .alignItems(VerticalAlign.Center)
    }
    .position({ x: '16vp', y: '16vp' })
    .visibility(this.viewModel.isUse ? Visibility.Visible : Visibility.Hidden)
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // Danmaku display layer
      this.DanmakuLayer()

      // Control overlay
      this.ControlOverlay()
    }
    .width('100%')
    .height(this.isFullScreen ? '100%' : '35%')
  }
}