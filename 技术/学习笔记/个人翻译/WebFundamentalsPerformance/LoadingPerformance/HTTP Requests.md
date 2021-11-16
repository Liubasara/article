---
name: HTTP Requests
title: 页面加载性能-HTTP请求
tags: ["技术","学习笔记", "个人翻译", "WebFundamentalsPerformance", "谷歌开发者文档"]
categories: 学习笔记
info: "页面加载性能-HTTP请求"
time: 2021/11/13
desc: '个人翻译, HTTP Requests, Web'
keywords: ['学习笔记', '个人翻译', 'HTTP Requests']
---

# 页面加载性能-HTTP请求

该系列为谷歌开发者文档的一些翻译，对应章节目录链接可以[访问这里](https://developers.google.com/web/fundamentals?hl=zh-cn)

> 原文链接：https://developers.google.com/web/fundamentals/performance/get-started/httprequests-5?hl=zh-cn

一个网页构成所需要的所有东西——文字，图像，样式，脚本，所有的这些都需要通过 HTTP 请求来请求服务器而得到。可以毫不夸张地说，页面显示所用的时间绝大部分都在用来下载这些组件，而不是实际渲染它们。至今我们已经讨论过通过压缩图像、缩小 CSS 和 JavaScript、压缩文件等等手段来减小这些下载手段。不过还有一个更基本的方法我们没有试过，除了仅仅减少下载大小以外，我们还可以考虑减少下载频率。

减少页面所需的组件数量会按比例减少它需要发出的 HTTP 请求数量。这并不意味着省略内容，这只是意味着用更有效的方式来构建组件。

## 合并文本资源

许多网页页面会使用多个样式文件和脚本文件。当我们在开发页面的代码时，为了使代码清晰且易于维护，我们一般会将这些代码文件分开到不同的单独文件里面。亦或者，我们会将自己的样式与市场部门要求我们使用的样式区分开。亦或者我们可能会在测试期间将这些规则和脚本放在单独的文件里。上述这些都是我们拥有多个资源文件的理由。

但由于每个文件都需要它们自己的 HTTP 请求，且每个请求都需要花费时间，所以我们可以通过合并文件的方式来加快网页的加载速度。用一个请求来代替三个或四个请求肯定会节省时间。而第一眼看下来这么作似乎很简单——以 CSS 为例子，似乎只要把所有 CSS 都放到一个主要的样式表里面。然后从页面里面移除掉除该资源以外的其他所有资源就可以了。用这种方式，每移除一个额外的资源就会去除掉一个 HTTP 请求并且节省一个请求的往返时间。但这种方式有一些注意事项：

CSS 样式表允许后面的规则在没有警告的情况下就覆盖前面的规则，且 CSS 不会抛出错误。因此将样式表放在一起是自找麻烦。

> 这部分的解释写的有些冗余，摆了

在合并 JavaScript 文件时，你可能也会遇到类似的情况，内容完全不一样的函数可能会拥有相同的名称，或者名称相同的变量可能会有不同的作用域和用途。但只要你积极寻找的话，这些并不是无法克服的苦难。

合并文字资源从而减少 HTTP 请求是十分值得的，只是在这样做的时候一定要小心就是了。

## 合并图片资源





> 下一段：On its face, this technique sounds a bit nonsensical. Sure, it's logical to combine multiple CSS or JavaScript resources into one file, but images? Actually, it is fairly simple, and it has the same effect of reducing the number of HTTP requests as combining text resources -- sometimes even more dramatically.
