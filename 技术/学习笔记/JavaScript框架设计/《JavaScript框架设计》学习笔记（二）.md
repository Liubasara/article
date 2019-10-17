---
name: 《JavaScript框架设计》学习笔记（二）
title: 《JavaScript框架设计》学习笔记（二）
tags: ["技术","学习笔记","JavaScript框架设计"]
categories: 学习笔记
info: "前言、第 4 章 浏览器嗅探与特征侦测、第 5 章 类工厂"
time: 2019/10/17
desc: 'JavaScript框架设计, 资料下载, 学习笔记'
keywords: ['JavaScript框架设计资料下载', '前端', '学习笔记']
---

# 《JavaScript框架设计》学习笔记（二）

## 第 4 章 浏览器嗅探与特征侦测

### 4.1 判定浏览器

早期所有框架都是通过`navigator.userAgent`进行浏览器判定的，当然有些个别没良心的浏览器厂商就无法识别了...

### 4.2 事件的支持侦测

顾名思义，就是通过代码来判定浏览器对某种事件的支持，从而决定是否要采用代替方案。

### 4.3 样式的支持侦测

CSS3 带来了许多好用的样式，但麻烦的是对于没有标准化的样式，每个浏览器都会有自己的私有前缀。

浏览器为此实现了一个`CSS.suports`方法，[用法可以点这里进行了解](https://developer.mozilla.org/zh-CN/docs/Web/API/CSS/supports)。

```javascript
CSS.supports('display', 'flow-root') // chrome: true
```

结论：随着浏览器的疯狂更新版本，标准浏览器啊引发的各种 BUG 已经超越 IE 了。特征侦测不退反进，正变得越来越重要。

## 第 5 章 类工厂



> 本次应阅读至 P72 第 5 章 类工厂 84