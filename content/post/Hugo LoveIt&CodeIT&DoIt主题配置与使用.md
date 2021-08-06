---
title: "Hugo LoveIt&CodeIT&DoIt主题配置与使用"
slug: "hugo-theme-loveit"
date: 2020-06-03T22:44:25+08:00
lastmod: 2021-08-06T22:44:25+08:00
draft: false
toc: true
weight: false
categories: ["建站笔记"]
tags: ["hugo"]
---

  ## 安装主题

把这个主题克隆到 `themes` 目录:

```
git clone https://github.com/dillonzq/LoveIt.git themes/LoveIt
```

## 配置主题

### 站点配置文件的修改

将`根目录\themes\LoveIt\exampleSite`路径下的`config.toml`文件复制到根目录下，覆盖掉根目录下的`config.toml`文件。然后，我们在notepad++中打开并对其作一定的修改就可以直接使用，具体可以修改的内容如下：

```
baseURL = "https://bore.vip/"
# [en, zh-cn, fr, ...] 设置默认的语言
defaultContentLanguage = "zh-cn"
# 网站语言, 仅在这里 CN 大写
languageCode = "zh-CN"
# 是否包括中日韩文字
hasCJKLanguage = true
# 主题
theme = "CodeIT"
# 网站标题
title = "Bore's Notes"
# 是否使用 robots.txt
enableRobotsTXT = true
# 是否使用 git 信息
enableGitInfo = true
# 是否使用 emoji 代码
enableEmoji = true

# 菜单配置
[menu]
  [[menu.main]]
    identifier = "posts"
    # 你可以在名称 (允许 HTML 格式) 之前添加其他信息, 例如图标
    pre = ""
    # 你可以在名称 (允许 HTML 格式) 之后添加其他信息, 例如图标
    post = ""
    name = "归档"
    url = "/posts/"
    # 当你将鼠标悬停在此菜单链接上时, 将显示的标题
    title = ""
    weight = 4
  [[menu.main]]
    identifier = "home"
    pre = ""
    post = ""
    name = "首页"
    url = "/"
    title = ""
    weight = 1
  [[menu.main]]
    identifier = "categories"
    pre = ""
    post = ""
    name = "分类"
    url = "/categories/"
    title = ""
    weight = 2
  [[menu.main]]
    identifier = "tags"
    pre = ""
    post = ""
    name = "标签"
    url = "/tags/"
    title = ""
    weight = 3
    [[menu.main]]
    identifier = "about"
    pre = ""
    post = ""
    name = "关于"
    url = "/about/"
    title = ""
    weight = 5
  [[menu.main]]
    identifier = "links"
    pre = ""
    post = ""
    name = "友链"
    url = "/links/"
    title = ""
    weight = 6
	
[params]
  # CodeIT 主题版本
  version = "0.2.X"
  # 网站描述
  description = "本站主要用来收集整理资料、记录笔记，方便自己查询使用。"
  # 网站关键词
  keywords = ["个人博客", "个人网站","Bore's Note","hugo"]
  # 网站默认主题样式 ("light", "dark", "auto")
  defaultTheme = "auto"
  # 公共 git 仓库路径，仅在 enableGitInfo 设为 true 时有效
  gitRepo = "https://github.com/iwyang/iwyang.github.io"
  #  哪种哈希函数用来 SRI, 为空时表示不使用 SRI
  # ("sha256", "sha384", "sha512", "md5")
  fingerprint = ""
  #  日期格式
  dateFormat = "2006-01-02"
  # 网站图片, 用于 Open Graph 和 Twitter Cards
  images = ["/logo.png"]
	
 #  应用图标配置
  [params.app]
    # 当添加到 iOS 主屏幕或者 Android 启动器时的标题, 覆盖默认标题
    title = "Bore's Note"
    # 是否隐藏网站图标资源链接
    noFavicon = false
    # 更现代的 SVG 网站图标, 可替代旧的 .png 和 .ico 文件
    svgFavicon = ""
    # Android 浏览器主题色
    themeColor = "#ffffff"
    # Safari 图标颜色
    iconColor = "#5bbad5"
    # Windows v8-10磁贴颜色
    tileColor = "#da532c"

  #  搜索配置
  [params.search]
    enable = true
    # 搜索引擎的类型 ("lunr", "algolia")
    type = "algolia"
    # 文章内容最长索引长度
    contentLength = 4000
    # 搜索框的占位提示语
    placeholder = ""
    #  最大结果数目
    maxResultLength = 10
    #  结果内容片段长度
    snippetLength = 50
    #  搜索结果中高亮部分的 HTML 标签
    highlightTag = "em"
    #  是否在搜索索引中使用基于 baseURL 的绝对路径
    absoluteURL = false
    [params.search.algolia]
      index = "hugo"
      appID = "R7GU8Q3PGK"
      searchKey = "03cd2f39cefdd4b40deed2f1222ad496"

  # 页面头部导航栏配置
  [params.header]
    # 桌面端导航栏模式 ("fixed", "normal", "auto")
    desktopMode = "fixed"
    # 移动端导航栏模式 ("fixed", "normal", "auto")
    mobileMode = "auto"
    #  页面头部导航栏标题配置
    [params.header.title]
      # LOGO 的 URL
      logo = ""
      # 标题名称
      name = "Bore's Notes"
      # 你可以在名称 (允许 HTML 格式) 之前添加其他信息, 例如图标
      pre = ""
      # 你可以在名称 (允许 HTML 格式) 之后添加其他信息, 例如图标
      post = ""
      #  是否为标题显示打字机动画
      typeit = false

  # 页面底部信息配置
  [params.footer]
    enable = true
    #  自定义内容 (支持 HTML 格式)
    custom = ''
    #  是否显示 Hugo 和主题信息
    hugo = true
    #  是否显示版权信息
    copyright = true
    #  是否显示作者
    author = true
    # 网站创立年份
    since = 2020
    # ICP 备案信息，仅在中国使用 (支持 HTML 格式)
    icp = ""
    # 许可协议信息 (支持 HTML 格式)
    license = '<a rel="license external nofollow noopener noreffer" href="https://creativecommons.org/licenses/by-nc/4.0/" target="_blank">CC BY-NC 4.0</a>'

  #  Section (所有文章) 页面配置
  [params.section]
    # section 页面每页显示文章数量
    paginate = 10000
    # 日期格式 (月和日)
    dateFormat = "01-02"
    # RSS 文章数目
    rss = 10

  #  List (目录或标签) 页面配置
  [params.list]
    # list 页面每页显示文章数量
    paginate = 20
    # 日期格式 (月和日)
    dateFormat = "01-02"
    # RSS 文章数目
    rss = 10

  # 主页配置
  [params.home]
    #  RSS 文章数目
    rss = 10
    # 主页个人信息
    [params.home.profile]
      enable = true
      # Gravatar 邮箱，用于优先在主页显示的头像
      gravatarEmail = ""
      # 主页显示头像的 URL
      avatarURL = "/images/avatar.jpg"
      #  主页显示的网站标题 (支持 HTML 格式)
      title = ""
      # 主页显示的网站副标题
      subtitle = "博观而约取，厚积而薄发"
      # CodeIT 更改 | 0.1.1 (HTML format is supported)
      # 是否为副标题显示打字机动画
      typeit = true
      # 是否显示社交账号
      social = false
      #  免责声明 (支持 HTML 格式)
      disclaimer = ""
    # 主页文章列表
    [params.home.posts]
      enable = true
      # 主页每页显示文章数量
      paginate = 10
      #  被 params.page 中的 hiddenFromHomePage 替代
      # 当你没有在文章前置参数中设置 "hiddenFromHomePage" 时的默认行为
      defaultHiddenFromHomePage = false

  # 作者的社交信息设置
  [params.social]
    GitHub = "iwyang"
    Linkedin = ""
    Twitter = ""
    Instagram = ""
    Facebook = ""
    Telegram = "iwyang"
    Medium = ""
    Gitlab = ""
    Youtubelegacy = ""
    Youtubecustom = ""
    Youtubechannel = ""
    Tumblr = ""
    Quora = ""
    Keybase = ""
    Pinterest = ""
    Reddit = ""
    Codepen = ""
    FreeCodeCamp = ""
    Bitbucket = ""
    Stackoverflow = ""
    Weibo = ""
    Odnoklassniki = ""
    VK = ""
    Flickr = ""
    Xing = ""
    Snapchat = ""
    Soundcloud = ""
    Spotify = ""
    Bandcamp = ""
    Paypal = ""
    Fivehundredpx = ""
    Mix = ""
    Goodreads = ""
    Lastfm = ""
    Foursquare = ""
    Hackernews = ""
    Kickstarter = ""
    Patreon = ""
    Steam = ""
    Twitch = ""
    Strava = ""
    Skype = ""
    Whatsapp = ""
    Zhihu = ""
    Douban = ""
    Angellist = ""
    Slidershare = ""
    Jsfiddle = ""
    Deviantart = ""
    Behance = ""
    Dribbble = ""
    Wordpress = ""
    Vine = ""
    Googlescholar = ""
    Researchgate = ""
    Mastodon = ""
    Thingiverse = ""
    Devto = ""
    Gitea = ""
    XMPP = ""
    Matrix = ""
    Bilibili = "iwyang"
    Email = "xxxx@xxxx.com"
    RSS = true
    # CodeIT 新增 | 0.1.2 Open Researcher and Contributor ID
    Orcid = ""

  #  文章页面配置
  [params.page]
    #  是否在主页隐藏一篇文章
    hiddenFromHomePage = false
    #  是否在搜索结果中隐藏一篇文章
    hiddenFromSearch = false
    #  是否使用 twemoji
    twemoji = false
    # 是否使用 lightgallery
    lightgallery = false
    #  是否使用 ruby 扩展语法
    ruby = true
    #  是否使用 fraction 扩展语法
    fraction = true
    #  是否使用 fontawesome 扩展语法
    fontawesome = true
    # 是否在文章页面显示原始 Markdown 文档链接
    linkToMarkdown = true
    #  是否在 RSS 中显示全文内容
    rssFullText = false
    #  目录配置
    [params.page.toc]
      # 是否使用目录
      enable = true
      #  是否保持使用文章前面的静态目录
      keepStatic = false
      # 是否使侧边目录自动折叠展开
      auto = true
    #  代码配置
    [params.page.code]
      # 是否显示代码块的复制按钮
      copy = true
      # 默认展开显示的代码行数
      maxShownLines = 10
    # KaTeX 数学公式
    [params.page.math]
      enable = true
      # 默认块定界符是 $$ ... $$ 和 \\[ ... \\]
      blockLeftDelimiter = ""
      blockRightDelimiter = ""
      # 默认行内定界符是 $ ... $ 和 \\( ... \\)
      inlineLeftDelimiter = ""
      inlineRightDelimiter = ""
      # KaTeX 插件 copy_tex
      copyTex = true
      # KaTeX 插件 mhchem
      mhchem = true
    # Mapbox GL JS 配置
    [params.page.mapbox]
      # Mapbox GL JS 的 access token
      accessToken = ""
      # 浅色主题的地图样式
      lightStyle = "mapbox://styles/mapbox/light-v9"
      # 深色主题的地图样式
      darkStyle = "mapbox://styles/mapbox/dark-v9"
      # 是否添加 NavigationControl
      navigation = true
      # 是否添加 GeolocateControl
      geolocate = true
      # 是否添加 ScaleControl
      scale = true
      # 是否添加 FullscreenControl
      fullscreen = true
    #  文章页面的分享信息设置
    [params.page.share]
      enable = false
      Twitter = true
      Facebook = true
      Linkedin = false
      Whatsapp = true
      Pinterest = false
      Tumblr = false
      HackerNews = false
      Reddit = false
      VK = false
      Buffer = false
      Xing = false
      Line = true
      Instapaper = false
      Pocket = false
      Digg = false
      Stumbleupon = false
      Flipboard = false
      Weibo = true
      Renren = false
      Myspace = true
      Blogger = true
      Baidu = false
      Odnoklassniki = false
      Evernote = true
      Skype = false
      Trello = false
      Mix = false
      # CodeIT 新增 | 0.1.2
      Telegram = false
    #  评论系统设置
    [params.page.comment]
      enable = true
      # Disqus 评论系统设置
      [params.page.comment.disqus]
        enable = false
        # Disqus 的 shortname，用来在文章中启用 Disqus 评论系统
        shortname = ""
      # Gitalk 评论系统设置
      [params.page.comment.gitalk]
        enable = false
        owner = ""
        repo = ""
        clientId = ""
        clientSecret = ""
      # Valine 评论系统设置
      [params.page.comment.valine]
        enable = false
        appId = ""
        appKey = ""
        placeholder = ""
        avatar = "mp"
        meta= ['nick','mail']
        pageSize = 10
        lang = ""
        visitor = true
        recordIP = true
        highlight = true
        enableQQ = false
        serverURLs = ""
        #  emoji 数据文件名称, 默认是 "google.yml"
        # ("apple.yml", "google.yml", "facebook.yml", "twitter.yml")
        # 位于 "themes/CodeIT/assets/data/emoji/" 目录
        # 可以在你的项目下相同路径存放你自己的数据文件:
        # "assets/data/emoji/"
        emoji = ""
      # Facebook 评论系统设置
      [params.page.comment.facebook]
        enable = false
        width = "100%"
        numPosts = 10
        appId = ""
        languageCode = "zh_CN"
      # Telegram Comments 评论系统设置
      [params.page.comment.telegram]
        enable = false
        siteID = ""
        limit = 5
        height = ""
        color = ""
        colorful = true
        dislikes = false
        outlined = false
      # Commento 评论系统设置
      [params.page.comment.commento]
        enable = false
      # Utterances 评论系统设置
      [params.page.comment.utterances]
        enable = true
        # owner/repo
        repo = "iwyang/comments"
        issueTerm = "title"
        label = ""
        lightTheme = "github-light"
        darkTheme = "github-dark"
    #  第三方库配置
    [params.page.library]
      [params.page.library.css]
        # someCSS = "some.css"
        # 位于 "assets/"
        # 或者
        # someCSS = "https://cdn.example.com/some.css"
      [params.page.library.js]
        # someJavascript = "some.js"
        # 位于 "assets/"
        # 或者
        # someJavascript = "https://cdn.example.com/some.js"
    #  页面 SEO 配置
    [params.page.seo]
      # 图片 URL
      images = []
      # 出版者信息
      [params.page.seo.publisher]
        name = ""
        logoUrl = ""

  #  TypeIt 配置
  [params.typeit]
    # 每一步的打字速度 (单位是毫秒)
    speed = 100
    # 光标的闪烁速度 (单位是毫秒)
    cursorSpeed = 1000
    # 光标的字符 (支持 HTML 格式)
    cursorChar = "|"
    # 打字结束之后光标的持续时间 (单位是毫秒, "-1" 代表无限大)
    duration = -1

  # 网站验证代码，用于 Google/Bing/Yandex/Pinterest/Baidu
  [params.verification]
    google = ""
    bing = ""
    yandex = ""
    pinterest = ""
    baidu = ""

  #  网站 SEO 配置
  [params.seo]
    # 图片 URL
    image = ""
    # 缩略图 URL
    thumbnailUrl = ""

  #  网站分析配置
  [params.analytics]
    enable = false
    # Google Analytics
    [params.analytics.google]
      id = ""
      # 是否匿名化用户 IP
      anonymizeIP = true
    # Fathom Analytics
    [params.analytics.fathom]
      id = ""
      # 自行托管追踪器时的主机路径
      server = ""
    # CodeIT 新增 | 0.1.0 Plausible Analytics
    [params.analytics.plausible]
      domain = ""

  #  Cookie 许可配置
  [params.cookieconsent]
    enable = false
    # 用于 Cookie 许可横幅的文本字符串
    [params.cookieconsent.content]
      message = ""
      dismiss = ""
      link = ""

  #  第三方库文件的 CDN 设置
  [params.cdn]
    # CDN 数据文件名称, 默认不启用
    # ("jsdelivr.yml")
    # 位于 "themes/CodeIT/assets/data/cdn/" 目录
    # 可以在你的项目下相同路径存放你自己的数据文件:
    # "assets/data/cdn/"
    data = ""

  #  兼容性设置
  [params.compatibility]
    # 是否使用 Polyfill.io 来兼容旧式浏览器
    polyfill = false
    # 是否使用 object-fit-images 来兼容旧式浏览器
    objectFit = false

# Hugo 解析文档的配置
[markup]
  # 语法高亮设置
  [markup.highlight]
    codeFences = true
    guessSyntax = true
    lineNos = true
    lineNumbersInTable = true
    # false 是必要的设置
    # (https://github.com/sunt-programator/CodeIT/issues/158)
    noClasses = false
  # Goldmark 是 Hugo 0.60 以来的默认 Markdown 解析库
  [markup.goldmark]
    [markup.goldmark.extensions]
      definitionList = true
      footnote = true
      linkify = true
      strikethrough = true
      table = true
      taskList = true
      typographer = true
    [markup.goldmark.renderer]
      # 是否在文档中直接使用 HTML 标签
      unsafe = true
  # 目录设置
  [markup.tableOfContents]
    startLevel = 2
    endLevel = 6

# 作者配置
[author]
  name = "bore"
  email = "iwyang@qq.com"
  link = "https://bore.vip"

# 网站地图配置
[sitemap]
  changefreq = "weekly"
  filename = "sitemap.xml"
  priority = 0.5

# Permalinks 配置
[Permalinks]
  # posts = ":year/:month/:filename"
  posts = "/posts/:slug"

# 隐私信息配置
[privacy]
  #  Google Analytics 相关隐私 (被 params.analytics.google 替代)
  [privacy.googleAnalytics]
    # ...
  [privacy.twitter]
    enableDNT = true
  [privacy.youtube]
    privacyEnhanced = true

# 用于输出 Markdown 格式文档的设置
[mediaTypes]
  [mediaTypes."text/plain"]
    suffixes = ["md"]

# 用于输出 Markdown 格式文档的设置
[outputFormats.MarkDown]
  mediaType = "text/plain"
  isPlainText = true
  isHTML = false

# 用于 Hugo 输出文档的设置
[outputs]
  home = ["HTML", "RSS", "JSON"]
  page = ["HTML", "MarkDown"]
  section = ["HTML", "RSS"]
  taxonomy = ["HTML", "RSS"]
  taxonomyTerm = ["HTML"]
```

**注意**：

1. 如果固定链接设置为`posts = "/posts/:slug"`，文章的分类和标签都不能为空，否则会报错！
2. 如果要在菜单前面加图标，格式是`pre = "<i class='fa fa-fw fa-home'></i>"`，`'fa fa-fw fa-home'`是单引号，不是双引号。

### 默认文章模板的修改

将`根目录\archetypes`下的`default.md`修改如下：

```yaml
title: "{{ replace .TranslationBaseName "-" " " | title }}"
slug: ""
date: {{ .Date }}
lastmod: {{ .Date }}
draft: false
toc: true
weight: false
categories: [""]
tags: [""]
```

### LoveIt主题官方前置参数

```yaml
---
title: "我的第一篇文章"
subtitle: ""
date: 2020-03-04T15:58:26+08:00
lastmod: 2020-03-04T15:58:26+08:00
draft: true
author: ""
authorLink: ""
description: ""
license: ""
images: []

tags: []
categories: []
featuredImage: ""
featuredImagePreview: ""

hiddenFromHomePage: false
hiddenFromSearch: false
twemoji: false
lightgallery: true
ruby: true
fraction: true
fontawesome: true
linkToMarkdown: true
rssFullText: false

toc:
  enable: true
  auto: true
code:
  copy: true
  # ...
math:
  enable: true
  # ...
mapbox:
  accessToken: ""
  # ...
share:
  enable: true
  # ...
comment:
  enable: true
  # ...
library:
  css:
    # someCSS = "some.css"
    # 位于 "assets/"
    # 或者
    # someCSS = "https://cdn.example.com/some.css"
  js:
    # someJS = "some.js"
    # 位于 "assets/"
    # 或者
    # someJS = "https://cdn.example.com/some.js"
seo:
  images: []
  # ...
---
```

+ **title**: 文章标题.
+ **subtitle**: 文章副标题.
+ **date**: 这篇文章创建的日期时间. 它通常是从文章的前置参数中的 date 字段获取的, 但是也可以在 网站配置 中设置.
+ **lastmod**: 上次修改内容的日期时间.
+ **draft**: 如果设为 `true`, 除非 `hugo` 命令使用了 `--buildDrafts`/`-D` 参数, 这篇文章不会被渲染.
+ **author**: 文章作者.
+ **authorLink**: 文章作者的链接.
+ **description**: 文章内容的描述.
+ **license**: 这篇文章特殊的许可.
+ **images**: 页面图片, 用于 Open Graph 和 Twitter Cards.
+ **tags**: 文章的标签.
+ **categories**: 文章所属的类别.
+ **featuredImage**: 文章的特色图片.
+ **featuredImagePreview**: 用在主页预览的文章特色图片.
+ **hiddenFromHomePage**: 如果设为 `true`, 这篇文章将不会显示在主页上.
+ **hiddenFromSearch**: 如果设为 true, 这篇文章将不会显示在搜索结果中.
+ **twemoji**: 如果设为 true, 这篇文章会使用 twemoji.
+ **lightgallery**: 如果设为 `true`, 文章中的图片将可以按照画廊形式呈现.
+ **ruby**: 如果设为 true, 这篇文章会使用 上标注释扩展语法.
+ **fraction**: 如果设为 true, 这篇文章会使用 分数扩展语法.
+ fontawesome: 如果设为 true, 这篇文章会使用 Font Awesome 扩展语法.
+ **linkToMarkdown**: 如果设为 `true`, 内容的页脚将显示指向原始 Markdown 文件的链接.
+ **rssFullText**: 如果设为 true, 在 RSS 中将会显示全文内容.
+ **toc**: 和[网站配置](https://hugoloveit.com/zh-cn/theme-documentation-basics#site-configuration) 中的 params.page.toc 部分相同.
+ **code**: 和[网站配置](https://hugoloveit.com/zh-cn/theme-documentation-basics#site-configuration) 中的 params.page.code 部分相同.
+ **math**: 和[网站配置](https://hugoloveit.com/zh-cn/theme-documentation-basics#site-configuration) 中的 params.page.math 部分相同.
+ **mapbox**: 和[网站配置](https://hugoloveit.com/zh-cn/theme-documentation-basics#site-configuration) 中的 params.page.mapbox 部分相同.
+ **share**: 和 [网站配置](https://hugoloveit.com/zh-cn/theme-documentation-basics#site-configuration) 中的 `params.page.share` 部分相同.
+ **comment**: 和[网站配置](https://hugoloveit.com/zh-cn/theme-documentation-basics#site-configuration) 中的 params.page.comment 部分相同.
+ **library**: 和[网站配置](https://hugoloveit.com/zh-cn/theme-documentation-basics#site-configuration)中的 params.page.library 部分相同.
+ **seo**: 和[网站配置](https://hugoloveit.com/zh-cn/theme-documentation-basics#site-configuration)中的 params.page.seo 部分相同.

### 添加友情链接 shortcodes

> 在前辈大佬的基础上，为本博客使用的主题实现友链卡片功能，并加入简单的移动页面适配。代码借鉴来自 [kissshot](https://github.com/kkkgo/hugo-friendlinks/) 和 [数学小兵儿](https://github.com/MatNoble/hugo-shortcodes-sets/) 两位大佬。

#### 第一种方法

##### 代码部分

`LoveIt/layouts/shortcodes/` 下面新建 `friend.html` 文件：

```html
{{ if .IsNamedParams }}
<a target="_blank" href={{ .Get "url" }} title={{ .Get "name" }} class="friendurl">
  <div class="frienddiv">
    <div class="frienddivleft">
      <img class="myfriend" src={{ .Get "logo" }} />
    </div>
    <div class="frienddivright">
      <div class="friendname">{{ .Get "name" }}</div>
      <div class="friendinfo">{{ .Get "word" }}</div>
    </div>
  </div>
</a>
{{ end }}
```

`LoveIt/assets/css/_partial/_single/` 下面新建 `_friend.scss` 文件：

```css
.friendurl {
 text-decoration: none !important;
 color: black;
}

.myfriend {
 width: 56px !important;
 height: 56px !important;
 border-radius: 50%;
 border: 1px solid #ddd;
 padding: 2px;
 box-shadow: 1px 1px 1px rgba(0, 0, 0, 0.15);
 margin-top: 14px !important;
 margin-left: 14px !important;
 background-color: #fff;
}

.frienddiv {
 height: 92px;
 margin-top: 10px;
 width: 48%;
 display: inline-block !important;
 border-radius: 5px;
 background: rgba(255, 255, 255, 0.2);
 box-shadow: 4px 4px 2px 1px rgba(0, 0, 255, 0.2);
}

.frienddiv:hover {
 background: rgba(87, 142, 224, 0.15);
}

.frienddiv:hover .frienddivleft img {
 transition: 0.9s !important;
 -webkit-transition: 0.9s !important;
 -moz-transition: 0.9s !important;
 -o-transition: 0.9s !important;
 -ms-transition: 0.9s !important;
 transform: rotate(360deg) !important;
 -webkit-transform: rotate(360deg) !important;
 -moz-transform: rotate(360deg) !important;
 -o-transform: rotate(360deg) !important;
 -ms-transform: rotate(360deg) !important;
}

.frienddivleft {
 width: 92px;
 float: left;
}

.frienddivleft {
 margin-right: 2px;
}

.frienddivright {
 margin-top: 18px;
 margin-right: 18px;
}

.friendname {
 text-overflow: ellipsis;
 overflow: hidden;
 white-space: nowrap;
}

.friendinfo {
 text-overflow: ellipsis;
 overflow: hidden;
 white-space: nowrap;
}

@media screen and (max-width: 600px) {
 .friendinfo {
  display: none;
 }
 .frienddivleft {
  width: 84px;
  margin: auto;
 }
 .frienddivright {
  height: 100%;
  margin: auto;
  display: flex;
  align-items: center;
  justify-content: center;
 }
 .friendname {
  font-size: 14px;
 }
}
```

`LoveIt/assets/css/_page/` 下面修改 `_single.scss`，引入下面一行：

```scss
@import "../_partial/_single/friend";
```

##### 展示效果

使用示例：

```markdown
{{</* friend name="Bore" url="https://bore.vip/" logo="https://cdn.jsdelivr.net/gh/iwyang/pic/avatar.jpg" word="博观而约取，厚积而薄发" */>}} 
```

![](https://cdn.jsdelivr.net/gh/iwyang/pic/20210715233435.jpg)

**注意**：可以用`/* */`来阻止渲染

![](https://cdn.jsdelivr.net/gh/iwyang/pic/20210717161923.png)



#### 第二种方法

2021.7.17 目前采用的就是这种方法。

##### 代码

**注意：后面说的`assets`和`layouts`目录都不是`themes/LoveIt/\*`下的，而是`博客根目录/*`**

1. `layouts/shortcodes/`下面新建`friend.html`文件：

注意这里我将原来的`<a target="_blank" href={{ .Get "url"  | safeURL }} title={{ .Get "name" }} >`改成了` <a target="_blank" href={{ .Get "url"  | safeURL }} title={{ .Get "word" }} >`

```html
{{ if .IsNamedParams }}
    {{- $src := .Get "logo" -}}
    {{- $small := .Get "logo_small" | default $src -}}
    {{- $large := .Get "logo_large" | default $src -}}
    <div class="friend-div">
        <a target="_blank" href={{ .Get "url"  | safeURL }} title={{ .Get "word" }} >
            <img class="lazyload"
                 src="/svg/loading.min.svg"
                 data-src={{ $src | safeURL }}
                 alt={{ .Get "name" }}
                 data-sizes="auto"
                 data-srcset="{{ $small | safeURL }}, {{ $src | safeURL }} 1.5x, {{ $large | safeURL }} 2x" />
            <span class="friend-name">{{ .Get "name" }}</span>
            <span class="friend-info">{{ .Get "word" }}</span>
        </a>
    </div>
{{ end }}
```

2. `assets/css/_partial/_single/`下面新建`_friend.scss`文件：

```scss
#article-container {
 word-wrap: break-word;
 overflow-wrap: break-word
}
   
#article-container a {
 color: #49b1f5
}
   
#article-container a:hover {
 text-decoration: underline
}
   
#article-container img {
 margin: 0 auto .8rem
}
   
.flink#article-container .friend-list-div > .friend-div a .friend-info,
.flink#article-container .friend-list-div > .friend-div a .friend-name {
 overflow: hidden;
 -o-text-overflow: ellipsis;
 text-overflow: ellipsis;
 white-space: nowrap
}
   
.flink#article-container .friend-list-div {
 overflow: auto;
 padding: 10px 10px 0;
 text-align: center;
}
.flink#article-container .friend-list-div > .friend-div {
 position: relative;
 float: left;
 overflow: hidden;
 margin: 15px 7px;
 width: calc(100% / 3 - 15px);
 height: 90px;
 border-radius: 8px;
 line-height: 17px;
 -webkit-transform: translateZ(0)
}
   
@media screen and (max-width: 1100px) {
 .flink#article-container .friend-list-div > .friend-div {
  width: calc(50% - 15px) !important
 }
   
@media screen and (max-width: 600px) {
 .flink#article-container .friend-list-div > .friend-div {
  width: calc(100% - 15px) !important
 }
}
}
   
.flink#article-container .friend-list-div > .friend-div:hover {
 background: rgba(87, 142, 224, 0.15);
}
   
.flink#article-container .friend-list-div > .friend-div:hover img {
 -webkit-transform: rotate(360deg);
 -moz-transform: rotate(360deg);
 -o-transform: rotate(360deg);
 -ms-transform: rotate(360deg);
 transform: rotate(360deg)
}
   
.flink#article-container .friend-list-div > .friend-div:before {
 position: absolute;
 top: 0;
 right: 0;
 bottom: 0;
 left: 0;
 z-index: -1;
 background: var(--text-bg-hover);
 content: '';
 -webkit-transition: -webkit-transform .3s ease-out;
 -moz-transition: -moz-transform .3s ease-out;
 -o-transition: -o-transform .3s ease-out;
 -ms-transition: -ms-transform .3s ease-out;
 transition: transform .3s ease-out;
 -webkit-transform: scale(0);
 -moz-transform: scale(0);
 -o-transform: scale(0);
 -ms-transform: scale(0);
 transform: scale(0)
}
.flink#article-container .friend-list-div > .friend-div:hover:before,
.flink#article-container .friend-list-div > .friend-div:focus:before,
.flink#article-container .friend-list-div > .friend-div:active:before {
 -webkit-transform: scale(1);
 -moz-transform: scale(1);
 -o-transform: scale(1);
 -ms-transform: scale(1);
 transform: scale(1)
}
.flink#article-container .friend-list-div > .friend-div a {
 color: var(--font-color);
 text-decoration: none
}
   
.flink#article-container .friend-list-div > .friend-div a img{
 float: left;
 margin: 15px 10px;
 width: 60px;
 height: 60px;
 border-radius: 35px;
 -webkit-transition: all .3s;
 -moz-transition: all .3s;
 -o-transition: all .3s;
 -ms-transition: all .3s;
 transition: all .3s
}
   
.flink#article-container .friend-list-div > .friend-div a .friend-name {
 display: block;
 padding: 16px 10px 0 0;
 height: 40px;
 font-weight: 700;
 font-size: 20px
}
   
.flink#article-container .friend-list-div > .friend-div a .friend-info {
 display: block;
 padding: 1px 10px 1px 0;
 height: 50px;
 font-size: 13px
}
```

3. 拷贝`themes/LoveIt/assets/css/_page/_single.scss`到`assets/css/_page/_single.scss`，并引入下面一行：

```scss
@import "../_partial/_single/friend";
```

##### 预览

先自行在`config.toml`中配置友情链接，然后 md 文件中写如下代码：

```markdown
<div class="flink" id="article-container">
<div class="friend-list-div" >

{{</* friend name="友链名" url="友链地址" logo="友链图标链接" word="友链描述" */>}}
{{</* friend name="友链名" url="友链地址" logo="友链图标链接" word="友链描述" */>}}
...

</div>
</div>
```

> **注意：两个 div 不能少！！**

![](https://cdn.jsdelivr.net/gh/iwyang/pic/20210717220844.jpg)



## 参考链接

+ [1.Hugo 篇四：添加友链卡片 shortcodes](https://blog.233so.com/2020/04/friend-link-shortcodes-for-hugo-loveit/)
+ [2.Hugo 添加友情链接页面](https://reb.mallotec.com/post/9e9c31ab/)
+ [Doit主题文档 - 基本概念](https://hugodoit.pages.dev/zh-cn/theme-documentation-basics/)
+ [Codeit主题文档 - 基本概念](https://codeit.suntprogramator.dev/zh-cn/theme-documentation-basics/)

