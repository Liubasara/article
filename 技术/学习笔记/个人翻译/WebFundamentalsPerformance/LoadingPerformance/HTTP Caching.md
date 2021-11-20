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

虽然 HTTP 缓存是根据《Internet 工程任务组（IETF）规范》（[Internet Engineering Task Force (IETF) specifications](https://tools.ietf.org/html/rfc7234)）来进行标准化的，但浏览器却可能会根据获取方式、存储、内容保留方式的不同而存在多种缓存。你可以从这篇优秀的文章中看到这些缓存各不相同的地方：[四个缓存的故事（A Tale of Four Caches）](https://calendar.perfplanet.com/2016/a-tale-of-four-caches/)。

当然，每个第一次访问你的网页的访问者都不会有关于页面的任何缓存。而且即便是重复的访问者，可能也不会有多少 HTTP 缓存，因为他们可能会人为清楚缓存，又或者浏览器会自动这么做，又或者他们会使用控制键组合来强制刷新页面。尽管如此，还有大量的网站用户依然会在拥有某些组件缓存的前提下重复访问你的网站，而这能在加载时间上起到巨大的影响。最大化缓存的使用率在提高回访率的方面有着重要的帮助。

## 开启缓存

缓存的工作原理是基于网页资源的更改频率，将它们进行分类。举例来说，你的网站 logo 图片也许永远俺不会更换，但你的网络脚本则会每隔几天就更改一次。确定哪些类型的内容是静态的，哪些是动态的，对您和您的用户都有好处。

要记住同样重要的一点是，我们认为的浏览器缓存可能实际发生在客户端与真正的服务器中间的任何节点，比如说代理缓存或 CDN 缓存中。

## 缓存头

两个主要的缓存头类型包括：cache-control 和 exjpires 字段，它们决定了资源缓存的特性。一般来说，cache-control 字段比起 expires 字段，被认为是一个更加现代且更灵活的字段，不过这两个字段也可以被同时使用。

缓存头是在服务器的层面上起作用的。举个例子，在一个 Apache 服务上的`.htaccess`文件，被将近一半的活动网站用来设置它们的缓存特性。在识别到对应的资源或是资源类型时——像是图片或者 CSS 文件，缓存就会通过缓存选项来进行开启。

### cache-control



> 下一段：You can enable cache-control with a variety of options in a comma-delimited list. Here is an example of an Apache `.htaccess` configuration that sets caching for various image file types, as matched by an extension list, to one month and public access (some available options are discussed below).

