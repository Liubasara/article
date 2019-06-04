---
name: 《深入浅出NodeJs》学习笔记（七）
title: 《深入浅出NodeJs》学习笔记（七）
tags: ['读书笔记', '深入浅出NodeJs']
categories: 学习笔记
info: "深入浅出NodeJs 第7章 网络编程"
time: 2019/6/3
desc: '深入浅出NodeJs, 资料下载, 学习笔记, 第7章 网络编程'
keywords: ['深入浅出NodeJs资料下载', '前端', '深入浅出NodeJs', '学习笔记', '第7章 网络编程']
---

# 《深入浅出NodeJs》学习笔记（七）

## 第7章 网络编程

本章介绍 Node 在网络服务器方面的具体能力。

对于 Node 而言，只需要几行代码即可构建服务器，无需额外的，像 Apache 或 Nginx 这样的容器。

Node 提供了 net、dgram、http、https 这4个模块，分别用于处理 TCP、UDP、HTTP、HTTPS，适用于服务器端和客户端。

### 7.1 构建 TCP 服务

目前多数应用都是基于 TCP 搭建而成的。

#### 7.1.1 TCP

TCP 全名为传输控制协议，在 OSI 模型中属于传输层协议。

![OSImodel.jpg](./images/OSImodel.jpg)

TCP 是面向连接的协议，其显著特征是在传输之前需要进行3次握手，正常断开需要进行4次挥手。

#### 7.1.2 创建 TCP 服务器端

使用 Node 来创建一个 TCP 服务器端的代码如下：

```javascript
var net = require('net')
var server = net.createServer(function (socket) {
    // 新连接
    socket.on('data', function (data) {
        socket.write('你好')
    })
    socket.on('end', function () {
        console.log('连接断开')
    })
    socket.write('hi')
})
server.listen(8124, function () {
    console.log('server bound')
})
```

通过`net.createServer(listener)`的方式就可以创建一个 TCP 服务器，listener 是连接事件 connection 的侦听器，也可以采用如下的方式进行侦听：

```javascript
var server = net.createServer()
server.on('connection', function (socket) {
    // 新的连接
})
server.listen(8124)
```

除了服务器外，你还可以自行使用 net 模块构建客户端来测试上面的服务端代码：

```javascript
var net = require('net')
var client = net.connect({port: 8124}, function () {
    console.log('client connected')
    client.write('world\r\n')
})
client.on('data', function (data) {
    console.log(data.toString())
    client.end()
})
client.on('end', function () {
    console.log('client disconnected')
})
```

#### 7.1.3 TCP 服务的事件

上述的示例中，代码分为服务器事件和连接事件。

其中通过 net.createServer() 创建的服务器是一个 EventEmitter 的实例，其自定义事件有以下几种：

- listening：在调用 serer.listen() 绑定端口或者 Domain Socket 后触发。也可以通过`server.listen(port, listeningListener)`中的第二个参数来定义
- connection：每个客户端连接到服务器端时触发，也可以通过`net.createServer()`中的最后一个参数来定义
- close：当服务器关闭时触发，在调用`server.close()`后，服务器停止接受套接字，等待所有连接都断开后，会触发此事件
- error：服务器发生异常时触发该事件，如果不侦听 error 事件，服务器将会抛出异常

还有一类事件是**连接事件**，该事件在数据传输时触发，既可以通过 data 事件来读取另一端传过来的数据，也可以通过 write 方法从一端向另一端发送数据。

- data：当一端调用 write() 发送数据，另一端会触发 data 事件，事件传递的数据就是 write 发送的数据。
- end：连接中的任意一端发送了 FIN 数据触发该事件
- drain：当任意一端调用 write 发送数据，当前端会触发该事件
- error：异常发生时触发
- close：套接字完全关闭时触发
- timeout：当一定时间后连接不再活跃时，事件将会被触发，用于通知用户。

此外，由于 TCP 套接字是可写可读的 Stream 对象，所以可以使用 pipe() 方法巧妙的实现管道操作。

> 值得注意的是，TCP针对网络中的小数据包有一定的优化策略：Nagle算法。如果每次只送一个字节的内容而不优化，网络中将充满只有极少数有效数据的数据包，将十分浪费网络资源。 Nagle算法针对这种情况，要求缓冲区的数据达到一定数量或者一定时间后才将其发出，所以小数据包将会被Nagle算法合并，以此来优化网络。这种优化虽然使网络带宽被有效地使用，但是数据有可能被延迟发送。
>
> 在Node中，由于TCP默认启用了Nagle算法，可以调用socket.setNoDelay(true)去掉Nagle算法，使得write()可以立即发送数据到网络中。 
>
> 另一个需要注意的是，尽管在网络的一端调用write()会触发另一端的data事件，但是并不意味着每次write()都会触发一次data事件，在关闭掉Nagle算法后，另一端可能会将接收到的多个小数据包合并，然后只触发一次data事件。

### 7.2 构建 UDP 服务



> 本次阅读至 P154 7.2 构建UDP服务 172