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

import { CommentItem } from '../../model/CommentModel';
import { VideoPlayViewModel } from '../../viewmodel/VideoPlayViewModel';

/**
 * Comment list view component
 * Displays a list of comments with input field at the bottom
 */
@Component
export struct CommentListView {
  @ObjectLink viewModel: VideoPlayViewModel;
  
  build() {
    Column() {
      // Comment list area (scrollable)
      if (this.viewModel.commentList.length === 0) {
        // Empty state
        Column() {
          Text('暂无评论')
            .fontSize(16)
            .fontColor('#999999')
            .textAlign(TextAlign.Center)
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else {
        // Comment list
        List() {
          ForEach(this.viewModel.commentList, (comment: CommentItem) => {
            ListItem() {
              this.CommentItemView(comment)
            }
          }, (comment: CommentItem) => comment.id)
        }
        .width('100%')
        .layoutWeight(1)
        .divider({
          strokeWidth: 1,
          color: '#F0F0F0',
          startMargin: 60,
          endMargin: 16
        })
        .edgeEffect(EdgeEffect.Spring)
      }
      
      // Input area at the bottom with fixed height
      this.CommentInputArea()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
  
  @Builder
  CommentItemView(comment: CommentItem) {
    Row() {
      // User avatar placeholder
      Column() {
        Text(comment.userName.charAt(0))
          .fontSize(18)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
      }
      .width(40)
      .height(40)
      .borderRadius(20)
      .backgroundColor('#F67609')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      
      // Comment content
      Column() {
        // User name and time
        Row() {
          Text(comment.userName)
            .fontSize(14)
            .fontColor('#333333')
            .fontWeight(FontWeight.Medium)
          
          Blank()
          
          Text(comment.getFormattedTime())
            .fontSize(12)
            .fontColor('#999999')
        }
        .width('100%')
        .margin({ bottom: 4 })
        
        // Comment text
        Text(comment.content)
          .fontSize(15)
          .fontColor('#333333')
          .width('100%')
          .textOverflow({ overflow: TextOverflow.Clip })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 12 })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .alignItems(VerticalAlign.Top)
  }
  
  @Builder
  CommentInputArea() {
    Column() {
      Row() {
        // Input field
        TextInput({ 
          placeholder: '请输入评论...', 
          text: this.viewModel.currentCommentText 
        })
          .layoutWeight(1)
          .height(40)
          .backgroundColor(Color.White)
          .borderRadius(20)
          .border({ width: 1, color: '#E0E0E0' })
          .padding({ left: 16, right: 16 })
          .fontSize(15)
          .fontColor('#333333')
          .placeholderColor('#999999')
          .onChange((value: string) => {
            this.viewModel.currentCommentText = value;
          })
          .onSubmit(() => {
            this.viewModel.sendComment();
          })
        
        // Send button
        Button('发送')
          .height(40)
          .width(70)
          .fontSize(15)
          .fontColor('#FFFFFF')
          .backgroundColor('#F67609')
          .borderRadius(20)
          .margin({ left: 12 })
          .enabled(this.viewModel.currentCommentText.trim() !== '')
          .onClick(() => {
            this.viewModel.sendComment();
          })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .height(60)
    .backgroundColor(Color.White)
    .justifyContent(FlexAlign.Center)
    .border({
      width: { top: 1 },
      color: { top: '#E0E0E0' }
    })
  }
}
