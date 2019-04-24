---
name: 《高性能JavaScript》学习笔记（一）
title: 《高性能JavaScript》学习笔记（一）
tags: ['读书笔记', '高性能JavaScript']
categories: 学习笔记
info: "高性能JavaScript 第1章 加载和运行"
time: 2019/4/24
desc: '高性能JavaScript, 资料下载, 学习笔记, 第1章 加载和运行'
keywords: ['高性能JavaScript资料下载', '前端', '高性能JavaScript', '学习笔记', '第1章 加载和运行']
---

# 《高性能JavaScript》学习笔记（一）

> 资料下载地址(pdf压缩文件):
>
> [百度网盘](https://pan.baidu.com/s/1SGSWVpribkbNhVXvSkyZwg)
>
> 提取码: tjdd
>
> **本资料仅用于学习交流，如有能力请到各大销售渠道支持正版 !**

## 第1章 加载和运行

大多数浏览器使用单进程处理 UI 更新和 JavaScript 运行等多个任务，而同一时间只能有一个任务被执行。也就是说在通常情况下，页面加载时，JavaScript 运行了多长时间，用户的等待时间就有多长。

当浏览器遇到一个`<script>`标签时，浏览器会停下来运行此 JavaScript 代码，然后再继续解析，翻译页面。同样的事情发生在使用 src 属性加载 JavaScript 的过程中。浏览器必须首先下载外部文件的代码，然后解析并运行此代码。此过程中，页面解析和用户交互式被完全阻塞的。

**脚本位置**

因为脚本阻塞其他页面资源的下载过程，**所以推荐的办法是，将所有`<script>`标签放在尽可能接近`<body>`标签底部的位置，尽量减少对整个页面下载的影响**。

**成组脚本**

由于每个`<script>`标签下载时阻塞页面解析过程，所以限制页面的`<script>`总数也可以改善性能。每个 HTTP 请求都会产生额外的性能负担，下载一个 100KB 的文件比下载4个 25KB 的文件要快。

你可以通过一些打包工具来将你的 JavaScript 脚本打包成一个单独的文件。

#### 非阻塞脚本

保持 JavaScript 文件短小，并限制 HTTP 请求的数量，只是创建反应迅速的网页应用的第一步。尽管下载一个大 JavaScript 文件只产生一次 HTTP 请求，却会锁定浏览器一大段时间。为避免这种情况，你需要向页面中逐步添加JavaScript。而这意味着在 window 的 load 事件发出之后开始下载代码。

有几种方法可以实现这种效果：

1. 延期脚本

   HTML4 为 `<script>`标签定义了一个扩展属性: defer。一个带有 defer 属性的 script 标签可以放置在文档的任何位置而不会影响性能。

   **PS**：对于现代浏览器来说，该书对于 defer 的描述是错误的。正确的描述可见[这篇文章](https://www.cnblogs.com/jiasm/p/7683930.html)

2. 动态脚本元素

   DOM 允许你使用 JavaScript 动态创建 HTML 中几乎全部的文档内容。一个新的 script 元素可以非常容易地通过标准 DOM 函数创建：

   ```javascript
   var script = document.createElement("script")
   script.type = "text/javascript"
   script.src="file1.js"
   document.getElementsByTagName("head")[0].appendChild(script); 
   ```

   你可以在页面中动态加载很多 JavaScript 文件，但要注意，浏览器不保证文件加载的顺序。如果多个文件的次序十分重要，更好的办法是将这些文件按照正确的次序连成一个文件。

   动态脚本加载时非阻塞 JavaScript 下载中最常用的模式。

3. XHR 脚本注入

   另一个非阻塞方式获得脚本的方法是使用 XHR 对象将脚本注入到页面中。即大名鼎鼎的 Ajax 技术。

   ```javascript
   ajax('example.com/url.js', async: true, success: function (data) {
       var script = document.createElement("script")
       script.type = 'text/javascript'
       script.text = data
       document.getElementsByTagName("head")[0].appendChild(script)
   })
   ```

   此方法的有点是，你可以下载不立即执行的 JavaScript 代码。另一个优点是，同样的代码在所有现代浏览器中都不会引发异常。

   此方法也有缺点：即 JavaScript 文件必须与页面放置在同一个域内，不能从 CDN 下载。(否则会出现跨域问题)

**推荐的非阻塞模式**

> 本次阅读至 18 推荐的非阻塞模式