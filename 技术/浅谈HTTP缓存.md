---
name: 浅谈HTTP缓存
title: 浅谈HTTP缓存
tags: ["技术"]
categories: 学习笔记
info: "吾日三省吾身：让存吗，能发不，更新啥"
oldtime: 2019/3/5
time: 2022/7/11 6:00
desc: '学习笔记, 前端面试, HTTP缓存'
keywords: ['前端面试', '学习笔记', 'HTTP缓存']
---

# 浅谈HTTP缓存

> 引用资料：
>
> - [浏览器静态资源的缓存机制（http强缓存 协商缓存）](https://my.oschina.net/wangch5453/blog/2995385)
> - [HTTP强缓存和协商缓存](https://segmentfault.com/a/1190000008956069)
> - [HTTP基于缓存策略三要素分解法](https://mp.weixin.qq.com/s/qOMO0LIdA47j3RjhbCWUEQ?utm_source=caibaojian.com)

![缓存请求总体流程](./images/cache-control-1.jpg)

HTTP缓存分为三个阶段：

- 缓存存储

  决定客户端是否可以缓存当前页面

  > 代表字段：Cache-Control头中的public、private、no-store

- 缓存过期

  决定是否向服务器发送请求

  > 代表字段：Expires、Cache-Control头中的no-cache(max-age为0)、max-age(代表最多能缓存多少秒, 和Expires同时存在时以该字段为准)

- 缓存对比

  服务器所做的事情，根据特定字段对比来决定是否给浏览器返回新的资源，或是只返回响应头，使用缓存。

  > 代表字段： Etags(服务器返回) / If-None-Match(浏览器发送)、Last-Modified(服务器返回) / If-Modified-Since(浏览器发送)

HTTP缓存分两种：

- 强缓存，可以只经历前两个阶段(缓存存储、缓存过期)，只要缓存没过期以及用户没有强制刷新，浏览器就不会真正向后端请求数据

- 协商缓存，必然会向后端服务器发送请求，历经三个阶段，后端根据Etags和Last-Modified等字段确定是否返回资源以及浏览器是否使用本地缓存。

  **PS**：Last-Modified和ETAGS可以一起使用，但服务器会优先验证Etags。

> 再再PS：记一次面试，搞懂返回200的缓存和304缓存之间的区别。
>
> 面试官：既然你提到缓存有两种情况，一种是强缓存返回200，另一种是协商缓存返回304，那这两种缓存之间有什么区别吗？性能优化的角度来看，哪种缓存最好？
>
> 我(一脸懵逼)：难道这俩之间的区别不就是一个没有向服务器发起请求，另一个发起了吗？
>
> 面试官(微微一笑)：这是其中一点区别，但还不是最重要的。
>
> **接下来是解答时间：**

返回缓存有两种情况：

- 200 cache from memory
- 304 disk from disk

~~如上所述，返回缓存的情况下，如果是强缓存返回200，那么浏览器会直接往内存里面读取缓存数据。而协商缓存返回的304状态码是会让浏览器的硬盘中读取数据的~~。

由于在电脑中内存是最快的载体，而且强缓存也没有往服务器发请求，所以如果从性能优化的角度而言，返回200的缓存毫无疑问是最优的。

**UPDATE**：

上面关于浏览器存储内存还是硬盘的逻辑分析是错误的，纠错相关可看[这篇文章](https://blog.liubasara.info/#/blog/articleDetail/mdroot%2F%E6%8A%80%E6%9C%AF%2F%E3%80%8A%E5%89%8D%E7%AB%AF%E6%80%A7%E8%83%BD%E4%BC%98%E5%8C%96%E5%8E%9F%E7%90%86%E4%B8%8E%E5%AE%9E%E8%B7%B5%E3%80%8B%E5%AD%A6%E4%B9%A0%E8%AE%B0%E5%BD%95.md)。

> 是否将缓存放入内存是由浏览器决定的，可以放入内存的资源有下列这些：
>
> - base64 格式图片
> - 体积不大的 JS、CSS 文件

