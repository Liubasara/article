---
name: WebRTC权威指南学习笔记（5）
title: WebRTC权威指南学习笔记（5）
tags: ["技术","学习笔记","WebRTC权威指南"]
categories: 学习笔记
info: "第7章 数据通道"
time: 2021/4/24
desc: 'WebRTC权威指南, 资料下载, 学习笔记'
keywords: ['WebRTC权威指南', 'WebRTC', '学习笔记']
---

# WebRTC权威指南学习笔记（5）

## 第7章 数据通道

WebRTC 数据通道是在浏览器之间建立的一种非媒体交互连接。它为 Web 开发人员提供了一种灵活且可配置的通道，用于绕过服务器来直接交换数据。对于某些应用程序，借助采用 WebSocket 连接或 HTTP 消息的服务器传递少量数据就足以满足需要。而数据通道支持流量大、延迟低的连接，既稳定可靠，又不失灵活性。

本章将介绍数据通道、JavaScript API 以及底层协议。

### 7.1 数据通道简介

虽然有关 WebRTC 的宣传主要侧重于它对于对等媒体的支持，但其原设计师一直都希望它也支持实时数据传输。

数据通道模型基于 WebSocket 建立，具有简单且可设置的 send 方法和 onmessage 处理程序。数据通道的创建非常简单，下一节将对此进行介绍。不过与媒体不同的是，单个对等连接中的多个数据通道全都使用同一个底层流。在实际中，这意味着只需要进行一次提议/应答协商即可建立首个数据通道，之后将自动根据用于该数据通道的协议协商所有新的数据通道，因此无须在 JavaScript 级别进行额外的提议/应答交换，即可添加更多数据通道。

为数据通道提供此功能的底层协议被称为流控制传输协议（Stream Control Transport Protocol，SCTP）。

### 7.2 使用数据通道

数据通道 API 是对等连接 API 的一部分，因此只有在创建 RTCPeerConnection 实例后才能创建数据通道。

```javascript
pc = new RTCPeerConnection()
dc = pc.createDataChannel('dc1')
```

这是创建数据通道的最简便方式。新数据通道的标签将为 dc1。利用上面的简单语法创建数据通道时，将导致对等端收到 RTCDataChannelEvent，通过为对等连接设置 ondatachannel 处理程序，可在对等端处理该事件。

```javascript
pc = new RTCPeerConnection()
pc.ondatachannel = function (e) {
  dc = e.channel
}
```

此时，两个对等端之间已建立双向数据数据通道。无论数据通道通过`createDataChannel()`创建还是通过`ondatachannel`返回，现在都可以通过`send()`方法和 onmessage 处理程序来使用它。

```javascript
dc.send('I can send a text string')
dc.send(new Blob(['I can send blobs'], { type: 'text/plain' }))
dc.send(new arrayBuffer(32)) // 发送 arrayBuffer
dc.send(new uInt8Array([1, 2, 3])) // 还发送 arrayBufferViews
dc.onmessage = function (e) {
  console.log('Received message' + e.data)
}
```

数据通道的多种配置选项只能在数据通道创建之后使用，因为需要在对等端之间围绕它们进行协商。所有这些选项都作为 RTCDataChannelInit 对象的属性包括在内。

默认情况下，将创建可靠的数据通道，可靠的数据通道意味着如果有任何数据包丢失，靠着底层的传输机制就能自动找回这些数据包。但如果连接十分糟糕，且大多数数据包都没能送达，这时就需要 JavaScript 通过配置参数控制重新传输的级别。

```javascript
// 限制通道在第一次数据传输失败时重新传输数据的次数
dc = pc.createDataChannel('dc1', { maxRetransmits: 3 })
// 限制通道允许重试操作持续的毫秒数
dc = pc.createDataChannel('dc1', { maxRetransmitTime: 30 })
```

PS：注意 maxRetransmits 和 maxRetransmitTime 这两个属性是互斥的，不能同时指定两者。

由于每次发送都通过网络独立进行，不同的消息可能采用不同的路径，因此会导致最终的送达顺序不同于最初的发送顺序。默认情况下 WebRTC 数据通道将根据需要进行等待，比如需要成功收到消息 1 以后才将消息 1 和消息 2 释放给 onmessage 处理程序。

但有时消息之间彼此足够独立，顺序并不重要，此时就可以使用下面这种方法：

```javascript
// 允许在消息送达时接收它们，即使其顺序混乱也不例外
dc = pc.createDataChannel('', {ordered: false})
```

在上面的示例中，由于远程对等端并不创建数据通道，而是只接收数据通道创建的通知，这样就导致了远程对等端无法对这个数据通道进行设置。虽然远程端也可以自己调用 createChannel 来创建一个额外的双向通道，但无疑有些浪费资源。

针对这个问题，幸运的是开发者可以通过一些配置选项来创建不同类型的数据通道，并单独配置每个方向。

```javascript
// 本地对等端：创建数据通道的前半部分
properties = {negotiated: true, id: 1, maxRetransmits: 3}
dc = pc.createDataChannel("", properties)
// 运程对等端：创建数据通道的后半部分
properties = {negotiated: true, id: 1, maxRetransmits: 6}
dc = pc.createDataChannel("", properties)
```

上面的例子中创建了一个双向数据通道，允许本地浏览器向远程浏览器重新传输 3 次，并允许远程浏览器向本地重新传输 6 次。

这种创建方式有两个关键点：

- negotiated 属性：双端都必须设置为 true
- id 属性：两个对等端必须将此属性设置为同一个值，才能将两个单向数据通道关联起来。如果未设置 id 属性，浏览器将为其自动选择一个值，并通过信令通道将该 id 发送至对等端，然后让对等端使用该 id 创建数据通道。

### 7.3 可运行的数据通道代码示例

现在可以往之前的 demo 中添加最后一部分 —— 数据通道。同样，服务器和信令代码保持不变，唯一的新代码位于客户端 HTML 和 JavaScript 中。











> 本地阅读至 P116 7.3 可运行的数据通道代码示例 135