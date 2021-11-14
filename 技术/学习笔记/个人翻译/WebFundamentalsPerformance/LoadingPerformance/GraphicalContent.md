---
name: GraphicalContent
title: 页面加载性能-图像内容
tags: ["技术","学习笔记", "个人翻译", "WebFundamentalsPerformance", "谷歌开发者文档"]
categories: 学习笔记
info: "页面加载性能-图像内容"
time: 2021/11/12
desc: '个人翻译, Graphical Content, Web'
keywords: ['学习笔记', '个人翻译', 'Graphical Content']
---

# 页面加载性能-图像内容

该系列为谷歌开发者文档的一些翻译，对应章节目录链接可以[访问这里](https://developers.google.com/web/fundamentals?hl=zh-cn)

> 原文链接：https://developers.google.com/web/fundamentals/performance/get-started/graphicalcontent-4?hl=zh-cn

由于本章的谷歌机翻比较完善，所以仅对一些重要的内容进行翻译。

网络用户是一群视觉群体，他们依赖图片来支持网站的内容。就像文字内容一样，图像内容也是在网页或应用程序中传达信息的关键组成部分。

但是图像需要大量的时间和带宽来下载和呈现，很容易在一个典型的网站中占据占总带宽的 65%~85%。因此，获得获取显著性能提升的一个主要方法就是减少图片资源加载所需要的时间，让我们研究一些方法来解决这个问题吧。

## 移除非必要的图像

太多的网站会将很多大而无用的图像放在“首屏”，而这会减慢页面的加载速度并且让阅读者在获得有意义的内容之前就将页面向下滚动了一半。

认真考虑是否真的需要这些图像，如果需要，是否是立即需要，可以在更重要的内容之后加载吗？如果不是，是否可以对其进行优化，使其对页面加载的影响最小？

如果图像没有增加信息价值或为用户阐明含义，请将其删除，您删除的每个图像都会加快页面的加载时间。

## 选择合适的图像类型

结论：PNG 用于剪贴画，线条图或是任何需要透明度的地方，JPG 用于照片，GIF 用于需要动画的地方。

PNG 是一种无损压缩格式，JPG 则是有损压缩的格式，但是对于一般的图像来说它们并不会有明显的视觉差异，而 JPG 图像的大小通常比 PNG 小得多，因此，在可能的地方应该尽可能用 JPG。

## 删除图像元数据

元数据存在于大多数图像中，其中包括相机数据/日期时间戳/文件格式/分辨率等信息，对于大多数的网站来说，元数据并不重要，因此我们最好将其删除。可以使用一些图像编辑器或者是一些在线工具来做到这一点，比如 VerExif：http://www.verexif.com/en/

该在线工具用于上传图像并识别要删除的元数据。

## 调整图像大小

### 根据预期的使用来调整图片大小

使用到的图像都应该根据其预期用途适当调整大小，并且不应该用浏览器的 CSS 来调整它们的大小以进行渲染。

### 降低图像质量

在大多数情况下，可以降低 JPG 的质量，从而降低文件大小，而不会出现任何明显的质量差异。

一些图像处理工具：

- [XNConvert](https://www.xnview.com/en/xnconvert/)：跨平台工具用于处理批量图像，并执行大小调整，优化和其他转换
- [ImageOptim](https://imageoptim.com/mac)：用于 Mac 和在线服务的免费工具，用于专门优化图像以提高速度，还包括元数据删除功能
- [ResizeIt](https://itunes.apple.com/us/app/resizeit/id416280139?mt=12)：Mac 专用桌面产品，可以同时更改多个图像的大小，并可以同时转换文件格式
- [Gimp](https://www.gimp.org/)：一个广受欢迎的跨平台工具，可以让您执行各种图像处理任务，包括调整大小。

更多的工具可以查阅 CrazyEgg 的一篇综合文章：https://www.crazyegg.com/blog/image-editing-tools/

### 压缩图像

使用压缩工具可以进一步压缩 PNG 和 JPG 图像，从而减小文件大小而不影像图像尺寸或视觉质量。例如可以使用免费的在线压缩工具 TinyPng 来完成图像压缩。

https://tinypng.com/

不要认为 PNG 是无损的就不能被进一步压缩，事实上确实可以。TinyPng 不是唯一可用的工具，下面这篇文章对图像压缩产品做了一个很好地总结：

http://enviragallery.com/9-best-free-image-optimization-tools-for-image-compression/

## 概括

图形内容大小是一个很容易解决的主要领域，但它确实可以显著提高您的网站在加载页面时的速度。除此以外，下面的链接中还有更多有关于图像优化的出色文章：

[https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/image-optimization](http://tinyurl.com/pmy5d9f)
