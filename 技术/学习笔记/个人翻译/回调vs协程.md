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









> 下一段：Contrasting the typical browser or Node.js environment, coroutines run each “light-weight thread” with its own stack. The implementations of these threads varies but typically they have a relatively small initial stack size (~4kb), growing when required.



