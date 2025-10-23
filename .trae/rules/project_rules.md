## 项目目标说明
- 开发一个flutter应用，主要用于安卓平台。实现每日推送，ai分析总结后的，订阅的RSS文章和生成的每日播客。


## 项目代码说明
- 项目的主文件在`lib/main.dart`
- 项目的代码结构如下：
  - `lib/`：包含所有dart代码文件
    - `main.dart`：应用的入口文件
    - `pages/`：包含所有页面的代码文件
      - `article_page.dart`：文章详情页面，用于展示文章内容和播放音频
    - `home_page.dart`：应用的主页面，包含每日文章列表和音频播放器
    - `widgets/`：包含所有可复用组件的代码文件
      - `article_card.dart`：文章卡片组件，用于展示文章信息
      - `audio_player.dart`：音频播放器组件，用于播放和控制音频
    - `mock_data.dart`：模拟数据，用于提供文章列表和播客内容