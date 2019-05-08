---
name: 《高性能JavaScript》学习笔记（四）
title: 《高性能JavaScript》学习笔记（四）
tags: ['读书笔记', '高性能JavaScript']
categories: 学习笔记
info: "高性能JavaScript 第7章 Ajax异步JavaScript和XML, 第8章 编程实践, 第9章 创建并部署高性能 JavaScript 应用程序"
time: 2019/5/5
desc: '高性能JavaScript, 资料下载, 学习笔记, 第7章 Ajax异步JavaScript和XML, 第8章 编程实践, 第9章 创建并部署高性能 JavaScript 应用程序'
keywords: ['高性能JavaScript资料下载', '前端', '高性能JavaScript', '学习笔记', '第7章 Ajax异步JavaScript和XML', '第8章 编程实践', '第9章 创建并部署高性能 JavaScript 应用程序']
---

# 《高性能JavaScript》学习笔记（四）

## 第7章 Ajax异步JavaScript和XML

Ajax 是高性能 JavaScript 的基石。本章考察从服务器收发数据最快的技术，以及最有效的数据编码格式

### 使用 XHR 时，应使用 POST 还是 GET

当使用 XHR 获取数据时，你既可以选择 POST 也可以选择 GET。如果请求不改变服务器状态，则应尽可能使用 GET，因为 GET 请求会在 URL 地址栏被缓冲起来，当你多次提取相同的数据时，可以提高性能。

只有当 URL 和参数的长度超过了 2048 个字符串时才使用 POST 提取数据。（因为某些浏览器会限制 URL 长度，过长的参数会被截断）

**Sending Data 发送数据**

虽然 XHR 主要用于从服务器获取数据，但它也可以用来将数据发回。数据可以用 GET 或 POST 方式发回，还可以带上任意数量的 HTTP 信息头。

当使用 XHR 将数据发回服务器时，使用 GET 会比使用 POST 要快，因为 GET 请求只占用一个单独的数据包。而 POST  则至少要发送两个数据包：一个用于信息头，另一个用于 POST 体。

POST 更适合于向服务器发送大量数据。因为它不关心额外数据包的数量，也不受 URL 长度限制的影响。

**Beacons 灯标**

使用 JavaScript 来创建一个新的 Image 对象，将 src 属性设置为服务器上的一个脚本文件 URL。此 URL 包含我们打算通过 GET 格式返回的键值对数据。**要注意的是，此时并没有创建 img 元素或者将它们插入到 DOM 中**。

```javascript
var url = '/status_tracker.php'
var params = [
    'step=2',
    'time=12156423'
]
(new Image()).src = url + '?' + params.join('&')
```

服务器取得此数据并保存下来，而不必向客户端返回什么，因此也没有实际的图像显示。这是将信息发回服务器最简单朴实的方法。其开销很小，也不会受到任何服务器端错误的影响。

但这种方法也意味着你会受到很大的限制。比如不能发送 POST 数据，URL 长度被限制。接收返回数据的方法很有限(比如说监听 Image 对象的 load 事件)

```javascript
var url = '/status_tracker.php'
var params = [
    'step=2',
    'time=12156423'
]
(new Image()).src = url + '?' + params.join('&')
beacon.onload = function () {
    if (this.width === 1) {
        // success
    }
    if (this.width === 2) {
        // failure
    }
}
beacon.onerror = function () {
    // Error
}
```

### 数据格式

没有那种数据格式会始终比其他格式更好，传输不同的数据，用到的格式也不尽相同。

**XML**

与其他格式相比，XML 极其冗长。一般情况下，解析 XML 需要占用 JavaScript 程序员相当一部分精力。

**JSON**

JSON 是一种轻量级并易于解析的数据格式，其按照 JavaScript 对象和数组字面语法所编写。

最快的 JSON 格式是使用数组的 JSONP 格式。虽然这只比使用 XHR 的 JSON 略快，但是这种差异会随着列表尺寸的增大而增大。当然，如果要使用 JSONP 的话，服务器返回的必须是可执行的 JavaScript，其使用动态的脚本标签注入技术可以在任何网站中被任何人调用，因此也会带来一些安全问题。

**总结**

总的来说越轻量级的格式越好，最好是 JSON 或者自定义格式

### Ajax性能向导

一旦你选择了最合适的数据传输技术和数据格式，那么就要开始考虑其他的优化技术了。

**缓存数据**

最快的 Ajax 就是不要发出一个不必要的请求，有两种方法可以避免：

- 在服务器端，设置 HTTP 头，确保返回报文在浏览器中（具体的可看之前的[这篇博客](https://blog.liubasara.info/#/post/%E6%B5%85%E8%B0%88HTTP%E7%BC%93%E5%AD%98)）
- 在客户端中，缓存已获取的数据，不要多次请求同一个数据。(localStorage、cookie)

第一种技术容易设置和维护，而第二种能给你最大程度的控制。

**设置 HTTP 头**

在响应报文中发送正确的 HTTP 头，可以让 Ajax 响应报文被浏览器所缓存。

**本地存储数据**

除了依赖浏览器处理缓存以外，你还可以手动实现它，直接在本地存储那些从服务器收到的响应报文。

### 了解 Ajax 库的限制

Ajax 库能让你方便的发起 XHR 请求，但为了在浏览器上统一接口，大多数 Ajax 库都不会让你访问 XMLHttpRequest 的完整功能。

本节会介绍一些只能用 XMLHttpRequest 对象来实现的东西。

大多数 JavaScript 库不允许你直接访问 readystatechange 事件，而这意味着你必须等待整个响应报文接收完，然后才能开始使用它。

但是通过监听这个事件，我们可以在响应报文接收的过程中就开始解析它。

直接操作 XHR 对象可以减少函数开销，进一步提高性能。只是如果放弃使用 Ajax 库，你可能会在不同的浏览器上遇到各种奇怪的兼容问题。

## 第8章 编程实践

### 避免二次评估

当你在 JavaScript 代码中执行另一段 JavaScript 代码时(通俗来说就是使用`eval`、`new Function`来执行字符串代码)，你会付出二次评估的代价。引擎需要首先评估其为正常代码，然后再进行执行。二次评估是一项昂贵的操作，与直接包含相应代码相比将占用更长的时间。

### 使用对象/数组字面量

使用字面量来创建对象和数组不仅能让代码更快，同时也能让其在代码中占用更少的空间。

### 原生方法

无论你怎样优化 JavaScript 代码，它永远不会比 JavaScript 引擎提供的原生方法更快。因为相对于你写的代码来说，这些原生方法早在你的方法加载之前就已经存在于浏览器了。

## 第9章 创建并部署高性能 JavaScript 应用程序



> 本次阅读至 P279 创建并部署高性能 JavaScript 应用程序