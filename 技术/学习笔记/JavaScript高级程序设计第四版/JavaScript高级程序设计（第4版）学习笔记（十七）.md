---
name: JavaScript高级程序设计（第4版）学习笔记（十七）
title: JavaScript高级程序设计（第4版）学习笔记（十七）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：27. 工作者线程"
time: 2020/12/12
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']
---

# JavaScript高级程序设计（第4版）学习笔记（十七）

## 第 27 章 工作者线程

> PS：本章的内容和翻译都基本属于天书级别...差评

JavaScriprt 的单线程可以保证它与不同浏览器 API 兼容，如果 JavaScript 可以多线程执行并发更改，那么像 DOM 这样的 API 就会出现问题。因此 POSIX 线程或 Java 的 Thread 类传统并发结构都不适合 JavaScript。

而这也是工作者线程（worker）的价值所在：允许把主线程的工作转嫁给独立的实体，而不会改变现有的单线程模型。

### 27.1 工作者线程简介

> 工作者线程消耗相对比较重，不建议大量使用。例如，对一张 400 万像素的图片，为每个像素 都启动一个工作者线程是不合适的。通常，工作者线程应该是长期运行的，启动成本比较高， 每个实例占用的内存也比较大。

### 27.2 专用工作者线程

使用`new Worker('./test.js')`可以用于初始化一个工作者线程。

在 test.js 内，通过`self.onmessage = function (data) {}`来接受从主线程传入的参数。

#### 27.2.9 与专用工作者线程通信

与工作者线程的通信都是通过异步消息完成的，但这些消息可以有多种形式。

1. postMessage()

   ```javascript
   // Worker.js
   function factorial (n) {
     return n++
   }
   self.onmessage = ({data}) => {
     self.postMessage(`result is ${factorial(data)}`)
   }
   // main.js
   const factorialWorker = new Worker('./Worker.js')
   factorialWorker.onmessage = ({data}) => console.log(data)
   factorialWorker.postMessage(1)
   
   // result is 2
   ```

2. MessageChannel 对象

   MessageChannel API 可以在两个上下文间明确建立通信渠道，在传递复杂消息时可以替代 postMessage。

   MessageChannel 实例有两个端口，分别代表两个通信端点。要让父页面和工作线程通过 MessageChannel 通信，需要把一个端口传入到工作者线程中。

   ```javascript
   // worker.js
   // 在监听器中存储全局 messagePort
   let messagePort = null
   self.onmessage = ({ports}) => {
     // 只设置一次端口
     if (!messagePort) {
       // 初始化消息发送端口
       // 给变量赋值并重置监听器
       messagePort = ports[0]
       self.onmessage = null
       // 在全局对象上设置消息处理器
       messagePort.onmessage = ({data}) => {
         // 收到消息后发送数据
         messagePort.postMessage(`res is ${++data}`)
       }
     }
   }
   // main.js
   const channel = new MessageChannel()
   const factorialWorker = new Worker('./worker.js')
   // 把 MessagePort 对象发送到工作者线程，让工作者线程负责处理初始化信道
   factorialWorker.postMessage(null, [channel.port1])
   // 通过信道实际发送数据
   channel.port2.onmessage = ({data}) => console.log(data)
   // 工作者线程通过信道响应
   channel.port2.postMessage(1)
   
   // res is 1
   ```

   MessageChannel 真正有用的地方是让两个工作者线程之间直接通信，可以通过把端口传给另一个工作者，这可以通过把端口传给另一个工作者线程实现。

   ```javascript
   // 下面的例子把一个数组传给了一个 worker，而这个 worker 又把它传给了另一个 worker，再传回主线程
   
   // main.js
   const channel = new MessageChannel()
   const workerA = new Worker('./worker.js')
   const workerB = new Worker('./worker.js')
   
   workerA.postMessage('workerA', [channel.port1])
   workerB.postMessage('workerB', [channel.port2])
   
   workerA.onmessage = ({data}) => console.log(data)
   workerB.onmessage = ({data}) => console.log(data)
   
   workerA.postMessage(['page'])
   // ['page', 'workerA', 'workerB']
   workerB.postMessage(['page'])
   // ['page', 'workerB', 'workerA']
   
   // worker.js
   let messagePort = null
   let contextIdentifier = null
   function addContextAndSend(data, destination) {
     // 添加标识符以识别当前工作者进程
     data.push(contextIdentifier)
     // 把数据发送到下一个目标
     destination.postMessage(data)
   }
   
   self.onmessage = ({data, ports}) => {
     // 如果消息里存在端口则初始化工作者线程
     if (ports.length) {
       // 记录标识符
       contextIdentifier = data
       // 获取 MessagePort
       messagePort = ports[0]
       
       // 添加处理程序把接收的数据发回到父页面
       messagePort.onmessage = ({data}) => {
         addContextAndSend(data, self)
       }
     } else {
       addContextAndSend(data, messagePort)
     }
   }
   ```
   
#### 27.2.11 线程池

> 。。。。。。从这里开始本书的内容已经完全看不懂了

### 27.3 共享工作者线程 SharedWorker

共享工作者线程或共享线程与专用工作者线程类似，但可以被多个可信任的执行上下文访问。例如，同源的两个标签页可以访问同一个共享工作者线程。

### 27.4 服务工作者线程 ServiceWorker

> 服务工作者线程(service worker)是一种类似浏览器中代理服务器的线程，可以拦截外出请求和缓 存响应。这可以让网页在没有网络连接的情况下正常使用，因为部分或全部页面可以从服务工作者线程 缓存中提供服务。服务工作者线程也可以使用 Notifications API、Push API、Background Sync API 和 Channel Messaging API。

### 27.5 小结

- 工作者线程可以运行异步 JavaScript 而不阻塞用户界面。
- 工作者线程有自己独立的环境，只能通过异步消息与外界通信。
- 工作者线程可以是专用线程、共享线程。专用线程只能由一个页面使用，而共享线程则可以由同源
- 服务工作者线程用于让网页模拟原生应用程序。服务工作者线程也是一种工作者线程，但它们更像 是网络代理，而非独立的浏览器线程。可以把它们看成是高度定制化的网络缓存，它们也可以在 PWA 中支持推送通知。

## 第 28 章 最佳实践

本章节讲一些代码规范和样例，没啥意思。

## 附录 A ES2018 和 ES2019







> 本次阅读至 P867 892 附录 A ES2018 和 ES2019