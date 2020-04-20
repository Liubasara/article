---
name: 《Linux命令行》学习笔记（八）
title: 《Linux命令行》学习笔记（八）
tags: ["技术","学习笔记","Linux命令行与shell脚本编程大全"]
categories: 学习笔记
info: "第9章 安装软件程序"
time: 2020/4/17
desc: 'Linux命令行与shell脚本编程大全, 资料下载, 学习笔记, 第9章 安装软件程序'
keywords: ['Linux命令行与shell脚本编程大全', 'shell学习', '学习笔记', '第9章 安装软件程序']
---

# 《Linux命令行》学习笔记（八）.md

## 第 9 章 安装软件程序

> 本章内容：
>
> - 安装软件
> - 使用 Debian 包
> - 使用 Red Hat 包

### 9.1 包管理基础

PMS（包管理系统：package management system）利用一个数据库来记录各种相关内容：

- 系统上安装了什么软件包
- 每个包安装了什么文件
- 每个已安装软件包的版本

Linux 利用 PMS 工具可以通过互联网访问存储着软件包的服务器，这些服务器称为**仓库**。可以用 PMS 工具来搜索新的软件包或者更新已安装的软件包。

PMS工具及相关命令在不同的Linux发行版上有很大的不同。Linux中广泛使用的两种主要的 PMS基础工具是`dpkg`和`rpm`。 

基于Debian的发行版（如Ubuntu和Linux Mint）使用的是`dpkg`命令，该命令会直接和 Linux 系统上的 PMS 交互。

基于Red Hat的发行版（如Fedora、openSUSE及Mandriva）使用的是`rpm`命令。

### 9.2 基于 Debian 的系统

`dpkg`命令是基于 Debian 系 PMS 工具的核心，这个 PMS 的其他工具有：

- apt-get
- apt-cache
- aptitude

其中，aptitude 是 apt 和 dpkg 的前端，命令行下使用 aptitude 有助于避免常见的软件安装问题。

#### 9.2.1 用 aptitude 管理软件包

![linux-aptitude-1.jpg](./images/linux-aptitude-1.jpg)

以上是该命令的交互式界面。

```shell
aptitude show package_name
# 列出相关包所安装的全部文件
dpkg -L package_name
# 查找某个特定文件属于哪个软件包，注意，在使用的时候必须用绝对文件路径。 
dpkg --search absolute_file_name 
```

可以用上面的命令显示包的对应详情。

#### 9.2.2 用 aptitude 安装软件包







> 阅读至 P163  178