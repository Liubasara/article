---
name: 《JavaScript异步编程》学习笔记（一）
title: 《JavaScript异步编程》学习笔记（一）
tags: ['读书笔记', 'JavaScript异步编程']
categories: 学习笔记
info: "JavaScript异步编程 第1章 深入理解JavaScript事件"
time: 2019/4/10
desc: 'JavaScript异步编程, 资料下载, 学习笔记, 第1章 深入理解JavaScript事件'
keywords: ['前端', 'JavaScript异步编程', '学习笔记', '第1章 深入理解JavaScript事件']
---

# 《JavaScript异步编程》学习笔记（一）

> 资料下载地址(pdf压缩文件):
>
> [百度网盘](https://pan.baidu.com/s/1PdPSFrLApizcuileAvTFZQ)
>
> 提取码: uyq5
>
> **本资料仅用于学习交流，如有能力请到各大销售渠道支持正版 !**

## 第1章 深入理解 JavaScript 事件

本章将介绍 JavaScript 异步机制，并破除一些常见的误解。

### 1.1 事件的调度

如果想让 JavaScript 中的某段代码将来再运行，可以将它放在回调中。

在常规的认知中，我们对 setTimeout 以及其中的回调函数认知是这样的：

> 给定一个回调及 n毫秒的延迟，setTimeout 就会在 n毫秒后运行该回调。

但是，**可怕的总是那些细节**，哪怕是像 setTimeout 这种看起来很简单的东西。事实上，像上面这样的描述，只能说接近正确，甚至在一些极端情况中，更可以说是完全错误的。

想要真正理解 setTimeout ，必须先大体了解 JavaScript 事件模型。

#### 1.1.1 现在还是将来运行

尝试运行以下代码

```javascript
for ( var i = 1; i <= 3; i++ ) {
    setTimeout(function () {console.log(i)}, 0)
}
// 4 4 4
```

要理解上面输出的这个结果，需要知道以下 3 件事：

- 这里只有一个名为 i 的变量，其作用域由生命语句`var i`定义(该生命语句在不经意间让 i 的作用域不是循环内部，而是扩散至蕴含循环的那个最内侧函数)
- 循环结束后，`i === 4`一直递增，直到不再满足条件`i <= 3`为止
- JavaScript 事件处理器在线程空闲之前不会运行

#### 1.1.2 线程的阻塞

```javascript
var start = new Date()
setTimeout(function () {
    var end = new Date()
     console.log('Time elapsed:', end - start, 'ms')
}, 500)
while (new Date() - start < 1000) {}

// 在 chrome 下运行的结果: Time elapsed: 1000 ms
// 在 EDGE 下运行的结果：Time elapsed: 1001 ms
```

以上代码可以证明 setTimeout  的计时不是精准的。不过，这个数字肯定至少是 1000，因为 setTimeout 在循环结束运行之前不可能被触发。

那么 setTimeout 既然没有使用另一个线程，那它到底干了什么呢。

#### 1.1.3 队列

调用 setTimeout 的时候，**会有一个延时事件排入队列**。然后 setTimeout 调用之后的那行代码运行，接着是再下一行代码，直到再也没有任何代码，JavaScript 引擎才会到**队列**中取出事件来执行。

> 输入事件的工作方式完全一样：用户单击一个已附加有单击事件处 理器的 DOM（Document Object Model，文档对象模型）元素时， 会有一个单击事件排入队列。但是，该单击事件处理器要等到当前 所有正在运行的代码均已结束后（可能还要等其他此前已排队的事 件也依次结束）才会执行。因此，使用 JavaScript的那些网页一不 小心就会变得毫无反应。 

JavaScript 代码永远不会被中断，这是因为代码在运行期间只需要排队事件即可，而这些事件在代码运行结束之前不会被触发。

### 1.2 异步函数的类型

JavaScript 环境提供的异步函数可以分为两大类：

- I/O 函数
- 计时函数

如果想在应用中定义复杂的异步行为，就要使用这两类异步函数作为基本的构造块。

#### 1.2.1 异步的I/O函数

> 创造 Node.js，并不是为了人们能在服务器上运行 JavaScript，仅仅是 因为 Ryan Dahl想要一个建立在某高级语言之上的事件驱动型服务器框架。JavaScript碰巧就是适合干这个的语言。为什么？因为JavaScript 语言可以完美地实现非阻塞式 I/O。 

相比于其他一不小心就会因为IO调用引起"阻塞"的应用，JavaScript 中这种阻塞方式几乎沦为无稽之谈。类似下面的循环将会永远运行下去，不可能停下来。

```javascript
var ajaxRequest = new XMLHttpRequest
ajaxRequest.open('GET', url)
ajaxRequest.send(null)
while (ajaxRequest.readyState === XMLHttpRequest.UNSENT) {
    // readyState 在循环返回之前不会有更改
    // 个人理解：即便数据返回了，由于 JavaScript 的特性，也必须要在这段循环完之后才能进行事件队列的调用，所以是无解的
}
```

相反，我们需要附加一个事件处理器，随即返回事件队列

```javascript
var ajaxRequest = new XMLHttpRequest
ajaxRequest.open('GET', url)
ajaxRequest.send(null)
ajaxRequest.onreadystatechange = function () {
    // ...
}
```

> 在浏览器端，Ajax方法有一个可设置为 false 的 async 选项（但永 远、永远别这么做），这会挂起整个浏览器窗格直到收到应答为止。 
>
> 在 Node.js 中，同步的 API 方法在名称上会有明确的标示，譬如 fs.readFileSync。编写短小的脚本时，这些同步方法会很方便。但是，如果所编写的应用需要处理并行的多个请求或多项操作，则应该避免使用它们。

非阻塞式 I/O 既是障碍也是优势，有了非阻塞式的 IO ，才能自然而然地写出高效的基于事件的代码。

#### 1.2.2 异步的计时函数

> 本次阅读至 P7 1.2.2 异步的计时函数 30