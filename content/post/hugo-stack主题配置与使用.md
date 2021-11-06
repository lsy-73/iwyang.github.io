---
title: "Hugo Stack主题配置与使用"
slug: "hugo-theme-stack"
description: ""
date: 2021-07-24T09:15:26+08:00
lastmod: 2021-11-07T09:15:26+08:00
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
# disqusShortname: 

# GA Tracking ID
googleAnalytics:

# Theme i18n support
# Available values: en, fr, id, ja, ko, pt-br, zh-cn, es, de, nl, it
DefaultContentLanguage: zh-cn

permalinks:
    post: /archives/:slug/
    page: /:slug/
    
# whether to use emoji code
enableEmoji: true

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
        <span><a style="color: inherit;" href="https://github.com/iwyang/iwyang.github.io/edit/develop/content/{{ replace .File.Path "\\" "/" }}" target="_blank" rel="noopener noreferrer">在 GitHub 上编辑此页</a></span>
    </section>
    {{ end }}

    {{- if ne .Lastmod .Date -}}
    <section class="article-lastmod">
        {{ partial "helper/icon" "clock" }}
        <span>
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
   {{ define "body-class" }}article-page keep-sidebar{{ end }}
   {{ define "main" }}
       {{ partial "article/article.html" . }}
       
       <div class="article-list--compact links">
           {{ $siteResources := resources }}
           {{ range $i, $link :=  $.Site.Data.links }}
               <article>
                   <a href="{{ $link.website }}" target="_blank" rel="noopener">
                       <div class="article-details">
                           <h2 class="article-title">
                               {{- $link.title -}}
                           </h2>
                           <footer class="article-time">
                               {{ with $link.description }}
                                   {{ . }}
                               {{ else }}
                                   {{ $link.website }}
                               {{ end }}
                           </footer>
                       </div>
               
                       {{ if $link.image }}
                           {{ $image := $siteResources.Get (delimit (slice "link-img/" $link.image) "") | resources.Fingerprint "md5" }}
                           {{ $imageResized := $image.Resize "120x120" }}
                           <div class="article-image">
                               <img src="{{ $imageResized.RelPermalink }}" width="{{ $imageResized.Width }}" height="{{ $imageResized.Height }}"
                                   loading="lazy" data-key="links-{{ $link.website }}" data-hash="{{ $image.Data.Integrity }}">
                           </div>
                       {{ end }}
                   </a>
               </article>
           {{ end }}
       </div>
   
       {{ if or (not (isset .Params "comments")) (eq .Params.comments "true")}} 
           {{ partial "comments/include" . }}
       {{ end }}
   
       {{ partialCached "footer/footer" . }}
   
       {{ partialCached "article/components/photoswipe" . }}
   {{ end }}
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
           "title": "Upptime",
           "website": "https://iwyang.github.io/check",
           "image": "upptime.jpg",
   		"description": "利用Github Actions查看网站运行状态。"
       },
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
       },
   		{
           "title": "大大的小蜗牛",
           "website": "https://eallion.com/",
           "image": "eallion.jpg",
   		"description": "机会总是垂青于有准备的人。"
       }
   ]
   ```

## 添加音乐短代码

1.网站根目录新建文件`layouts\shortcodes\music.html`

```html
{{- $scratch := .Page.Scratch.Get "scratch" -}}
<!-- require APlayer -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/aplayer/dist/APlayer.min.css">
<style type="text/css">.dark-theme .aplayer{background:#212121}.dark-theme .aplayer.aplayer-withlist .aplayer-info{border-bottom-color:#5c5c5c}.dark-theme .aplayer.aplayer-fixed .aplayer-list{border-color:#5c5c5c}.dark-theme .aplayer .aplayer-body{background-color:#212121}.dark-theme .aplayer .aplayer-info{border-top-color:#212121}.dark-theme .aplayer .aplayer-info .aplayer-music .aplayer-title{color:#fff}.dark-theme .aplayer .aplayer-info .aplayer-music .aplayer-author{color:#fff}.dark-theme .aplayer .aplayer-info .aplayer-controller .aplayer-time{color:#eee}.dark-theme .aplayer .aplayer-info .aplayer-controller .aplayer-time .aplayer-icon path{fill:#eee}.dark-theme .aplayer .aplayer-list{background-color:#212121}.dark-theme .aplayer .aplayer-list::-webkit-scrollbar-thumb{background-color:#999}.dark-theme .aplayer .aplayer-list::-webkit-scrollbar-thumb:hover{background-color:#bbb}.dark-theme .aplayer .aplayer-list li{color:#fff;border-top-color:#666}.dark-theme .aplayer .aplayer-list li:hover{background:#4e4e4e}.dark-theme .aplayer .aplayer-list li.aplayer-list-light{background:#6c6c6c}.dark-theme .aplayer .aplayer-list li .aplayer-list-index{color:#ddd}.dark-theme .aplayer .aplayer-list li .aplayer-list-author{color:#ddd}.dark-theme .aplayer .aplayer-lrc{text-shadow:-1px -1px 0 #666}.dark-theme .aplayer .aplayer-lrc:before{background:-moz-linear-gradient(top, #212121 0%, rgba(33,33,33,0) 100%);background:-webkit-linear-gradient(top, #212121 0%, rgba(33,33,33,0) 100%);background:linear-gradient(to bottom, #212121 0%, rgba(33,33,33,0) 100%);filter:progid:DXImageTransform.Microsoft.gradient( startColorstr='#212121', endColorstr='#00212121',GradientType=0 )}.dark-theme .aplayer .aplayer-lrc:after{background:-moz-linear-gradient(top, rgba(33,33,33,0) 0%, rgba(33,33,33,0.8) 100%);background:-webkit-linear-gradient(top, rgba(33,33,33,0) 0%, rgba(33,33,33,0.8) 100%);background:linear-gradient(to bottom, rgba(33,33,33,0) 0%, rgba(33,33,33,0.8) 100%);filter:progid:DXImageTransform.Microsoft.gradient( startColorstr='#00212121', endColorstr='#cc212121',GradientType=0 )}.dark-theme .aplayer .aplayer-lrc p{color:#fff}.dark-theme .aplayer .aplayer-miniswitcher{background:#484848}.dark-theme .aplayer .aplayer-miniswitcher .aplayer-icon path{fill:#eee}</style>
<script src="https://cdn.jsdelivr.net/npm/aplayer/dist/APlayer.min.js"></script>
<!-- require MetingJS -->
<script src="https://cdn.jsdelivr.net/npm/meting@2.0.1/dist/Meting.min.js"></script>

{{- if .IsNamedParams -}}
    {{- if .Get "url" -}}
        <meting-js url="{{ .Get `url` }}" name="{{ .Get `name` }}" artist="{{ .Get `artist` }}" cover="{{ .Get `cover` }}" theme="{{ .Get `theme` | default `#2980b9` }}"
        {{- with .Get "fixed" }} fixed="{{ . }}"{{ end -}}
        {{- with .Get "mini" }} mini="{{ . }}"{{ end -}}
        {{- with .Get "autoplay" }} autoplay="{{ . }}"{{ end -}}
        {{- with .Get "volume" }} volume="{{ . }}"{{ end -}}
        {{- with .Get "mutex" }} mutex="{{ . }}"{{ end -}}
        ></meting-js>
    {{- else if .Get "auto" -}}
        <meting-js auto="{{ .Get `auto` }}" theme="{{ .Get `theme` | default `#2980b9` }}"
        {{- with .Get "fixed" }} fixed="{{ . }}"{{ end -}}
        {{- with .Get "mini" }} mini="{{ . }}"{{ end -}}
        {{- with .Get "autoplay" }} autoplay="{{ . }}"{{ end -}}
        {{- with .Get "loop" }} loop="{{ . }}"{{ end -}}
        {{- with .Get "order" }} order="{{ . }}"{{ end -}}
        {{- with .Get "volume" }} volume="{{ . }}"{{ end -}}
        {{- with .Get "mutex" }} mutex="{{ . }}"{{ end -}}
        {{- with .Get "list-folded" }} list-folded="{{ . }}"{{ end -}}
        {{- with .Get "list-max-height" }} list-max-height="{{ . }}"{{ end -}}
        ></meting-js>
    {{- else -}}
        <meting-js server="{{ .Get `server` }}" type="{{ .Get `type` }}" id="{{ .Get `id` }}" theme="{{ .Get `theme` | default `#2980b9` }}"
        {{- with .Get "fixed" }} fixed="{{ . }}"{{ end -}}
        {{- with .Get "mini" }} mini="{{ . }}"{{ end -}}
        {{- with .Get "autoplay" }} autoplay="{{ . }}"{{ end -}}
        {{- with .Get "loop" }} loop="{{ . }}"{{ end -}}
        {{- with .Get "order" }} order="{{ . }}"{{ end -}}
        {{- with .Get "volume" }} volume="{{ . }}"{{ end -}}
        {{- with .Get "mutex" }} mutex="{{ . }}"{{ end -}}
        {{- with .Get "list-folded" }} list-folded="{{ . }}"{{ end -}}
        {{- with .Get "list-max-height" }} list-max-height="{{ . }}"{{ end -}}
        ></meting-js>
    {{- end -}}
{{- else if strings.HasSuffix (.Get 0) "http" -}}
    <meting-js auto="{{ .Get 0 }}" theme="#2980b9"></meting-js>
{{- else -}}
    <meting-js server="{{ .Get 0 }}" type="{{ .Get 1 }}" id="{{ .Get 2 }}" theme="#2980b9"></meting-js>
{{- end -}}
{{- $scratch.Set "music" true -}}
```

2.添加歌曲列表（注意：去掉注释/*  */）

```yaml
{{/* < music auto="https://music.163.com/#/playlist?id=60198"> */}}
```

3.添加单曲（注意：去掉注释/*  */）

```
{{/* < music server="netease" type="song" id="1868553" > */}}
或者
{{/* < music netease song 1868553 > */}}
```

4.其它参数

`music` shortcode 有一些可以应用于以上三种方式的其它命名参数:

- **autoplay** *[可选]*

  是否自动播放音乐, 默认值是 `false`.

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

## 附：hugo注释

```yaml
{{/* comment */}}
```

## 参考链接

+ [Hugo 主题 Stack文档](https://docs.stack.jimmycai.com/zh/)
+ [hugo主题stack - 银河小筑](https://yinhe.co/archives/20210401_hugo_theme_stack.html)
+ [树洞](https://blog.jimmycai.com/links/)
+ [Adding the widget tag-cloud for "categories", on the right content region on Homepage](https://github.com/CaiJimmy/hugo-theme-stack/issues/169)
+ [vinceying/Vince-blog-https://i.vince.pub/](https://github.com/vinceying/Vince-blog)
+ [hugo音乐短代码](https://immmmm.com/hugo-shortcodes-music/)
+ [主题文档 - 扩展 Shortcodes-music](https://hugodoit.pages.dev/zh-cn/theme-documentation-extended-shortcodes/#8-music)
+ [Hugo模板的基本语法-注释](https://hugo.aiaide.com/post/hugo%E6%A8%A1%E6%9D%BF%E7%9A%84%E5%9F%BA%E6%9C%AC%E8%AF%AD%E6%B3%95/#%E6%B3%A8%E9%87%8A)

