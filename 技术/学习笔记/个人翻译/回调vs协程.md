---
name: 回调vs协程
title: 回调vs协程
tags: ["技术","学习笔记","个人翻译"]
categories: 学习笔记
info: "加油啊不愿意同步的大哥哥！"
time: 2021/11/9
desc: '个人翻译, Callbacks vs Coroutines'
keywords: ['Git', '个人翻译', '学习笔记', 'Callbacks vs Coroutines']
---

# 回调vs协程

> 原文链接：[Callbacks vs Coroutines](https://medium.com/@tjholowaychuk/callbacks-vs-coroutines-174f1fe66127)

最近一段时间，出现了很多有关于 Google V8 引擎提供的 ES6 generators（生成器）补丁的争论，这是由一篇名为[《关于使用 JavaScript 生成器来解决回调问题的研究》](http://jlongster.com/A-Study-on-Solving-Callbacks-with-JavaScript-Generators)的文章引起的。虽然生成器这个特性依旧还藏在`--harmony`或者`--harmony-generators`标志的后面，但已经能让我们学习到很多经验了！在这片文章里面，笔者想通过自己的一些有关于协程的经验来解释，为什么笔者个人认为这是一个非常好的工具。

## 回调 vs 生成器

在我们进入协程与生成器的区分之前，让我们先来看看在 Node.js 或是浏览器这类被回调统治的生态系统里面，是什么让生成器变得有用的。

首先，生成器是一种回调的补充，一些回调的形式对于生成器的补充来说是必要的。无论你喜欢称呼这些能够允许某些逻辑延迟执行的方式为“futures”、“thunks”还是“promises”都好，这就是一种允许你产生一个值并且允许生成器来处理其余部分的方法。

每当这些 yield 生成的值被抛出给调用者，调用者就会等待回调然后再继续恢复生成器。以这种方式来使用生成器的机制实际上与回调机制相同，但是我们很快就会看到一些额外的好处。

如果你还是不太确定生成器是如何出现的，这里有一个基于 generator 进行构建的流控制库的简单实现。

```javascript
var fs = require('fs')

function thread(fn) {
  var gen = fn()
  function next(err, res) {
    var ret = gen.next(res)
    if (ret.done) return
    ret.value(next)
  }
  next()
}

function read(path) {
  return function(done) {
    fs.readFile(path, 'utf8', done)
  }
}

thread(function *(){
  var a = yield read('Readme.md')
  var b = yield read('package.json')
  
  console.log(a)
  console.log(b)
})
```

## 为什么协程让代码更加强壮

与典型的浏览器环境或 Node.js 环境相比，每个协程都会在自己的堆栈中运行一个轻量级的“线程”。这些线程的实现各不相同，但通常来说它们都会有一个相对较小的堆栈（大约 4Kb），只要在需要时才会增长。

为什么协程这么棒呢？因为错误处理！如果你曾经使用 Node.js 工作过就会知道，即使相比于浏览器环境来说它的异常状态也非常常见，你就会知道错误处理并非那么容易面对。有时候你会收到很多个具有副作用未知的回调（或者是一个完全忘记进行错误处理的回调和没有对异常进行上报的回调）。又或者你忘记了监听 error 事件，从而导致了一个未被捕获的异常并让你的进程意外中断了。

对于一些人是很乐于见到这样的处理过程并认为这没什么问题的。但是作为一个从 Node.js 出生就开始使用它的人来说，我认为还是有很多事情可以做来提高这个工作流程的。而 Node.js 在其他方面都很棒，但这个就是它致命的弱点（译者注：Achilles' heel，[阿喀琉斯之踵](https://language.chinadaily.com.cn/a/202108/30/WS612c517fa310efa1bd66c095.html)）。

---



> 下一段：Let’s take a simple example of reading and writing to and from the same file with callbacks:



