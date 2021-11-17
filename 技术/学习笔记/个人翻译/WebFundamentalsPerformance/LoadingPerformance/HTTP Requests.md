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

从表面上看，合并图片资源这种技术听上去好像有点荒谬。合并多个 CSS 或者 JavaScript 资源到一个文件听上去是很合理的，但是合并图片呢？而事实上，这种技术是相当简单的，而且也跟合并文字资源一样，也可以减少 HTTP 的请求数量，有时候效果比起合并文本甚至更加显著。

虽然这种技术可以应用于任何一组图像，但是一般都会用在像图标这种小图标上——额外的 HTTP 请求用来请求这些小图片显得特别浪费。

这种技术主要的做法就是将小图片合并到一张自然的图片文件中，并且使用 CSS 的背景位置（background-position）属性来展示这张图片中的正确部分（通常被称为雪碧图）。使用 CSS 来进行重新定位是无缝且快速的，很适合用于已经下载好的资源中，而且也在大量的 HTTP 请求和图片下载之间做了良好的权衡。

举个例子，您可能会有一系列的社交媒体图标，包含其各自的网站或应用程序的链接。与其下载三个（或者更多）的图像，不如将它们组合成一个图像文件，如下所示：

![request-1.png](./images/request-1.png)

再然后，不要为了不同的链接而使用不同的图片，而是通过一次请求去获取完整的图片并且使用 CSS 来为每个要展示的链接进行背景定位，并且展示图片中链接所对应的正确部分。

下面是一些样例 CSS 和对应的 HTML：

```html
<style>
  a.facebook {
    display: inline-block;
    width: 64px;
    height: 64px;
    background-image: url('socialmediaicons.png');
    background-position: 0px 0px;
  }
  a.twitter {
    display: inline-block;
    width: 64px;
    height: 64px;
    background-image: url('socialmediaicons.png');
    background-position: -64px 0px;
  }
  a.pinterest {
    display: inline-block;
    width: 64px;
    height: 64px;
    background-image: url('socialmediaicons.png');
    background-position: -128px 0px;
  }
</style>

<p>Find us on:</p>
<p><a class="facebook" href="https://facebook.com"></a></p>
<p><a class="twitter" href="https://twitter.com"></a></p>
<p><a class="pinterest" href="https://pinterest.com"></a></p>
```

对于`background-position`这个属性来说，它的默认位置是`0,0`，第一个参数指的是图像相对于容器向左水平移动 x 个像素，第二个参数是图像相对于容器向上移动 y 个像素。

这种简单的技术让 CSS 在幕后进行图像转换，从而会为您节省多次 HTTP 请求，如果您有很多的小图像，比如说导航栏 icon 或者功能按钮，它可以为您节省很多次请求服务器的次数。

您可以在[WellStyled](https://wellstyled.com/css-nopreload-rollovers.html)找到一篇关于此技术写得很好的文章，包括样式代码。

## 一个警告





> 下一段：In our discussion of combining text and graphics, we should note that the newer [HTTP/2](https://developers.google.com/web/fundamentals/performance/http2?hl=zh-cn) protocol may change how you consider combining resources. For example, common and valuable techniques like minification, server compression, and image optimization should be continued on HTTP/2. However, physically combining files as discussed above might not achieve the desired result on HTTP/2.
