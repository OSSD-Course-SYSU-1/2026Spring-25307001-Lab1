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
struct DanmakuItemView {
  @ObjectLink danmaku: DanmakuItem;
  @Prop containerWidth: number = 0;
  @Prop containerHeight: number = 0;
  @Prop index: number = 0;
  @Prop danmakuOpacity: number = 1.0;

  build() {
    Text(this.danmaku.content)
      .fontSize(this.danmaku.fontSize)
      .fontColor(this.danmaku.color)
      .fontWeight(FontWeight.Medium)
      .opacity(this.danmakuOpacity)
      .padding({ left: 8, right: 8, top: 4, bottom: 4 })
      .backgroundColor('#1A000000')
      .borderRadius(4)
      .position({
        x: this.getDanmakuX(),
        y: this.getDanmakuY()
      })
  }

  private getDanmakuX(): number {
    if (this.containerWidth === 0) {
      return 0;
    }
    
    switch (this.danmaku.type) {
      case DanmakuType.TOP:
      case DanmakuType.BOTTOM:
        // Center horizontally
        return this.containerWidth / 2 - this.danmaku.estimatedWidth / 2;
      case DanmakuType.NORMAL:
      default:
        // Scrolling danmaku - use positionX directly
        return this.danmaku.positionX;
    }
  }

  private getDanmakuY(): number {
    if (this.containerHeight === 0) {
      return 0;
    }
    
    switch (this.danmaku.type) {
      case DanmakuType.TOP:
        // Top position - 10% from top
        return this.containerHeight * 0.1;
      case DanmakuType.BOTTOM:
        // Bottom position - 10% from bottom
        return this.containerHeight * 0.9 - 20;
      case DanmakuType.NORMAL:
      default:
        // Distribute vertically - 8 rows
        const rowHeight = this.containerHeight * 0.8 / 8;
        return this.containerHeight * 0.1 + (this.index % 8) * rowHeight;
    }
  }
}

@Component
export struct DanmakuDisplayView {
  @ObjectLink viewModel: VideoPlayViewModel;
  @Link isFullScreen: boolean;
  
  @State containerWidth: number = 0;
  @State containerHeight: number = 0;

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // Danmaku items
      ForEach(this.viewModel.danmakuList, (danmaku: DanmakuItem, index: number) => {
        if (danmaku.isVisible && this.viewModel.isDanmakuEnabled) {
          DanmakuItemView({
            danmaku: danmaku,
            containerWidth: this.containerWidth,
            containerHeight: this.containerHeight,
            index: index,
            danmakuOpacity: this.viewModel.danmakuSettings.opacity
          })
        }
      }, (danmaku: DanmakuItem) => danmaku.id)

      // Control overlay
      Column({ space: 8 }) {
        Row() {
          Text(this.viewModel.isDanmakuEnabled ? '弹幕开' : '弹幕关')
            .fontSize(12)
            .fontColor(this.viewModel.isDanmakuEnabled ? Color.Green : Color.Gray)
            .onClick(() => {
              this.viewModel.toggleDanmakuEnabled();
            })
        }
        .padding({ left: 12, right: 12, top: 6, bottom: 6 })
        .backgroundColor('#4D000000')
        .borderRadius(16)

        Row() {
          Text('发弹幕')
            .fontSize(12)
            .fontColor(Color.White)
            .onClick(() => {
              this.viewModel.toggleDanmakuInput();
            })
        }
        .padding({ left: 12, right: 12, top: 6, bottom: 6 })
        .backgroundColor('#4D000000')
        .borderRadius(16)

        Row() {
          Text('清空')
            .fontSize(12)
            .fontColor(Color.White)
            .onClick(() => {
              this.viewModel.clearAllDanmaku();
            })
        }
        .padding({ left: 12, right: 12, top: 6, bottom: 6 })
        .backgroundColor('#4D000000')
        .borderRadius(16)
      }
      .position({ x: 16, y: 16 })
    }
    .width('100%')
    .height('100%')
    .clip(false) // Allow danmaku to be visible outside container bounds
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.containerWidth = newValue.width as number;
      this.containerHeight = newValue.height as number;
      // Update viewModel's screenWidth for danmaku positioning
      if (this.containerWidth > 0) {
        this.viewModel.screenWidth = this.containerWidth;
      }
    })
  }
}
