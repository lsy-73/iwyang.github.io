---
title: "halo定时备份的方法"
slug: "halo-backup"
date: 2020-07-26T21:49:25+08:00
lastmod: 2020-07-26T21:49:25+08:00
draft: false
toc: true
weight: false
categories: ["技术"]
tags: ["halo"]
---

 在网上查询了一下halo定时备份有三种方案：邮箱和Dropbox，以及github。

## 备份到QQ邮箱

### **安装邮件发送依赖组件**

#### Centos 7

```bash
yum install sendmail mailx -y
```

#### Centos 8

```bash
yum -y install postfix sendmail-cf mailx
service postfix start
sudo systemctl enable postfix
```

### 修改附件发送大小限制

看下现在邮件的大小限制：

```bash
sudo postconf message_size_limit
```

<div class="note info">message_size_limit = 10240000</div>

差不多是10M，放大10倍，应该差不多了。

```bash
sudo postconf -e "message_size_limit = 102400000"
```

### 获得&编辑备份脚本

```bash
wget https://raw.githubusercontent.com/iwyang/scripts/master/halo_email_backup.sh
```

#### 创建备份文件夹

<div class="note primary">如果选择将文件备份到临时目录的话，这步可跳过，直接修改脚本即可。我直接跳过了这一步。</div>

```bash
mkdir -p /home/back
```

#### 修改脚本

脚本原来模样：

```js
#!/bin/bash
# 进入到备份文件夹
cd /home/back
#压缩网站数据
tar zcvf web_$(date +"%Y%m%d").tar.gz 网站目录
# 导出数据库到备份文件夹内
mysqldump -uroot -p数据库密码 数据库名称 > web_data_$(date +"%Y%m%d").sql
# 以附件形式发送数据库到指定邮箱
echo "Blog date"|mail -s "Backup$(date +%Y-%m-%d)" -a web_data_$(date +"%Y%m%d").sql 收件人邮箱
# 删除本地3天前的数据
rm -rf web_$(date -d -3day +"%Y%m%d").tar.gz web_data_$(date -d -3day +"%Y%m%d").sql
# 登录FTP
lftp ftp地址 -u ftp用户名,ftp密码 << EOF
# 进入FTP根目录
cd ftp根目录文件夹
# 删除3天前备份文件
mrm web_$(date -d -3day +"%Y%m%d").tar.gz
mrm web_data_$(date -d -3day +"%Y%m%d").sql
# 上传当天备份文件
mput web_$(date +"%Y%m%d").tar.gz
mput web_data_$(date -d -3day +"%Y%m%d").sql
bye
EOF
```

根据实际需求，改成下面模样：

```
vi halo_email_backup.sh
```

```js
#!/bin/bash
cd /tmp
tar zcvf web_$(date +"%Y%m%d").tar.gz /root/.halo
echo "Blog date"|mail -s "Backup$(date +%Y-%m-%d)" -a web_$(date +"%Y%m%d").tar.gz 455343442@qq.com
rm -f web_$(date +"%Y%m%d").tar.gz
```

上面代码中最后的`rm -f web_$(date +"%Y%m%d").tar.gz`，表示删除本地的临时文件。

### 设置定时任务

#### 赋予文件执行权限

```bash
chmod +x /root/halo_email_backup.sh
```

运行的时候就输入下面的代码即可：`./halo_email_backup.sh`

#### 设定自动任务

```bash
crontab -e
```

```bash
01 00 * * * /root/halo_email_backup.sh
```

意思是每天凌晨0:01运行这个脚本。

## 备份到Dropbox

### 创建Dropbox应用

首先，需要创建一个Dropbox应用，可以从该网址进行创建：https://www.dropbox.com/developers/apps/create

在这里，应用类型选择`Dropbox API`，数据存储类型选择`App folder`，然后`命名`创建。然后记录下`App key`，`App secret`，`token`，下面要用。

### 下载dropbox_uploader.sh

[dropbox_uploader](https://github.com/andreafabrizi/Dropbox-Uploader/) 是一个第三方Dropbox备份脚本，首先下载脚本：

```bash
curl "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o dropbox_uploader.sh
```

然后，为该脚本添加执行权限：

```bash
chmod +x dropbox_uploader.sh
```

执行该脚本，绑定APP：

```bash
./dropbox_uploader.sh
```

根据提示输入Dropbox应用中的`token`，然后输入`y`确认。

之后可以执行下面的命令测试上传，提示Done就是绑定成功了：

```bash
./dropbox_uploader.sh upload /etc/passwd /backup/passwd.old
```

### 编写备份脚本

编写定时备份脚本，取名为`backup.sh`。代码原来模样如下：

```bash
vi backup.sh
```

```js
#!/bin/bash
SCRIPT_DIR="/root" #这个改成你存放刚刚下载下来的dropbox_uploader.sh的文件夹位置
DROPBOX_DIR="/backup" #这个改成你的备份文件想要放在Dropbox下面的文件夹名称，如果不存在，脚本会自动创建
BACKUP_SRC="/home/wwwroot /usr/local/nginx/conf" #这个是你想要备份的本地服务器上的文件，不同的目录用空格分开
BACKUP_DST="/tmp" #这个是你暂时存放备份压缩文件的地方，一般用/tmp即可
MYSQL_SERVER="localhost" #这个是你mysql服务器的地址，一般填这个本地地址即可
MYSQL_USER="mysqluser" #这个是你mysql的用户名名称，比如root或admin之类的
MYSQL_PASS="password" #这个是你mysql用户的密码
# 下面的一般不用改了
NOW=$(date +"%Y.%m.%d")
DESTFILE="$BACKUP_DST/$NOW.tar.gz"
# 备份mysql数据库并和其它备份文件一起压缩成一个文件
mysqldump -u $MYSQL_USER -h $MYSQL_SERVER -p$MYSQL_PASS --all-databases > "$NOW-Databases.sql"
echo "数据库备份完成，打包网站数据中..."
tar cfzP "$DESTFILE" $BACKUP_SRC "$NOW-Databases.sql"
echo "所有数据打包完成，准备上传..."
# 用脚本上传到dropbox
$SCRIPT_DIR/dropbox_uploader.sh upload "$DESTFILE" "$DROPBOX_DIR/$NOW.tar.gz"
if [ $? -eq 0 ];then
     echo "上传完成"
else
     echo "上传失败，重新尝试"
fi
# 删除本地的临时文件
rm -f "$NOW-Databases.sql" "$DESTFILE"
```

根据实际情况改成下面模样：

```js
#!/bin/bash
SCRIPT_DIR="/root" 
DROPBOX_DIR="/backup" 
BACKUP_SRC="/root/.halo" 
BACKUP_DST="/tmp"
NOW=$(date +"%Y.%m.%d")
DESTFILE="$BACKUP_DST/$NOW.tar.gz"
echo "打包网站数据中..."
tar cfzP "$DESTFILE" $BACKUP_SRC
echo "所有数据打包完成，准备上传..."
$SCRIPT_DIR/dropbox_uploader.sh delete "$DROPBOX_DIR"
$SCRIPT_DIR/dropbox_uploader.sh upload "$DESTFILE" "$DROPBOX_DIR/$NOW.tar.gz"
if [ $? -eq 0 ];then
     echo "上传完成"
else
     echo "上传失败，重新尝试"
fi
rm -f "$DESTFILE"
```

**先用`$SCRIPT_DIR/dropbox_uploader.sh delete "$DROPBOX_DIR"`删除`Dropbox`备份文件夹，再上传文件。这样就保证`Dropbox`永远只有一个最新的备份文件，不用手动删除多余的备份文件了**。

---

当然也可以通过脚本设置保留旧数据的时长。如下面一个脚本就是让旧数据在Dropbox保留7天，本地保留10天。（不过觉得没有必要，还是上面的方法简单，下面方法尝试过，老是出现问题，旧数据删除不了，不想折腾了）

```js
#!/bin/bash
 
# 定义需要备份的目录
WEB_DIR=/home/www # 网站数据存放目录
 
# 定义备份存放目录
DROPBOX_DIR=/$(date +%Y-%m-%d) # Dropbox上的备份目录
LOCAL_BAK_DIR=/home/backup # 本地备份文件存放目录
 
# 定义备份文件名称
DBBakName=DB_$(date +%Y%m%d).tar.gz
WebBakName=Web_$(date +%Y%m%d).tar.gz
 
# 定义旧数据名称
Old_DROPBOX_DIR=/$(date -d -7day +%Y-%m-%d)
OldDBBakName=DB_$(date -d -10day +%Y%m%d).tar.gz
OldWebBakName=Web_$(date -d -10day +%Y%m%d).tar.gz
 
cd $LOCAL_BAK_DIR
 
#使用命令导出数据库
mongodump --out $LOCAL_BAK_DIR/mongodb/ --db bastogne
 
#压缩数据库文件合并为一个压缩文件
tar zcf $LOCAL_BAK_DIR/$DBBakName $LOCAL_BAK_DIR/mongodb
rm -rf $LOCAL_BAK_DIR/mongodb
 
#压缩网站数据
cd $WEB_DIR
tar zcf $LOCAL_BAK_DIR/$WebBakName ./*
 
cd ~
#开始上传
./dropbox_uploader.sh upload $LOCAL_BAK_DIR/$DBBakName $DROPBOX_DIR/$DBBakName
./dropbox_uploader.sh upload $LOCAL_BAK_DIR/$WebBakName $DROPBOX_DIR/$WebBakName
 
#删除旧数据
rm -rf $LOCAL_BAK_DIR/$OldDBBakName $LOCAL_BAK_DIR/$OldWebBakName
./dropbox_uploader.sh delete $Old_DROPBOX_DIR/
 
echo -e "Backup Done!"
```

---

### 赋予文件执行权限

```bash
chmod +x backup.sh
```

运行的时候就输入下面的代码即可：`./backup.sh`

### 设置定时任务

```bash
crontab -e
```

```bash
02 00 * * * /root/backup.sh
```

这样，就可以每天凌晨00:02自动备份到Dropbox了。

### 修改时区

如果你不知道服务器当前时间，可以使用下面的命令，查看当前时间：

```bash
date -R
```

修改当前时区为上海（这步未进行）：

```bash
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

## 备份到github

### 准备工作

首先当然是在服务器上安装`GIt`，配置`ssh公钥`，并且在`github`上添加服务器`ssh公钥`。具体过程略。

### 初始化仓库

```bash
cd /root/.halo
git init
git remote add origin git@github.com:iwyang/halo.git
git add .
git commit -m "site backup"
git push --force origin master
```

---

注意要删除主题文件夹下的`.git`文件夹，不然的话就无法备份主题了。当然也可以不备份主题，因为主题所有配置选项都在数据库里。如果这样的话，命令要作如下调整：

```bash
git add application.yaml upload/ db/
```

---

### 设置定时任务

#### 编写备份脚本

```bash
cd /root
vi github.sh
```

脚本原来模样：

```js
#!/bin/bash
#进入到网站根目录，记得修改为自己的站点
cd /home/xxx.com
#将数据库导入到该目录，这里以mysql为例，passwd为数据库密码，typecho为数据库名称，typecho.sql为备份的数据库文件
mysqldump -uroot -ppasswd typecho > typecho.sql
git add -A
git commit -m "backsite"
git push -u origin master
```

根据实际情况修改如下：

```js
#!/bin/bash
echo -e "\033[0;32mDeploying updates to github...\033[0m"
cd /root/.halo
git add .	
git commit -m "site backup"
git push --force origin master
```

为了防止服务器里`.git`文件夹过大，脚本可以作如下调整：

```js
#!/bin/bash
echo -e "\033[0;32mDeploying updates to github...\033[0m"
cd /root/.halo
rm -rf .git
git init
git remote add origin git@github.com:iwyang/halo.git
git add .    
git commit -m "site backup"
git push --force origin master
rm -rf .git
```

#### 赋予文件执行权限

```bash
chmod +x /root/github.sh
```

#### 设定自动任务

```bash
crontab -e
```

```js
03 00 * * * /root/github.sh
```

意思是每天凌晨0:03运行这个脚本。

### 还原博客

```bash
git clone git@github.com:iwyang/halo.git .halo
```

 接下来就是配置个 Java 环境，下载个 Halo 运行包，配置域名访问。具体可参考[官方文档](https://halo.run/)。

## 总结

`halo`博客迁移后，最好删除`logs`文件夹下的日志文件。

---

## SCP命令

### 下载文件

从服务器下载文件到本地，在`Git Bash`执行：

```bash
scp root@104.224.191.88:/root/.ssh/mysite ssh
```

意思是将服务器`/root/.ssh`目录下的mysite文件复制到当前路径下`ssh`文件夹下。

### 上传文件

从本地上传文件到服务器，在`Git Bash`执行：

```bash
scp .halo.zip root@137.220.43.191:/root/
```

意思是将当前目录下`.halo.ip`文件上传到服务器`/root/目录下`。

## wordpress常用命令

<div class="note primary">附录：wordpress常用mysql命令</div>

```yaml
# 1.删除数据库
mysqladmin -u root -p drop wordpress
# 2.新建一个空数据库
mysqladmin -u root -p create wordpress
# 3.导入数据
mysql -uroot -p”你的密码” wordpress < 你的数据sql文件
# 4.更新Url
# 4.1.连接数据库
mysql -u root -p
# 4.2. 选择数据库
use wordpress
# 4.3.更新URL
SELECT * FROM wp_options WHERE option_name = 'home';
UPDATE wp_options SET option_value="https://new_url/" WHERE option_name = "home";

SELECT * FROM wp_options WHERE option_name = 'siteurl';
UPDATE wp_options SET option_value="https://new_url/" WHERE option_name = "siteurl";
```

---

## `nginx`: command not found 解决方案

只需要输入`source /etc/profile` ，让配置文件重新生效一下即可。

## 参考链接

+ [1.Linux 每日自动备份到FTP及数据库通过邮箱发送方法](https://www.moerats.com/archives/69/)
+ [2.fetchmail: SMTP error: 552 5.3.4 Message size exceeds fixed limit](http://blog.sina.com.cn/s/blog_7edf8b9f0100to4p.html)
+ [3.如何将服务器上的网站数据定时自动备份到Dropbox](http://sufaming.com/?p=189)
+ [4.Linux 定时备份服务器/网站数据到Github私人仓库](https://www.moerats.com/archives/858/)
+ [5.MySQL 教程](https://www.runoob.com/mysql/mysql-tutorial.html)
+ [6.Changing the WordPress site URL using the MySQL command line](https://precisionsec.com/changing-the-wordpress-site-url-using-the-mysql-command-line/)
+ [7.CentOs8系统安装mailx发邮件](https://blog.csdn.net/jia12216/article/details/106098267)



