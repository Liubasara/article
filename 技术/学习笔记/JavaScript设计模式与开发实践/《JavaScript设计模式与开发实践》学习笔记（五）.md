---
name: 《JavaScript设计模式与开发实践》学习笔记（五）
title: 《JavaScript设计模式与开发实践》学习笔记（五）
tags: ["技术","学习笔记","JavaScript设计模式与开发实践"]
categories: 学习笔记
info: "第二部分、第 6 章 代理模式"
time: 2019/9/20,
desc: 'JavaScript设计模式与开发实践, 资料下载, 学习笔记'
keywords: ['JavaScript设计模式与开发实践资料下载', '前端', '学习笔记']
---

# 《JavaScript设计模式与开发实践》学习笔记（五）

## 第 6 章 代理模式

> 代理模式是一种非常有意义的模式，在生活中可以找到很多代理模式的场景。比如，明星都 有经纪人作为代理。如果想请明星来办一场商业演出，只能联系他的经纪人。经纪人会把商业演 出的细节和报酬都谈好之后，再把合同交给明星签 。

**代理模式是为一个对象提供一个代用品或者占位符，以便控制对它的访问**。

![proxyPattern-1.png](./images/proxyPattern-1.png)

### 6.1 一个例子

> A 想给 B 送花，A 决定把花交给 A 和 B 共同的朋友 C，让她把花给 B

```javascript
var Flower = function () {}

var A = {
  sendFlower: function (target) {
    var flower = new Flower()
    target.receiveFlower(flower)
  }
}

// 代理
var C = {
  receiveFlower: function (flower) {
    B.receiveFlower(flower)
  }
}

var B = {
  receiveFlower: function (flower) {
    console.log('收到花' + flower)
  }
}

A.sendFlower(C)
```

上面的代码实现了一个最简单的代理模式，虽然此处的代理模式并没有什么用处，只是把请求简单地转交给本体。



> 本次阅读至 P90 109