---
name: 《JavaScript设计模式与开发实践》学习笔记（三）
title: 《JavaScript设计模式与开发实践》学习笔记（三）
tags: ["技术","学习笔记","JavaScript设计模式与开发实践"]
categories: 学习笔记
info: "第一部分、第 2 章 this、call 和 apply"
time: 2019/9/16,
desc: 'JavaScript设计模式与开发实践, 资料下载, 学习笔记'
keywords: ['JavaScript设计模式与开发实践资料下载', '前端', '学习笔记']
---

# 《JavaScript设计模式与开发实践》学习笔记（三）

## 第 2 章 this、call 和 apply

### 2.1 this

**JavaScript 的 this 总是指向一个对象，而具体指向哪个对象是在运行时基于函数的执行环境动态绑定的，而非函数被声明时的环境。**（**PS：ES6 箭头函数中的 this 例外**）

#### 2.1.1 this 的指向

this 的指向大致分为以下几种：

- 作为对象的方法调用，指向该对象
- 作为普通函数调用，默认指向全局对象，strict 模式下，指向 undefined
- 构造器调用，指向调用返回的对象
- Function.prototype.call 或 Function.prototype.apply 调用，指向传入的对象

#### 2.1.2 丢失的 this

当函数的默认执行环境被取代，（如：`var a = c.b` ，其中`c.b`是一个函数）这种情况发生的时候，很容易会发生`this`指针丢失的错误。

这时候，我们可以手动修改执行函数，也可以通过箭头函数将函数的执行环境绑定，又或者，我们可以借助`call`、`apply`、`bind`三大函数的力量。

### 2.2 call 和 apply





> 本次阅读至P29 2.2 call 和 apply 48