---
title: "Hugo Papermod主题配置与使用"
slug: "hugo-papermod-theme"
description: ""
date: 2021-08-09T08:54:56+08:00
lastmod: 2021-08-09T08:54:56+08:00
draft: false
toc: true
weight: false
image: ""
categories: ["技术"]
tags: ["hugo"]
---

最近一两天又在折腾主题，这回是[Hugo-PaperMod](https://git.io/hugopapermod)主题，虽然还没打算换，但还是记录一下吧。

## 基本操作

查看文档：**[PaperMod - Features](https://github.com/adityatelange/hugo-PaperMod/wiki/Features)**

## `config.yml`配置

**注意**：如果把`baseURL`设置成`"/"`，页面顶部导航失效，如果要用顶部导航，就设置为`baseURL: "https://bore.vip"`

```yaml
baseURL: "/"
title: Bore's Notes
paginate: 10
theme: PaperMod
defaultContentLanguage: zh

permalinks:
    posts: /archives/:slug/

enableInlineShortcodes: true
enableRobotsTXT: true
buildDrafts: false
buildFuture: false
buildExpired: false
enableEmoji: true
# googleAnalytics: UA-123-45

minify:
    disableXML: true
    minifyOutput: false

menu:
    main:
        - identifier: home
          name: 首页
          url: /
          weight: 10
        - identifier: archives
          name: 归档
          url: /archives/
          weight: 20
        - identifier: categories
          name: 分类
          url: /categories/
          weight: 30
        - identifier: tags
          name: 标签
          url: /tags/
          weight: 40
        - identifier: about
          name: 关于
          url: /about/
          weight: 50
        - identifier: search
          name: 搜索
          url: /search/
          weight: 60

outputs:
    home:
        - HTML
        - RSS
        - JSON

params:
    env: production # to enable google analytics, opengraph, twitter-cards and schema.
    description: "本站主要用来收集整理资料、记录笔记，方便自己查询使用。"
    author: 
    # author: ["Me", "You"] # multiple authors

    defaultTheme: auto
    disableThemeToggle: false
    DateFormat: "2006-01-02"
    ShowShareButtons: false
    ShowReadingTime: false
    disableSpecial1stPost: true
    displayFullLangName: true
    ShowPostNavLinks: true
    ShowBreadCrumbs: true
    ShowCodeCopyButtons: true
    ShowToc: true
    comments: true
    images: ["papermod-cover.png"]
    mainSections:
        - posts

    profileMode:
        enabled: false
        title: PaperMod
        imageUrl: "#"
        imageTitle: my image
        # imageWidth: 120
        # imageHeight: 120
        buttons:
            - name: Archives
              url: archives
            - name: Tags
              url: tags

    # homeInfoParams:
        # Title: "PaperMod"
        # Content: >
            # Welcome to demo of hugo's theme PaperMod.

            # - **PaperMod** is a simple but fast and responsive theme with useful feature-set that enhances UX.

            # - Do give a 🌟 on Github !

            # - PaperMod is based on theme [Paper](https://github.com/nanxiaobei/hugo-paper).

    socialIcons:
        - name: github
          url: "https://github.com/adityatelange/hugo-PaperMod"
        - name: KoFi
          url: "https://ko-fi.com/adityatelange"
        - name: RsS
          url: "index.xml"

    editPost:
        URL: "https://github.com/iwyang/iwyang.github.io/tree/develop/content"
        Text: "Suggest Changes" # edit text
        appendFilePath: true # to append file path to Edit link

    # label:
    #     text: "Home"
    #     icon: icon.png
    #     iconHeight: 35

    # analytics:
    #     google:
    #         SiteVerificationTag: "XYZabc"

    assets:
        favicon: "/images/favicon.png"
        favicon16x16: "/images/favicon.png"
        favicon32x32: "/images/favicon.png"
        apple_touch_icon: "/images/favicon.png"
        safari_pinned_tab: "/images/favicon.png"

    cover:
        hidden: true # hide everywhere but not in structured data
        hiddenInList: true # hide on list pages and home
        hiddenInSingle: true # hide on single page

    fuseOpts:
        isCaseSensitive: false
        shouldSort: true
        location: 0
        distance: 1000
        threshold: 0.4
        minMatchCharLength: 0
        keys: ["title", "permalink", "summary", "content"]

taxonomies:
    category: categories
    tag: tags
    series: series

markup:
    goldmark:
        renderer:
            unsafe: true
#     highlight:
#         # anchorLineNos: true
#         codeFences: true
#         guessSyntax: true
#         lineNos: true
#         # noClasses: false
#         style: monokai

privacy:
    vimeo:
        disabled: false
        simple: true

    twitter:
        disabled: false
        enableDNT: true
        simple: true

    instagram:
        disabled: false
        simple: true

    youtube:
        disabled: false
        privacyEnhanced: true

services:
    instagram:
        disableInlineCSS: true
    twitter:
        disableInlineCSS: true
```

## `archetypes`默认模板

```yaml
---
title: "My 1st post"
date: 2020-09-15T11:30:03+00:00
# weight: 1
# aliases: ["/first"]
tags: ["first"]
author: "Me"
# author: ["Me", "You"] # multiple authors
showToc: true
TocOpen: false
draft: false
hidemeta: false
comments: false
description: "Desc Text."
canonicalURL: "https://canonical.url/to/page"
disableHLJS: true # to disable highlightjs
disableShare: false
disableHLJS: false
hideSummary: false
searchHidden: true
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
cover:
    image: "<image path/url>" # image path/url
    alt: "<alt text>" # alt text
    caption: "<text>" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: true # only hide on current single page
editPost:
    URL: "https://github.com/<path_to_repo>/content"
    Text: "Suggest Changes" # edit text
    appendFilePath: true # to append file path to Edit link
---
```

自定义：

```yaml
title: "{{ replace .TranslationBaseName "-" " " | title }}"
slug: ""
description: ""
date: {{ .Date }}
lastmod: {{ .Date }}
draft: false
showToc: true
weight: false
categories: [""]
tags: [""]
```

## 加入`Waline`评论系统

根目录新建`layouts\partials\comments.html`：

````sh
<script src="https://cdn.jsdelivr.net/npm/@waline/client"></script>
<div id="waline"></div>
<script>
  new Waline({
    el: '#waline',
    serverURL: 'https://m.bore.vip/',
    copyright: true,
    login: 'enable',
    placeholder: '欢迎评论',
    dark: '.dark',
	requiredMeta: ['nick', 'mail'],
  });
</script>
````

网上别人配置：

```scss
<!-- Waline -->
{{- if .Site.Params.waline.enable -}}
<script src="https://cdn.jsdelivr.net/npm/@waline/client@{{ .Site.Params.waline.version }}/dist/Waline.min.js"></script>
<div class="pagination__title">
    <span class="pagination__title-h"
        ><span class="vcount"></span>精彩评论</span
    >
    <hr />
</div>
<div id="waline"></div>
<script>
    var locale = {
        admin: "Ṽerified", // 博主标识
        busy: "操作频繁，请稍候再试...",
        cancel: "取消",
        cancelReply: "取消回复",
        comments: "评论",
        confirm: "确认",
        continue: "继续",
        days: "天前",
        emoji: "表情",
        expand: "查看更多...",
        hours: "小时前",
        link: "网址",
        login: "登录",
        logout: "退出",
        mail: "邮箱",
        mailFail: "请填写正确的邮件地址",
        minutes: "分钟前",
        more: "加载更多...",
        nick: "昵称",
        nickFail: "昵称不能少于 3 个字符",
        now: "刚刚",
        placeholder:
            "·支持 匿名评论\n·支持 Markdown\n·支持 Twimoji\n·支持 代码块语法高亮\n·不收集 UserAgent", // 评论框提示语
        preview: "预览",
        reply: "回复",
        seconds: "秒前",
        sofa: "来发评论吧～",
        submit: "提交",
        uploadDone: "传输完成！",
        uploading: "正在传输...",
        word: "字",
        wordHint: "评论字数应在 $0 到 $1 字之间！\n当前字数：$2",
        "code-98": "Waline 初始化失败，请检查 av-min.js 版本",
        "code-99": "Waline 初始化失败，请检查 init 中的`el`元素.",
        "code-100": "Waline 初始化失败，请检查你的 AppId 和 AppKey.",
        "code-140": "今日 API 调用总次数已超过开发版限制.",
        "code-401": "未经授权的操作，请检查你的 AppId 和 AppKey.",
        "code-403": "访问被 API 域名白名单拒绝，请检查你的安全域名设置.",
    };
    new Waline({
        el: "#waline", // 初始化 Waline 挂载器
        avatarCDN: "https://sdn.geekzu.org/avatar/", // 设置 Gravatar 头像 CDN 地址
        copyright: true, // Waline 版权信息
        dark: "auto", // 适配暗黑模式
        highlight: true, // 代码高亮
        locale, // 自定义语言 i18n，请在上面 locale 中修改内容
        requiredMeta: ["nick", "mail"], // 必填项
        serverURL: "https://tcb.eallion.com/waline", // Waline 的服务端地址，末尾勿加 “/”
        visitor: true, // 开启访问量统计
        wordLimit: 0, // 评论字数限制，0 为无限制
    });
</script>
{{- end }}

<!-- Twikoo -->
{{- if .Site.Params.twikoo.enable -}}
<div class="pagination__title">
    <span class="pagination__title-h">精彩评论</span>
    <hr />
</div>
<div id="tcomment"></div>
<script src="https://cdn.jsdelivr.net/npm/twikoo@{{ .Site.Params.twikoo.version }}/dist/twikoo.all.min.js"></script>
<!-- <script>window.TWIKOO_MAGIC_PATH="共用评论区的名称"</script> -->
<script>
    twikoo.init({
        envId: "eallion-8gkunp4re49bae66",
        el: "#tcomment",
        path: 'window.TWIKOO_MAGIC_PATH||window.location.pathname',
        onCommentLoaded: function () {
            $(".tk-content img:not(.tk-avatar-img)").each(function () {
                var _b = $("<a></a>").attr("href", this.src);
                $(this).wrap(_b);
            })
            $(".tk-content a[rel!=link]:has(img)").slimbox();
        }
    });
</script>
{{- end }}

<!-- DisqusJS -->
{{- if .Site.Params.disqus.enable -}}
<div id="disqus_thread"></div>
{{- if .Site.Params.disqus.proxy -}}
<script src="https://cdn.jsdelivr.net/npm/disqusjs@{{ .Site.Params.disqus.version }}/dist/disqus.js"></script>
<script>
    var dsqjs = new DisqusJS({
        shortname: "eallion",
        siteName: "{{ .Site.Params.title }}",
        identifier:
            '{{ if .Params.identifier }}{{ trim .Params.identifier "/" }}{{ else }}{{ trim .RelPermalink "/" }}{{ end }}',
        url: '{{ if .Params.identifier }}"{{ trim .Site.BaseURL "/" }}{{ .Params.identifier }}"{{ else }}{{ .Permalink }}{{ end }}',
        title: "{{ .Title }}",
        api: "https://disqus.skk.moe/disqus/",
        apikey: "fF9m3DwDSmNQ2g5DIpuWElDaQTx1ofpMSSW8JeKaB2loVBExeInmMbaEGeLs7lOL",
        admin: "eallion",
        adminLabel: "",
        nocomment: "",
    });
</script>
{{- else -}} {{- $script := printf `
<script defer src="https://%s.disqus.com/embed.js"></script>
` .Site.Params.comment.disqus.shortname -}} {{- end -}}
<noscript>
    Please enable JavaScript to view the
    <a href="https://disqus.com/?ref_noscript">comments powered by Disqus.</a>
</noscript>
{{- end -}}

<!-- Utterances -->
{{- if .Site.Params.utterances.enable -}}
<script
    src="https://utteranc.es/client.js"
    repo="eallion/blog"
    issueterm="url"
    label="Comments"
    theme="github-light"
    crossorigin="anonymous"
    async
></script>
{{- end -}}
```

## 更改分类、标签显示中文

1. `content`目录下新建`categories\_index.md`:

```yaml
---
title: "分类"
---
```

2. `content`目录下新建`tags\_index.md`:

```yaml
---
title: "标签"
---
```

3. `posts`目录下新建`posts\_index.md`:

```yaml
---
title: "文章"
---
```

## 参考链接

+ [1.hugo-PaperMod](https://github.com/adityatelange/hugo-PaperMod/)
+ [2.ĀKURAI's](https://404gle.cn/)
+ [3.akuraito/blog](https://github.com/akuraito/blog)

