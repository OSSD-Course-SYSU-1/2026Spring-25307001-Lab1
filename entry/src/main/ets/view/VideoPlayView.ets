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
import { resourceManager } from '@kit.LocalizationKit';
import { window } from '@kit.ArkUI';
import { getShowTime } from '../common/TimeUtils';
import { PlayerState } from '../model/PlayerStateModel';
import { CommonConstants as Const } from '../common/CommonConstants';
import { VideoPlayViewModel } from '../viewmodel/VideoPlayViewModel';
import { DanmakuDisplayView } from './danmaku/DanmakuDisplayView';
import { DanmakuInputView } from './danmaku/DanmakuInputView';
import { CommentListView } from './comment/CommentListView';
import { VideoFilterType, FilterInfo } from '../model/VideoFilterModel';
import { SizeAdapter } from '../common/SizeAdapter';
import { ResponsiveLayoutManager, BreakpointType } from '../common/ResponsiveLayoutManager';
import { DistributedStateManager } from '../common/DistributedStateManager';
import { DistributedControlView } from './DistributedControlView';

const DOMAIN = 0xFF00;
const TAG = 'VideoPlayView';
const FULL_SIZE = '100%';
const NORMAL_SIZE = '100%';
const WIDTH_SIZE = '100%';

@Component
export struct VideoPlayView {
  @ObjectLink viewModel: VideoPlayViewModel;
  @Link videoSources: resourceManager.RawFileDescriptor[];
  // [Start isFullScreen]
  // The horizontal full-screen playback state flag.
  @Watch('fullScreenSet') @Link isFullScreen: boolean;
  // [End isFullScreen]
  
  // 响应式布局管理器
  private sizeAdapter: SizeAdapter = SizeAdapter.getInstance();
  private layoutManager: ResponsiveLayoutManager = ResponsiveLayoutManager.getInstance();
  
  // 分布式状态管理器
  private distributedStateManager: DistributedStateManager = DistributedStateManager.getInstance();
  
  // 状态保存定时器
  private stateSaveTimerId: number = -1;
  
  // 自适应尺寸状态
  @State private videoPlayerHeight: string = '56%';
  @State private controlBarHeight: string = '48vp';
  @State private controlButtonSize: string = '36vp';
  @State private controlIconSize: string = '20vp';
  @State private videoPlayerWidth: string = '100%';
  @State private shouldShowSidebar: boolean = false;

  aboutToAppear(): void {
    this.viewModel.videoSources = this.videoSources;
    this.viewModel.setUIContext(this.getUIContext());
    this.viewModel.initialize();
    
    // 初始化响应式布局
    const context = this.getUIContext().getHostContext();
    if (context) {
      this.layoutManager.initialize(context);
    }
    this.updateAdaptiveSizes();
    
    // 监听断点变化
    this.layoutManager.onBreakpointChange(() => {
      this.updateAdaptiveSizes();
    });
    
    // 启动状态自动保存定时器（每5秒保存一次）
    this.startStateAutoSave();
    
    // 启动分布式状态自动同步（每3秒同步一次）
    this.distributedStateManager.startAutoSync(3000);
  }
  
  /**
   * 更新自适应尺寸
   */
  private updateAdaptiveSizes(): void {
    this.videoPlayerHeight = this.sizeAdapter.getVideoPlayerHeight();
    this.controlBarHeight = this.sizeAdapter.getControlBarHeight();
    this.controlButtonSize = this.sizeAdapter.getControlButtonSize();
    this.controlIconSize = this.sizeAdapter.getControlIconSize();
    this.videoPlayerWidth = this.sizeAdapter.getVideoPlayerWidth();
    this.shouldShowSidebar = this.sizeAdapter.shouldShowSidebar();
  }

  aboutToDisappear(): void {
    this.viewModel.cleanup();
    this.layoutManager.destroy();
    this.stopStateAutoSave();
    this.distributedStateManager.stopAutoSync();
  }
  
  /**
   * 启动状态自动保存
   */
  private startStateAutoSave(): void {
    this.stateSaveTimerId = setInterval(() => {
      this.saveCurrentState();
    }, 5000); // 每5秒保存一次
  }
  
  /**
   * 停止状态自动保存
   */
  private stopStateAutoSave(): void {
    if (this.stateSaveTimerId !== -1) {
      clearInterval(this.stateSaveTimerId);
      this.stateSaveTimerId = -1;
    }
  }
  
  /**
   * 保存当前播放状态
   */
  private saveCurrentState(): void {
    const playState = this.viewModel.getCurrentPlayState();
    if (playState) {
      this.distributedStateManager.savePlayState(playState);
    }
  }

  // [Start fullScreenSet]
  fullScreenSet() {
    // Change window orientation and layout when setting full screen.
    window.getLastWindow(this.getUIContext().getHostContext()).then((topWindow) => {
      topWindow.setPreferredOrientation(this.isFullScreen ?
        window.Orientation.AUTO_ROTATION_LANDSCAPE : window.Orientation.PORTRAIT).catch((error: BusinessError) => {
        hilog.error(DOMAIN, TAG, `Failed to setPreferredOrientation. Cause: ${error.code}, message: ${error.message}`);
      });
      topWindow.setWindowLayoutFullScreen(this.isFullScreen ? true : false).catch((error: BusinessError) => {
        hilog.error(DOMAIN, TAG,
          `Failed to setWindowLayoutFullScreen. Cause: ${error.code}, message: ${error.message}`);
      });
    }).catch((error: BusinessError) => {
      hilog.error(DOMAIN, TAG, `Failed to getLastWindow. Cause: ${error.code}, message: ${error.message}`);
    });
  }
  // [End fullScreenSet]

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 平板横屏分栏布局
      if (this.shouldShowSidebar && !this.isFullScreen) {
        this.TabletLandscapeLayout()
      } else {
        // 手机竖屏/全屏布局
        this.PhonePortraitLayout()
      }
      
      // Danmaku input overlay - placed in stack to ensure it's on top
      this.DanmakuInputOverlay()
      
      // Filter panel overlay - placed in stack to ensure it's on top
      this.FilterPanelOverlay()
    }
    .width('100%')
    .height('100%')
  }

  /**
   * 平板横屏左右分栏布局（类似B站iPad横屏）
   */
  @Builder
  TabletLandscapeLayout() {
    Row() {
      // 左侧：视频播放区域
      Column() {
        Stack({ alignContent: Alignment.Center }) {
          this.XComponentView()
          // Danmaku display layer
          DanmakuDisplayView({
            viewModel: this.viewModel,
            isFullScreen: $isFullScreen
          })
          this.ControlOverlay()
          this.SpeedListOverlay()
        }
        .width('100%')
        .height('100%')
      }
      .width(this.videoPlayerWidth)
      .height('100%')
      .backgroundColor(Color.Black)
      
      // 右侧：视频信息栏
      Column() {
        // 视频标题
        Row() {
          Text($r('app.string.Video_name'))
            .fontSize('20fp')
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .width('100%')
        .padding({ left: '16vp', right: '16vp', top: '16vp', bottom: '8vp' })
        
        // 分隔线
        Divider()
          .color('#333333')
          .margin({ left: '16vp', right: '16vp' })
        
        // 选集标题
        Row() {
          Text($r('app.string.Episodes'))
            .fontSize('16fp')
            .fontWeight(FontWeight.Medium)
            .fontColor('#AAAAAA')
          
          Blank()
          
          // Upload button
          Image($r('app.media.ic_upload'))
            .width(28)
            .height(28)
            .onClick(() => {
              this.viewModel.uploadVideo();
            })
        }
        .width('100%')
        .padding({ left: '16vp', right: '16vp', top: '12vp', bottom: '8vp' })
        
        // 选集列表（网格布局）
        Grid() {
          ForEach(this.videoSources, (item: resourceManager.RawFileDescriptor, index: number) => {
            GridItem() {
              Column() {
                Text((index + 1).toString())
                  .fontSize('16fp')
                  .fontColor(this.viewModel.chooseNumber === index && this.viewModel.isUse ? '#F67609' : '#FFFFFF')
              }
              .width('100%')
              .height('100%')
              .backgroundColor(this.viewModel.chooseNumber === index && this.viewModel.isUse ? '#3D3D3D' : '#2A2A2A')
              .borderRadius(8)
              .justifyContent(FlexAlign.Center)
              .borderColor(this.viewModel.chooseNumber === index && this.viewModel.isUse ? '#F67609' : 'transparent')
              .borderWidth(2)
              .onClick(() => {
                this.onVideoSelected(index, item);
              })
            }
          }, (item: resourceManager.RawFileDescriptor, index: number) => {
            return 'item: ' + item.toString() + 'index: ' + index.toString();
          })
        }
        .columnsTemplate('1fr 1fr 1fr')
        .rowsGap('8vp')
        .columnsGap('8vp')
        .width('100%')
        .height('180vp')
        .padding({ left: '16vp', right: '16vp' })
        
        // 分隔线
        Divider()
          .color('#333333')
          .margin({ left: '16vp', right: '16vp', top: '8vp' })
        
        // 评论区域
        if (this.viewModel.isCommentVisible) {
          Column() {
            Row() {
              Text('评论')
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#AAAAAA')
              
              Blank()
              
              Text('✕')
                .fontSize('16fp')
                .fontColor('#666666')
                .onClick(() => {
                  this.viewModel.toggleCommentPanel();
                })
            }
            .width('100%')
            .padding({ left: '16vp', right: '16vp', top: '12vp', bottom: '8vp' })
            
            CommentListView({
              viewModel: this.viewModel
            })
          }
          .width('100%')
          .layoutWeight(1)
        } else {
          // 评论按钮
          Row() {
            Text('查看评论')
              .fontSize('14fp')
              .fontColor('#F67609')
            
            Blank()
            
            Image($r('app.media.ic_public_play'))
              .width(16)
              .height(16)
              .fillColor('#F67609')
              .rotate({ angle: 90 })
          }
          .width('100%')
          .padding({ left: '16vp', right: '16vp', top: '12vp', bottom: '8vp' })
          .onClick(() => {
            this.viewModel.toggleCommentPanel();
          })
          
          Blank()
        }
      }
      .layoutWeight(1)
      .height('100%')
      .backgroundColor('#1A1A1A')
    }
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }

  /**
   * 手机竖屏/全屏布局
   */
  @Builder
  PhonePortraitLayout() {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        this.XComponentView()
        // Danmaku display layer
        DanmakuDisplayView({
          viewModel: this.viewModel,
          isFullScreen: $isFullScreen
        })
        this.ControlOverlay()
        this.SpeedListOverlay()
      }
      .width('100%')
      .height(this.isFullScreen ? '100%' : this.videoPlayerHeight)

      // Show either video selection or comment panel
      if (this.viewModel.isCommentVisible && !this.isFullScreen) {
        this.CommentPanelView()
      } else {
        this.VideoSelectionView()
        this.VideoPlaceholderView()
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor(Color.Black)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }

  @Builder
  XComponentView() {
    // [Start XComponent]
    XComponent({
      id: 'playerXC',
      type: XComponentType.SURFACE,
      libraryname: 'player'
    })
      .width(WIDTH_SIZE)
      .height(this.isFullScreen ? NORMAL_SIZE : FULL_SIZE)
    // [End XComponent]
  }

  @Builder
  ControlOverlay() {
    Column() {
      this.FullScreenHeaderView()
      Blank()
        .width('100%')
        .height('60%')
      this.PlaybackControls()
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.End)
    .padding({ left: '16vp', right: '16vp' })
    .visibility(this.viewModel.isUse ? Visibility.Visible : Visibility.Hidden)
  }

  @Builder
  FullScreenHeaderView() {
    Row() {
      Image($r('app.media.back'))
        .width('40vp')
        .height('40vp')
        .onClick(() => {
          this.isFullScreen = false;
        })

      Text($r('app.string.Video_name'))
        .fontColor(Color.White)
        .fontSize('20fp')
        .fontWeight(FontWeight.Medium)
        .margin({ left: '12vp' })
    }
    .width('100%')
    .height('24%')
    .justifyContent(FlexAlign.Start)
    .padding({ left: '36vp' })
    .visibility(this.isFullScreen ? Visibility.Visible : Visibility.Hidden)
  }

  @Builder
  PlaybackControls() {
    Row() {
      // Left side: Play button with Comment button below
      Column() {
        this.PlayPauseButton()
        this.CommentButton()
      }
      .width('10%')
      .height('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
      
      // Center: Time slider
      this.TimeSlider()
      
      // Right side: Speed, Danmaku, Filter, Fullscreen buttons
      Row() {
        this.SpeedButton()
        this.DanmakuButton()
        this.FilterButton()
        this.DistributedButton()
        this.FullScreenButton()
      }
      .width(this.isFullScreen ? '35%' : '45%')
      .height('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .width('100%')
    .height('16%')
    .padding({ left: '8vp', right: '8vp' })
    .justifyContent(FlexAlign.SpaceBetween)
    .visibility(this.viewModel.isSpeedListVisible ? Visibility.Hidden : Visibility.Visible)
  }

  @Builder
  PlayPauseButton() {
    Column() {
      Image(this.viewModel.playState === PlayerState.PLAYING ?
        $r('app.media.ic_public_pause') : $r('app.media.ic_public_play'))
        .width('30vp')
        .height('30vp')
        .onClick(() => {
          this.viewModel.playState = this.viewModel.togglePlayPause(this.viewModel.playState);
        })
    }
    .width('100%')
    .height('48%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  TimeSlider() {
    Row() {
      Text(getShowTime(this.viewModel.currentTime))
        .fontColor(Color.White)
        .fontSize('12fp')

      Slider({
        value: this.viewModel.currentTime,
        min: 0,
        max: this.viewModel.durationTime
      })
        .width(this.isFullScreen ? '75%' : '55%')
        .selectedColor('#F67609')
        .trackColor('#464642')
        .enabled(!this.viewModel.isSeek)
        .onChange((value: number, mode: SliderChangeMode) => {
          this.viewModel.onSliderChange(value, mode);
        })

      Text(getShowTime(this.viewModel.durationTime))
        .fontColor(Color.White)
        .fontSize('12fp')
    }
    .width(this.isFullScreen ? '60%' : '50%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  SpeedButton() {
    Column() {
      Text(this.viewModel.speedText)
        .fontColor(Color.White)
        .fontSize('14fp')
    }
    .width('25%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.viewModel.toggleSpeedList();
    })
  }

  @Builder
  DistributedButton() {
    Column() {
      DistributedControlView()
    }
    .width('25%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  FullScreenButton() {
    if (!this.isFullScreen) {
      Column() {
        Image($r('app.media.ic_public_enlarge'))
          .width('26vp')
          .height('26vp')
      }
      .width('25%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        this.isFullScreen = !this.isFullScreen;
      })
    }
  }

  @Builder
  DanmakuButton() {
    Column() {
      Text('弹幕')
        .fontSize('14fp')
        .fontColor(this.viewModel.isDanmakuInputVisible ? '#F67609' : Color.White)
        .fontWeight(FontWeight.Medium)
    }
    .width('25%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.viewModel.toggleDanmakuInput();
    })
  }
  
  @Builder
  CommentButton() {
    Column() {
      Text('评论')
        .fontSize('14fp')
        .fontColor(this.viewModel.isCommentVisible ? '#F67609' : Color.White)
        .fontWeight(FontWeight.Medium)
    }
    .width('100%')
    .height('48%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.viewModel.toggleCommentPanel();
    })
  }
  
  @Builder
  FilterButton() {
    Column() {
      Image($r('app.media.ic_filter'))
        .width('24vp')
        .height('24vp')
    }
    .width('25%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.viewModel.toggleFilterPanel();
    })
  }

  @Builder
  SpeedListOverlay() {
    Row() {
      Column() {
        List({ space: 0, initialIndex: 2 }) {
          ForEach(Const.VIDEO_SPEED_ARR, (item: number, index: number) => {
            ListItem() {
              Column() {
                Text(Const.VIDEO_SPEED_TEXT_ARR[index])
                  .fontSize('16fp')
                  .fontColor(this.viewModel.chooseSpeed === item ? '#F67609' : '#FFFFFF')
              }
              .width('100%')
              .height('50vp')
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .onClick(() => {
                this.viewModel.onSpeedSelected(item, index);
              })
            }
          }, (item: number, index: number) => {
            return 'item: ' + item.toString() + 'index: ' + index.toString();
          })
        }
        .width('100%')
        .height('100%')
        .stackFromEnd(true)
        .divider({
          strokeWidth: 0.1,
          color: '#EEEEEE',
          endMargin: 16,
          startMargin: 16
        })
      }
      .width(this.isFullScreen ? '180vp' : '120vp')
      .height('100%')
      .padding({ top: '16vp', bottom: '36vp' })
      .justifyContent(FlexAlign.End)
      .backgroundColor('#08ffffff')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.End)
    .visibility(this.viewModel.isSpeedListVisible ? Visibility.Visible : Visibility.Hidden)
    .onClick(() => {
      this.viewModel.hideSpeedList();
    })
  }

  @Builder
  FilterPanelOverlay() {
    Column() {
      // Header
      Row() {
        Text('视频滤镜')
          .fontSize('18fp')
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
        
        Blank()
        
        // Close button
        Text('✕')
          .fontSize('20fp')
          .fontColor(Color.White)
          .onClick(() => {
            this.viewModel.toggleFilterPanel();
          })
      }
      .width('100%')
      .height('50vp')
      .padding({ left: '16vp', right: '16vp' })
      
      // Current filter indicator
      Row() {
        Text('当前滤镜: ')
          .fontSize('14fp')
          .fontColor('#AAAAAA')
        Text(this.viewModel.currentFilterName)
          .fontSize('14fp')
          .fontColor('#F67609')
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .padding({ left: '16vp', right: '16vp', bottom: '12vp' })
      
      // Filter grid
      Grid() {
        ForEach(this.viewModel.allFilters, (filter: FilterInfo, index: number) => {
          GridItem() {
            Column() {
              // Filter icon
              Text(filter.icon)
                .fontSize('32fp')
                .width('48vp')
                .height('48vp')
                .textAlign(TextAlign.Center)
              
              // Filter name
              Text(filter.name)
                .fontSize('12fp')
                .fontColor(this.viewModel.currentFilterType === filter.type ? '#F67609' : Color.White)
                .fontWeight(this.viewModel.currentFilterType === filter.type ? FontWeight.Bold : FontWeight.Normal)
                .margin({ top: '4vp' })
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
            .padding('8vp')
            .borderRadius('8vp')
            .backgroundColor(this.viewModel.currentFilterType === filter.type ? '#20F67609' : '#10FFFFFF')
            .onClick(() => {
              this.viewModel.applyFilter(filter.type);
            })
          }
        }, (filter: FilterInfo) => filter.type)
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr 1fr 1fr')
      .columnsGap('8vp')
      .rowsGap('8vp')
      .width('100%')
      .height('320vp')
      .padding({ left: '16vp', right: '16vp' })
      
      // Footer with apply button
      Row() {
        Button('重置滤镜')
          .fontSize('14fp')
          .fontColor(Color.White)
          .backgroundColor('#333333')
          .borderRadius('20vp')
          .width('40%')
          .height('36vp')
          .onClick(() => {
            this.viewModel.applyFilter(VideoFilterType.NONE);
          })
        
        Button('确认应用')
          .fontSize('14fp')
          .fontColor(Color.White)
          .backgroundColor('#F67609')
          .borderRadius('20vp')
          .width('40%')
          .height('36vp')
          .onClick(() => {
            this.viewModel.toggleFilterPanel();
          })
      }
      .width('100%')
      .height('60vp')
      .justifyContent(FlexAlign.SpaceEvenly)
      .padding({ top: '12vp' })
    }
    .width('100%')
    .height('480vp')
    .backgroundColor('#CC000000')
    .borderRadius({ topLeft: '16vp', topRight: '16vp' })
    .position({ x: 0, y: '100%' })
    .translate({ y: this.viewModel.isFilterPanelVisible ? '-480vp' : '0vp' })
    .animation({
      duration: 300,
      curve: Curve.EaseOut
    })
  }

  @Builder
  VideoSelectionView() {
    Column() {
      Row() {
        Text($r('app.string.Video_name'))
          .fontSize('24fp')
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
      }
      .width('100%')
      .height('25%')
      .justifyContent(FlexAlign.Start)
      .padding({ left: '20vp', right: '20vp' })

      Row() {
        Text($r('app.string.Episodes'))
          .fontSize('16fp')
          .fontWeight(FontWeight.Regular)
          .fontColor(Color.White)
        
        Blank()
        
        // Upload button
        Image($r('app.media.ic_upload'))
          .width(32)
          .height(32)
          .onClick(() => {
            this.viewModel.uploadVideo();
          })
      }
      .width('100%')
      .height('20%')
      .padding({ left: '20vp', right: '20vp' })

      Row() {
        List({ space: '16vp', initialIndex: 0 }) {
          ForEach(this.videoSources, (item: resourceManager.RawFileDescriptor, index: number) => {
            ListItem() {
              Column() {
                Text((index + 1).toString())
                  .fontSize('20fp')
                  .fontColor(this.viewModel.chooseNumber === index && this.viewModel.isUse ? '#F67609' : '#FFFFFF')
              }
              .width(40)
              .height(40)
              .backgroundColor('#3B3A37')
              .borderRadius($r('sys.float.corner_radius_level5'))
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .borderColor(this.viewModel.chooseNumber === index && this.viewModel.isUse ? '#F67609' : '#3B3A37')
              .borderWidth(1)
              .onClick(() => {
                this.onVideoSelected(index, item);
              })
            }
          }, (item: resourceManager.RawFileDescriptor, index: number) => {
            return 'item: ' + item.toString() + 'index: ' + index.toString();
          })
        }
        .width('100%')
        .height('100%')
        .listDirection(Axis.Horizontal)
        .enabled(this.viewModel.isSwitchEnable)
      }
      .width('100%')
      .height('30%')
      .padding({ left: '20vp', right: '20vp' })
    }
    .width('100%')
    .height('35%')
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [[0x1b1a1c, 0], [0x000000, 0.5]]
    })
    .visibility(this.isFullScreen ? Visibility.Hidden : Visibility.Visible)
  }

  @Builder
  VideoPlaceholderView() {
    Blank()
      .width('100%')
      .height('55%')
      .backgroundColor(Color.Black)
      .visibility(this.isFullScreen ? Visibility.Hidden : Visibility.Visible)
  }

  @Builder
  DanmakuInputOverlay() {
    if (this.viewModel.isDanmakuInputVisible) {
      // Use Stack with absolute positioning to cover the entire screen
      Stack() {
        // Semi-transparent background covering entire screen
        Column() {
          Blank()
            .width('100%')
            .height('100%')
            .backgroundColor('#80000000')
            .onClick(() => {
              this.viewModel.hideDanmakuInput();
            })
        }
        .width('100%')
        .height('100%')
        
        // Danmaku input view at bottom - using absolute positioning
        Column() {
          DanmakuInputView({
            viewModel: this.viewModel
          })
        }
        .width('100%')
        .position({ x: 0, y: '100% - 350vp' }) // Position from bottom
        .zIndex(1000)
      }
      .width('100%')
      .height('100%')
      .position({ x: 0, y: 0 })
      .zIndex(999) // Highest z-index
    }
  }
  
  @Builder
  CommentPanelView() {
    Column() {
      // Comment header
      Row() {
        Text('评论')
          .fontSize(18)
          .fontColor('#333333')
          .fontWeight(FontWeight.Bold)
        
        Blank()
        
        // Close button
        Button({ type: ButtonType.Circle }) {
          Text('✕')
            .fontSize(18)
            .fontColor('#999999')
        }
        .width(30)
        .height(30)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          this.viewModel.toggleCommentPanel();
        })
      }
      .width('100%')
      .height(50)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')
      .border({
        width: { bottom: 1 },
        color: { bottom: '#E0E0E0' }
      })
      
      // Comment list with layoutWeight to fill remaining space
      CommentListView({
        viewModel: this.viewModel
      })
      .layoutWeight(1)
    }
    .width('100%')
    .height('65%')
    .backgroundColor('#FFFFFF')
  }

  private async onVideoSelected(index: number, rawDes: resourceManager.RawFileDescriptor): Promise<void> {
    const newState = await this.viewModel.onVideoSelected(index, rawDes);
    if (newState !== null) {
      this.viewModel.playState = newState;
    }
  }
}