---
name: 《C#高级编程》学习笔记（1）
title: 《C#高级编程》学习笔记（1）
tags: ["技术","学习笔记","C#高级编程"]
categories: 学习笔记
info: "C#高级编程 前言 第1章 .NET应用程序和工具"
time: 2022/12/27
desc: 'C#高级编程, 学习笔记, 前言, 第1章 .NET应用程序和工具'
keywords: ['学习笔记', 'C#', 'C#高级编程', '第1章 .NET应用程序和工具']
---

#  《C#高级编程》学习笔记（1）

> 资料下载地址(pdf压缩文件):
>
> [百度网盘（第 11 版）](https://pan.baidu.com/s/1KkGd9IJS2vANd_-gUJ1q4A?pwd=5sjz)
>
> 提取码: 5sjz 
>
> **本资料仅用于学习交流，如有能力请到各大销售渠道支持正版 !**

**译者序**

C# 是微软公司在 2000 年 6 月发布的一种面向对象的，运行于 .NET Framework 之上的高级程序设计语言。

C# 是兼顾了系统开发和应用开发的最佳实用预言，很有可能成为编程语言历史上的第一个“全能型”预言，它提供了一下软件工程要素的支持：

- 强类型检查
- 数组维度检查
- 未初始化的变量引用检测
- 自动垃圾收集

目前，C# 已发布到 7.x 版本，自 C# 6 以后，.NET Core 提供了代码的共享，使 C# 能够运行在 Windows、Linux 和 Mac 操作系统上，也因此让 C# 得以在任何操作系统上进行构建。

本书分为四个部分：

1. 第一部分：给出 C# 语言的基础知识
2. 第二部分：介绍独立于应用程序类型的 .NET Core 和 Windows Runtime
3. 第三部分：论述 Web 应用程序和服务
4. 第四部分：介绍如何使用 XAML 构建应用程序

## 前言

.NET 有很长的历史，但是 .NET Core 很年轻，.NET Core 2.0 从 .NET Freamework 中获得了许多新的 API，使其更容易将现有的 .NET Framework 程序迁移到 .NET Core 中。

下面是 .NET Core 部分特性的总结：

- .NET Core 是开源的
- .NET Core 使用现代模式
- .NET Core 支持在多个平台上开发
- ASP.NET Core 可以再 Windows 和 Linux 上运行

## 第 1 章 .NET 应用程序和工具

### 1.1 选择技术

.NET 是在 Windows 平台上创建应用程序的杰出技术。但现在，.NET 是在 Windows、Linux 和 Mac 上创建应用程序的杰出技术。

.NET Core 是 .NET 自其发明以来最大的变化，它是开源的代码，还可以为其他平台创建应用程序。

### 1.2 回顾 .NET 历史

下图显示了 .NET Framework 的版本、对应的公共语言运行库（Common Language Runtime，CLR）的版本、C# 的版本以及 Visual Studio 版本。

![1-1.png](./images/1-1.png)

#### 1.2.1 C# 1.0 —— 一种新语言

C# 1.0 是一种全新的编程语言，用于 .NET Framework。C# 编程语言主要受到 C++、Java 和 Pascal 的影响。.NET 的编译器会将 C# 代码编译成中间语言代码（Intermediate Language，IL）代码。IL 代码是面向对象的机器码。CLR 包含一个 JIT 编译器，垃圾收集器，调试器扩展和线程实用工具。

### 1.3 .NET 术语

使用 .NET Framework，可以创建 Windows Forms、WPF 和在 Windows 上运行的旧 ASP.NET 应用程序。

使用 .NET Core，可以创建在不同平台上运行的 ASP.NET Core 和控制台应用程序。

![1-3.png](./images/1-3.png)

#### 1.3.3 .NET Standard

.NET Standard 是一个协定，该协定规定了需要实现哪些 API。.NET Framework、.NET Core 和 Xamarin 实现了这个标准。

### 1.4 用 .NET Core CLI 编译

在本书的许多章节并不需要 Visual Studio，而可以使用任何的编辑器和命令行。可以使用 .NET Core 命令行接口来创建和编译应用程序。

#### 1.4.1 设置环境

访问 https://dot.net 并单击 Get Started 按钮，可以下载各操作系统平台的 .NET SDK。

在 WIndows 上，不同版本的 .NET Core 运行库以及 NuGet 包安装在用户配置文件中。所有不同版本的 NuGet 包（一种 zip 文件，包含单个或多个程序、配置信息和 PowerShell 脚本）都存储在这个文件夹中。

安装 .NET Core CLI 工具，要把 dotnet 工具作为入口点来启动所有这些工具，只需要启动：

```shell
dotnet --help
# 或者
dotnet -h
```

#### 1.4.2 创建应用程序









> 本次阅读至 P51 下次阅读应至 P62



