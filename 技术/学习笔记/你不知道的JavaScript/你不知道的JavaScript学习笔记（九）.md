---
name: 你不知道的JavaScript学习笔记（九）
title: 《你不知道的JavaScript》学习笔记（九）
tags: ['读书笔记', '你不知道的JavaScript']
categories: 学习笔记
info: "你不知道的JavaScript 第5章 程序性能 第6章 性能测试与调优"
time: 2019/3/16
desc: '你不知道的JavaScript, 资料下载, 学习笔记, 第5章 程序性能, 第6章 性能测试与调优'
keywords: ['前端', '你不知道的JavaScript', '学习笔记', '第5章 程序性能', '第6章 性能测试与调优']
---

# 《你不知道的JavaScript》学习笔记（九）

## 第5章 程序性能

为什么异步对JavaScript来说真的很重要？因为**性能**。

### 5.1 Web Worker

Web Worker是浏览器自带的机制，和语言本身没有太大关系，却为JavaScript这种单线程语言提供了多线程的可能性。

对于多线程来说，主要会存在以下问题：

- 独立的线程运行是否意味着可以并行运行（虚拟多线程并不会带来多少好处）
- 多个线程之间能否访问共享的作用域和资源，如果可以，那么就会遇到多数多线程语言所要面对的问题，合作式或抢占式的锁机制。
- 如果第二个条件可以满足，那么它们将如何通信？

在浏览器中，可以提供多个JavaScript引擎实例，各自运行在自己的线程上，这样你可以在每个线程上运行不同的程序。在JavaScript主程序中，可以这样实例化一个Worker：

```javascript
var w1 = new Worker("http://some.url.1/mycoolworker.js")
```

该URL会指向一个JavaScript文件的位置，而不是一个HTML页面。

要注意的是：**Worker之间以及它们和主程序之间，不会共享任何作用域或资源，那会把所有多线程编程的噩梦带到前端领域**，而是通过一个基本的事件消息机制互相联系。

```javascript
var w1 = new Worker("http://some.url.1/mycoolworker.js")
// 如何侦听事件
w1.addEventListener('message', function (event) {
    //event.data
})
// 发送触发事件
w1.postMessage("something cool to say")

// mycoolworker内部
addEventListener('message', function (event) {
    // event.data
})
postMessage('a really cool reply')
```

要终止Web Worker时，可以调用Worker对象的`terminate()`方法。

#### 5.1.1 Worker环境

在Worker内部是无法访问主程序的任何资源的，这是一个完全独立的线程。

你可以通过`importScripts(..)`向Worker加载额外的JavaScript脚本，这些脚本的加载是同步的，也就是说该函数会阻塞余下Worker的执行，直到文件的加载和执行完成。

```javascript
// 在Worker内部
importScripts('foo.js', 'bar.js')
```

## 第6章 性能测试与调优

最能引发普遍好奇心的领域之一，就是分析和测试编写一行或者一块代码的多种选择，然后确定哪一种更快。

在得出结论之前，我们需要探讨的是如何最精确可靠地测试JavaScript性能。

### 6.1 性能测试

说起测试的代码速度，大概会有人想这么干。

```javascript
var start = new Date().getTime()
// 进行一些操作
var end = new Date().getTime()
console.log('Duration', end - start)
```

看起来挺对，但这个方案其实存在很多的错误。

浏览器在不同平台上的定时器定时时间是不一样的，比如说Windows的早期版本上精度只有15ms，那就意味着这个运算的运行时间至少需要这么长才不会被报告为0。

而且这种方法只能计算本次运算的特定消耗了大概这么长时间，而它是不是总是以这样的速度运行，你基本是一无所知的。而且，你也不知道这个运算测试的环境是否过度优化了，有可能JavaScript引擎找到了什么方法来优化你这个独立的测试用例，但在更真实的程序中是无法进行这样的优化的，那么这个运算就会比测试时跑得慢。

综上所述，用这种测试方法是不科学的。

#### 6.1.2 Benchmark.js

这是一个用于测试的库。可以用于测试函数的运行。

### 6.2 环境为王

对特定的性能测试来说，不要忘了检查测试环境，特别是比较任务X和Y这样的比对测试。仅仅因为你的测试显示X比Y快，并不能说明结论X比Y快就有实际的意义。

### 6.3 jsPerf.com

该网站使用Benchmark.js来进行精确可靠的测试，会把上传的代码测试结果放在一个公开可得的URL上，你可以把这个URL转发给别人。

### 6.4 写好测试

编写更好更清晰的测试，使用 jsPerf.com 上的 Description 字段或代码注释，来精确表达你的测试目的。

### 6.5 微性能

一味地考虑微性能是不可取的，我们更应该关注代码逻辑和算法层面上的性能优化。况且，也并不是所有的引擎都类似。

> 程序员们浪费了大量的时间用于思考，或担心他们程序中非关键部分的速度，这 些针对效率的努力在调试和维护方面带来了强烈的负面效果。我们应该在，比如 说 97% 的时间里，忘掉小处的效率：过早优化是万恶之源。但我们不应该错过 关键的 3% 中的机会。 

### 6.6 尾调用优化

尾调用就是一个出现在另一个函数"结尾"处的函数调用。这个调用结束后就没有其余事情要做了。(除了可能要返回结果值)

```javascript
function foo(x) {
  return x
}
function bar(y) {
  return foo(y + 1) // 尾调用
}
function baz() {
  return 1 + bar(40) // 非尾调用
}
baz()
```

对于像上面的 baz 函数的情况，可以使用下面的方法解决变成尾调用：

```javascript
function baz () {
  function baz_foo (n, res) return n + res
  return baz_foo(1, bar(40)) // 尾调用
}
```
