---
name: HTTP Caching
title: 页面加载性能-HTTP缓存
tags: ["技术","学习笔记", "个人翻译", "WebFundamentalsPerformance", "谷歌开发者文档"]
categories: 学习笔记
info: "页面加载性能-HTTP缓存"
time: 2021/11/18
desc: '个人翻译, HTTP Caching, Web'
keywords: ['学习笔记', '个人翻译', 'HTTP Caching']
---

# 页面加载性能-HTTP缓存

该系列为谷歌开发者文档的一些翻译，对应章节目录链接可以[访问这里](https://developers.google.com/web/fundamentals?hl=zh-cn)

> 原文链接：https://developers.google.com/web/fundamentals/performance/get-started/httpcaching-6

当一个人访问网站，网站上所需要展示和操作的一切都会需要来自某个地方。一切的文本，图像，CSS 样式，脚本，多媒体等等文件都必须经由浏览器取回后才能显示或执行。而你可以让浏览器选择从哪里取回这些资源，这对页面的加载速度有着巨大的不同。

浏览器第一次加载网络页面的时候，它会将页面资源存储在 HTTP 缓存中（[HTTP Cache](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching)）。当下次浏览器命中该页面时，它可以在缓存中寻找之前获取的资源并且将它们从磁盘中取回，这种方式通常会比从网络下载要来得快。



> 下一段：While HTTP caching is standardized per the [Internet Engineering Task Force (IETF) specifications](https://tools.ietf.org/html/rfc7234), browsers may have multiple caches that differ in how they acquire, store, and retain content. You can read about how these caches vary in this excellent article, [A Tale of Four Caches](https://calendar.perfplanet.com/2016/a-tale-of-four-caches/).

