---
name: 《JavaScript异步编程》学习笔记（三）
title: 《JavaScript异步编程》学习笔记（三）
tags: ['读书笔记', 'JavaScript异步编程']
categories: 学习笔记
info: "JavaScript异步编程 第3章 Promise对象和Deferred对象 第4章 Async.js 的工作流控制"
time: 2019/4/16
desc: 'JavaScript异步编程, 学习笔记, 第3章 Promise对象和Deferred对象, 第4章 Async.js 的工作流控制'
keywords: ['前端', 'JavaScript异步编程', '学习笔记', '第3章 Promise对象和Deferred对象', '第4章 Async.js 的工作流控制']
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

> 本次阅读至P67 第4章 Async.js 的工作流控制 88