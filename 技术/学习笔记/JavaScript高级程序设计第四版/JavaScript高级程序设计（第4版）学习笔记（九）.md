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

但我们可以在现有实现基础上提供一种临时性的封装，以实现取消 Promise 的功能。

PS：多用于取消 request 请求。

> 拓展阅读：[axios取消接口请求](https://www.jianshu.com/p/22b49e6ad819)
>
> Q:为什么要取消请求？
>
> A:请求的响应时间存在不确定性，请求次数过多时，有可能较早发起的请求会较晚响应，那么我们需要设计一套机制，确保较晚发起的请求可以在客户端就取消掉较早发起的请求。
>
> Q:如何取消一次请求
>
> A:发起一次请求A，且该请求中携带标识此次请求的id,发起一次请求B，该请求中取消请求A,请求A响应时，通过校验发现是一个被取消的请求，那么就不正常处理其响应。

```javascript
function CancelToken (cancelFn) {
  this.promise = new Promise((resolve, reject) => {
    cancelFn(resolve)
  }).then(() => {
    console.log('Promise 取消')
  })
}
// 需要取消的较早发起较晚返回的请求
function request1 () {
  return new Promise((resolve, reject) => {
    const id = setTimeout(() => {
      resolve()
    }, 5000)
    window.token = new CancelToken((cancelCallback) => {
      window.clearObj = {
        id: id,
        cancelCallback: cancelCallback
      }
    })
  }).then(() => {
    console.log('5s later')
  })
}

// 较晚发起较早返回的请求，顺带需要取消掉前一个请求
function request2 () {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      window.clearObj.cancelCallback()
      window.token.promise.then(() => {
        clearTimeout(window.clearObj.id)
        resolve()
      })
    }, 2000)
  }).then(() => {
    console.log('2s later')
  })
}
```

上述代码的执行效果是，如果在执行了`request1`方法后的 3s 内如果发起`request2`请求，就会取消掉前一个请求。

> PS：此外还可以通过 Promise.race 或 reject 的方法来对 Promise 进行取消。
>
> [js 如何取消promise](https://www.cnblogs.com/ajanuw/p/12516221.html)

**2. 期约进度通知**

ES6 并不支持进度追踪，但同样可以通过扩展来实现。

一种扩展方式是扩展 Promise 类，为它添加 notify() 方法，如下：

```javascript
class TrackablePromise extends Promise {
  constructor (executor) {
    const notifyHandlers = []
    super((resolve, reject) => {
      return executor(resolve, reject, status => {
        notifyHandlers.map(handler => handler(status))
      })
    })
    this.notifyHandlers = notifyHandlers
  }
  notify (notifyHandler) {
    this.notifyHandlers.push(notifyHandler)
    return this
  }
}
// 这样就可以在执行函数中使用 notify 函数了
let p = new TrackablePromise((resolve, reject, notify) => {
  function countdown (x) {
    if (x > 0) {
      notify(`${20 * x}% 百分比`)
      setTimeout(() => countdown(x - 1), 1000)
    } else {
      resolve()
    }
  }
  countdown(5)
})
p.notify(x => setTimeout(() => {console.log(x)}, 0))
p.then(() => setTimeout(() => {console.log('completed')}))

// 80% 百分比
// 60% 百分比
// 40% 百分比
// 20% 百分比
// completed
```

> ES6不支持取消期约和进度通知，一个主要原因就是这样会导致期约连锁和期约合成过度复杂化。比如在一个期约连锁中，如果某个被其他期约依赖的期约被取消了或者发出了通知，那么接下来应该发生什么完全说不清楚。毕竟，如果取消了 Promise.all() 中的一个期约，或者期约连锁中前面的期约发送了一个通知，那么接下来应该怎么办才比较合理呢?

### 11.3 异步函数（async/await）

`async/await`是 ES8 规范新增的。他能让异步代码能够同步执行。

使用`await`关键字可以暂停异步函数代码的执行，等待期约解决。`await`关键字必须要在`async`函数中使用，不能在顶级上下文如`<script>`标签或模块中使用。在同步函数内部使用`await`会抛出`SyntaxError`。

要完成理解`await`关键字，必须知道它并非只是等待一个值可用那么简单。JavaScript 运行时在碰到`await`关键字时，会记录在哪里暂停执行，等到`await`右边的值可用了，JavaScript 运行时会向消息队列中推送一个任务，这个任务会恢复异步函数的执行。

因此，即便`await`后面跟着一个立即可用的值，函数的其余部分也会被异步求职。

> 拓展阅读：
>
> [记录await与async关于eventLoop的一个小坑](https://blog.liubasara.info/#/blog/articleDetail/mdroot%2F%E6%8A%80%E6%9C%AF%2F%E8%AE%B0%E5%BD%95await%E4%B8%8Easync%E5%85%B3%E4%BA%8EeventLoop%E7%9A%84%E4%B8%80%E4%B8%AA%E5%B0%8F%E5%9D%91.md)

```javascript
async function foo () {
  console.log(2)
  await null
  console.log(4)
}
console.log(1)
foo()
console.log(3)
// 1
// 2
// 3
// 4
```

#### 11.3.3 异步函数策略

异步函数的用途：

- 有了异步函数之后，一个简单的箭头函数就可以实现非阻塞暂停`sleep()`函数。

  ```javascript
  async function sleep (delay) {
    return new Promise(resolve => setTimeout(resolve, delay))
  }
  ```

- 顺序执行所有 Promise 而无需进行 then 的嵌套。

- 栈追踪与内存管理

  > JavaScript 引擎会在创建期约时尽可能保留完整的调用栈。在抛出错误时， 调用栈可以由运行时的错误处理逻辑获取，因而就会出现在栈追踪信息中。当然，这意味着栈追踪信息会占用内存，从而带来一些计算和存储成本。 
