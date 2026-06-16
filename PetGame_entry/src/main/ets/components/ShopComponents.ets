/**
 * 商店组件
 */
import { FOOD_LIST, SKIN_LIST, FoodItem, SkinItem } from '../common/Constants';
import { PathUtils, ColorUtils, AdaptiveUtils } from '../utils/AdaptiveUtils';
import { FoodShapeSelector } from './FoodShapes';

// ==================== 食物商店 ====================
@Component
export struct FoodShop {
  @Prop shopWidth: number = 320;
  @Prop shopHeight: number = 450;
  @Prop coins: number = 500;
  @Prop animationProgress: number = 1;
  onBuyFood: (foodId: number) => void = () => {};
  onClose: () => void = () => {};
  
  build() {
    Column() {
      // 标题栏
      Row() {
        Text('🍽️ 食物商店')
          .fontSize(AdaptiveUtils.fontSize(18))
          .fontColor('#5B21B6')
          .fontWeight(FontWeight.Bold)
        
        Blank()
        
        // 金币显示
        Row() {
          Text('💰')
            .fontSize(AdaptiveUtils.fontSize(12))
          Text(`${this.coins}`)
            .fontSize(AdaptiveUtils.fontSize(12))
            .fontColor('#FFB347')
            .fontWeight(FontWeight.Bold)
            .margin({ left: AdaptiveUtils.spacing(4) })
        }
        .padding({ left: AdaptiveUtils.spacing(8), right: AdaptiveUtils.spacing(8), top: AdaptiveUtils.spacing(4), bottom: AdaptiveUtils.spacing(4) })
        .backgroundColor('#FFF8E7')
        .borderRadius(AdaptiveUtils.spacing(10))
      }
      .width('100%')
      .padding({ left: AdaptiveUtils.spacing(14), right: AdaptiveUtils.spacing(14), bottom: AdaptiveUtils.spacing(10) })
      
      // 食物列表
      List() {
        ForEach(FOOD_LIST, (food: FoodItem) => {
          ListItem() {
            this.FoodItemCard(food)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .divider({ strokeWidth: 1, color: '#EDE9FE', startMargin: AdaptiveUtils.spacing(6), endMargin: AdaptiveUtils.spacing(6) })
      
      // 关闭按钮
      Button('关闭')
        .width('80%')
        .height(AdaptiveUtils.spacing(36))
        .linearGradient({
          angle: 90,
          colors: [['#E0E7FF', 0], ['#C7D2FE', 1]]
        })
        .fontColor('#6366F1')
        .fontWeight(FontWeight.Medium)
        .borderRadius(AdaptiveUtils.spacing(18))
        .margin({ top: AdaptiveUtils.spacing(10) })
        .onClick(() => {
          this.onClose();
        })
    }
    .width(this.shopWidth)
    .height(this.shopHeight)
    .linearGradient({
      angle: 135,
      colors: [['#FFFFFF', 0], ['#F5F3FF', 1]]
    })
    .borderRadius(AdaptiveUtils.spacing(16))
    .padding(AdaptiveUtils.spacing(14))
    .shadow({
      radius: 24,
      color: 'rgba(139, 92, 246, 0.25)',
      offsetX: 0,
      offsetY: 8
    })
    .translate({ x: this.shopWidth * (1 - this.animationProgress) })
    .opacity(this.animationProgress)
  }
  
  @Builder
  FoodItemCard(food: FoodItem) {
    Row() {
      // 食物图标
      Stack() {
        Shape() {
          Path()
            .width(AdaptiveUtils.spacing(48))
            .height(AdaptiveUtils.spacing(48))
            .commands(PathUtils.circle(AdaptiveUtils.spacing(24), AdaptiveUtils.spacing(24), AdaptiveUtils.spacing(24)))
            .fill('#F5F3FF')
        }
        .width(AdaptiveUtils.spacing(48))
        .height(AdaptiveUtils.spacing(48))
        
        FoodShapeSelector({ foodId: food.id, foodSize: AdaptiveUtils.spacing(36) })
      }
      .width(AdaptiveUtils.spacing(48))
      .height(AdaptiveUtils.spacing(48))
      
      Column() {
        Text(food.name)
          .fontSize(AdaptiveUtils.fontSize(13))
          .fontColor('#333333')
          .fontWeight(FontWeight.Bold)
        
        Text(food.description)
          .fontSize(AdaptiveUtils.fontSize(11))
          .fontColor('#999999')
          .margin({ top: AdaptiveUtils.spacing(2) })
        
        Text(`🍖 +${food.hungerValue}`)
          .fontSize(AdaptiveUtils.fontSize(10))
          .fontColor('#22C55E')
          .fontWeight(FontWeight.Medium)
          .margin({ top: AdaptiveUtils.spacing(2) })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({ left: AdaptiveUtils.spacing(10) })
      
      // 购买按钮
      Column() {
        Row() {
          Text('💰')
            .fontSize(AdaptiveUtils.fontSize(10))
          Text(`${food.price}`)
            .fontSize(AdaptiveUtils.fontSize(11))
            .fontColor(this.coins >= food.price ? '#FFB347' : '#999999')
            .fontWeight(FontWeight.Bold)
            .margin({ left: AdaptiveUtils.spacing(2) })
        }
        
        Button('购买')
          .width(AdaptiveUtils.spacing(44))
          .height(AdaptiveUtils.spacing(24))
          .fontSize(AdaptiveUtils.fontSize(10))
          .linearGradient({
            angle: 90,
            colors: this.coins >= food.price 
              ? [['#EC4899', 0], ['#F472B6', 1]]
              : [['#E5E7EB', 0], ['#D1D5DB', 1]]
          })
          .fontColor('#FFFFFF')
          .borderRadius(AdaptiveUtils.spacing(12))
          .margin({ top: AdaptiveUtils.spacing(5) })
          .enabled(this.coins >= food.price)
          .onClick(() => {
            this.onBuyFood(food.id);
          })
      }
      .width(AdaptiveUtils.spacing(54))
    }
    .width('100%')
    .padding({ top: AdaptiveUtils.spacing(8), bottom: AdaptiveUtils.spacing(8) })
  }
}

// ==================== 皮肤商店 ====================
@Component
export struct SkinShop {
  @Prop shopWidth: number = 320;
  @Prop shopHeight: number = 450;
  @Prop coins: number = 500;
  @Prop ownedSkins: number[] = [0];
  @Prop currentSkinId: number = 0;
  @Prop animationProgress: number = 1;
  onBuySkin: (skinId: number) => void = () => {};
  onWearSkin: (skinId: number) => void = () => {};
  onClose: () => void = () => {};
  
  build() {
    Column() {
      // 标题栏
      Row() {
        Text('👗 皮肤商店')
          .fontSize(AdaptiveUtils.fontSize(18))
          .fontColor('#5B21B6')
          .fontWeight(FontWeight.Bold)
        
        Blank()
        
        // 金币显示
        Row() {
          Text('💰')
            .fontSize(AdaptiveUtils.fontSize(12))
          Text(`${this.coins}`)
            .fontSize(AdaptiveUtils.fontSize(12))
            .fontColor('#FFB347')
            .fontWeight(FontWeight.Bold)
            .margin({ left: AdaptiveUtils.spacing(4) })
        }
        .padding({ left: AdaptiveUtils.spacing(8), right: AdaptiveUtils.spacing(8), top: AdaptiveUtils.spacing(4), bottom: AdaptiveUtils.spacing(4) })
        .backgroundColor('#FFF8E7')
        .borderRadius(AdaptiveUtils.spacing(10))
      }
      .width('100%')
      .padding({ left: AdaptiveUtils.spacing(14), right: AdaptiveUtils.spacing(14), bottom: AdaptiveUtils.spacing(10) })
      
      // 皮肤列表
      List() {
        ForEach(SKIN_LIST, (skin: SkinItem) => {
          ListItem() {
            this.SkinItemCard(skin)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .divider({ strokeWidth: 1, color: '#EDE9FE', startMargin: AdaptiveUtils.spacing(6), endMargin: AdaptiveUtils.spacing(6) })
      
      // 关闭按钮
      Button('关闭')
        .width('80%')
        .height(AdaptiveUtils.spacing(36))
        .linearGradient({
          angle: 90,
          colors: [['#E0E7FF', 0], ['#C7D2FE', 1]]
        })
        .fontColor('#6366F1')
        .fontWeight(FontWeight.Medium)
        .borderRadius(AdaptiveUtils.spacing(18))
        .margin({ top: AdaptiveUtils.spacing(10) })
        .onClick(() => {
          this.onClose();
        })
    }
    .width(this.shopWidth)
    .height(this.shopHeight)
    .linearGradient({
      angle: 135,
      colors: [['#FFFFFF', 0], ['#F5F3FF', 1]]
    })
    .borderRadius(AdaptiveUtils.spacing(16))
    .padding(AdaptiveUtils.spacing(14))
    .shadow({
      radius: 24,
      color: 'rgba(139, 92, 246, 0.25)',
      offsetX: 0,
      offsetY: 8
    })
    .translate({ x: this.shopWidth * (1 - this.animationProgress) })
    .opacity(this.animationProgress)
  }
  
  @Builder
  SkinItemCard(skin: SkinItem) {
    Row() {
      // 皮肤预览色块
      Stack() {
        Shape() {
          Path()
            .width(AdaptiveUtils.spacing(42))
            .height(AdaptiveUtils.spacing(42))
            .commands(PathUtils.circle(AdaptiveUtils.spacing(21), AdaptiveUtils.spacing(21), AdaptiveUtils.spacing(21)))
            .fill(this.getSkinColor(skin.id))
        }
        .width(AdaptiveUtils.spacing(42))
        .height(AdaptiveUtils.spacing(42))
        .shadow({
          radius: 8,
          color: this.getSkinColor(skin.id) + '40',
          offsetX: 0,
          offsetY: 2
        })
        
        if (this.currentSkinId === skin.id) {
          Shape() {
            Path()
              .width(AdaptiveUtils.spacing(48))
              .height(AdaptiveUtils.spacing(48))
              .commands(PathUtils.circle(AdaptiveUtils.spacing(24), AdaptiveUtils.spacing(24), AdaptiveUtils.spacing(24)))
              .stroke('#FFB347')
              .strokeWidth(3)
          }
          .width(AdaptiveUtils.spacing(48))
          .height(AdaptiveUtils.spacing(48))
        }
      }
      .width(AdaptiveUtils.spacing(48))
      .height(AdaptiveUtils.spacing(48))
      
      Column() {
        Text(skin.name)
          .fontSize(AdaptiveUtils.fontSize(13))
          .fontColor('#333333')
          .fontWeight(FontWeight.Bold)
        
        Text(skin.description)
          .fontSize(AdaptiveUtils.fontSize(11))
          .fontColor('#999999')
          .margin({ top: AdaptiveUtils.spacing(2) })
        
        // 拥有状态
        if (this.ownedSkins.includes(skin.id)) {
          Row() {
            Text('✓')
              .fontSize(AdaptiveUtils.fontSize(9))
              .fontColor('#FFFFFF')
          }
          .width(AdaptiveUtils.spacing(12))
          .height(AdaptiveUtils.spacing(12))
          .backgroundColor('#22C55E')
          .borderRadius(AdaptiveUtils.spacing(6))
          .margin({ top: AdaptiveUtils.spacing(4) })
        }
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({ left: AdaptiveUtils.spacing(10) })
      
      // 操作按钮
      if (this.ownedSkins.includes(skin.id)) {
        // 已拥有：穿戴/脱卸
        Button(this.currentSkinId === skin.id ? '脱卸' : '穿戴')
          .width(AdaptiveUtils.spacing(44))
          .height(AdaptiveUtils.spacing(26))
          .fontSize(AdaptiveUtils.fontSize(10))
          .linearGradient({
            angle: 90,
            colors: this.currentSkinId === skin.id 
              ? [['#E5E7EB', 0], ['#D1D5DB', 1]]
              : [['#A855F7', 0], ['#C084FC', 1]]
          })
          .fontColor(this.currentSkinId === skin.id ? '#666666' : '#FFFFFF')
          .borderRadius(AdaptiveUtils.spacing(13))
          .onClick(() => {
            this.onWearSkin(skin.id);
          })
      } else {
        // 未拥有：购买
        Column() {
          Row() {
            Text('💰')
              .fontSize(AdaptiveUtils.fontSize(10))
            Text(`${skin.price}`)
              .fontSize(AdaptiveUtils.fontSize(11))
              .fontColor(this.coins >= skin.price ? '#FFB347' : '#999999')
              .fontWeight(FontWeight.Bold)
              .margin({ left: AdaptiveUtils.spacing(2) })
          }
          
          Button('购买')
            .width(AdaptiveUtils.spacing(44))
            .height(AdaptiveUtils.spacing(24))
            .fontSize(AdaptiveUtils.fontSize(10))
            .linearGradient({
              angle: 90,
              colors: this.coins >= skin.price 
                ? [['#A855F7', 0], ['#C084FC', 1]]
                : [['#E5E7EB', 0], ['#D1D5DB', 1]]
            })
            .fontColor('#FFFFFF')
            .borderRadius(AdaptiveUtils.spacing(12))
            .margin({ top: AdaptiveUtils.spacing(5) })
            .enabled(this.coins >= skin.price && skin.price > 0)
            .onClick(() => {
              this.onBuySkin(skin.id);
            })
        }
        .width(AdaptiveUtils.spacing(54))
      }
    }
    .width('100%')
    .padding({ top: AdaptiveUtils.spacing(8), bottom: AdaptiveUtils.spacing(8) })
  }
  
  private getSkinColor(skinId: number): string {
    const colors = ['#FF8C69', '#9B59B6', '#FFB6C1', '#E74C3C', '#1ABC9C'];
    return colors[skinId] || colors[0];
  }
}
