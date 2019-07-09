---
name: 《深入浅出NodeJs》学习笔记（十）
title: 《深入浅出NodeJs》学习笔记（十）
tags: ['读书笔记', '深入浅出NodeJs']
categories: 学习笔记
info: "深入浅出NodeJs 第9章 玩转进程"
time: 2019/7/4 20:00
desc: '深入浅出NodeJs, 资料下载, 学习笔记, 第9章 玩转进程'
keywords: ['深入浅出NodeJs资料下载', '前端', '深入浅出NodeJs', '学习笔记', '第9章 玩转进程']
---

# 《深入浅出NodeJs》学习笔记（十）

## 第9章 玩转进程

> Node在选型时决定在V8引擎之上构建，也就意味着它的模型与浏览器类似。

但是 Node 进程只能利用一个核，这就引出了两个重要问题：

- 如何充分利用多核 CPU 服务器？
- 一旦单线程上抛出的异常没有被捕获，将会引起整个进程的崩溃，那么 Node 应该如何保证进程的健壮性和稳定性？

在这两个问题中，前者只是利用率不足的问题，后者对于实际产品化带来一定的顾虑。

要知道的是，Node 在严格意义上并非真正的单线程架构，一些 IO 线程和底层 C++ 代码由 libuv 处理，这些开发者接触不到的部分是有可能多线程运行的。但对于开发者所关注到的 JavaScript 开发部分，则永远是运行在 V8 上，是单线程的。

### 9.1 服务模型的变迁

> 从“古”到今，Web服务器的架构已经历了几次变迁。服务器处理客户端请求的并发量，就是每个里程碑的见证。

- 青铜时代：复制进程，**是通过进程的复制同时服务更多的请求和用户，设通过进行复制和预复制的方式搭建的服务器有资源的限制，且进程数上限为M，那这类服务的QPS为M/N**
- 白银时代：多线程，**操作系统只能通过将CPU切分为时间片的方法，让线程可以较为均匀地 使用CPU资源，但是操作系统内核在切换线程的同时也要切换线程的上下文，当线程数量过多时， 时间将会被耗用在上下文切换中**
- 黄金时代：事件驱动，**采用单线程避免了不必要的内存开销和上下文切换开销**

### 9.2 多进程架构

理想状态下，每个进程应各自利用一个 CPU ，以此实现多核 CPU 的利用。而 Node 提供了 child_process 模块并且也提供了一个 child_process.fork() 函数供我们实现进程的复制。

```javascript
// worker.js
var http = require('http')
http.createServer(function (req, res) {
    res.writeHead(200, {'Content-Type': 'text/plain'})
    res.end('Hello World\n')
}).listen((Math.round(1 + Math.random()) * 1000), '127.0.0.1')
```

通过 node 命令来启动，上面的命令将会侦听 1000 到 2000 之间的一个随机端口。

```javascript
var fork = require('child_process').fork
var cpus = require('os').cpus()
for (var i = 0;i < cpus.length;i++) {
    fork('./worker.js')
}
```

运行上面这段代码将会根据当前机器上的CPU数量复制出对应Node进程数。linux 系统下，可以通过`ps aux | grep worker.js`查看到进程的数量。

![linuxPS.jpg](./images/linuxPS.jpg)

这就是著名的 Master-Worker 主从模式。

![masterWorkerMode.jpg](./images/masterWorkerMode.jpg)

通过 fork 复制的进程都是一个独立的进程，它需要至少 30ms 的启动时间和至少 10MB 的内存。

> 尽管 Node 提供了 fork() 供我们复制进程使每个CPU 内核都使用上，但是依然要切记 fork() 进程是昂贵的。好在Node 通过事件驱动的方式在单线程上 解决了大并发的问题，这里启动多个进程只是为了充分将CPU资源利用起来，而不是为了解决并发问题

#### 9.2.1 创建子进程

child_process 模块给予 Node 可以随意创建子进程(child_process)的能力。创建子进程的方法有 4 个：

- spawn(): 启动一个子进程来执行命令
- exec(): 启动一个子进程来执行命令，与 spawn() 不同的是，它有一个回调函数获知子进程的状况
- execFile(): 启动一个子进程来执行可执行文件
- fork(): 与 spawn() 类似，不同点在于它创建 Node 的子进程只需要指定要执行的 JavaScript 文件模块即可

spawn() 与 exec()、execFile() 不同的是，后两者创建时可以指定 timeout 属性设置超时时间，一旦创建的进程运行超过设定的时间将会被杀死。

 exec() 与 execFile() 不同的是，exec() 适合执行已有的命令，execFile() 适合执行文件。四个命令创建子进程的例子如下所示：

```javascript
var cp = require('child_process')
cp.spawn('node', ['worker.js'])
cp.exec('node worker.js', function (err, stdout, stderr) {
    // TODO
})
cp.execFile('worker.js', function (err, stdout, stderr) {
    // TODO
})
cp.fork('./worker.js')
```

![processMethod.jpg](./images/processMethod.jpg)

可执行文件是指可以直接执行的文件，如果是 JavaScript 文件通过 execFile() 运行，需要在首行添加下面的代码：

```javascript
#!/usr/bin/env node
```

> 尽管4种创建子进程的方式有些差别，但事实上后面3种方法都是spawn()的延伸应用。 

#### 9.2.2 进程间通信

> 对于 child_process 模块，创建好了子进程，然后与父子进程间通信是十分容易的。

浏览器中，JavaScript 主线程与 UI 渲染共用同一个线程，两者互相阻塞。





> 本次阅读至P240 9.2.2 进程间通信 258页