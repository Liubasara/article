---
name: 《高性能JavaScript》学习笔记（二）
title: 《高性能JavaScript》学习笔记（二）
tags: ['读书笔记', '高性能JavaScript']
categories: 学习笔记
info: "高性能JavaScript 第3章 DOM编程"
time: 2019/4/26
desc: '高性能JavaScript, 资料下载, 学习笔记, 第3章 DOM编程'
keywords: ['高性能JavaScript资料下载', '前端', '高性能JavaScript', '学习笔记', '第3章 DOM编程']
---

# 《高性能JavaScript》学习笔记（二）

## 第3章 DOM编程

对 DOM 的操作代价昂贵，在网页应用的开发中，这往往是一个性能瓶颈所在。本章讨论可能对程序响应造成负面影响的 DOM 编程，并给出提高响应速度的建议。

本章讨论三类问题：

- 访问和修改 DOM 元素
- 修改 DOM 元素的样式，造成重绘和重新排版
- 通过 DOM 事件处理用户响应

但首先要搞清楚的是，什么是 DOM ？

### 浏览器世界中的 DOM

DOM 是一个独立于语言的，使用 XML 和 HTML 文档操作的应用程序接口(API)。但尽管它是与语言无关的API，但它在浏览器中的接口却是用 JavaScript 实现的。

浏览器通常要求 DOM 实现和 JavaScript 实现保持相互独立，比如在 chrome 中，其 JavaScript 引擎 V8 和 DOM 引擎 Gecko 就是分离的。

**天生就慢**

两个独立的部分以功能接口相接意味着什么呢？就像是两座岛屿之间仅仅用一道收费的桥梁连着，每次 ECMAScript 需要访问 DOM 时，就像是过桥，交一次过桥费。操作 DOM 的次数越多，其费用就越高。而最糟糕的情况下，就是在 HTML 集合中使用循环。

### 访问和修改

考虑下面的两个例子

```javascript
function innerHTMLLoop() {
    for (var count = 0; count < 1500;count++) {
        document.getElementById('here').innerHTML += 'a'
    }
}

function innerHTMLLoop2() {
    var content = ''
    for (var count = 0; count < 1500;count++) {
        content += 'a'
    }
    document.getElementById('here').innerHTML += content
}
```

在所有的浏览器中，以上`innerHTMLLoop2`方法都会比`innerHTMLLoop`的效率要高得多，在 IE6 的测试中，第二种方法的运行效率要比第一种高 155 倍。

#### innerHTML 和 DOM 方法比较

innerHTML 和 普通的 DOM 方法的速度区别不大，但是总的来说，还是 innerHTML 更快一些。

#### 节点克隆

> 阅读至 67页 Cloneing Nodes