---
name: 《JavaScript框架设计》学习笔记（一）
title: 《JavaScript框架设计》学习笔记（一）
tags: ["技术","学习笔记","JavaScript框架设计"]
categories: 学习笔记
info: "前言、第 1 章 种子模块"
time: 2019/10/10
desc: 'JavaScript框架设计, 资料下载, 学习笔记'
keywords: ['JavaScript框架设计资料下载', '前端', '学习笔记']
---

# 《JavaScript框架设计》学习笔记（一）

> 资料下载地址(equb, mobi, awz3, pdf):
>
> [百度网盘](https://pan.baidu.com/s/1gqEf3LIddxin14xRLfZAQg)
>
> 提取码: 2xar
>
> **本资料仅用于学习交流，如有能力请到各大销售渠道支持正版！**

## 第 1 章 种子模块

种子模块也叫核心模块，是框架最先执行的部分，里面的方法不一定要求有多么强大，但一定要十分稳定，常用以及具有扩展性。绝大多数模块都需要引用种子模块，以防止做重复的工作。

本书作者认为，种子模块应该包含如下功能：

- 对象扩展
- 数组化
- 类型判定
- 简单的事件绑定与卸载
- 无冲突处理
- 模块加载与 domReady

### 1.1 命名空间

IIFE（立即调用函数表达式）是现代 JavaScript 框架最主要的基础设施，用于防止变量污染。纵观各大类库的实现，一开始基本都是定义一个全局变量作为命名空间，然后对它进行扩展。

### 1.2 对象扩展

框架需要一种机制可以将新功能添加到命名空间上，这方法在 JavaScript 中通常被称为 extend 或者 mixin。

```javascript
function extend (destination, source) {
    for (var property in source) {
        destination[property] = source[property]
    }
    return destination
}
```

### 1.3 数组化

类数组对象是一个比较好的存储结构，不过功能太弱了，我们通常会在处理它们之前做一下转换。

```javascript
function toArray (array) {
    return [].slice.call(array)
}
```

### 1.4 类型的判定

JavaScript 存在两套类型系统，一套是基本数据类型，另一套是对象类型系统。

基本数据类型一般是通过 typeof 来检测，对象类型系统一般通过 instanceof 来检测。但很可惜的是在 JavaScript 中这么朴素的检测方法并不算靠谱。

所以对于各种类型，各大框架都实现了 isXXX 方法。

### 1.5 主流框架引入的机制——domReady

主流框架所实现的 domReady 使用的事件名为 DOMContentLoaded。与 window.onload 的主要区别在于 domReady 会在静态资源还未加载完成时就执行。

### 1.6 无冲突处理





> 本次应阅读至 P15 1.6 无冲突处理 28