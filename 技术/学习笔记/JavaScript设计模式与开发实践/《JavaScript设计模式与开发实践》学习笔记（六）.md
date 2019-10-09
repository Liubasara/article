---
name: 《JavaScript设计模式与开发实践》学习笔记（六）
title: 《JavaScript设计模式与开发实践》学习笔记（六）
tags: ["技术","学习笔记","JavaScript设计模式与开发实践"]
categories: 学习笔记
info: "第二部分、第 7 章 迭代器模式、第 8 章 发布-订阅模式"
time: 2019/9/23
desc: 'JavaScript设计模式与开发实践, 资料下载, 学习笔记'
keywords: ['JavaScript设计模式与开发实践资料下载', '前端', '学习笔记']
---

# 《JavaScript设计模式与开发实践》学习笔记（六）

## 第 7 章 迭代器模式

迭代器模式是指提供一种方法顺序访问一个聚合对象中的各个元素，而又不需要暴露该对象的内部表示。在使用迭代器模式以后，即使不关心对象的内部构造，也可以按照顺序访问其中的每个元素。

JavaScript 中已经有了许多方法内置了迭代器，比如`Array.prototype.forEach`、`Array.prototype.map`等等。

### 7.2 实现自己的迭代器

我们来实现一个`myEach`函数，接收循环中的每一步后将被触发的回调函数：

```javascript
Array.prototype.myEach = function (callback) {
    for (var i = 0, l = this.length; i < l; i++) {
        callback.call(this[i], this[i], i) // 把元素和下标传给 callback 函数
    }
}

var a = [1, 2, 3]
a.myEach((item, index) => {console.log(item)})
```

### 7.3 内部迭代器和外部迭代器

迭代器可以分为内部迭代器和外部迭代器两种。

> 现在有个需求要判断 2个数组里元素的值是否完全相等，比如数组 [1, 2, 3] 和 [1, 2, 3, 4]

1. 内部迭代器

   内部迭代的调用非常方便，像我们上面实现的就是一个内部迭代器，但由于内部迭代器的迭代规则已经被提前规定，上面的 each 函数无法同时迭代 2 个数组。要实现上面的需求，我们只能从回调函数着手。

   ```javascript
   var compare = function (arr1, arr2) {
       if (arr1.length !== arr2.length) throw new Error('两个数组不相等')
       arr1.myEach((i, n) => {
           if (i !== arr2[n]) {
               throw new Error('两个数组不相等')
           }
       })
       alert('两个数组相等')
   }
   compare([1,2,3], [1,2,3,4])
   ```

   这种写法虽然能得出结果，却显得十分“蹩脚”，完全依赖于 JavaScript 能够任意传递回调函数的特性。

   > 在一些没有闭包的语言中，内部迭代器本身的实现也相当复杂。比如C语言中的内部迭代器是用函数指针来实现的，循环处理所需要的数据都要以参数的形式明确地从外面传递进去

   

2. 外部迭代器

   外部迭代器规定了必须显式地请求迭代下一个元素，虽然增加了一些调用的复杂度，但也增强了迭代的灵活性，使我们可以手工控制迭代的过程或者顺序。

   下面是一个外部迭代器的实现：

   ```javascript
   let Iterator = function (obj) {
       let current = 0
       let next = function () {
           current += 1
       }
       let isDone = function () {
           return current >= obj.length
       }
       let getCurrItem = function () {
           return obj[current]
       }
       return {
           next,
           isDone,
           getCurrItem
       }
   }
   ```

   在这种迭代器下，我们可以将 compare 函数改写如下：

   ```javascript
   let compare = function (iterator1, iterator2) {
       while (!iterator1.isDone() && !iterator2.isDone()) {
           if (iterator1.getCurrItem() !== iterator2.getCurrItem()) {
               throw new Error('不相等')
           }
           iterator1.next()
           iterator2.next()
       }
       if (iterator1.isDone() && iterator2.isDone()) {
           alert('相等')
       } else {
           throw new Error('长度不相等')
       }
   }
   
   var iter1 = Iterator([1, 2, 3])
   var iter2 = Iterator([1, 2, 3, 4])
   compare(iter1, iter2)
   ```

   外部迭代器虽然调用方式相对复杂，但它的适用面更广，也更能满足多变的需求。

两种迭代器没有优劣之分，使用哪个要根据具体需求而定。

### 7.4 迭代类数组和字面量对象

在 JavaScript 中，迭代器模式不仅可以迭代数组，还可以迭代一些类数组的对象，无论内部迭代器还是外部迭代器，只要被迭代的对象拥有 length 属性且可以用下标访问，那它就可以被迭代。

此外，JavaScript 的`for...in`语句也可以用来迭代普通字面量对象的属性。

### 7.7 迭代器模式的应用举例 —— 根据不同的浏览器获取响应的上传组件对象

```javascript
/** 以下为伪代码 **/
// 将获取各种 upload 对象的方法封装在各自的函数里，然后使用一个迭代器获取这些 upload 对象，直到获取到一个可用的为止

var getActiveUploadObj = function () {
    try {
        return new ActiveXObject("TXFTNActiveX.FTNUpload") // IE 上传
    } catch (e) {
        return false
    }
}

var getFlashUploadObj = function () {
    // Flash 上传
    // ...
}

var getFormUploadObj = function () {
    // 表单上传
    var str = `<input name="file" type="file" class="ui-file"></input>`
    return document.body.appendChild(document.createTextNode(str))
}

// 迭代器
var iteratorUploadObj = function () {
    let args = [...auguments]
    for (var i = 0, fn;fn = arguments[i++];) {
        var uploadObj = fn()
        if (uploadObj !== false) {
            return uploadObj
        }
    }
}

// 根据优先级添加 upload 对象方法
var uploadObj = iteratorUploadObj(getActiveUploadObj, getFlashUploadObj, getFormUploadObj)
```

使用上面这种方法我们可以让不同的获取上传对象方法隔离互不干扰，同时也方便拓展，以后如果有新的 upload 对象，也能很方便的拓展进来。

## 第 8 章 发布-订阅模式

发布-订阅模式又称为观察者模式，用于定义对象间的一种一对多的依赖关系。在 JavaScript 中，我们一般用事件模型来替代传统的发布-订阅模式。

### 8.3 DOM 事件

事实上，DOM 的绑定事件就是一种经典的发布-订阅模式。

```javascript
// 新增订阅者
document.body.addEventListener('click', function () {console.log(123)})
// 发布
document.body.click()
```

### 8.4 自定义事件

实现发布-订阅模式需要以下几个步骤：

- 首先要指定一个发布者
- 然后给发布者添加一个缓存列表，用于存放回调函数以便通知订阅者
- 发布消息的时候，发布者会遍历这个缓存列表，并依次触发里面的订阅者回调函数

```javascript
class Events {
  clientList = [] // 缓存列表，存放订阅者的回调函数
  listen (fn) { // 增加订阅者
    this.clientList.push(fn) // 将订阅者添加进缓存列表
  }
  trigger (fn) { // 发布消息
    for (let i = 0, fn; fn = this.clientList[i++];) {
      fn.apply(this, arguments)
    }
  }
}

var events = new Events()
events.listen(function (wow) {console.log(wow)})
events.trigger('wow') // wow
```

上面实现了一个最简单的发布-订阅模式，但还有些许问题，现在的发布是一种广播模式，即订阅者无法根据 key 值来订阅自己感兴趣的消息。

为了实现这一功能，可以将代码修改如下：

```javascript
class Events {
  clientList = {} // 缓存列表，存放订阅者的回调函数
  listen (key, fn) { // 增加订阅者
    if (!this.clientList[key]) {
      this.clientList[key] = []
    }
    this.clientList[key].push(fn)
  }
  trigger () { // 发布消息
    let key = Array.prototype.shift.call(arguments) // 输入的第一个参数为 key
    let fns = this.clientList[key]
    
    for (let i = 0, fn; fn = fns[i++];) {
      fn.apply(this, arguments) // 将剩余的参数传入
    }
  }
}

var event = new Events()
event.listen('click', function (ww, qq) {console.log(ww, qq)})
event.trigger('click', 2, 3) // 2 3
```

这样，我们就实现了一个通用订阅-发布模式的基础功能。

### 8.6 取消订阅的事件

一个完善的观察者模式，需要支持通过传入的 key 和 函数指针消除对应的订阅者。

```javascript
class Events {
  clientList = {} // 缓存列表，存放订阅者的回调函数
  listen (key, fn) { // 增加订阅者
    if (!this.clientList[key]) {
      this.clientList[key] = []
    }
    this.clientList[key].push(fn)
  }
  trigger () { // 发布消息
    let key = Array.prototype.shift.call(arguments) // 输入的第一个参数为 key
    let fns = this.clientList[key]
    
    for (let i = 0, fn; fn = fns[i++];) {
      fn.apply(this, arguments) // 将剩余的参数传入
    }
  }
  remove (key, fn) { // 依靠传入的 key 和 函数指针找到对应的函数进行消除
    let fns = this.clientList[key]
    if (!fns) return false // 代表该 key 对应的事件还没有订阅
    if (!fn) {
      fns && fns.splice(0) // 若没有传递具体的回调函数，则代表清空该 key 下的所有订阅
      return true
    }
    for (let l = fns.length - 1;l >= 0;l--) {
      // 反向遍历订阅者列表
      let _fn = fns[l]
      if (_fn === fn) fns.splice(l, 1) // 删除该订阅者
    }
  }
}

var event = new Events()
var fn1 = function () {console.log(123)}
var fn2 = function () {console.log(234)}
event.listen('click', fn1)
event.listen('click', fn2)
event.trigger('click')
// 123
// 234
event.remove('click', fn1)
event.trigger('click')
// 234
```

### 8.7 适合使用订阅-发布模式的场景

一些需要消息触发的场景，将它们的逻辑模式从【消息触发后 】-> 【调用回调】改为【订阅消息】 -> 【消息触发】，提高程序的可维护性。

具体案例可见书本8.7小节

### 8.10 必须先订阅再发布吗？

在某些场景下，我们会遇到这样的需求，用户触发了消息，但此时订阅者却尚未订阅，而我们需要在其订阅之前将消息触发的动作先保存下来，待其订阅之后，再重新发布消息。

这种需求看起来很奇葩，但确实是存在的，比如说 QQ 这类聊天软件中，对方向我们推送了消息触发了一个事件，但此时用户离线，页面并不会渲染，只有当用户重新上线时，订阅者复活，才会执行该消息对应的回调函数进行页面渲染。

为了满足这种需求，我们需要建立一个存放离线事件的堆栈，当事件发布的时候，如果此时还没有订阅者来订阅，我们会将发布事件的动作包裹在一个函数里，将这些包装函数存入堆栈中，等到有对象来订阅此事件时，再遍历堆栈将其触发，当然，就像未读消息只会出现一次一样，这些触发也只有一次。

说了这么多，其实代码实现很简单：

```javascript
class Events {
  clientList = {}
  // 添加一个缓存列表用于缓存还没有被订阅的发布消息
  cacheList = {}
  
  listen (key, fn) {
    // 如果发布已经存在，则无需存入订阅列表，直接执行
    if (this.cacheList[key] instanceof Array) {
      fn(...this.cacheList[key])
      // 执行完成后将对应消息列表清空，防止执行多次
      this.cacheList[key] = null
    }
    if (!this.clientList[key]) {
      this.clientList[key] = []
    }
    this.clientList[key].push(fn)
  }
  
  trigger () {
    let key = Array.prototype.shift.call(arguments)
    let fns = this.clientList[key]
    if (!fns || (fns && fns.length === 0)) {
      // 若该事件还没有被订阅, 则先缓存起来
      this.cacheList[key] = [...arguments] // 把传入的参数列表缓存
      return
    }
    for (let i = 0, fn; fn = fns[i++];) {
      fn.apply(this, arguments)
    }
  }
  
  remove (key, fn) {
    let fns = this.clientList[key]
    if (!fns) return false
    if (!fn) {
      fns && fns.splice(0)
      return true
    }
    for (let l = fns.length - 1;l >= 0;l--) {
      let _fn = fns[l]
      if (_fn === fn) fns.splice(l, 1)
    }
  }
}
```

### 8.11 全局事件的命名冲突

> 全局的发布—订阅对象里只有一个 clinetList 来存放消息名和回调函数，大家都通过它来订 阅和发布各种消息，久而久之，难免会出现事件名冲突的情况，所以我们还可以给 Event 对象提供创建命名空间的功能。
>
> 实现后的调用如下：
>
> ```javascript
> Event.create('namespace1').listen('click', function (a) {
>     console.log(a)
> })
> Event.create('namespace1').trigger('click', 1) // 1
> 
> Event.create('namespace2').listen('click', function (a) {
>     console.log(a)
> })
> Event.create('namespace2').trigger('click', 2) //2
> ```
>
> 

PS：搞得那么麻烦，为啥不通过实现不同的实例来区分呢...

### 8.12 JavaScript 实现发布-订阅模式的便利性

在 JavaScript 中，由于回调函数的便利性，其实现的观察者模式通常默认为推模型，即先订阅，再发布。而在一般的语言中，还有拉模型，即我们在上个小节中实现的先发布再订阅的模式。