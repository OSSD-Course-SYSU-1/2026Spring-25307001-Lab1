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

import { DanmakuType, DanmakuColorPreset } from '../../model/DanmakuModel';
import { VideoPlayViewModel } from '../../viewmodel/VideoPlayViewModel';

@Component
export struct DanmakuInputView {
  @ObjectLink viewModel: VideoPlayViewModel;

  @Builder
  ColorPicker() {
    Column() {
      Text('选择颜色')
        .fontSize('16fp')
        .fontColor(Color.White)
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: '12vp' })

      Grid() {
        ForEach(this.viewModel.colorPresets, (colorPreset: DanmakuColorPreset, index: number) => {
          GridItem() {
            Column() {
              // Color preview circle
              Circle()
                .width('24vp')
                .height('24vp')
                .fill(colorPreset.value)
                .border({
                  width: colorPreset.value === this.viewModel.selectedDanmakuColor ? '2vp' : '1vp',
                  color: colorPreset.value === this.viewModel.selectedDanmakuColor ? '#FFFFFF' : '#666666'
                })
                .margin({ bottom: '4vp' })

              // Color name
              Text(colorPreset.name)
                .fontSize('10fp')
                .fontColor(Color.White)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .onClick(() => {
              this.viewModel.updateDanmakuColor(colorPreset.value);
            })
          }
          .width('48vp')
          .height('56vp')
          .margin({ right: '8vp', bottom: '8vp' })
        })
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr')
      .columnsGap('8vp')
      .rowsGap('8vp')
      .width('100%')
      .height('120vp')
      .margin({ bottom: '16vp' })

      // Custom color input
      Row() {
        Text('自定义颜色:')
          .fontSize('14fp')
          .fontColor(Color.White)
          .margin({ right: '8vp' })

        TextInput({ placeholder: '输入十六进制颜色码' })
          .width('120vp')
          .height('32vp')
          .fontSize('14fp')
          .fontColor(Color.White)
          .backgroundColor('#333333')
          .borderRadius('4vp')
          .padding({ left: '8vp', right: '8vp' })
          .onChange((value: string) => {
            // Validate hex color format
            if (/^#[0-9A-Fa-f]{6}$/.test(value)) {
              this.viewModel.updateDanmakuColor(value);
            }
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .padding({ left: '16vp', right: '16vp', top: '12vp', bottom: '12vp' })
  }

  @Builder
  TypeSelector() {
    Column() {
      Text('弹幕类型')
        .fontSize('16fp')
        .fontColor(Color.White)
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: '12vp' })

      Row() {
        // Normal (scroll) type
        Column() {
          Text('滚动')
            .fontSize('14fp')
            .fontColor(this.viewModel.selectedDanmakuType === DanmakuType.NORMAL ? '#F67609' : Color.White)
            .fontWeight(this.viewModel.selectedDanmakuType === DanmakuType.NORMAL ? FontWeight.Bold : FontWeight.Normal)
        }
        .width('33%')
        .height('40vp')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .border({
          width: this.viewModel.selectedDanmakuType === DanmakuType.NORMAL ? '2vp' : '1vp',
          color: this.viewModel.selectedDanmakuType === DanmakuType.NORMAL ? '#F67609' : '#666666'
        })
        .borderRadius('8vp')
        .onClick(() => {
          this.viewModel.updateDanmakuType(DanmakuType.NORMAL);
        })

        // Top type
        Column() {
          Text('顶部')
            .fontSize('14fp')
            .fontColor(this.viewModel.selectedDanmakuType === DanmakuType.TOP ? '#F67609' : Color.White)
            .fontWeight(this.viewModel.selectedDanmakuType === DanmakuType.TOP ? FontWeight.Bold : FontWeight.Normal)
        }
        .width('33%')
        .height('40vp')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .border({
          width: this.viewModel.selectedDanmakuType === DanmakuType.TOP ? '2vp' : '1vp',
          color: this.viewModel.selectedDanmakuType === DanmakuType.TOP ? '#F67609' : '#666666'
        })
        .borderRadius('8vp')
        .onClick(() => {
          this.viewModel.updateDanmakuType(DanmakuType.TOP);
        })

        // Bottom type
        Column() {
          Text('底部')
            .fontSize('14fp')
            .fontColor(this.viewModel.selectedDanmakuType === DanmakuType.BOTTOM ? '#F67609' : Color.White)
            .fontWeight(this.viewModel.selectedDanmakuType === DanmakuType.BOTTOM ? FontWeight.Bold : FontWeight.Normal)
        }
        .width('33%')
        .height('40vp')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .border({
          width: this.viewModel.selectedDanmakuType === DanmakuType.BOTTOM ? '2vp' : '1vp',
          color: this.viewModel.selectedDanmakuType === DanmakuType.BOTTOM ? '#F67609' : '#666666'
        })
        .borderRadius('8vp')
        .onClick(() => {
          this.viewModel.updateDanmakuType(DanmakuType.BOTTOM);
        })
      }
      .width('100%')
      .height('40vp')
      .margin({ bottom: '16vp' })
    }
    .width('100%')
    .padding({ left: '16vp', right: '16vp', top: '12vp', bottom: '12vp' })
  }

  @Builder
  InputArea() {
    Column() {
      // Text input
      TextInput({ placeholder: '输入弹幕内容...', text: this.viewModel.currentDanmakuText })
        .width('100%')
        .height('40vp')
        .fontSize('16fp')
        .fontColor(Color.White)
        .backgroundColor('#333333')
        .borderRadius('8vp')
        .padding({ left: '12vp', right: '12vp' })
        .onChange((value: string) => {
          this.viewModel.updateDanmakuText(value);
        })
        .margin({ bottom: '12vp' })

      // Action buttons
      Row() {
        // Cancel button
        Button('取消', { type: ButtonType.Normal })
          .width('30%')
          .height('40vp')
          .fontSize('14fp')
          .fontColor(Color.White)
          .backgroundColor('#666666')
          .borderRadius('8vp')
          .onClick(() => {
            this.viewModel.hideDanmakuInput();
          })

        Blank()
          .width('10%')

        // Send button
        Button('发送弹幕', { type: ButtonType.Capsule })
          .width('60%')
          .height('40vp')
          .fontSize('14fp')
          .fontColor(Color.White)
          .backgroundColor('#F67609')
          .borderRadius('8vp')
          .enabled(this.viewModel.currentDanmakuText.trim().length > 0)
          .onClick(() => {
            this.viewModel.sendDanmaku();
          })
      }
      .width('100%')
      .height('40vp')
    }
    .width('100%')
    .padding({ left: '16vp', right: '16vp', top: '12vp', bottom: '12vp' })
  }

  build() {
    Column() {
      // Header
      Row() {
        Text('发送弹幕')
          .fontSize('18fp')
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)

        Blank()
          .width('1fr')

        Text('×')
          .fontSize('24fp')
          .fontColor(Color.White)
          .onClick(() => {
            this.viewModel.hideDanmakuInput();
          })
      }
      .width('100%')
      .height('48vp')
      .padding({ left: '16vp', right: '16vp' })
      .backgroundColor('#1E1E1E')
      .borderRadius({ topLeft: '12vp', topRight: '12vp' })

      // Content
      Scroll() {
        Column() {
          this.ColorPicker()
          Divider()
            .strokeWidth('1vp')
            .color('#333333')
            .margin({ top: '8vp', bottom: '8vp' })
          
          this.TypeSelector()
          Divider()
            .strokeWidth('1vp')
            .color('#333333')
            .margin({ top: '8vp', bottom: '8vp' })
          
          this.InputArea()
        }
        .width('100%')
      }
      .width('100%')
      .height('400vp')
      .backgroundColor('#2A2A2A')
    }
    .width('100%')
    .height('500vp')
    .backgroundColor(Color.Transparent)
    .borderRadius('12vp')
    .shadow({ radius: '20vp', color: '#000000', offsetX: '0vp', offsetY: '2vp' })
  }
}