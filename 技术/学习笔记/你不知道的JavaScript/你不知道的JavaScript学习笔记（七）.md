---
name: 你不知道的JavaScript学习笔记（七）
title: 《你不知道的JavaScript》学习笔记（七）
tags: ["技术","学习笔记","你不知道的JavaScript"]
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

本章讲解了什么是Promise，可能会比较难理解，建议可以自己手写一个出来，结合书中的概念进行理解，可能会好一点。

```javascript
// 自己手写一个Promise
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
        // 只有使用setTimeout异步执行才能把myPromise2传出去，不然myPromise2就是undefined
        setTimeout(() => {
          let x = onFulFilled(this.value)
          // 你当然可以直接这样做，不过为了装逼(误)和更好的利用Promise，我们对这个值进行通用的递归判断，拿到一个最终的value值(对，其实下面那个递归函数就是调用then函数不停地生成Promise，最终目的就是把最终调用resolve函数的Promise的this.value值拿出来)
          // resolve(x)
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

#### 3.3.8 建立信任

为什么JavaScript异步代码需要信任，因为我们需要把控制权放在一个可信任的系统(Promise)中，这种系统的设计目的就是为了使异步编码更加清晰。

### 3.4 链式流

链式流的核心就是`then`这个步骤：

- 每次你对Promise调用then(..)，它都会创建并返回一个新的Promise，我们可以将其链接起来
- 不管从then(..)调用的完成回调（第一个参数）返回的值是什么，它都会被自动设置为被链接Promise（第一点中的）的完成。

简单总结一下使链式流程控制可行的`Promise`固有特性：

- 调用`Promise`的`then(..)`会自动创建一个新的`Promise`从调用返回
- 在完成或拒绝处理函数内部，如果返回一个值或者抛出一个异常，新返回的(可链接的)Promise就相应地决议
- 如果完成或拒绝处理函数返回一个Promise，它将会被展开，这样一来，不管它的决议值是什么，都会成为当前`then`返回的链接Promise的决议值。

### 3.5 错误处理

本节看不懂...日后再说

### 3.6 Promise模式

基于Promise构建的异步模式抽象还有很多变体。

#### 3.6.1 Promise.all([..])

在Promise链中，任意时刻都只能有一个异步任务在执行，但如果想要让多个异步任务**并行执行**，并且统一回调，该怎么实现呢？

Promise.all就提供了这样一种方式，该方法接收一个由Promise元素组成的数组，仅在所有的成员Promise都完成后才会完成，如果这些promise中有任何一个被拒绝的话，就会立刻丢弃来自其它所有promise的全部结果。

在经典的编程术语中，这样的模式机制叫作门(gate)，需要等待多个并行的任务完成，完成顺序不重要，但必须全部完成门才会打开。

#### 3.6.2 Promise.race([..])

尽管Promise.all([..])协调多个并发Promise的运行，但有时候我们只想要响应其中的一个Promise而抛弃掉其它的，这种模式在传统中称为门闩，在Promise中称为竞态。

该方法接收一个Promise组成的数组，当其中有成员完成以后，就会返回完成，其它的结果全部丢弃。而一旦有任何一个Promise决议为拒绝，它也会拒绝。

### 3.7 Promise API概述

总结Promise的所有API

#### 3.7.1 new Promise(..)构造器

```javascript
var p = new Promise((resolve, reject) => {
    // resolve(..)用于决议/完成这个promise
    // reject(..)用于拒绝这个promise
})
```

#### 3.7.2 Promise.resolve(..)和Promise.reject(..)

创建一个已被拒绝的Promise可以使用`Promise.reject()`，同理，创建一个已完成的Promise可以使用`Promise.resolve()`。

#### 3.7.3 then方法和catch方法

`then`接受一个或两个参数，第一个用于完成回调，第二个用于拒绝回调。

而`catch`只接受一个拒绝回调作为参数，换句话说，它等于`then(null, ...)`

#### 3.7.4 Promise.all和Promise.race

上文已经介绍过

### 3.8 Promise的局限性

#### 3.8.1 顺序错误处理

```javascript
var p = new Promise((resolve,reject) => {resolve('something')})
.then(data => {
    // do something
})
.then(data => {
    //do something
})
p.catch(error => {
    // error function
})
```

上述代码中的p实际指向的是最后一个then之后返回的Promise对象，这也就意味着，在中间，也就是如果在链的(就是不断的then)调用中发生了错误，此时的Promise有可能并不会触发你的错误处理函数，因为在Promise看来，这是已经被忽略掉的或者已经处理了的情况。

#### 3.8.2 单一值

根据定义，Promise只能有一个完成值或一个拒绝理由。在简单的例子中，这不是什么问题，但是在更复杂的场景中，你可能就会发现这是一种局限了。

#### 3.8.3 单决议

Promise最本质的一个特征是：Promise只能被决议一次(完成或拒绝)。

#### 3.8.4 惯性

如果说你之前的代码是使用回调来完成一部操作的(比如ajax)，那么使用Promise就会显得有些困难。也就是说，Promise的使用并没有一个放之四海皆准的适用原则。

#### 3.8.5 无法取消的Promise

一旦创建了一个Promise并为其注册了完成或拒绝处理函数，如果出现某种情况使得这个任务悬而未决的话，你也没有办法从外部停止它的进程。

#### 3.8.6 Promise性能

Promise有一个真正的性能局限：它没有真正提供可信任性保护支持的列表以供选择。(不懂...)

