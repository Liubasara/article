---
name: JavaScript高级程序设计（第4版）学习笔记（九）
title: JavaScript高级程序设计（第4版）学习笔记（九）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：11. 期约与异步函数"
time: 2020/10/28
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']

---

# JavaScript高级程序设计（第4版）学习笔记（九）

## 第 11 章 期约与异步函数

ES6 新增了正式的 Promise（期约...这个让人心脏骤停的翻译）引用类型，支持优雅地定义和组织异步逻辑。接下来几个版本增加了使用`async`和`await`关键字定义异步函数的机制。

### 11.1 异步编程

异步操作并不一定计算量大或要等很长时间。只要你不想为等待某个异步操作而阻塞线程执行，那么任何时候都可以使用。 

在早期 JavaScript 中，只支持定义回调函数来表明异步操作完成，对于多个异步操作的串联，通常需要深度嵌套的回调函数。（回调地狱）

### 11.2 期约（Promise）

ES6 新增的 Promise 可以通过`new`操作符来实例化，创建新的 Promise 时需要传入一个执行器（executor）函数作为参数。

PS：这段翻译真是灾难...而且就算不考虑翻译，这一节写的也不够简单明了，建议看其他资料进行学习...

下面是一个 Promise/A+ 的简单实现：

```javascript
const PENDING = "pending"
const FULFILLED = "fulFilled"
const REJECTED = "rejected"

class MyPromise {
  constructor(executor) {
    this.state = PENDING
    this.value = undefined
    this.reason = undefined
    this.resolveCbList = []
    this.rejectCbList = []
    let resolve = value => {
      if (this.state === PENDING) {
        this.state = FULFILLED
        this.value = value
        this.resolveCbList.forEach(fn => fn())
      }
    }
    let reject = reason => {
      if ((this.state = PENDING)) {
        this.state = REJECTED
        this.reason = reason
        this.rejectCbList.forEach(fn => fn())
      }
    }
    try {
      executor(resolve, reject)
    } catch (e) {
      reject(e)
    }
  }
  then(onFulFilled, onRejected) {
    // onFulfilled如果不是函数，就忽略onFulfilled，直接返回value
    onFulFilled =
      typeof onFulFilled === "function" ? onFulFilled : value => value
    // onRejected如果不是函数，就忽略onRejected，直接扔出错误
    onRejected =
      typeof onRejected === "function"
        ? onRejected
        : err => {
            throw err
          }
    let myPromise2 = new MyPromise((resolve, reject) => {
      if (this.state === PENDING) {
        this.resolveCbList.push(() => {
          setTimeout(() => {
            let x = onFulFilled(this.value)
            resolvePromise(myPromise2, x, resolve, reject)
          }, 0)
        })
        this.rejectCbList.push(() => {
          setTimeout(() => {
            let x = onRejected(this.reason)
            resolvePromise(myPromise2, x, resolve, reject)
          }, 0)
        })
      }
      if (this.state === FULFILLED) {
        // 使用 setTimeout 异步执行把 myPromise2 传出去，不然myPromise2就是undefined
        // 也可以使用 MutationObserver 来替代 setTimeout 可以达到微任务队列的效果（像 Vue 这类框架就是这么干的）
//         const targetNode = document.createElement('div')
//         targetNode.innerText = 0
//         const config = { attributes: true, childList: true, subtree: true }
//         const callback = function (mutationsList, observer) {
//           let x = onFulFilled(this.value)
//           if (x instanceof myPromise) {
//             x.then(resolve, reject)
//           } else {
//             resolve(x)
//           }
//         }
//         const observer = new MutationObserver(callback.bind(this))
//         observer.observe(targetNode, config)
//         targetNode.innerText = +targetNode.innerText + 1
        setTimeout(() => {
          let x = onFulFilled(this.value)
          // 你当然可以直接这样做，不过为了装逼(误)和更好的利用Promise以及判断循环调用的情况，我们对这个值进行通用的递归判断，拿到一个最终的value值(对，其实下面那个递归函数就是调用then函数不停地生成Promise，最终目的就是把最终调用resolve函数的Promise的this.value值拿出来)
          // if (x instanceof MyPromise) {
          //   x.then(resolve, reject)
          // } else {
          //   resolve(x)
          // }
          resolvePromise(myPromise2, x, resolve, reject)
        }, 0)
      }
      if (this.state === REJECTED) {
        setTimeout(() => {
          let x = onRejected(this.reason)
          resolvePromise(myPromise2, x, resolve, reject)
        }, 0)
      }
    })
    return myPromise2 // 返回这个myPromise2 正常情况下，经过递归处理以后，该myPromise2的this.value值是一个最终确定的值而不会是一个Promise
  }
  
  // catch 函数(非核心)
  catch (onRejected) {
    // 默认不成功
    return this.then(null, onRejected)
  }
}


/**
 * resolve中的值几种情况：
 * 1.普通值
 * 2.promise对象
 * 3.thenable对象/函数
 */

/**
 * 对resolve 进行改造增强 针对resolve中不同值情况 进行处理
 * @param  {promise} promise2 promise1.then方法返回的新的promise对象
 * @param  {[type]} x         promise1中onFulfilled的返回值
 * @param  {[type]} resolve   promise2的resolve方法
 * @param  {[type]} reject    promise2的reject方法
 */
function resolvePromise(myPromise2, x, resolve, reject) {
  if (myPromise2 === x) {
    reject(new TypeError("循环引用"))
  }
  let called
  if (x !== null && (typeof x === "object" || typeof x === "function")) {
    try {
      let then = x.then
      if (typeof then === "function") {
        // Promise 对象
        then.call(
          x,
          y => {
            if (called) return // 文档要求，一旦成功，不能调用失败
            called = true
            resolvePromise(x, y, resolve, reject)
          },
          err => {
            if (called) return // 文档要求，一旦失败，不能调用成功
            called = true
            reject(err)
          }
        )
      } else {
        // 普通对象
        resolve(x)
      }
    } catch (e) {
      if (called) return // 文档要求，一旦成功，不能调用失败
      called = true
      reject(e)
    }
  } else {
    resolve(x)
  }
}

// 以下是其他的方法
MyPromise.resolve = function (value) {
  return new MyPromise((resolve, reject) => {
    resolve(value)
  })
}

MyPromise.reject = function (value) {
  return new MyPromise((resolve, reject) => {
    reject(value)
  })
}

MyPromise.race = function (promises) {
  return new MyPromise((resolve, reject) => {
    for (let i = 0; i < promises.length; i++) {
      promises[i].then(resolve, reject)
    }
  })
}

MyPromise.all = function (promises) {
  return new MyPromise((resolve, reject) => {
    let successArr = []
    let successCount = 0
    function processData (index, data) {
      successArr[index] = data
      // 判断数组中成功的数量是否等于promises中元素的数量
      if (++successCount === promises.length) {
        resolve(successArr)
      }
    }
    for (let i = 0; i < promises.length; i++) {
      promises[i].then(data => {
        processData(i, data)
      }, reject)
    }
  })
}

// test
// var p1 = new MyPromise((resolve, reject) => resolve(1))
// .then( data => new MyPromise(resolve => resolve(++data)))
// .then(data => console.log(data))

// var p1 = new MyPromise((resolve, reject) => resolve(1))
// .then( data => new MyPromise( resolve => resolve(new MyPromise( resolve => resolve(++data) )) ))
// .then(data => console.log(data))
```

#### Promise.prototype.finally()

该方法用于给期约添加`onFinally`处理程序，该处理程序在 Promise 转换为 resolved 或 rejected 状态时都会执行，但没有办法知道期约的状态是解决还是拒绝。

> 这个新期约实例不同于 then()或 catch()方式返回的实例。因为 onFinally 被设计为一个状态无关的方法，所以在大多数情况下它将表现为父期约的传递。对于已解决状态和被拒绝状态都是如此。

#### 11.2.4 期约连锁与期约合成

可以把任意多个函数作为处理程序合成一个连续传值的期约连锁：

```javascript
function compose (...fns) {
  return (x) => fns.reduce((promise, fn) => promise.then(fn), Promise.resolve(x))
}
let addTen = compose(
  x => x + 2,
  y => y + 3,
  z => z + 5
)
addTen(8).then(res => {console.log(res)}) // 18
```

#### 11.2.5 Promise 扩展

ES6 的 Promise 实现很可靠，但也有不足之处：期约取消和进度追踪。

**1. 期约取消**

当 Promise 正在处理，但程序却不再需要其结果的场景下，ES6 无法主动取消 Promise。（曾经有过提案，但最终被撤回了）





> 本次阅读至 P345 370  期约取消
