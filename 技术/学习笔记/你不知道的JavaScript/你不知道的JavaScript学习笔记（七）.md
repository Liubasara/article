---
name: 你不知道的JavaScript学习笔记（七）
title: 《你不知道的JavaScript》学习笔记（七）
tags: ['读书笔记', '你不知道的JavaScript']
categories: 学习笔记
info: "你不知道的JavaScript 第2章 回调 第3章 Promise"
time: 2019/3/10
desc: '你不知道的JavaScript, 资料下载, 学习笔记, 第2章 回调, 第3章 Promise'
keywords: ['前端', '你不知道的JavaScript', '学习笔记', '第2章 回调', '第3章 Promise']
---

# 《你不知道的JavaScript》学习笔记（七）

## 第2章 回调

### 2.1 continuation

回调函数包裹或者说封装了程序的延续。

### 2.2 顺序的大脑

JavaScript总是沿着线性执行，过多的回调函数会使得程序变得更加复杂，严重到导致"回调地狱"出现，以至于到最后无法维护和更新。

### 2.3 信任问题

控制反转，即使用回调函数必然会将异步后的代码交给别的函数进行处理，有时候这些异步后的代码并不是由你自己编写的，这就会产生一个信任问题。

### 2.4 省点回调

回调设计存在几个变体，意在解决前面讨论的一些信任问题。

有些API设计提供了分离回调(一个用于成功通知，一个用于出错通知)。

## 第3章 Promise

### 3.1 什么是Promise

Promise是一种封装和组合未来值的易于复用的机制。

### 3.2 具有then方法的鸭子类型

如何确定某个值是不是真正的Promise。使用`instanceof Promise`来检查可以知道当前对象是否为`Promise`对象的实例，但是`Promise`值可能是从其他浏览器窗口(`iframe`等)收到的，这个浏览器窗口自己的`Promise`可能和当前窗口不一样，这样就会导致无法识别。

此外，很多第三方库和框架也可能会选择实现自己的Promise来作兼容，而不用原生的ES6 Promise实现，在这种情况下，我们需要通过一些功能性判断来识别`Promise`。

**识别Promise就是定义某种称为`thenable`的东西，将其定义为任何具有`then()`方法的对象和函数，我们认为，任何这样的值就是Promise一致的thenable**。也就是常说的**鸭子类型**。

于是，对`thenalbe`的鸭子类型检测便大致类似于：

```javascript
if (p !== null && (typeof p === 'object' || typeof p === function) && typeof p.then === 'function') {
    // 这是一个thenable
} else {
    // 不是thenable
}
```

### 3.3 Promise的信任问题

使用`Promiese`可以很好的解决调用过早或者调用过晚的问题。

Promise并没有完全摆脱回调。它们只是改变了传递回调的位置。我们并不是把回调传递给了函数内部，而是从函数中得到了某个东西。

使用`Promise.resolve()`来处理一个值可以让它变为合法的Promise对象，无论传入的是什么，传出来的都会是一个`Promise`，这使得构建程序的过程更加的可控和可信任。

> 本次阅读至P197 3.3.8建立信任 217

