---
name: JavaScript高级程序设计（第4版）
title: JavaScript高级程序设计（第4版）学习笔记（一）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：1. 什么是 JavaScript 2. HTML 中的 JavaScript"
time: 2020/10/6
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']
---

# JavaScript高级程序设计（第4版）学习笔记（一）

> **请到各大销售渠道支持正版**！

## 第 1 章 什么是 JavaScript

基本跟第三版的内容一致，主要介绍了 JavaScript 的诞生渊源、组成部分及其版本历史。

补充内容：

### 1.2 -> .2 DOM

**1. 为什么 DOM 是必须的**

为了保证 Web 跨平台的本性，为了防止浏览器厂商擅自使用不同的实现方式来开发 DHTML，万维网联盟开始了制定 DOM 标准的进程。

**2. DOM 级别**

DOM 标准有 Level1、2、3 的区分，等级越高负责的功能接口越高级。

目前，W3C 不再按照 Level 来维护 DOM 了，而是作为 DOM Living Standard 来维护，其快照称为 DOM4

> 在阅读关于DOM的资料时，你可能会看到DOMLevel0的说法。注意，并没有一 个标准叫“DOM Level 0”，这只是 DOM 历史中的一个参照点。DOM Level 0 可以看作 IE4 和 Netscape Navigator 4 中最初支持的 DHTML。

## 第 2 章 HTML 中的 JavaScript

`<script>`标签由网景公司创造出来并最早实现，用于插入在 HTML 中，又在日后被规范引入。该标签有 8 个属性：

- async：可选，表示应该立即下载脚本但不阻止其他页面动作。

  > 拓展阅读：
  >
  > - [浅谈script标签中的async和defer](https://www.cnblogs.com/jiasm/p/7683930.html)

- defer：可选，表示脚本可以延迟到文档被解析和显示之后再执行。

- charset：可选，代表 src 属性指定的代码字符集。这个属性很少使用，大多数浏览器不在乎它的值

- crossorigin：可选，配置相关请求的 CORS （跨域资源共享）设置。默认不使用 CORS。有`anonmous`和`use-credentials`这两个值，代表出站请求是否会包含凭据。

- language：废弃，最初用于表示代码块中的脚本语言。如 JavaScript、VBScript 等。

- src：可选，表示包含要执行的代码的外部文件。

- type：可选，代替 language，表示代码块中脚本语言的内容类型（MIME 类型）。默认值为"text/javascript"，而 javascript 文件的 MIME 类型通常是"application/x-javascript"（IE 浏览器）或者"application/javascript"（非 IE 浏览器）。如果这个值是`module`，则代码会被当成 ES6 模块，此时代码中的`import`和`export`关键字会生效。

使用了 src 属性的`<script>`元素不应该再在`<script>`和`</script>`标签中再包含其他 JavaScript 代码。如果两者都提供的话，则浏览器只会下载并执行脚本文件，从而忽略行内代码。

#### 2.1.1 标签位置

现代 Web 应用程序通常将所有 JavaScript 引用放在`<body>`元素中的页面内容后面。这样能提前页面的渲染（页面在浏览器解析到`<body>`的起始标签时开始渲染），让用户感觉页面加载得更快。

> 拓展阅读 ：
>
> - [原来 CSS 与 JS 是这样阻塞 DOM 解析和渲染的](https://juejin.im/post/6844903497599549453)

#### 2.1.4 动态加载脚本

通过 JavaScript 中的 DOM API，可以向 DOM 中动态添加 DOM 元素插入到 DOM 中，从而让浏览器加载更多脚本。默认情况下，以这种方式创建的`<script>`元素是以异步方式加载的，相当于添加了`async`属性。不过由于不是所有浏览器都支持`async`属性，因此如果要统一动态脚本的加载行为，可以考虑明确地将其设置为同步加载。

```javascript
let script = document.createElement('script')
script.src = 'test.js'
script.async = false
document.head.appendChild(script)
```

除此以外还有一个问题，以这种方式获取的资源对浏览器预加载器是不可见的。这会严重影响它们在资源获取队列中的优先级，以及有可能会严重影响性能。为此，可以在文档头部显示声明一下。

```html
<link rel="preload" href="test.js"></link>
```







> 本次阅读至 P16 41