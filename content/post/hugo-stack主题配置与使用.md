---
title: "Hugo Stack主题配置与使用"
slug: "hugo-theme-stack"
description: ""
date: 2021-07-24T09:15:26+08:00
lastmod: 2021-08-13T09:15:26+08:00
draft: false
toc: true
weight: false
image: ""
categories: ["技术"]
tags: ["hugo"]
---

又换主题了，这回使用的是[hugo-theme-stack](https://github.com/CaiJimmy/hugo-theme-stack)，无意发现这款主题，正合我意，够简单，最重要的是支持本地搜索，再不用弄哪个`Alogia`了。

## 下载主题&更新主题

1. 下载主题

```bash
git init
git submodule add https://github.com/CaiJimmy/hugo-theme-stack/ themes/hugo-theme-stack
```

2. 更新主题

```bash
git submodule update --remote
```

## 查看主题版本号

```bash
git show 查看当前版本
----------------------------------------------------------------
git tag　列出所有版本号
git checkout　+某版本号　(你当前文件夹下的源码会变成这个版本号的源码)
```

## `config.yaml`配置文件

```yaml
baseurl: /
languageCode: zh-CN
theme: hugo-theme-stack
paginate: 10
title: Bore's Notes

# Change it to your Disqus shortname before using
# disqusShortname: hugo-theme-stack

# GA Tracking ID
googleAnalytics:

# Theme i18n support
# Available values: en, fr, id, ja, ko, pt-br, zh-cn, es, de, nl, it
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
        edit:
            enabled: true

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
            placeholder: 欢迎评论（昵称、邮箱必填，网址选填）
            locale:
                admin: 博主
   
        twikoo:
            envId: https://twikoo-lake.vercel.app
            region:
            path:
            lang:

    widgets:
        enabled:
            - search
            - categories
            - tag-cloud
            - archives
           
        archives:
            limit: 10000

        tagCloud:
            limit: 10000
            
        categoriesCloud:
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
          params:
            ### For demonstration purpose, the home link will be open in a new tab
            newTab: false

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

## 显示右侧工具栏分类目录

参考 https://github.com/CaiJimmy/hugo-theme-stack/issues/169

1. Create `categories.html` in layouts/partials/widget

```html
<section class="widget tagCloud">
  <div class="widget-icon">
      {{ partial "helper/icon" "categories" }}
  </div>
  <h2 class="widget-title section-title">{{ T "widget.categoriesCloud.title" }}</h2>

  <div class="tagCloud-tags">
      {{ range first .Site.Params.widgets.categoriesCloud.limit .Site.Taxonomies.categories.ByCount }}
          <a href="{{ .Page.RelPermalink }}" class="font_size_{{ .Count }}">
              {{ .Page.Title }}
          </a>
      {{ end }}
  </div>
</section>
```

2. 修改 `config.yaml`

```yaml
widgets:
        enabled:
            - categories
        
        categoriesCloud:
            limit: 20
```

3. 网站根目录新建`\i18n\zh-CN.yaml`

```yaml
widget:
    categoriesCloud:
        title: 
            other: 分类
```

5. Download categories.svg paste to `assets/icons`, from [here](https://github.com/rmdhnreza/rmdhnreza.my.id/tree/main/assets/icons)

> **注意**：可以按需删除图标。

## 文章底部添加`在 GitHub 上编辑此页`

1. 拷贝主题目录`/layouts/partials/article/components/footer.html`到网站根目录，修改为：

```html
<footer class="article-footer">
    {{ partial "article/components/tags" . }}

    {{ if and (.Site.Params.article.license.enabled) (not (eq .Params.license false)) }}
    <section class="article-copyright">
        {{ partial "helper/icon" "copyright" }}
        <span>{{ default .Site.Params.article.license.default .Params.license | markdownify }}</span>
    </section>
    {{ end }}
	
	{{ if and (.Site.Params.article.edit.enabled) (not (eq .Params.edit false)) }}
    <section class="article-edit">
        {{ partial "helper/icon" "external-link" }}
        <span><a href="https://github.com/iwyang/iwyang.github.io/edit/develop/content/{{ replace .File.Path "\\" "/" }}" target="_blank" rel="noopener noreferrer">在 GitHub 上编辑此页</a></span>
    </section>
    {{ end }}

    {{- if ne .Lastmod .Date -}}
    <section class="article-time">
        {{ partial "helper/icon" "clock" }}
        <span class="article-time--modified">
            {{ T "article.lastUpdatedOn" }} {{ .Lastmod.Format ( or .Site.Params.dateFormat.lastUpdated "Jan 02, 2006 15:04 MST" ) }}
        </span>
    </section>
    {{- end -}}
</footer>
```

2. 编辑`config.yaml`：

```yaml
    article:
        math: false
        toc: true
        readingTime: true 
        license:
            enabled: false
            default: Licensed under CC BY-NC-SA 4.0
        edit:
            enabled: true
```

以后只要在Frontmatter添加`edit: false`来关闭。

3. 拷贝`external-link.svg`图标到网站根目录`/assets/icons`下。图标地址：[点击直达](https://github.com/iwyang/iwyang.github.io/tree/develop/assets/icons)

## 添加友情链接 shortcodes

1. 网站根目录新建文件`layouts\page\links.html`：

   ```html
   <footer class="article-footer">
       {{ partial "article/components/tags" . }}
   
       {{ if and (.Site.Params.article.license.enabled) (not (eq .Params.license false)) }}
       <section class="article-copyright">
           {{ partial "helper/icon" "copyright" }}
           <span>{{ default .Site.Params.article.license.default .Params.license | markdownify }}</span>
       </section>
       {{ end }}
   	
   	{{ if and (.Site.Params.article.edit.enabled) (not (eq .Params.edit false)) }}
       <section class="article-edit">
           {{ partial "helper/icon" "external-link" }}
           <span><a href="https://github.com/iwyang/iwyang.github.io/edit/develop/content/{{ replace .File.Path "\\" "/" }}" target="_blank">在 GitHub 上编辑此页</a></span>
       </section>
       {{ end }}
   
       {{- if ne .Lastmod .Date -}}
       <section class="article-time">
           {{ partial "helper/icon" "clock" }}
           <span class="article-time--modified">
               {{ T "article.lastUpdatedOn" }} {{ .Lastmod.Format ( or .Site.Params.dateFormat.lastUpdated "Jan 02, 2006 15:04 MST" ) }}
           </span>
       </section>
       {{- end -}}
   </footer>
   ```
   
2. 网站根目录新建文件`\layouts\shortcodes\link.html`：

   ```html
   {{$URL := .Get 0}}
   {{ with .Site.GetPage $URL }}
   <div class="post-preview">
     <div class="post-preview--meta" style="width:100%;">
       <div class="post-preview--middle">
         <h4 class="post-preview--title">
           <a target="_blank" href="{{ .Permalink }}">{{ .Title }}</a>
         </h4>
         <time class="post-preview--date">{{ .Date.Format ( default "2006-01-02") }}</time>
         {{ if .Params.tags }}
         <small>{{ range .Params.tags }}#{{ . }}&nbsp;{{ end }}</small>
         {{ end }}
         <section style="max-height:105px;overflow:hidden;" class="post-preview--excerpt">
           {{ .Summary | plainify}}
         </section>
       </div>
     </div>
   </div>
   {{ end }}
   ```
   
   3. `网站图像`放在网站根目录`\assets\link-img\`文件夹下。
   4. 网站根目录新建文件`\data\links.json`：
   
   ```json
   [
       {
           "title": "ConstOwn",
           "website": "https://blog.juanertu.com",
           "image": "constown.jpg",
   		"description": "能与你一起成长，我荣幸之至。"
       },
       {
           "title": "小丁的个人博客",
           "website": "https://tding.top",
           "image": "ding.jpg",
   		"description": "世间所有的相遇，都是久别重逢。"
       },
       {
           "title": "Xu's Blog",
           "website": "https://hasaik.com",
           "image": "xu.jpg",
   		"description": "简单不先于复杂，而是在复杂之后。"
       },
       {
           "title": "知行志",
           "website": "https://baozi.fun",
           "image": "zhi.jpg",
   		"description": "Halo Theme Xue作者。"
       },
       {
           "title": "Takagi",
           "website": "https://lixingyong.com",
           "image": "takagi.jpg",
   		"description": "Takagi是啥呀？？当然是最喜欢的Takagi了吖ヾ(≧∇≦*)ゝ"
       },
       {
           "title": "千与千寻",
           "website": "https://www.chihiro.org.cn",
           "image": "qian.jpg",
   		"description": "所以，看不到光，算是不幸吗？需要光才是真正的不幸吧。"
       },
       {
           "title": "Bill Yang's Blog",
           "website": "https://blog.bill.moe",
           "image": "bill.jpg",
   		"description": "这辈子都不可能更新的 。"
       },
       {
           "title": "Sanarous's Blog",
           "website": "https://bestzuo.cn",
           "image": "sanarous.jpg",
   		"description": "Dream it possible, make it possible"
       },
   	    {
           "title": "JACK小桔子的小屋",
           "website": "https://jackxjz.top/",
           "image": "jack.jpg",
   		"description": "一个分享科技/日常的网站。"
       },
   	{
           "title": "若只如初见",
           "website": "https://joyli.net.cn/",
           "image": "ruo.jpg",
   		"description": "世间所有的相遇，都是久别重逢。"
       }
   ]
   ```

## 更改分类、标签、页面显示中文

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

3. 根目录`\i18n\zh-CN.yaml`输入：

```yaml
list:
    page:
        one: "{{ .Count }} 页面"
        other: "{{ .Count }} 页面"
```

最终根目录`\i18n\zh-CN.yaml`

```yaml
list:
    page:
        one: "{{ .Count }} 页面"
        other: "{{ .Count }} 页面"

widget:
    categoriesCloud:
        title: 
            other: 分类
```

## `最后更新于`前面空格太长了

更新3.0出现以下问题：“最后更新于”前面空格太长了，如下图。

![空格太长了](https://cdn.jsdelivr.net/gh/iwyang/pic/202108121555733.png)

解决方法：

网站根目录新建`assets/scss/custom.scss`

```scss
.article-footer > .article-time {
    gap: 0px;
}
```

## 附：使用Git Submodule管理Hugo主题

+ 如果克隆库的时候要初始化子模块，请加上 `--recursive` 参数，如：

```bash
git clone -b develop git@github.com:iwyang/iwyang.github.io.git blog --recursive
```

+ 如果已经克隆了主库但没初始化子模块，则用：

```bash
git submodule update --init --recursive
```

+ 如果已经克隆并初始化子模块，而需要从子模块的源更新这个子模块，则：

```bash
git submodule update --recursive --remote
```

更新之后主库的 git 差异中会显示新的 SHA 码，把这个差异选中提交即可。

---

+ 其他命令：在主仓库更新所有子模块：`git submodule foreach git pull origin master`

## 参考链接

+ [Hugo 主题 Stack文档](https://docs.stack.jimmycai.com/zh/)
+ [hugo主题stack - 银河小筑](https://yinhe.co/archives/20210401_hugo_theme_stack.html)
+ [树洞](https://blog.jimmycai.com/links/)
+ [Adding the widget tag-cloud for "categories", on the right content region on Homepage](https://github.com/CaiJimmy/hugo-theme-stack/issues/169)
+ [vinceying/Vince-blog-https://i.vince.pub/](https://github.com/vinceying/Vince-blog)
+ [“最后更新于”前面空格太长了](https://github.com/CaiJimmy/hugo-theme-stack/issues/300)

