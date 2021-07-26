---
title: "hugo利用Github Action自动构建博客"
slug: "hugo-github-action"
date: 2020-07-06T17:19:19+08:00
lastmod: 2021-07-26T17:19:19+08:00
draft: false
toc: true
weight: false
categories: ["建站笔记"]
tags: ["hugo"]
---

## 初始化 GitHub 仓库

Github上新建一个名为`iwyang.github.io`的仓库。

## 配置`ACTIONS_DEPLOY_KEY`

### 生成公钥

Windows 上安装 [Git for Windows](https://git-for-windows.github.io/) 之后在开始菜单里打开 Git Bash 输入：

```
git config --global user.name "你的用户名"
git config --global user.email "你的电子邮箱"
```

```
cd ~
mkdir .ssh
cd .ssh
ssh-keygen -t rsa
```

在系统当前用户文件夹下生成了私钥 `id_rsa` 和公钥 `id_rsa.pub`。

### 上传id_rsa.pub

点击博客仓库的Settings->Deploy keys->add deploy key，Title填写`ACTIONS_DEPLOY_KEY`，Key填写`id_rsa.pub`文件的内容。

### 上传id_rsa

点击博客仓库的Settings->Secrets->Add a new secret，Name填写`ACTIONS_DEPLOY_KEY`，Value填写`id_rsa`文件的内容。

## 配置 Github actions

在博客根目录新建`.github/workflows/gh_pages.yml`文件。代码如下：

```yaml
name: GitHub Page Deploy

on:
  push:
    branches:
      - develop
jobs:
  build-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout master
        uses: actions/checkout@v1
      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: 'latest'
          extended: true

      - name: Build Hugo
        run: |
          hugo

      - name: Deploy Hugo to gh-pages
        uses: peaceiris/actions-gh-pages@v2
        env:
          ACTIONS_DEPLOY_KEY: ${{ secrets.ACTIONS_DEPLOY_KEY }}
          PUBLISH_BRANCH: master
          PUBLISH_DIR: ./public
```

如果使用的是`loveit主题`并且使用algolia搜索，则还要配置自动更新索引，需在`gh_pages.yml`里作相应修改：

```
name: GitHub Page Deploy

on:
  push:
    branches:
      - develop
jobs:
  build-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout master
        uses: actions/checkout@v1
      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: 'latest'
          extended: true

      - name: Build Hugo
        run: |
          hugo && npm install atomic-algolia --save && npm run algolia

      - name: Deploy Hugo to gh-pages
        uses: peaceiris/actions-gh-pages@v2
        env:
          ACTIONS_DEPLOY_KEY: ${{ secrets.ACTIONS_DEPLOY_KEY }}
          PUBLISH_BRANCH: master
          PUBLISH_DIR: ./public
```

2021.7.17：目前使用下面的：

```yaml
name: GitHub Page Deploy

on:
  push:
    branches:
      - develop
jobs:
  build-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout master
        uses: actions/checkout@v2
      # with:
      # submodules: true  # Fetch Hugo themes (true OR recursive)
      # fetch-depth: 0    # Fetch all history for .GitInfo and .Lastmod
      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: 'latest'
          extended: true

      - name: Build Hugo
        run: hugo --minify && npm install atomic-algolia --save && npm run algolia

      - name: Deploy Hugo to gh-pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          PUBLISH_BRANCH: master
          PUBLISH_DIR: ./public
        # cname:
```

## 推送到远端

### 修改主题文件夹

将主题文件夹里的`.git`、`gitignore`、`.github`等文件夹都删除。

### 修改根目录`.gitignore`文件

```
/public
```

### 提交源码

初始化git，新建并切换到`develop`分支，将源码提交到`develop`分支。稍等片刻，github action会自动部署blog到`master`分支。

```
git init
git checkout -b develop
git remote add origin git@github.com:iwyang/iwyang.github.io.git
git add .
git commit -m "备份源码"
git push --force origin develop
```

 ### 最终部署脚本如下：

```bash
#!/bin/bash

echo -e "\033[0;32mDeploying updates to gitee...\033[0m"

# backup
git submodule update --remote
git config --global core.autocrlf false
git add .
git commit -m "site backup"
git push origin develop --force
```

## 服务器操作

### 克隆仓库

```
rm -rf /var/www/hexo
git clone git@github.com:iwyang/iwyang.github.io.git /var/www/hexo
```

### 出现问题

执行上一步可能会出现问题：` Permission denied (publickey). Could not read from remote repository`。

解决方法：

#### 服务器生成ssh key

```
yum install rsync -y
ssh-keygen -t rsa -C "455343442@qq.com"
```

一路回车即可，会生成你的ssh key。然后再终端下执行命令：

```
ssh -v git@github.com
```

这时会报错，最后两句是：

```
No more authentication methods to try.  
　　Permission denied (publickey).
```

在终端再执行以下命令：

```
ssh-agent -s 
```

接着在执行:

```
ssh-add ~/.ssh/id_rsa
```

出现问题：`Could not open a connection to your authentication agent.`

解决方法：使用：`ssh-agent bash` 命令，然后再次使用`ssh-add ~/.ssh/id_rsa_name`这个命令就没问题了。(**注意**：Identity added: ...这是ssh key文件路径的信息，如`/.ssh/id_rsa`)

#### 配置github

打开你刚刚生成的`id_rsa.pub`，将里面的内容复制，进入你的github账号，在settings下，SSH and GPG keys下new SSH key，然后将id_rsa.pub里的内容复制到Key中，完成后Add SSH Key。

#### 验证Key

```
ssh -T git@github.com 
```

### 设置crontab定时任务：

```
crontab -e
*/5 * * * * git -C /var/www/hexo pull
```

这样只要提交源码给github，`github action`就会帮你部署博客到`github page`，服务器通过`git pull`定时拉取更新。换台电脑不用再搭建环境，直接在gtihub新建或者修改文章，剩下的工作就交给`github action`。注意回本地电脑先`git pull`拉取更新，再提交源码。

**注意：好像先要从源码仓库clone一份源码到本地，才能利用`git pull`拉取github已有的更新。只有先拉取github已有的更新，再在本地提交源码，github上的更新才不会被删除**。

### 本地操作

```
git clone -b develop git@github.com:iwyang/iwyang.github.io.git blog --recursive
```
因为使用`Submodule`管理主题，所以最后要加上 `--recursive`，因为使用 git clone 命令默认不会拉取项目中的子模块，你会发现主题文件是空的。（另外一种方法：`git submodule init && git submodule update`）

---

#### 同步更新源文件

```
git pull
```

#### 同步主题文件

```
git submodule update --remote
```

运行此命令后， Git 将会自动进入子模块然后抓取并更新，更新后重新提交一遍，子模块新的跟踪信息便也会记录到仓库中。这样就保证仓库主题是最新的。

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

## 使用 GitHub Actions 实现文件自动化部署

下面记下`使用 GitHub Actions 实现文件自动化部署`。（未测试）

### 准备工作

安装`rsync`：

```
yum install rsync -y
```

### 建立SSH密钥对

为了方便，在服务器上生成SSH密钥对：

```bash
mkdir -p ~/.ssh && cd ~/.ssh
ssh-keygen -t rsa -f mysite
```

这里一路回车就行，执行完成后，会在`~/.ssh`下生成两个文件：`mysite`（私钥）和`mysite.pub`（公钥）。其中私钥是你的个人登录凭证，**不可以分享给他人**，如果别人得到了你的私钥，就能登录到你的服务器。公钥则需要放到登录的目标服务器上。

### 把 public key 加入到 authorized_keys 里面

将公钥`mysite.pub`的内容贴到目标服务器的`~/.ssh/authorized_keys`中，如果上一步你直接是在服务器中执行，则只要：

```
cat mysite.pub >> authorized_keys
```

否则，手动复制公钥的内容，粘贴到`~/.ssh/authorized_keys`后面即可，若文件或目录不存在，可以自己创建。这一步的目的，是告诉目标服务器：「我以后用这个私钥登录，你需要允许哈」。

### 修改 ssh folder 权限

确保服务器`~/.ssh`文件夹的权限低于711，我这里直接用600（仅本用户可读写）

```bash
chmod 600 -R ~/.ssh
```

### 设置 ssh 配置文件，打开密钥登录功能

```
vi /etc/ssh/sshd_config
```

```diff
+ PermitRootLogin yes
- #PubkeyAuthentication yes
+ PubkeyAuthentication yes
```

### 重启 ssh 服务

```
service sshd restart
```

### 复制 private key 到 GitHub

将`private key` 复制到 `GitHub repo -> setttings -> secrets`里，并且命名为`DEPLOY_KEY`。顺便在`secrets`里设置一下`SSH_HOST`和`SSH_USERNAME`。

```
SSH_HOST：服务器IP
SSH_USERNAME：root
```

### 编写工作流文件

 repo 的根目录创建 .github/workflows/develop.yml 文件，以后每次 master branch 有新的 commit，这个 action 就会执行。

```yaml
name: Deploy Site

on:
  push:
    branches:
      - master # only run this workflow when there's a new commit pushed to the master branch

jobs:
  deploy: # job_id
    runs-on: ubuntu-latest # environment: use ubuntu

    steps: # automated steps
      - name: Checkout Repo # 1. checkout repo
        uses: actions/checkout@v2 # Use a third party action (https://github.com/actions/checkout)

      - name: Deploy to Server # 2. deploy to remote server
        uses: AEnterprise/rsync-deploy@v1.0 # Use a third party action (https://github.com/AEnterprise/rsync-deploy)
        env:
          DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }} # use pre-configured secret (the private key)
          ARGS: -avz --delete # must have this variable
          SERVER_PORT: "22" # SSH port
          FOLDER: ./ # folder to push (./ is the root of current repo)
          SERVER_IP: ${{ secrets.SSH_HOST }} # use pre-configured ssh_host value (e.g., IP or domain.com）
          USERNAME: ${{ secrets.SSH_USERNAME }} # use pre-configured ssh_username value
          SERVER_DESTINATION: /var/www/xxx/ # put your repo files on this directory of the remote server
```

---

另外一个例子：

```yaml
name: Deploy site files

on:
  push:
    branches:
      - master  # 只在master上push触发部署
    paths-ignore:   # 下列文件的变更不触发部署，可以自行添加
      - README.md
      - LICENSE

jobs:
  deploy:

    runs-on: ubuntu-latest   # 使用ubuntu系统镜像运行自动化脚本

    steps:  # 自动化步骤
    - uses: actions/checkout@v2   # 第一步，下载代码仓库

    - name: Deploy to Server  # 第二步，rsync推文件
      uses: AEnterprise/rsync-deploy@v1.0  # 使用别人包装好的步骤镜像
      env:
        DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}   # 引用配置，SSH私钥
        ARGS: -avz --delete --exclude='*.pyc'   # rsync参数，排除.pyc文件
        SERVER_PORT: '22'  # SSH端口
        FOLDER: ./  # 要推送的文件夹，路径相对于代码仓库的根目录
        SERVER_IP: ${{ secrets.SSH_HOST }}  # 引用配置，服务器的host名（IP或者域名domain.com）
        USERNAME: ${{ secrets.SSH_USERNAME }}  # 引用配置，服务器登录名
        SERVER_DESTINATION: /home/fming/mysite/   # 部署到目标文件夹
    - name: Restart server   # 第三步，重启服务
      uses: appleboy/ssh-action@master
      with:
        host: ${{ secrets.SSH_HOST }}  # 下面三个配置与上一步类似
        username: ${{ secrets.SSH_USERNAME }}
        key: ${{ secrets.DEPLOY_KEY }}
        # 重启的脚本，根据自身情况做相应改动，一般要做的是migrate数据库以及重启服务器
        script: |
          cd /home/fming/mysite/
          python manage.py migrate
          supervisorctl restart web
```

<div class="note primary">有了GitHub Actions这个利器，除了自动部署，还可以做自动备份……只要你想，你甚至能提交代码自动触发房间开灯。当然，这些都必须围绕一个GitHub代码仓库来做。推荐大家把自己用到的代码都放到Git上管理，一是可以备份方便重建，二是可以利用这些周边的生态，来让你的生活更简单。不要再用百度网盘存代码、用FTP客户端传文件了。</div>

---

## 参考链接

+ [1.使用Github Actions自动编译部署基于hugo的博客](https://yanlong.me/post/deploy-blog-use-github-actions/)
+ [2.用 Hugo 自动构建 搭建 GitHub Pages](https://juejin.im/post/5e0d9f61f265da5d0d435a24)
+ [3.使用 GitHub Action 自动部署博客到远程服务器](https://blog.lunawen.com/posts/20200628-luna-tech-github-action-blog-autodeployment/)
+ [4.使用 GitHub Actions 实现博客自动化部署](https://frostming.com/2020/04-26/github-actions-deploy)
+ [5.解决git@github.com: Permission denied (publickey). Could not read from remote repository](https://blog.csdn.net/ywl470812087/article/details/104459288)
+ [6.GIT 子模块](https://yihui.org/cn/2017/03/git-submodule/)
+ [7.子模块](https://zj-git-guide.readthedocs.io/zh_CN/stable/basic/%E5%AD%90%E6%A8%A1%E5%9D%97.html)

