---
name: 你不知道的JavaScript学习笔记（十）
title: 《你不知道的JavaScript》学习笔记（十）
tags: ["技术","学习笔记","你不知道的JavaScript"]
categories: 学习笔记
info: "你不知道的JavaScript 下卷 第1章 深入编程 第2章 深入JavaScript 第3章"
time: 2019/3/18
desc: '你不知道的JavaScript, 资料下载, 学习笔记, 下卷, 第1章 深入编程, 第2章 深入JavaScript, 第3章'
keywords: ['前端', '你不知道的JavaScript', '学习笔记', '下卷', '第1章 深入编程', '第2章 深入JavaScript', '第3章']
---

# 《你不知道的JavaScript》学习笔记（十）

## 第1章 深入编程

老调重弹，本章介绍基础编程概念。

在程序被执行时，对命令的翻译若是自上而下逐行执行的，这种语言通常被称为代码解释型语言。

而另外一些语言，翻译是提前执行的，当执行程序时，实际上运行的是已经编译好的、可以执行的计算机语言。

基本上，可以说JavaScript是解释型的，因为每次执行JavaScript源码时都要进行处理。**但这么说并不准确，因为JavaScript引擎实际上是动态编译程序，然后立即执行编译后的代码**。

### 1.8 块

使用一对大括号将可以创建一个块。**在块中使用`let`与`const`关键词定义的变量或函数不会被声明到该块作用域之外，但如果使用函数声明或是`var`关键词定义变量，则会被声明到块作用域之外**。

```javascript
// example
{
    var test1 = 123
    function testFunc1 () {
        console.log('testFunc1')
    }
}
test1 // 123
testFunc1() // testFunc1

// example 2
{
    let test2 = 123
    const testFunc2 = function () {
        console.log('testFunc2')
    }
}
test2 // 报错
testFunc2() // 报错
```

## 第2章 深入JavaScript

老调重弹，介绍 JavaScript 基本概念，如作用域，表达式，`this`等等。

### 2.1 值与类型

在 JavaScript 中，一般通过数字位置索引数组，通过命名属性，当然由于 Array 其实也是一种特殊的对象，所以你完全可以反过来这么干，但无论如何这都是不推荐的。

### 2.5 作为值的函数

#### 2.5.1 立即调用函数表达式

```javascript
(function IIFE(){console.log('hello')})()
// 相比于上面这种, 下面这种用法更好, 更加直观而且可以有效避免函数合并时带来的分词问题
// 但有一个缺点, 下面这种写法不能用于ES6的箭头函数
void function IIFE(){console.log('hello')}()
```

### 2.8 旧与新

通过使用两种主要的技术，`polyfilling`和`transpilling`，可以向旧版浏览器引入新版 JavaScript 特性。

#### 2.8.1 polyfilling

`polyfill`的意思是根据新特性的定义，创建一段与之行为等价但能够在旧的 JavaScript 环境中运行的代码。

#### 2.8.2 transpiling

语言中新增的语法是无法进行`polyfilling`的，因此我们需要通过工具将新版代码转换为等价的旧版代码，该过程被称为`transpiling`，也就是 transforming 转换 与 compiling 编译 的组合。

目前，出色的`transpiler`库有`Bable`和`Traceur`。

### 2.9 非 JavaScript

在浏览器中，有很多的方法只是提供了 EcmaScript 的接口，然而其内在实现却并不是 ECMAScript ，比如我们日常要用到的 DOM API ，它既不是由 JavaScript 引擎提供的，也不由 JavaScript 标准控制。其余的像 console 对象， alert 方法也是如此。

## 第3章 深入“你不知道的JavaScript”系列

本章开始总结本书的要点，和进行一些概念性的吹逼(？？？)

吹逼要点：

- 对于学习JavaScript ，深入理解模块模式应该是最高优先级的任务
- 类型转换是很有用的（持保留意见）
- JavaScript 前途无量，yeah~

第一部分结束