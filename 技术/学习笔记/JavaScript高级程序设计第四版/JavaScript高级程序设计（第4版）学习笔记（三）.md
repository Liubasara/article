---
name: JavaScript高级程序设计（第4版）学习笔记（三）
title: JavaScript高级程序设计（第4版）学习笔记（三）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：4. 变量、作用域与内存 5. 基本引用类型"
time: 2020/10/12
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']

---

# JavaScript高级程序设计（第4版）学习笔记（三）

## 第 4 章 变量、作用域与内存

### 4.1 原始值和引用值

ECMAScript 变量可以包含两种不同类型的数据：原始值和引用值。

引用值是保存在内存中的对象，与其他语言不通，JavaScript 不允许直接访问内存位置，因此也就不能直接操作对象所在的内存空间。在操作对象时，实际操作的是对该对象的引用（reference）而非实际的对象本身。为此，保存引用值的变量是按照引用（by reference）访问的。

#### 4.1.1 动态属性

对于引用值而言，可以随时添加，修改和删除其属性和方法，而原始值则不能有属性（虽然尝试给原始值添加属性也不会报错，但不可用。）

```javascript
var a = {}
var b = 1
a.name = 123
b.name = 123
a.name // 123
b.name // undefined
```

#### 4.1.2 复制值

通过变量复制一个原始值时，原始值会被复制到新变量的位置。而尝试复制引用值时，存储在变量中的值也会被复制到新变量所在的位置，区别在于，这里的复制的值实际上是一个指针，它指向存储在堆内存中的对象。

#### 4.1.3 传递参数

ECMAScript 中所有函数的参数都是按值传递的。这意味着函数外的值会被复制到函数内部的参数中，就像从一个变量复制到另一个变量一样。也就是 4.1.2 中的内容。

#### 4.1.4 确定类型

`typeof`适合用于判断一个变量是否为字符串、数值、布尔值或是`undefined`。

但如果判断的对象是引用值，`typeof`的作用就不是那么大。这种情况下，想要知道一个引用值是什么类型的对象，可以使用`instanceof`操作符。

### 4.2 执行上下文与作用域

每个函数调用都有自己的上下文。当代码执行流进入函数时，函数的上下文被推到一个上下文栈上。 在函数执行完之后，上下文栈会弹出该函数上下文，将控制权返还给之前的执行上下文。程序的执行流就是通过这个上下文栈进行控制的。 全局上下文是外层的上下文。

上下文中的代码在执行的时候，会创建变量对象的一个作用域链（scope chain）。这个作用域链决定了各级上下文中的代码在访问变量和函数时的顺序。

#### 4.2.1 作用域链增强

某些语句会导致在作用域链前端临时添加一个上下文：

- try/catch 语句的 catch 块
- with 语句
- 块级作用域

> 延伸阅读：[从 scope 理解块级作用域](https://blog.liubasara.info/#/blog/articleDetail/mdroot%2F%E6%8A%80%E6%9C%AF%2F%E4%BB%8Escope%E7%90%86%E8%A7%A3%E5%9D%97%E7%BA%A7%E4%BD%9C%E7%94%A8%E5%9F%9F.md)

#### 4.2.2 变量声明

`var`声明会被拿到函数或全局作用域的顶部，位于作用域的所有代码之前。提升让同一作用域中的代码不必考虑变量是否已经声明就可以直接使用。

而`let`声明和`const`声明则不会进行变量提升。甚至就连单独的块也是它们声明变量的作用域。

### 4.3 垃圾回收

JavaScript 是使用垃圾回收的语言，也就是说执行环境负责在代码执行时管理内存。基本思路很简单：确定哪个变量不会再使用，然后释放它占用的内存。这个过程是周期性的，即垃圾回收程序每隔一定时间就会自动运行。如何标记未使用的变量有不同的实现方式，在浏览器的发展史上用过两种主要的标记策略：

- 标记清理
- 引用计数

#### 4.3.4 内存管理

JavaScript 运行在一个内存管理与垃圾回收都很特殊的环境。分配给浏览器的内存通常比分配给桌面软件的要少很多，主要是为了避免运行大量的 JavaScript 的网页耗尽系统内存而导致操作系统崩溃。

因此将内存占用量保持在一个较小的值可以让页面性能更好。如果数据不再必要，可以把它设置为`null`，从而解除引用，等待垃圾回收。

## 第 5 章 基本引用类型

在 ECMAScript 中，引用类型是把数据和功能组织到一起的结构，经常被人错误地称为“类”。虽然从技术上讲 JavaScript 是一门面向对象语言，但 ECMAScript 缺少传统的面向对象编程语言所具备的某些基本结构，包括类和接口等等。

本章介绍基于 Object 的各类引用类型。

- Date，日期时间，与第三版内容差不多

- RegExp，正则，添加内容：

  使用 RegExp 可以基于已有的正则表达式实例，选择性的修改他们的标记

  ```javascript
  const re1 = /cat/g
  console.log(re1) // "/cat/g"
  const re2 = new RegExp(re1)
  console.log(re2) // "/cat/g"
  const re3 = new RegExp(re1, 'i') // 修改标记位为忽略大小写的 i
  console.log(re3) // "/cat/i"
  ```

此外还有原始值的包装类型：

- Boolean

- Number

  **Number.isInteger()方法与安全整数**

  ES6 新增的方法，用于分辨一个数值是否保存为整数。

  ```javascript
  console.log(Number.isInteger(1.00)) // true
  console.log(Number.isInteger(1.01)) // false
  ```

  IEEE754 有一个特殊的数值范围，从`Number.MIN_SAFE_INTEGER`到`Number.MAX_SAFE_INTEGER`，为了鉴别整数是否在这个范围内，可以使用`Number.isSafeInteger()`方法。

  ```javascript
  console.log(Number.isInteger(2 ** 53)) // false
  console.log(Number.isInteger(2 ** 53) - 1) // true
  
  console.log(Number.isInteger(-1 * (2 ** 53))) // false
  console.log(Number.isInteger(-1 * (2 ** 53) + 1))) // true
  ```

- String

  ES6 新增内容，字符串的原型上暴露了一个`@@iterator`方法，表示可以迭代字符串的每个字符。可以手动使用迭代器，也可以使用`for-of`对这个字符进行迭代。

  ```javascript
  let message = 'hiABC'
  let messageIterator = message[Symbol.iterator]()
  console.log(messageIterator.next()) // {value: 'h', done: false}
  console.log(messageIterator.next()) // {value: 'i', done: false}
  console.log(messageIterator.next()) // {value: 'A', done: false}
  console.log(messageIterator.next()) // {value: 'B', done: false}
  console.log(messageIterator.next()) // {value: 'C', done: true}
  
  for (const c of message) {
    console.log(c)
  }
  // h
  // i
  // A
  // B
  // C
  ```

此外 ECMAScript 中还提供两个单例的内置对象：

- Global
- Math
