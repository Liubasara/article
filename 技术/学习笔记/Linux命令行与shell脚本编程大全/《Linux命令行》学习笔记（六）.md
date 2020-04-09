---
name: 《Linux命令行》学习笔记（六）
title: 《Linux命令行》学习笔记（六）
tags: ["技术","学习笔记","Linux命令行与shell脚本编程大全"]
categories: 学习笔记
info: "第7章 理解Linux文件权限"
time: 2020/4/8
desc: 'Linux命令行与shell脚本编程大全, 资料下载, 学习笔记, 第7章 理解Linux文件权限'
keywords: ['Linux命令行与shell脚本编程大全', 'shell学习', '学习笔记', '第7章 理解Linux文件权限']
---

# 《Linux命令行》学习笔记（六）

## 第7章 理解Linux文件权限

> 本章内容
>
> - 理解Linux的安全性
> - 解读文件权限
> - 使用Linux组

### 7.1 Linux 的安全性

每个能进入 Linux 系统的用户都会被分配唯一的用户账户。用户对系统中各种对象的访问权限取决于他们登录系统时的账号。

用户权限是通过创建用户时分配的**用户ID**(User ID，缩写为 UID)来跟踪的。每个用户都有唯一的 UID，但用户在登录系统的时候使用的不是 UID 而是最长为 8 字符的登录名。

#### 7.1.1 /etc/passwd 文件

Linux 系统使用 /etc/paddwd 文件来将用户的登录名匹配到对应的 UID 值。

```shell
cat /etc/passwd
# root:x:0:0:root:/root:/bin/bash
# katie:x:502:502:katie:/home/katie:/bin/bash
# jessica:x:503:503:Jessica:/home/jessica:/bin/bash
# mysql:x:27:27:MySQL Server:/var/lib/mysql:/bin/bash
```

上面的字段包含了如下信息：

```shell
# 登录用户名:用户密码:用户账户的UID:用户账户的组ID:用户账户的文本描述（备注字段）:用户HOME目录的位置:用户的默认shell
```

其中 root 用户是 Linux 的系统管理员，固定分配给它的 UID 是 0。Linux 系统会为各种各样的功能创建不同的**系统账户**。

> 在安全成为一个大问题之前，这些服务经常会用root账户登录。遗憾的是，如果有非授权的 用户攻陷了这些服务中的一个，他立刻就能作为root用户进入系统。为了防止发生这种情况，现 在运行在Linux服务器后台的几乎所有的服务都是用自己的账户登录。这样的话，即使有人攻入 了某个服务，也无法访问整个系统。

Linux 为系统账户预留了 500 以下的 UID 值。有些服务甚至需要用特定的 UID 才能正常工作。而为普通用户创建账户时，他多数 Linux 系统会从 500 开始。

可以看到 /etc/passwd 文件中的密码字段都被设置成了 x，这是因为该文件中存储的密码是加密过后的用户密码。绝大多数 Linux 系统都会将用户密码保存在另一个单独的文件中（/etc/shadow），只有特定的程序才能访问这个文件。

> 你可以用任何文本编辑器在/etc/password文件里直接手动 进行用户管理（比如添加、修改或删除用户账户）。但这样做极其危险。如果/etc/passwd文件出现 损坏，系统就无法读取它的内容了，这样会导致用户无法正常登录（即便是root用户）。用标准的 Linux用户管理工具去执行这些用户管理功能就会安全许多。

#### 7.1.2 /etc/shadow 文件

只有 root 用户才能访问 /etc/shadow 文件，比起 /etc/passwd 要安全许多。

其中的记录如下所示：

```shell
# rich:$1$.FfcK0ns$f1UgiyHQ25wrB/hykCn020:11627:0:99999:7::: 
```

字段对应含义如下：

- 与/etc/passwd文件中的登录名字段对应的登录名 -> rich
- 加密后的密码 -> $1$.FfcK0ns$f1UgiyHQ25wrB
- 自上次修改密码后过去的天数密码（自1970年1月1日开始计算） -> 11627
- 多少天后才能更改密码 -> 0
- 多少天后必须更改密码 -> 99999
- 密码过期前提前多少天提醒用户更改密码 -> 7
- 密码过期后多少天禁用用户账户
- 用户账户被禁用的日期（用自1970年1月1日到当天的天数表示）
- 预留字段给将来使用 

#### 7.1.3 添加新用户

`useradd`命令可以一次性向 Linux 系统添加创建新用户账户及设置用户 HOME 目录。

默认情况下`useradd`命令使用系统的默认值以及命令行参数来设置用户账户，可以通过查看 /etc/default/useradd 文件或使用`useradd -D`来查看这些默认值。

```shell
useradd -D
# GROUP=100
# HOME=/home
# INACTIVE=-1
# EXPIRE=
# SHELL=/bin/bash
# SKEL=/etc/skel
# CREATE_MAIL_SPOOL=yes
```





> 阅读至 P127 142





