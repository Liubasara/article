---
name: 你不知道的JavaScript学习笔记（六）
title: 《你不知道的JavaScript》学习笔记（六）
tags: ['读书笔记', '你不知道的JavaScript']
categories: 学习笔记
info: "你不知道的JavaScript 第4章 强制类型转换 第5章 语法"
time: 2019/3/6 12:00
desc: '你不知道的JavaScript, 资料下载, 学习笔记, 第4章 强制类型转换 第5章 语法'
keywords: ['前端', '你不知道的JavaScript', '学习笔记', '第4章 强制类型转换', '第5章 语法']
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

#### 4.3.1 字符串和数字之间的显式转换

```javascript
// 字符串转数字
var a = '3.14'
Number(a)
+a
// 数字转字符串
var b = 15
b.toString()
String(b)
```

- 日期显式转为数字

  ```javascript
  // 获取当前时间戳
  var timestamp = +new Date()
  var timestamp2 = Date.now()
  ```

- `~`运算符

  `~`运算符(即字位操作"非")

  ```javascript
  ~~-49.6 // -49
  ~~NaN // 0
  ~~1E20 / 10 // 166199296 
  ```

#### 4.3.2 显式解析数字字符串

```javascript
var a = "42"
var b = '42px'

Number(a) // 42
parseInt(a) // 42

Number(b) // NaN
parseInt(b) // 42
```

可见，解析允许字符串中含有非数字字符，解析按从左到右的顺序，如果遇到非数字字符就停止。而转换不允许出现非数字字符，否则会失败并返回NaN。

`parseInt(...)`方法接收两个参数，第一个是被解析的值，第二个是基数(进制)，默认为10。

### 4.4 隐式强制类型转换

本小节内容不算太好懂，而且描述的有点复杂，推荐看[这篇文章](https://juejin.im/post/5a7172d9f265da3e3245cbca#heading-6)来替代。

像`42 + '' === '42'`这样子结果为`true`的等式，其实就已经包含了隐式强制类型的转换。

#### 4.4.2 || 和 &&

`||`称为断路机制，而`&&`被称为短路机制。

### 4.5 宽松相等和严格相等

宽松相等(==)允许在相等比较中进行强制类型转换，而===不允许。

这里的坑太多，不详细介绍。

## 第5章 语法

### 5.1 语句和表达式

在JavaScript中表达式可以返回一个结果值，如`var a = 3 * 6`这种，就是一个表达式。而语句则是由数个短语和运算符相连组成的句子。

而在JavaScript中，尽管没有办法显式的获取，但事实就是每个表达式都是有一个明确的返回值的。

```javascript
// 在chrome控制台中输入一个表达式就能看到它的默认返回值
// 定义变量表达式无论是否赋值都返回undefinded，而为一个变量赋值则会返回该值
var a = 1
// undefined
var c = a
// undefinded
var v
//undefinded
v = 3
// 3
```

利用这种表达式特性，你可以合并很多语句和判断，写出更简洁的代码。

### 5.2 运算符优先级

&&和||在语句中并非从左到右顺序执行，三元计算符的优先级从高到低排序为：

- `&&`运算符
- `||`运算符
- `?`运算符

### 5.3 自动分号

JavaScript内部有一套名为ASI的纠错机制，用于为没有分号的语句自动加上分号。

是否应该加分号，是JavaScript社区中最具争议性的话题之一(此外还有Tab和空格之争......真是闲的)

### 5.4 错误

- ES6加入了参数默认值，这有时候会导致函数的`arguments`数组和实际上函数中的参数并不对应。

  ```javascript
  function test (a = 1, b = 2) {console.log(a, b);console.log(arguments.length);}
  test()
  // 1 2 a与b的默认值
  // 0 arguments的长度，此时尽管函数中有默认参数，但arguments中并没有元素
  ```

  此外，使用`arguments`在严格模式中也会报错，所以最好不要使用该参数。(且ES6中引入了剩余参数`...`，明显比`arguments`好用)

### 5.6 try...finally



> 本次阅读至P117 5.6 try...finally 137