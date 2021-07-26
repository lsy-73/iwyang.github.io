---
title: "Hugo Stack主题配置与使用"
slug: "hugo-theme-stack"
description: ""
date: 2021-07-24T09:15:26+08:00
lastmod: 2021-07-26T09:15:26+08:00
draft: false
toc: true
weight: false
image: ""
categories: ["建站笔记"]
tags: ["hugo"]
---

> 又换主题了，这回使用的是[hugo-theme-stack](https://github.com/CaiJimmy/hugo-theme-stack)，无意发现这款主题，正合我意，够简单，最重要的是支持本地搜索，再不用弄哪个`Alogia`了。

## 下载主题

```
git init
git submodule add https://github.com/CaiJimmy/hugo-theme-stack/ themes/hugo-theme-stack
```

## 更新主题

```
git submodule update --remote
```

## 查看主题版本号

```
git show 查看当前版本
----------------------------------------------------------------
git tag　列出所有版本号
git checkout　+某版本号　(你当前文件夹下的源码会变成这个版本号的源码)
```

## `config.yaml`配置文件

```yaml
baseurl: https://bore.vip
languageCode: en-us
theme: hugo-theme-stack
paginate: 10
title: Bore's Notes

# Change it to your Disqus shortname before using
# disqusShortname: hugo-theme-stack

# GA Tracking ID
googleAnalytics:

# Theme i18n support
# Available values: en, fr, id, ja, ko, pt-br, zh-cn, es, de, nl
DefaultContentLanguage: zh-cn

permalinks:
    post: /archives/:slug/
    page: /:slug/

params:
    mainSections:
        - post
    featuredImageField: image
    rssFullContent: true
    favicon: /img/favicon.png

    footer:
        since: 2020
        customText:

    dateFormat:
        published: 2006-01-02
        lastUpdated: 2006-01-02

    sidebar:
        emoji: 🍥
        subtitle: 博观而约取，厚积而薄发
        avatar:
            enabled: false
            local: true
            src: img/avatar.jpg

    article:
        math: false
        toc: true
        readingTime: false 
        license:
            enabled: false
            default: Licensed under CC BY-NC-SA 4.0

    comments:
        enabled: true
        provider: waline

        utterances:
            repo: iwyang/comments
            issueTerm: title
            label: utterances
            theme: dark-orange

        remark42:
            host:
            site:
            locale:

        vssue:
            platform:
            owner:
            repo:
            clientId:
            clientSecret:
            autoCreateIssue: false

        # Waline client configuration see: https://waline.js.org/en/reference/client.html
        waline:
            serverURL: https://m.bore.vip/
            lang: zh-CN
            visitor: false
            avatar: mp
            emoji:
                - https://cdn.jsdelivr.net/gh/walinejs/emojis/weibo
            requiredMeta:
                - nick
                - mail
            placeholder:
            locale:
                admin: 博主

    widgets:
        enabled:
            - search
            - archives
            - tag-cloud

        archives:
            limit: 10000

        tagCloud:
            limit: 10000

    opengraph:
        twitter:
            # Your Twitter username
            site:

            # Available values: summary, summary_large_image
            card: summary_large_image

    defaultImage:
        opengraph:
            enabled: false
            local: false
            src:

    colorScheme:
        # Display toggle
        toggle: true

        # Available values: auto, light, dark
        default: auto

    imageProcessing:
        cover:
            enabled: true
        content:
            enabled: true

### Custom menu
### See https://docs.stack.jimmycai.com/configuration/custom-menu
### To remove about, archive and search page menu item, remove `menu` field from their FrontMatter
menu:
    main:
        - identifier: home
          name: 首页
          url: /
          weight: -100
          pre: home

related:
    includeNewer: true
    threshold: 60
    toLower: false
    indices:
        - name: tags
          weight: 100

        - name: categories
          weight: 200

markup:
    tableOfContents:
        endLevel: 4
        ordered: true
        startLevel: 2
    highlight:
        noClasses: false
```

## `archetypes`默认模板

```yaml
title: "{{ replace .TranslationBaseName "-" " " | title }}"
slug: ""
description: ""
date: {{ .Date }}
lastmod: {{ .Date }}
draft: false
toc: true
weight: false
image: ""
categories: [""]
tags: [""]
```

## 魔改(未测试)

### 给文章加上思源宋体

在站点根目录新建文件 `layouts/partials/head/custom.html`， 内容如下：

```html
<style>
    :root {
        --article-font-family: "Noto Serif SC", var(--base-font-family);
    }
</style>

<script>
		(function () {
		    const customFont = document.createElement('link');
		    customFont.href = "https://fonts.googleapis.com/css2?family=Noto+Serif+SC:wght@400;700&display=swap";
		
		    customFont.type = "text/css";
		    customFont.rel = "stylesheet";
		
		    document.head.appendChild(customFont);
		}());
</script>
```

### 回到顶部按钮

编辑 `themes\stack\layouts\partials\footer\components\custom-font.html`

```
    //back to top
    $.goup({
        trigger: 300,
        bottomOffset: 20,
        locationOffset: 20,
        title:  'Back to TOP',
        titleAsText: false
    });

```

## 附：使用Git Submodule管理Hugo主题

+ 如果克隆库的时候要初始化子模块，请加上 `--recursive` 参数，如：

```
git clone -b develop git@github.com:iwyang/iwyang.github.io.git blog --recursive
```

+ 如果已经克隆了主库但没初始化子模块，则用：

```
git submodule update --init --recursive
```

+ 如果已经克隆并初始化子模块，而需要从子模块的源更新这个子模块，则：

```
git submodule update --recursive --remote
```

更新之后主库的 git 差异中会显示新的 SHA 码，把这个差异选中提交即可。

---

+ 其他命令：在主仓库更新所有子模块：`git submodule foreach git pull origin master`

---

## Hugo Stack主题更新记录

+ 2021.7.26 地址：[44e3d20](https://github.com/CaiJimmy/hugo-theme-stack/commit/44e3d20bad845a515657308d38692e7f431b4d05)

```diff
feat(article): use markdownify for licence in article (#273)
* Use markdownify for licence in article

So we can use links, e.g. to credits for main photo.

* refactor: move .article-copyright style to partials/layout/article

Co-authored-by: Jimmy Cai <github@jimmycai.com>
```

## 参考链接

+ [Hugo 主题 Stack文档](https://docs.stack.jimmycai.com/zh/)
+ [hugo主题stack - 银河小筑](https://yinhe.co/archives/20210401_hugo_theme_stack.html)

