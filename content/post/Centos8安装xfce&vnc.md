---
title: "Centos8安装xfce&vnc"
slug: "centos8-xfce-vnc"
date: 2020-05-18T14:06:25+08:00
lastmod: 2020-05-18T14:06:25+08:00
draft: false
toc: true
weight: false
categories: ["建站笔记"]
tags: ["服务器"]
---

##  安装 Xfce 桌面环境

```bash
yum install epel-release -y
yum groupinstall xfce -y
```

## 安装 VNC 服务器

```bash
yum install tigervnc-server -y
```

现在安装了 VNC 服务器，下一步是运行 vncserver 命令，该命令将创建初始配置并设置密码。

```bash
vncserver
```

系统将提示您输入并确认密码，以及是否将其设置为仅查看密码。如果您选择设置仅查看密码，则用户将无法使用鼠标和键盘与 VNC 实例进行交互。**所以这里要选择n**。

>You will require a password to access your desktops.
>
>Password:
>Verify:
>Would you like to enter a view-only password (y/n)? n
>/usr/bin/xauth:  file /root/.Xauthority does not exist

在继续下一步之前，首先使用 vncserver 带有 -kill 选项和服务器编号作为参数的命令停止 VNC 实例。在我们的例子中，服务器在端口 5901 (:1)中运行，因此我们将使用以下命令停止它：

```bash
vncserver -kill :1
```

## 配置 VNC 服务器

现在我们的 CentOS 服务器上安装了 Xfce 和 TigerVNC ，下一步是配置 TigerVNC 使用 Xfce 。为此，请打开以下文件：

```bash
vi ~/.vnc/xstartup
```

并将默认内容改为以下内容：

```bash
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4 
```

保存并关闭文件。无论何时启动或重新启动 TigerVNC 服务器，都将自动执行上述脚本。

如果需要将  [附加选项](http://tigervnc.org/doc/vncserver.html) 传递给 VNC 服务器，则可以打开 `~/.vnc/config` 文件并在每行添加一个选项。最常见的选项列在文件中。取消注释并根据自己的喜好进行修改。这是一个例子：

```bash
# securitytypes=vncauth,tlsvnc
# desktop=sandbox
geometry=1024x768
# localhost
# alwaysshared
dpi=96
```

## 创建 Systemd 单元文件

我们将创建一个 systemd 单元文件，使我们能够根据需要轻松启动，停止和重新启动 VNC 服务，与任何其他 systemd 服务相同。

```bash
sudo cp /usr/lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:1.service
```

使用文本编辑器打开文件，并替换为以下内容（本例用户名为root）。

```bash
vi /etc/systemd/system/vncserver@\:1.service
```

```bash
[Unit]
Description=Remote desktop service (VNC)
After=syslog.target network.target

[Service]
Type=forking

# Clean any existing files in /tmp/.X11-unix environment
ExecStartPre=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'
ExecStart=/usr/sbin/runuser -l root -c "/usr/bin/vncserver %i"
PIDFile=/root/.vnc/%H%i.pid
ExecStop=/bin/sh -c '/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :'

[Install]
WantedBy=multi-user.target
```

保存并关闭文件。通知 systemd 我们创建了一个新的单元文件，让其重新加载：

```bash
sudo systemctl daemon-reload
```

下一步是使用以下命令启用单元文件：

```bash
sudo systemctl enable vncserver@:1.service
```

符号 `1` 后面的数字 `@` 定义了 VNC 服务将在其上运行的显示端口，在我们的情况下，这是默认设置 `1` ， VNC 服务器将在端口上侦听， `5901` 如我们在上一节中讨论的那样。

执行以下命令启动 VNC 服务：

```bash
sudo systemctl start vncserver@:1.service
```

验证服务是否已成功启动：

```bash
sudo systemctl status vncserver@:1.service
```

>● vncserver@:1.service - Remote desktop service (VNC)
>Loaded: loaded (/etc/systemd/system/vncserver@:1.service; enabled; vendor pr>
>Active: active (running) since Mon 2020-05-18 14:00:12 CST; 23min ago
>Process: 806 ExecStart=/usr/sbin/runuser -l root -c /usr/bin/vncserver :1 (co>
>Process: 767 ExecStartPre=/bin/sh -c /usr/bin/vncserver -kill :1 > /dev/null >
> Main PID: 1018 (Xvnc)
>Tasks: 0 (limit: 6193)
>Memory: 716.0K

## 连接到 VNC 服务器

下载[vnc viewer](https://www.realvnc.com/en/connect/download/viewer/windows/)，输入`ip:1`登录。

## 参考链接

+ [如何在 CentOS 7 上安装和配置 VNC](https://www.gobeta.net/linux/how-to-install-and-configure-vnc-on-centos-7/)