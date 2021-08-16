---
title: "hugo部署到coding&gitee&备份源码"
slug: "hugo-install-on-coding-and-gitee"
date: 2020-05-13T09:42:25+08:00
lastmod: 2020-05-13T09:42:25+08:00
draft: false
toc: true
weight: false
categories: ["技术"]
tags: ["hugo"]
---

## 本地操作

### 安装GIt

本地需要安装 [Git](https://git-scm.com/) ，安装过程略。安装完git后还要配置环境变量：
右键我的电脑 --> 属性，然后点击高级系统设置 --> 环境变量 --> 选择用户变量或系统变量中的Path,点击编辑；找到Git安装目录,添加以下地址:

```bash
D:\Program Files\Git\bin
D:\Program Files\Git\mingw64\libexec\git-core
D:\Program Files\Git\mingw64\bin
```

### 配置SSH 公钥

Windows 上安装 [Git for Windows](https://git-for-windows.github.io/) 之后在开始菜单里打开 Git Bash 输入：

```bash
git config --global user.name "你的用户名"
git config --global user.email "你的电子邮箱"
```

```bash
cd ~
mkdir .ssh
cd .ssh
ssh-keygen -t rsa
```

在系统当前用户文件夹下生成了私钥 `id_rsa` 和公钥 `id_rsa.pub`。

### 初始化 Hugo

#### 安装hugo

windows10下安装hugo，可以参照Hugo官方手册的方法，这里讲一个相对简单稳定的方法。

1.下载hugo程序压缩包：前往https://github.com/gohugoio/hugo/releases下载和自己系统版本相符合的hugo程序压缩包。(建议下载hugo_extended版本)

2.解压到某个文件夹中（路径不要有中文，而且自己要记得文件夹的路径），最好是不常改动的文件夹下边，以防文件被误删或者丢失。

3.添加hugo到系统环境变量PATH中

+ 找到“系统环境变量”的设置位置，在开始菜单的搜索栏搜索环境变量
+ 添加用户环境变量，依此：点击环境变量，找到用户变量中的path，点击编辑，然后点击新建，在使用浏览按钮选中文件夹，即可使用hugo。（选中到hugo.exe所在的文件夹即可，不需要选中hugo.exe，貌似添加完系统变量，要重启电脑才能在Git Bash里运行hugo）
+ 接下来，为了万无一失，还是要检查一下hugo是否安装完成。以管理员方式打开cmd命令窗口，然后输入以下指令：

```bash
hugo version
```

如果得到如下响应，（即显示版本信息），说明安装成功，接下来就可以玩转hugo了。

```bash
Hugo Static Site Generator v0.70.0/extended windows/amd64 BuildDate: unknown
```

#### 创建并配置站点

> 以下命令均在'Git Bash'中运行

进入你想存放 Hugo 网站文件夹的目录，执行以下命令：

```bash
hugo new site blog  
```

#### 添加主题

```bash
git clone https://github.com/dillonzq/LoveIt.git themes/LoveIt
```

附更新主题命令：

```bash
cd ./themes/LoveIt/
git pull
```

配置主题

将 根目录\themes\even\exampleSite路径下的config.toml文件复制到根目录下，覆盖掉根目录下的config.toml文件。然后，我们在notepad++中打开并对其作一定的修改就可以直接使用。

#### 配置config.toml

略

#### 设置文章模板

为了更好的使用附加功能，我们提前修改一下模板。这样，每次使用新建一篇文档时候就省去很多麻烦事。
使用Typora文档工具打开themes/tranquilpeak/archetypes中的post.md直接替换为以下的模板：

```yaml
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
lastmod: {{ .Date }}
draft: false
weight: false
categories: [""]
tags: [""] 
```

　接下来在根目录下使用以下命令生成一篇文档吧：

```bash
hugo new post/XXXX.md
```

#### 新建“关于”页面

```bash
hugo new about.md
```

`config.toml`相应位置添加：

```yaml
[[menu.main]]
  name = "关于"
  weight = 50
  identifier = "about"
  url = "/about/"
```

#### 启动博客的本地预览

建议在配置文件中设置好主题，或者使用 –t指令指定主题，在站点的根目录下使用命令进行本地启动，本地启动的命令如下：

```bash
hugo server -D
```

使用浏览器打开 http://localhost:1313 预览。

## 部署到coding

### coding上的操作

操作和部署到github大同小异，首先要在coding上开通pages静态网站服务，注意以下几点：

- 配置SSH公钥时要勾选启用推送权限。
- 开启Coding Pages 服务，要先在`项目设置—功能开关`里开启持续集成和持续部署。然后进行实名认证：右上角—团队管理—团队设置—高级设置。
- 删除项目，点左下角—项目设置—更多。
- 添加自定义域名，添加cname记录，指向给你的网址。线路选默认。这样就保证国内线路走coding。
- 注意：一定要选首选的域名，并且非首选域名要勾选跳转至首选域名，不然有些第三方服务数据会统计不到一起。
- 开启 HTTPS，要先去域名 DNS 把 GitHub 的解析暂停掉，然后再重新申请 SSL 证书，然后开启强制 HTTPS 访问。（不然会申请失败）

### 提交本地仓库

```bash
rm -rf public/*
hugo
cd public
git remote rm origin
git init
git remote add origin git@e.coding.net:iwyang/hugo/hugo.git
git add .
git commit -m "Add a new post"
git push --force origin master
```

### 解决404错误

可是当你push完hugo生成的静态页面源码到你的repo中后点Coding给你分配的访问地址后却返回的是404页面，其实解决这个问题也很简单，就是点一下上图中的立即部署就行了。

### 自动备份脚本

为了后续更新方便起见，可以在根目录新建一个一键自动部署脚本，命名为`deploy.sh`（如果对配置不做大的改动（例如：更换主题等），后续的更新可以使用以下脚本）

```bash
#!/bin/bash

echo -e "\033[0;32mDeploying updates to gitee...\033[0m"

# Removing existing files
rm -rf public/*
# Build the project
hugo
# Go To Public folder
cd public
git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master --force

# Come Back up to the Project Root
cd ..
```

创建完脚本以后，不要忘了加权限

```bash
chmod 777 xxx
```

---

附网上找到的另外两个部署脚本：

官方脚本：

```bash
#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
cd public
# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master --force

# Come Back up to the Project Root
cd ..
```

另外一个脚本：

```bash
#!/bin/bash

echo -e "\033[0;32mDeploying updates to Coding...\033[0m"

# Removing existing files
rm -rf public/*
# Build the project
hugo
# Go To Public folder
cd public
git remote rm origin
git init
git remote add origin git@e.coding.net:iwyang/hugo.git
git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master --force

# Come Back up to the Project Root
cd ..
```

---

## 部署到gitee

略

### 提交本地仓库

```bash
rm -rf public/*
hugo
cd public
git remote rm origin
git init
git remote add origin git@gitee.com:iwyang/iwyang.git
git add .
git commit -m "Add a new post"
git push origin master --force
```

### 备份hugo源码

```bash
git remote rm origin
git init
git checkout -b backup
git add .
git commit -m "备份源码"
git remote add origin git@gitee.com:iwyang/iwyang.git
git push origin backup --force
```

## 备份hugo源码

### 备份到gitee backup分支

在gitee上新建一个backup的分支，然后把下面代码加到`deploy.sh`末尾，这种方法有个问题，那就是themes等几个文件夹无法备份，因为这几个关联的仓库不一样，不过content文件夹备份了就行。

```bash
git remote rm origin
git init
git checkout -b backup
git add .
git commit -m "备份源码"
git remote add origin git@gitee.com:iwyang/iwyang.git
git push --force origin backup
```

---

PS: **如果执行第三步`git checkout -b backup`后，提示`fatal: A branch named 'backup' already exists.`，则执行以下操作：**

```bash
git branch -D backup    #删除分支:必须切换到其他的分之下才可操作
git checkout -b backup  #切换分支
```

### 备份到github master分支

按理说备份到私人仓库为好，可为了`GitInfo`以及`lastmod`生效，需要新建一个公共仓库。（注意要先备份源码到github上，再部署public里的网页到服务器上，为了方便，需要在自动部署脚本里作相应设置）

```bash
git remote rm origin
git init
git add .
git commit -m "备份源码"
git remote add origin git@github.com:iwyang/hugo.git
git push --force origin master
```

---

> PS:这里`Git Bash`开头会报错：`warning: LF will be replaced by CRLF`，解决方法：在`git add .`前面添加：

```bash
git config --global core.autocrlf false
```

 最终效果：

```bash
# backup
git config --global core.autocrlf false
git add .
git commit -m "备份源码"
git remote add origin git@github.com:iwyang/hugo-backup.git
git push origin master --force
```

在自动部署脚本里也要作相应修改。

---

然后在`config.toml`里作如下修改

```bash
enableGitInfo = true
gitRepo = "https://github.com/iwyang/hugo-backup"
```

## 总结

最好不要反复切换部署仓库，否则git会出现以下错误提示：

```bash
remote: error: The last gc run reported the following. Please correct the root cause
remote: and remove gc.log.
remote: Automatic cleanup will not be performed until the file is removed.
remote:
remote: warning: There are too many unreachable loose objects; run 'git prune' to remove them.
```

查资料，原来是自己本地一些 “悬空对象”太多(git删除分支或者清空stash的时候，这些其实还没有真正删除，成为悬空对象，我们可以使用merge命令可以从中恢复一些文件)

解决方法：

1.输入命令：`git fsck --lost-found`，可以看到好多“dangling commit”

2.清空他们：`git gc --prune=now`，完成

---

**其他**：如果将文章由hexo换成hugo，部署在`github`时，有5篇文章会导致报错：《Hexo Next主题进阶写作技巧 》、《Hexo-NexT (v7.7.2) 主题配置》、《Hexo-NexT 新建友链页面》、《hexo版本升级》、《markdown基本语法》。

## 参考链接

+ [1.Hugo+github搭建个人博客 (windows10)](https://saquarius.com/2019/07/hugo-github%E6%90%AD%E5%BB%BA%E4%B8%AA%E4%BA%BA%E5%8D%9A%E5%AE%A2windows10/#%E5%87%86%E5%A4%87%E5%B7%A5%E4%BD%9C)
+ [2.如何利用 GitHub Pages 和 Hugo 轻松搭建个人博客？](https://zhuanlan.zhihu.com/p/57361697)
+ [3.Hugo 从入门到会用](https://blog.olowolo.com/post/hugo-quick-start/)
+ [4.码云Pages](https://gitee.com/help/articles/4136#article-header0)
+ [5.git运行突然提示 remote: error: The last gc run reported the following](https://blog.csdn.net/persist_xyz/article/details/88619036)