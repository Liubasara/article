---
name: 《高性能JavaScript》学习笔记（四）
title: 《高性能JavaScript》学习笔记（四）
tags: ['读书笔记', '高性能JavaScript']
categories: 学习笔记
info: "高性能JavaScript 第7章 Ajax异步JavaScript和XML"
time: 2019/5/5
desc: '高性能JavaScript, 资料下载, 学习笔记, 第7章 Ajax异步JavaScript和XML'
keywords: ['高性能JavaScript资料下载', '前端', '高性能JavaScript', '学习笔记', '第7章 Ajax异步JavaScript和XML']
---

# 《高性能JavaScript》学习笔记（四）

## 第7章 Ajax异步JavaScript和XML

Ajax 是高性能 JavaScript 的基石。本章考察从服务器收发数据最快的技术，以及最有效的数据编码格式

### 使用 XHR 时，应使用 POST 还是 GET

当使用 XHR 获取数据时，你既可以选择 POST 也可以选择 GET。如果请求不改变服务器状态，则应尽可能使用 GET，因为 GET 请求会在 URL 地址栏被缓冲起来，当你多次提取相同的数据时，可以提高性能。

只有当 URL 和参数的长度超过了 2048 个字符串时才使用 POST 提取数据。（因为某些浏览器会限制 URL 长度，过长的参数会被截断）

**Sending Data 发送数据**

> 本次阅读至 P227 Sending Data 发送数据