---
name: 你不知道的JavaScript学习笔记（十）
title: 《你不知道的JavaScript》学习笔记（十）
tags: ['读书笔记', '你不知道的JavaScript']
categories: 学习笔记
info: "你不知道的JavaScript 下卷 第1章 深入编程 第2章 深入JavaScript"
time: 2019/3/18
desc: '你不知道的JavaScript, 资料下载, 学习笔记, 下卷, 第1章 深入编程, 第2章 深入JavaScript'
keywords: ['前端', '你不知道的JavaScript', '学习笔记', '下卷', '第1章 深入编程', '第2章 深入JavaScript']
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

老调重弹，介绍 JavaScript 基本概念。

在 JavaScript 中，一般通过数字位置索引数组，通过命名属性，当然由于 Array 其实也是一种特殊的对象，所以你完全可以反过来这么干，但无论如何这都是不推荐的。

#### 2.1.2 内置类型方法

> 本次阅读至P30 2.1.2 内置类型方法 52