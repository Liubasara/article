---
name: GraphicalContent
title: 页面加载性能-图像内容
tags: ["技术","学习笔记", "个人翻译", "WebFundamentalsPerformance", "谷歌开发者文档"]
categories: 学习笔记
info: "页面加载性能-图像内容"
time: 2021/11/13
desc: '个人翻译, Text Content, Web'
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





> 下一段：Size images based on their intended use
>
> Large images take longer to download than smaller ones. All your images should be appropriately sized for their intended use and should not rely on the browser to resize them for rendering.
