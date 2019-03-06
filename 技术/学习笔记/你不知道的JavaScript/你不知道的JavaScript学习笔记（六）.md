---
name: 你不知道的JavaScript学习笔记（六）
title: 《你不知道的JavaScript》学习笔记（六）
tags: ['读书笔记', '你不知道的JavaScript']
categories: 学习笔记
info: "你不知道的JavaScript 第4章 强制类型转换"
time: 2019/3/6 12:00
desc: '你不知道的JavaScript, 资料下载, 学习笔记, 第4章 强制类型转换'
keywords: ['前端', '你不知道的JavaScript', '学习笔记', '第4章 强制类型转换']
---

# 《你不知道的JavaScript》学习笔记（六）

## 第4章 强制类型转换

将值从一种类型转换为另一种类型通常称为**类型转换**，这是显式的情况，对于隐式的情况，称为**强制类型转换**。

```javascript
var a = 42
var b = a + '' // 隐式
var c = String(a) // 显式
```

### 4.3 显式强制类型转换

> 本次阅读应至P56 4.3 76