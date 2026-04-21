# DecodePlayControl-master 项目结构分析

## 一、项目根目录结构解析

| 文件/目录          | 作用说明                                                                 |
|---------------------|--------------------------------------------------------------------------|
| `build-profile.json5` | 应用级构建配置：定义全局签名方案、编译模式（debug/release）和目标设备类型 |
| `hvigorfile.ts`     | 应用级构建脚本：定义自定义任务（如代码混淆、资源压缩）                   |
| `oh-package.json5`  | 三方库依赖管理：声明项目依赖的 HarmonyOS Kits 及版本约束                  |
| `oh_modules/`       | 三方库存储目录：存放 `oh-package.json5` 声明的依赖库实际文件              |
| `.gitignore`        | 版本控制排除规则文件（需根据项目补充完整规则）                           |
| `README.md`         | 项目说明文档：包含功能描述、使用方法和注意事项                           |

## 二、entry模块结构解析
entry/
├── src/
│ ├── main/
│ │ ├── ets/
│ │ │ ├── entryability/ # 应用入口能力
│ │ │ │ └── EntryAbility.ets # 应用生命周期管理
│ │ │ ├── pages/ # 页面组件
│ │ │ │ └── Index.ets # 主播放界面
│ │ │ └── utils/ # 工具类
│ │ │ └── AVDecoder.ets # 解码器封装实现
│ │ ├── resources/ # 资源文件
│ │ │ ├── base/
│ │ │ │ ├── element/ # 尺寸/颜色/字符串等资源
│ │ │ │ └── profile/ # 配置文件
│ │ │ ├── media/ # 媒体资源（图标/预览图）
│ │ │ └── rawfile/ # 原始文件（测试视频资源）
│ │ └── module.json5 # 模块配置
│ └── oh-package.json5 # 模块级依赖配置
├── build-profile.json5 # 模块编译配置
└── hvigorfile.ts # 模块构建脚本





## 三、核心文件功能解析

### 1. module.json5（模块配置）
```json5
{
  "module": {
    "name": "entry",
    "type": "entry",
    "description": "主模块",
    "deviceTypes": ["phone", "tablet"],
    "abilities": [
      {
        "name": "EntryAbility",
        "srcEntry": "./ets/entryability/EntryAbility.ets",
        "launchType": "standard",
        "description": "主入口"
      }
    ]
  }
}
2. EntryAbility.ets（应用入口）




import UIAbility from '@ohos.app.ability.UIAbility';

export default class EntryAbility extends UIAbility {
  onCreate() {
    // 初始化视频解码器
    AVDecoder.initDecoder();
    // 创建Surface渲染层
    Window.createWindowSurface(this.context, "video_surface");
  }
}
3. Index.ets（主播放界面）




import AVDecoder from '../utils/AVDecoder';

@Entry
@Component
struct Index {
  private surfaceId: string = ''; // Surface渲染层ID

  aboutToAppear() {
    // 获取Surface ID
    this.surfaceId = AVDecoder.getSurfaceId();
    
    // 加载视频文件
    AVDecoder.loadVideo($rawfile('demo.mp4'));
  }

  build() {
    Column() {
      // 视频渲染Surface
      SurfaceView({
        id: this.surfaceId,
        controller: this.surfaceController
      }).width('100%').height(300)
      
      // 播放控制按钮
      Button('播放').onClick(() => AVDecoder.play())
      Button('暂停').onClick(() => AVDecoder.pause())
    }
  }
}
4. AVDecoder.ets（解码器封装）



import { AVCodec } from '@kit.AVCodecKit';
import { Window } from '@kit.WindowKit';

export class AVDecoder {
  private static decoder: AVCodec;
  private static surfaceId: string = '';

  // 初始化解码器
  static async initDecoder() {
    this.decoder = await AVCodec.createDecoder();
    const surface = await Window.createWindowSurface(getContext(), "video_surface");
    this.surfaceId = surface.getSurfaceId();
    
    this.decoder.configure({
      codecType: CodecComponentType.VIDEO_AVC,
      surfaceId: this.surfaceId // 绑定Surface
    });
  }

  // 获取Surface ID
  static getSurfaceId(): string {
    return this.surfaceId;
  }
}
四、项目依赖与配置
1. SDK版本 (oh-package.json5)




{
  "dependencies": {
    "@kit.AVCodecKit": "1.0.0",   // 视频编解码核心库
    "@kit.AVPlayerKit": "1.0.0",  // 播放控制库
    "@kit.WindowKit": "1.0.0",    // Surface渲染支持
    "@ohos/hilog": "2.0.0"        // 日志系统
  }
}
2. ABI配置 (build-profile.json5)




{
  "apiType": 'faMode',
  "buildOption": {
    "artifactType": "obfuscation",
    "targetAbi": [ "armeabi-v7a", "arm64-v8a" ]
  }
}
3. Surface播放流程



sequenceDiagram
    participant UI as 播放界面
    participant Decoder as AVDecoder
    participant Codec as AVCodecKit
    participant Surface as WindowKit
    
    UI->>Decoder: 初始化播放器
    Decoder->>Codec: createDecoder()
    Decoder->>Surface: createWindowSurface()
    Surface-->>Decoder: 返回surfaceId
    Decoder->>Codec: configure(surfaceId)
    UI->>Decoder: 加载视频(rawfile)
    Decoder->>Codec: 输入视频数据
    Codec->>Surface: 输出解码帧
项目 .gitignore 配置



# DevEco Studio 配置文件
.idea/
*.iml
.local
*.hprof

# 构建产物
build/
*.build
*.log
release/

# 依赖目录
oh_modules/
node_modules/

# 操作系统文件
.DS_Store
Thumbs.db

# 缓存文件
*.tmp
*.bak

# 日志文件
*.log
logs/

# 本地配置文件
local.properties
*.keystore

# 二进制文件
*.apk
*.hap
*.app
*.a