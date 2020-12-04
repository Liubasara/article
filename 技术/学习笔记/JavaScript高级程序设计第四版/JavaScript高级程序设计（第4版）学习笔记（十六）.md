---
name: JavaScript高级程序设计（第4版）学习笔记（十六）
title: JavaScript高级程序设计（第4版）学习笔记（十六）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：25. 客户端存储"
time: 2020/12/4
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']
---

# JavaScript高级程序设计（第4版）学习笔记（十六）

## 第 25 章 客户端存储

部分冷饭。

安全标志`secure`是 cookie 中唯一的非键值对，只需一个 secure 就可以，比如：`Set-Cookie: name=value; domain=.example.com; path=/; secure`。

还有一种叫作 HTTP-only 的 cookie。HTTP-only 可以在浏览器设置，也可以在服务器设置，但只能在服务器上读取，这是因为 JavaScript 无法取得这种 cookie 的值。

### 25.3 IndexedDB







> 本次阅读至 P762 25.3 IndexedDB 787