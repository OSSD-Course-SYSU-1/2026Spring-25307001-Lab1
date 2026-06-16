/**
 * 存档列表页面
 * 显示所有存档，支持创建、加载、删除存档
 */

import { GameStorage, SaveSlot } from '../utils/GameStorage';
import { PathUtils, ColorUtils, AdaptiveUtils } from '../utils/AdaptiveUtils';
import router from '@ohos.router';
import common from '@ohos.app.ability.common';

@Entry
@Component
struct SaveListPage {
  @State saveList: SaveSlot[] = [];
  @State showDeleteConfirm: boolean = false;
  @State deleteTargetId: number = -1;
  @State showCreateDialog: boolean = false;
  @State newSaveName: string = '';
  
  async aboutToAppear() {
    // 初始化GameStorage
    const context = getContext(this) as common.UIAbilityContext;
    await GameStorage.getInstance().init(context);
    
    // 初始化屏幕适配
    AdaptiveUtils.init(360, 640);
    
    // 加载存档列表
    await this.loadSaveList();
  }
  
  // 加载存档列表
  async loadSaveList() {
    this.saveList = await GameStorage.getInstance().getSaveList();
  }
  
  // 创建新存档
  async createNewSave() {
    if (this.newSaveName.trim() === '') {
      this.newSaveName = '存档 ' + (this.saveList.length + 1);
    }
    
    const saveId = await GameStorage.getInstance().createNewSave(this.newSaveName);
    if (saveId !== -1) {
      GameStorage.getInstance().setCurrentSave(saveId);
      
      router.pushUrl({
        url: 'pages/Index',
        params: { saveId: saveId, isNew: true }
      });
    }
    
    this.showCreateDialog = false;
    this.newSaveName = '';
  }
  
  // 加载存档
  async loadSave(saveId: number) {
    GameStorage.getInstance().setCurrentSave(saveId);
    
    router.pushUrl({
      url: 'pages/Index',
      params: { saveId: saveId, isNew: false }
    });
  }
  
  // 删除存档
  async deleteSave() {
    if (this.deleteTargetId !== -1) {
      await GameStorage.getInstance().deleteSave(this.deleteTargetId);
      await this.loadSaveList();
    }
    
    this.showDeleteConfirm = false;
    this.deleteTargetId = -1;
  }
  
  // 格式化时间
  formatTime(timestamp: number): string {
    const date = new Date(timestamp);
    const month = date.getMonth() + 1;
    const day = date.getDate();
    const hour = date.getHours().toString().padStart(2, '0');
    const minute = date.getMinutes().toString().padStart(2, '0');
    return `${month}月${day}日 ${hour}:${minute}`;
  }
  
  // 获取宠物类型中文名
  getPetTypeName(petType: string): string {
    switch (petType) {
      case 'Octo': return '章鱼精灵';
      case 'Serp': return '蛇形精灵';
      case 'Robin': return '鸟形精灵';
      default: return '未知';
    }
  }
  
  // 获取成长阶段中文名
  getGrowthStageName(stage: string): string {
    switch (stage) {
      case 'baby': return '幼年期';
      case 'youth': return '青年期';
      case 'adult': return '成年期';
      default: return '未知';
    }
  }
  
  build() {
    Stack() {
      // 背景渐变
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: 135,
          colors: [['#667eea', 0], ['#764ba2', 1]]
        })
      
      Column() {
        // 标题
        Text('存档列表')
          .fontSize(AdaptiveUtils.fontSize(28))
          .fontColor('#ffffff')
          .fontWeight(FontWeight.Bold)
          .margin({ top: AdaptiveUtils.spacing(50), bottom: AdaptiveUtils.spacing(25) })
        
        // 存档列表
        if (this.saveList.length === 0) {
          // 空状态
          Column() {
            Text('📁')
              .fontSize(AdaptiveUtils.fontSize(48))
              .margin({ bottom: AdaptiveUtils.spacing(15) })
            
            Text('暂无存档')
              .fontSize(AdaptiveUtils.fontSize(18))
              .fontColor('#ffffff')
              .opacity(0.8)
            
            Text('点击下方按钮创建新存档')
              .fontSize(AdaptiveUtils.fontSize(12))
              .fontColor('#ffffff')
              .opacity(0.6)
              .margin({ top: AdaptiveUtils.spacing(8) })
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        } else {
          // 存档卡片列表
          List() {
            ForEach(this.saveList, (save: SaveSlot) => {
              ListItem() {
                this.SaveCard(save)
              }
              .margin({ bottom: AdaptiveUtils.spacing(12) })
            }, (save: SaveSlot) => save.id.toString())
          }
          .width(AdaptiveUtils.isTablet() ? '60%' : '90%')
          .layoutWeight(1)
          .margin({ top: AdaptiveUtils.spacing(8) })
        }
        
        // 底部按钮区
        Row() {
          Button('返回')
            .width('40%')
            .height(AdaptiveUtils.scale(45))
            .fontSize(AdaptiveUtils.fontSize(16))
            .fontColor('#667eea')
            .backgroundColor('#ffffff')
            .borderRadius(AdaptiveUtils.scale(22))
            .onClick(() => {
              router.back();
            })
          
          Blank().width('5%')
          
          Button('新建存档')
            .width('40%')
            .height(AdaptiveUtils.scale(45))
            .fontSize(AdaptiveUtils.fontSize(16))
            .fontColor('#ffffff')
            .backgroundColor('#FF6B9D')
            .borderRadius(AdaptiveUtils.scale(22))
            .onClick(() => {
              this.showCreateDialog = true;
            })
        }
        .width(AdaptiveUtils.isTablet() ? '50%' : '90%')
        .margin({ bottom: AdaptiveUtils.spacing(35) })
      }
      .width('100%')
      .height('100%')
      
      // 删除确认对话框
      if (this.showDeleteConfirm) {
        this.DeleteConfirmDialog()
      }
      
      // 创建存档对话框
      if (this.showCreateDialog) {
        this.CreateSaveDialog()
      }
    }
    .width('100%')
    .height('100%')
  }
  
  // 存档卡片组件
  @Builder
  SaveCard(save: SaveSlot) {
    Column() {
      Row() {
        // 左侧：存档信息
        Column() {
          Text(save.name)
            .fontSize(AdaptiveUtils.fontSize(18))
            .fontColor('#333333')
            .fontWeight(FontWeight.Bold)
          
          Row() {
            Text(this.getPetTypeName(save.petType))
              .fontSize(AdaptiveUtils.fontSize(12))
              .fontColor('#666666')
            
            Text(' · ')
              .fontSize(AdaptiveUtils.fontSize(12))
              .fontColor('#999999')
            
            Text(this.getGrowthStageName(save.growthStage))
              .fontSize(AdaptiveUtils.fontSize(12))
              .fontColor('#666666')
          }
          .margin({ top: AdaptiveUtils.spacing(4) })
          
          Text('最后保存: ' + this.formatTime(save.lastSaveTime))
            .fontSize(AdaptiveUtils.fontSize(11))
            .fontColor('#999999')
            .margin({ top: AdaptiveUtils.spacing(4) })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
        
        // 右侧：操作按钮
        Row() {
          Button('继续')
            .width(AdaptiveUtils.scale(55))
            .height(AdaptiveUtils.scale(32))
            .fontSize(AdaptiveUtils.fontSize(12))
            .fontColor('#ffffff')
            .backgroundColor('#667eea')
            .borderRadius(AdaptiveUtils.scale(16))
            .onClick(() => {
              this.loadSave(save.id);
            })
          
          Button('删除')
            .width(AdaptiveUtils.scale(55))
            .height(AdaptiveUtils.scale(32))
            .fontSize(AdaptiveUtils.fontSize(12))
            .fontColor('#ffffff')
            .backgroundColor('#FF6B6B')
            .borderRadius(AdaptiveUtils.scale(16))
            .margin({ left: AdaptiveUtils.spacing(8) })
            .onClick(() => {
              this.deleteTargetId = save.id;
              this.showDeleteConfirm = true;
            })
        }
      }
      .width('100%')
      .padding(AdaptiveUtils.spacing(12))
    }
    .width('100%')
    .backgroundColor('#ffffff')
    .borderRadius(AdaptiveUtils.scale(12))
    .shadow({
      radius: 10,
      color: 'rgba(0,0,0,0.1)',
      offsetX: 0,
      offsetY: 5
    })
  }
  
  // 删除确认对话框
  @Builder
  DeleteConfirmDialog() {
    Column() {
      Column() {
        Text('确认删除')
          .fontSize(AdaptiveUtils.fontSize(18))
          .fontColor('#333333')
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: AdaptiveUtils.spacing(12) })
        
        Text('删除后无法恢复，确定要删除这个存档吗？')
          .fontSize(AdaptiveUtils.fontSize(13))
          .fontColor('#666666')
          .margin({ bottom: AdaptiveUtils.spacing(20) })
        
        Row() {
          Button('取消')
            .width('40%')
            .height(AdaptiveUtils.scale(40))
            .fontSize(AdaptiveUtils.fontSize(14))
            .fontColor('#666666')
            .backgroundColor('#f0f0f0')
            .borderRadius(AdaptiveUtils.scale(20))
            .onClick(() => {
              this.showDeleteConfirm = false;
              this.deleteTargetId = -1;
            })
          
          Blank().width('10%')
          
          Button('确认删除')
            .width('40%')
            .height(AdaptiveUtils.scale(40))
            .fontSize(AdaptiveUtils.fontSize(14))
            .fontColor('#ffffff')
            .backgroundColor('#FF6B6B')
            .borderRadius(AdaptiveUtils.scale(20))
            .onClick(() => {
              this.deleteSave();
            })
        }
        .width('100%')
      }
      .width('80%')
      .padding(AdaptiveUtils.spacing(20))
      .backgroundColor('#ffffff')
      .borderRadius(AdaptiveUtils.scale(16))
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgba(0,0,0,0.5)')
    .justifyContent(FlexAlign.Center)
  }
  
  // 创建存档对话框
  @Builder
  CreateSaveDialog() {
    Column() {
      Column() {
        Text('创建新存档')
          .fontSize(AdaptiveUtils.fontSize(18))
          .fontColor('#333333')
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: AdaptiveUtils.spacing(15) })
        
        TextInput({ placeholder: '输入存档名称', text: this.newSaveName })
          .width('100%')
          .height(AdaptiveUtils.scale(45))
          .fontSize(AdaptiveUtils.fontSize(14))
          .backgroundColor('#f5f5f5')
          .borderRadius(AdaptiveUtils.scale(8))
          .onChange((value: string) => {
            this.newSaveName = value;
          })
          .margin({ bottom: AdaptiveUtils.spacing(20) })
        
        Row() {
          Button('取消')
            .width('40%')
            .height(AdaptiveUtils.scale(40))
            .fontSize(AdaptiveUtils.fontSize(14))
            .fontColor('#666666')
            .backgroundColor('#f0f0f0')
            .borderRadius(AdaptiveUtils.scale(20))
            .onClick(() => {
              this.showCreateDialog = false;
              this.newSaveName = '';
            })
          
          Blank().width('10%')
          
          Button('创建')
            .width('40%')
            .height(AdaptiveUtils.scale(40))
            .fontSize(AdaptiveUtils.fontSize(14))
            .fontColor('#ffffff')
            .backgroundColor('#667eea')
            .borderRadius(AdaptiveUtils.scale(20))
            .onClick(() => {
              this.createNewSave();
            })
        }
        .width('100%')
      }
      .width('80%')
      .padding(AdaptiveUtils.spacing(20))
      .backgroundColor('#ffffff')
      .borderRadius(AdaptiveUtils.scale(16))
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgba(0,0,0,0.5)')
    .justifyContent(FlexAlign.Center)
  }
}
