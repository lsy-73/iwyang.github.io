---
title: "hexo利用Github Actions自动构建博客"
slug: "hexo-github-actions"
date: 2020-07-07T19:11:25+08:00
lastmod: 2020-07-07T19:11:25+08:00
draft: false
toc: true
weight: false
categories: ["技术"]
tags: ["hexo","github"]
---

## 生成公钥

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

### 上传id_rsa.pub

在右上角个人账户依次点击`Settings`->`SSH and GPG keys`添加刚刚生成的公钥，名称随意。

### 上传id_rsa

然后在 Settings > Secrets 中新增一个 secret，命名为 `DEPLOY_KEY`，把私钥 `id_rsa` 的内容复制进去，供后续使用。

## 配置 GitHub Actions

### 第一种

在博客根目录新建`.github/workflows/gh_pages.yml`文件。代码如下：

```yaml
name: Hexo Deploy

# 只监听 source 分支的改动
on:
  push:
    branches:
      - develop

# 自定义环境变量
env:
  POST_ASSET_IMAGE_CDN: true

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      # 获取博客源码和主题
      - name: Checkout
        uses: actions/checkout@v2.3.4

      - name: Checkout theme repo
        uses: actions/checkout@v2.3.4
        with:
          repository: jerryc127/hexo-theme-butterfly
          ref: master
          path: themes/butterfly

      # 这里用的是 Node.js 14.x
      - name: Set up Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '14'

      # 设置 yarn 缓存，npm 的话可以看 actions/cache@v2 的文档示例
      - name: Get yarn cache directory path
        id: yarn-cache-dir-path
        run: echo "::set-output name=dir::$(yarn cache dir)"

      - name: Use yarn cache
        uses: actions/cache@v2.1.6
        id: yarn-cache
        with:
          path: ${{ steps.yarn-cache-dir-path.outputs.dir }}
          key: ${{ runner.os }}-yarn-${{ hashFiles('**/yarn.lock') }}
          restore-keys: |
            ${{ runner.os }}-yarn-

      # 安装依赖
      - name: Install dependencies
        run: |
          yarn install --prefer-offline --frozen-lockfile

      # 从之前设置的 secret 获取部署私钥
      - name: Set up environment
        env:
          DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}
        run: |
          sudo timedatectl set-timezone "Asia/Shanghai"
          mkdir -p ~/.ssh
          echo "$DEPLOY_KEY" > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa
          ssh-keyscan github.com >> ~/.ssh/known_hosts

      # 生成并部署
      - name: Deploy
        run: |
          npx hexo deploy --generate
          
      - name: Deploy Hexo to Server
        uses: SamKirkland/FTP-Deploy-Action@4.1.0
        with:
          server: 104.224.191.88
          username: admin
          password: ${{ secrets.FTP_MIRROR_PASSWORD }}
          local-dir: ./public/
          server-dir: /var/www/blog/
```

---

### 第二种

PS：第二种比第一种慢。

首先确认` _config.yml` 文件中有类似如下的 GitHub Pages 配置：

```yaml
deploy:
  type: git
  repo:
    github: git@github.com:iwyang/hexo.git
  branch: gh-pages
```

#### 配置私钥

- 首先在 GitHub 上打开保存 Hexo 的仓库，访问 Settings -> Secrets，然后选择 New secret;
- 名字部分填写：HEXO_DEPLOY_KEY，注意大小写，这个后面的 GitHub Actions Workflow 要用到;
- 在 Value 的部分填入 github-deploy-key 中的内容。

#### 添加公钥

- 接下来我们需要访问存放网页的仓库，也就是 Hexo 部署以后的仓库，访问 Settings -> Deploy keys;
- 按 Add deploy key 来添加一个新的公钥；
- 在 Title中输入：HEXO_DEPLOY_PUB 字样，当然也可以填写其它自定义的名字;
- 在 Key 中粘贴 github-deploy-key.pub文件的内容。

#### 创建 Workflow

**在 Hexo 的仓库中创建一个新文件：.github/workflows/auto_deploy.yml，文件的内容如下:**

```yaml
name: auto deploy # workflow name

# 只监听 source 分支的改动
on:
  push:
    branches:
      - develop

jobs:
  build: # job1 id
    runs-on: ubuntu-latest # 运行环境为最新版 Ubuntu
    name: auto deploy
    steps:
    - name: Checkout # step1 获取源码
      uses: actions/checkout@v1 # 使用 actions/checkout@v1
      with: # 条件
        submodules: true # Checkout private submodules(themes or something else). 当有子模块时切换分支？
    - name: Setup Node.js 12.x
      uses: actions/setup-node@master
      with:
        node-version: "12.x"
    - name: Generate Public Files
      run: |
        npm i
        npm install hexo-cli -g
        hexo clean && hexo generate
    - name: Deploy
      uses: peaceiris/actions-gh-pages@v3
      with:
        deploy_key: ${{ secrets.HEXO_DEPLOY_KEY }}
        external_repository: iwyang/hexo
        publish_branch: public
        publish_dir: ./public
        commit_message: ${{ github.event.head_commit.message }}
        user_name: 'github-actions[bot]'
        user_email: 'github-actions[bot]@users.noreply.github.com'
    - name: Deploy Hexo to Server
      uses: SamKirkland/FTP-Deploy-Action@4.1.0
      with:
        server: 104.224.191.88
        username: hexo
        password: ${{ secrets.FTP_MIRROR_PASSWORD }}
        local-dir: ./public/
        server-dir: /var/www/hexo/
```



## github、gitee、服务器三线部署

```yaml
name: Hexo Deploy

# 只监听 source 分支的改动
on:
  push:
    branches:
      - develop

# 自定义环境变量
env:
  POST_ASSET_IMAGE_CDN: true

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      # 获取博客源码和主题
      - name: Checkout
        uses: actions/checkout@v2.3.4

      - name: Checkout theme repo
        uses: actions/checkout@v2.3.4
        with:
          repository: jerryc127/hexo-theme-butterfly
          ref: master
          path: themes/butterfly

      # 这里用的是 Node.js 14.x
      - name: Set up Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '14'

      # 设置 yarn 缓存，npm 的话可以看 actions/cache@v2 的文档示例
      - name: Get yarn cache directory path
        id: yarn-cache-dir-path
        run: echo "::set-output name=dir::$(yarn cache dir)"

      - name: Use yarn cache
        uses: actions/cache@v2.1.6
        id: yarn-cache
        with:
          path: ${{ steps.yarn-cache-dir-path.outputs.dir }}
          key: ${{ runner.os }}-yarn-${{ hashFiles('**/yarn.lock') }}
          restore-keys: |
            ${{ runner.os }}-yarn-

      # 安装依赖
      - name: Install dependencies
        run: |
          yarn install --prefer-offline --frozen-lockfile

      # 从之前设置的 secret 获取部署私钥
      - name: Set up environment
        env:
          DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}
        run: |
          sudo timedatectl set-timezone "Asia/Shanghai"
          mkdir -p ~/.ssh
          echo "$DEPLOY_KEY" > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa
          ssh-keyscan github.com >> ~/.ssh/known_hosts

      # 生成并部署
      - name: Deploy
        run: |
          npx hexo deploy --generate
          
      - name: Deploy Hexo to Server
        uses: SamKirkland/FTP-Deploy-Action@4.1.0
        with:
          server: 104.224.191.88
          username: admin
          password: ${{ secrets.FTP_MIRROR_PASSWORD }}
          local-dir: ./public/
          server-dir: /var/www/blog/
          
      - name: Sync to Gitee
        uses: wearerequired/git-mirror-action@master
        env:
          # 注意在 Settings->Secrets 配置 GITEE_RSA_PRIVATE_KEY
          SSH_PRIVATE_KEY: ${{ secrets.GITEE_RSA_PRIVATE_KEY }}
        with:
          # 注意替换为你的 GitHub 源仓库地址
          source-repo: git@github.com:iwyang/iwyang.github.io.git
          # 注意替换为你的 Gitee 目标仓库地址
          destination-repo: git@gitee.com:iwyang/iwyang.git

      - name: Build Gitee Pages
        uses: yanglbme/gitee-pages-action@main
        with:
          # 注意替换为你的 Gitee 用户名
          gitee-username: iwyang
          # 注意在 Settings->Secrets 配置 GITEE_PASSWORD
          gitee-password: ${{ secrets.GITEE_PASSWORD }}
          # 注意替换为你的 Gitee 仓库，仓库名严格区分大小写，请准确填写，否则会出错
          gitee-repo: iwyang/iwyang
          # 要部署的分支，默认是 master，若是其他分支，则需要指定（指定的分支必须存在）
          branch: master
```

将hexo三线部署（由于部署hexo较慢，如果单独为`gitee`建立一个`workflows`，gitee会先部署完成，这样无法同步；hugo可以单独为`gitee`建立一个`workflows`，因为`hugo`部署到服务器会先于部署到`gitee`）

## 推送到远端

### 配置Hexo的_config.yml

```yaml
deploy:
  type: git
  repo:
    github: git@github.com:iwyang/iwyang.github.io.git
  branch: master
  name: iwyang
  email: 455343442@qq.com
```

当然，具体步骤还是得根据自己的需求进行相应的修改。

### 提交源码

今后只需备份源码到`develop`分支，`gitbub action`就会自动部署博客到`iwyang.github.io`仓库。

```yaml
git init
git checkout -b develop
git remote add origin git@github.com:iwyang/iwyang.github.io.git
git add .
git commit -m "备份源码"
git push --force origin develop
```

### 最终部署脚本

`deploy.sh`内容：

```bash
#!/bin/bash

echo -e "\033[0;32mDeploying updates to gitee...\033[0m"

# backup
git config --global core.autocrlf false
git add .
git commit -m "site backup"
git push origin develop --force
```

## 参考链接

+ [使用 GitHub Actions 自动部署 Hexo 博客](https://printempw.github.io/use-github-actions-to-deploy-hexo-blog/)
+ [GitHub Actions 实现 Hexo 自动部署](https://weijiajin.com/1f41c35f3517/)

