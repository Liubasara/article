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

> 下一段：Many web pages use multiple stylesheets and script files. As we develop pages and add useful formatting and behavior code to them, we often put pieces of the code into separate files for clarity and ease of maintenance. Or we might keep our own stylesheet separate from the one the Marketing Department requires us to use. Or we might put experimental rules or scripts in separate files during testing. Those are all valid reasons to have multiple resource files.
