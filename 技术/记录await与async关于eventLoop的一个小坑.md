---
name: 记录await与async关于eventLoop的一个小坑
title: 记录await与async关于eventLoop的一个小坑
tags: ["技术"]
categories: 学习笔记
info: "小小循环，大大智慧"
time: 2020/3/24
desc: node, javascript前端笔记
keywords: ['node', '前端', 'eventLoop', '学习笔记']
---

# 记录await与async关于eventLoop的一个小坑

> 引用资料：
>
> - [async/await执行顺序](https://juejin.im/post/5e5c7f6c518825491b11ce93#heading-2)
> - [async/await 在chrome 环境和 node 环境的 执行结果不一致，求解？](https://www.zhihu.com/question/268007969)

```javascript
// 例一：当 await 后面跟的不是一个 Promise 变量的时候，await 后面的代码会第一时间作为 micro task 注入到事件循环中
console.log('script start')

async function async1() {
    await async2()
    console.log('async1 end')
}
async function async2() {
    console.log('async2 end')
    return 1 // different
}
async1()

setTimeout(function() {
    console.log('setTimeout')
}, 0)

new Promise(resolve => {
    console.log('Promise')
    resolve()
})
.then(function() {
    console.log('promise1')
})
.then(function() {
    console.log('promise2')
})

console.log('script end')
/**
script start
async2 end
Promise
script end
async1 end
promise1
promise2
setTimeout
*/
```



```javascript
// 例二：当 await 后面跟的是一个 Promise 变量的时候，await 会将该 Promise 变量的 then 方法作为 micro task 注入 EventLoop。在该 Promise 变为 resolved 状态后，再将 await 之后的代码作为 micro task 注入 EventLoop
console.log('script start')

async function async1() {
    await async2()
    console.log('async1 end')
}
async function async2() {
    console.log('async2 end')
    return Promise.resolve().then(()=>{ // different
        console.log('async2 end1')
    })
}
async1()

setTimeout(function() {
    console.log('setTimeout')
}, 0)

new Promise(resolve => {
    console.log('Promise')
    resolve()
})
.then(function() {
    console.log('promise1')
})
.then(function() {
    console.log('promise2')
})

console.log('script end')

/**
script start
async2 end
Promise
script end
async2 end1
promise1
promise2
async1 end
*/
```



