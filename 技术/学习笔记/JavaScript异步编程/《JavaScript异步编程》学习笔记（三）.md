---
name: 《JavaScript异步编程》学习笔记（三）
title: 《JavaScript异步编程》学习笔记（三）
tags: ['读书笔记', 'JavaScript异步编程']
categories: 学习笔记
info: "JavaScript异步编程 第3章 Promise对象和Deferred对象 第4章 Async.js 的工作流控制 第5章 worker 对象的多线程技术"
time: 2019/4/16
desc: 'JavaScript异步编程, 学习笔记, 第3章 Promise对象和Deferred对象, 第4章 Async.js 的工作流控制 第5章 worker 对象的多线程技术'
keywords: ['前端', 'JavaScript异步编程', '学习笔记', '第3章 Promise对象和Deferred对象', '第4章 Async.js 的工作流控制', '第5章 worker 对象的多线程技术']
---

# 《JavaScript异步编程》学习笔记（三）

## 第3章 Promise对象和Deferred对象

本章介绍的是基于Jquery的Promise，在 ES6 已经普及的今天显得稍稍有些过时，建议快速阅读~但是开头的一节小品还是很有意思的。

Promise 对象代表一项有两种可能结果的任务，它还持有多个回调，出现不同结果时会分别触发响应的回调。

> 大家可能会奇怪：这种变化能有什么好处呢？为什么非得在触发 Ajax 调用之后再附加回调呢？一言以蔽之：封装。如果 Ajax 调用要实现 很多效果（既要触发动画，又要插入 HTML，还要锁定/解锁用户输 入，等等），那么仅由负责发出请求的那部分应用代码来处理所有这 些效果，显然很蠢很拙劣。 

使用 Promise 对象最大的优势在于，它可以轻松从现有 Promise 对象派生出新的 Promise 对象。

### 3.7 jQuery 与 Promise/A 的对比

> 从功能上看，jQuery的 Promise与 CommonJS的 Promises/A几乎完全 一样。Q.js 库是流行的 Promises/A 实现，其提供的方法甚至能与 jQuery的 Promise和谐共存。这两者的区别只是形式上的，即用相同 的词语表示不同的含义。
>
> 在 jQuery 1.8问世之前，jQuery的 then 方法只是一种可以同时调用 done、fail和progress这3种回调的速写法，而Promises/A的then 在行为上更像是 jQuery 的 pipe。jQuery 1.8 订正了这个问题，使得 then 成为 pipe 的同义词。不过，由于向后兼容的问题，jQuery 的Promise再如何对 Promises/A示好也不太会招人待见。

基于上述原因，应该尽量避免在同一个项目中混用多个 Promise 实现。

## 第4章 Async.js 的工作流控制

本章介绍使用 Async.js 来进行工作流控制，消解异步代码中的"套话"。

在 ES7 中官方支持了 async / await 语法，但是标准中的语法和 Async.js 虽然都用于异步编程，但在使用中其实并不一样，希望读者不要混淆二者。

本章大多在讲工具库函数的使用，暂且略过...

## 第5章 worker 对象的多线程技术

**事件是多线程技术的替代品。更准确地说，事件能够代替一种特殊的多线程，即应用程序进程可拆分成多个部分同时运行的多线程技术**。

但对于真正的多线程技术来说，最需要关注的点还在于"锁"机制，即不同线程之间访问同一资源的顺序问题。

> 另一方面，向多颗 CPU 内核分发任务又日益成为基本需求，因为这 些 CPU 内核不再像过去期望的那样持续地大幅提升效率。因此，我们需要多线程技术。那这是否意味着要放弃基于事件的编程呢？ 
>
> 恰恰相反！尽管只运行在一个线程上确实不怎么理想，但天真地将应用直接分发给多个内核更加糟糕。多内核系统的那些内核如果必须经 常交谈以避免相互拆台，那么整个系统就会慢得像蜗牛爬一样。最好能让每颗内核领取一项独立的作业，然后偶尔同步一下。 

本章会讲述浏览器端及 Node 环境中的 worker 对象和一些实践应用。

### 5.1 网页版 worker 对象

网页版 worker 对象是 HTML5 标准的一部分。要生成 worker 对象，只需要以脚本 URL 为参数来调用全局 Worker 构造函数即可。

```javascript
var worker = new Worker('worker.js')
worker.addEventListener('message', function (e) {
    console.log(e.data) // 重复由 postMessage 发送的任何东西
})
```

worker 对象的交互接口呈现出便利的对称设计：我们可以使用 worker.postMessage 来发送消息，而 worker 本身可以使用 self.addEventListener('message', ...) 来接收消息。

#### 5.1.1 网页版 worker 对象的局限性

网页版 worker 的首要目标是在不损害 DOM 响应能力的前提下处理复杂的计算。一般在网页中有几种用法：

- 解码视频
- 加密通信
- 解析网页式编辑器中的文本(富文本)

> 在基于 Ace的编辑器中键入代码时， Ace需要先进行一些相当繁重的字符串分析，然后再使用恰当的语法 高亮格式更新 DOM。在现代浏览器中，这种分析工作通常会另开一 个独立线程来做，以确保编辑器能保持平滑度和响应度。 

在通常情况下，为了避免竞态的出现，worker 对象会把自己的计算结果发送给主线程，由主线程去更新页面。基于类似的理由，worker 对象也看不到全局的 window 对象和主线程及其他 worker 线程中的其他任何对象。

通过 postMessage 发送的对象会透明地作序列化和反序列化(有点类似于`JSON.parse(JSON.stringify(obj))`，但实际效果更强(能解决`undefined`和循环引用的情况))。

worker 对象甚至不能使用 console 对象，它只能看到自己的全局对象 self，以及 self 已捆绑的所有东西：标准的 JavaScript 对象(如 setTimeout 和 Math)，以及浏览器的 Ajax 方法。

还有一个特殊的 importScripts 函数可以**同步地加载并运行**指定的脚本。

`importScripts('https://example-js.com/example.js')`

### 5.2 cluster 带来的 Node 版 worker

简单了解由 cluster 库带来的 worker 即可。

```javascript
var cluster = require('cluster');
if (cluster.isMaster) {
    // 分化 worker 对象
    var coreCount = require('os').cups().length
    for (var i = 0; i < coreCount; i++) {
        var worker = cluster.fork()
        worker.send('Hello, Worker!')
        worker.on('message', function (message) {
            if (message._queryId) return;
            console.log(message)
        })
    }
} else {
    process.send('Hello, main process!')
    process.on('message', function (message) {
        console.log(message)
    })
}
```

> 以上这段代码的输出次序是不可预知的，因为每个线程都竞相抢占 console.log。大家必须用 Ctrl+C快捷键手动结束此进程。

#### 5.2.2 Node 版 worker 对象的局限性

> 大多数情况下，cluster 对象和网页版 worker对象遵守同样的规则： 有一个主线程和多个 worker 线程，它们之间的交流基于一些带有序 列化对象或附连字符串的事件。不过，网页版 worker 在浏览器端显 然是二等公民，而 Node版 worker却几乎拥有主线程的所有权利和权限，但以下这些除外（但不限于这些）： 
>
> - 关停应用程序的能力
> - 孵化出更多 worker 对象的能力
> - 彼此交流的能力