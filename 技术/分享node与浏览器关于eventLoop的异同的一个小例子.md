---
name: 分享node与浏览器关于eventLoop的异同的一个小例子
title: 分享node与浏览器关于eventLoop的异同的一个小例子
tags: ["技术"]
categories: 学习笔记
info: ""
time: 2019/1/20
desc: node, javascript前端笔记
keywords: ['node', '前端', 'eventLoop', '学习笔记']
---

# 分享node与浏览器关于eventLoop的异同的一个小例子

> 引用资料：
>
> - [又被node的eventloop坑了，这次是node的锅](https://juejin.im/post/5c3e8d90f265da614274218a)
> - [简单总结下JS中EventLoop事件循环机制](https://www.cnblogs.com/hanzhecheng/p/9046144.html)

```javascript
function test () {
   console.log('start')
    setTimeout(() => {
        console.log('children2')
        Promise.resolve().then(() => {console.log('children2-1')})
    }, 0)
    setTimeout(() => {
        console.log('children3')
        Promise.resolve().then(() => {console.log('children3-1')})
    }, 0)
    Promise.resolve().then(() => {console.log('children1')})
    console.log('end') 
}

test()

// 以上代码在node11以下版本的执行结果(先执行所有的宏任务，再执行微任务)
// start
// end
// children1
// children2
// children3
// children2-1
// children3-1

// 以上代码在node11及浏览器的执行结果(顺序执行宏任务和微任务)
// start
// end
// children1
// children2
// children2-1
// children3
// children3-1
```

