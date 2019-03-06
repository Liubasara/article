---
name: 浅谈HTTP缓存
title: 浅谈HTTP缓存
tags: ['读书笔记']
categories: 学习笔记
info: "吾日三省吾身：让存吗，能发不，更新啥"
time: 2019/3/5,
desc: '学习笔记, 前端面试, HTTP缓存'
keywords: ['前端面试', '学习笔记', 'HTTP缓存']
---

# 浅谈HTTP缓存

> 引用资料：
>
> - [HTTP强缓存和协商缓存](https://segmentfault.com/a/1190000008956069)
> - [HTTP基于缓存策略三要素分解法](https://mp.weixin.qq.com/s/qOMO0LIdA47j3RjhbCWUEQ?utm_source=caibaojian.com)

HTTP缓存分为三个阶段：

- 缓存存储

  决定客户端是否可以缓存当前页面

  代表字段Cache-Control头中的public、private、no-store

- 缓存过期

  决定是否向服务器发送请求

  代表字段Expires、Cache-Control头中的no-cache(max-age为0)、max-age(代表最多能缓存多少秒, 和Expires同时存在时以该字段为准)

- 缓存对比

  服务器所做的事情，根据特定字段对比来决定是否给浏览器返回新的资源，或是只返回响应头，使用缓存。

  代表字段 Etags(服务器返回) / If-None-Match(浏览器发送)、Last-Modified(服务器返回) / If-Modified-Since(浏览器发送)

  Etags

HTTP缓存分两种：

- 强缓存，可以只经历前两个阶段(缓存存储、缓存过期)，只要缓存没过期以及用户没有强制刷新，浏览器就不会真正向后端请求数据

- 协商缓存，必然会向后端服务器发送请求，历经三个阶段，后端根据Etags和Last-Modified等字段确定是否返回资源以及浏览器是否使用本地缓存。

  **PS**：Last-Modified和ETAGS可以一起使用，但服务器会优先验证Etags。

