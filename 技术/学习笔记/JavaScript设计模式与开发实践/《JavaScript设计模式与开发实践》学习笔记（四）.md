---
name: 《JavaScript设计模式与开发实践》学习笔记（四）
title: 《JavaScript设计模式与开发实践》学习笔记（四）
tags: ["技术","学习笔记","JavaScript设计模式与开发实践"]
categories: 学习笔记
info: "第二部分、第 4 章 单例模式、第 5 章 策略模式"
time: 2019/9/18,
desc: 'JavaScript设计模式与开发实践, 资料下载, 学习笔记'
keywords: ['JavaScript设计模式与开发实践资料下载', '前端', '学习笔记']
---

# 《JavaScript设计模式与开发实践》学习笔记（四）

---

**第二部分 设计模式**

第二部分并没有全部涵盖 GoF 所提出的 23 种设计模式，而是选择了在 JavaScript 开发中更常见的 14 种设计模式。

---

## 第 4 章 单例模式

单例模式的定义是：**保证一个类仅有一个实例，并提供一个访问它的全局访问点**。

实际应用中，用到单例模式的地方很多，比如说 loading 弹窗，提示语弹框等等。

### 4.1 实现单例模式

使用单例模式时，我们通常会使用一个变量来标志当前是否已经为某个类创建过对象，如果是，则在下一次获取该类的实例时，直接返回之前创建的对象。

```javascript
function Single () {}
Single.getInstance = (function () {
    let instance
    return function () {
        if (!instance) {
            instance = new Single()
        }
        return instance
    }
})()

var a = Single.getInstance()
var b = Single.getInstance()
a === b // true
```

上面的例子中我们通过 Single.getInstance 来获取唯一的对象，这种方式相对简单，但有一个问题：Single 类的使用者必须要通过 Single.getInstance 来获取对象，与普通的 new XXX 这种方式不一样，增加了这个类的不透明性。

接下来我们一步步地编写出更好的单例模式。

### 4.2 透明的单例模式

我们的目标是实现一个“透明”的单例类，用户从这个类中创建对象的时候，可以像使用其他任何普通类一样。

我们可以用一个自执行的匿名函数来初步做到这点：

```javascript
var BetterSingle = (function () {
    var instance
    var BetterSingle = function () {
        if (instance) return instance
        return instance = this
    }
    return BetterSingle
})()

var a = new BetterSingle()
var b = new BetterSingle()
a === b // true
```

上面完成了一个透明地单例类的编写，但他还是有一些缺点，比如增加了程序的复杂度和造成了一定的阅读困难。

造成这种缺点的原因是我们的 BetterSingle 函数违反了“单一职责原则”，这个函数既要承担新建一个对象的职责，还要保证该对象是唯一的，这是一种不好的做法，让这个构造函数看起来很奇怪。

如果将来这个类要从单例类变成可产生多个实例的类，上面的函数就不能满足要求，我们要么得重新写一个类，要么就只能修改上面的函数和以往的业务代码。

### 4.3 用代理实现单例模式

我们引入代理类的方式可以解决上面提出的问题。

```javascript
var Single = function () {}

var ProxySingle = (function () {
    var instance
    return function () {
        if (!instance) {
            instance = new Single()
        }
        return instance
    }
})()

var a = new ProxySingle()
var b = new ProxySingle()
var c = new Single()

a === b // true
b === c // false
```

上面的代码通过使用一个代理类的方法完成单例模式的编写，这样在完美解决了上面的问题的同时也做到了职责分离。实际上这是缓存代理的应用之一，在第 6 章中我们将继续学习。

### 4.4 JavaScript 的单例模式

上面的写法是传统面向对象语言的写法，但 JavaScript 其实是一个没有“类”概念的语言，我们并不需要拘泥于类的方式来实现单例应用。

单例模式的核心是**确保只有一个实例，并且提供全局访问**。

### 4.5 惰性单例

惰性单例指在需要的时候才创建的对象实例，比如我们上面写的代码中，`instance`实例对象总是在我们调用`Singleton.getInstance`的时候才被创建，而不是在一开始就被创建。

根据 4.4 的说法，我们无需拘泥于创建类的方法，类的创建完全可以借助于函数而不是`new`操作符。

```javascript
var createObj = function () {
    var res = {}
    return res
}
var getSingle = function (fn) {
    var result
    return function () {
        return result || (result = fn.apply(this, arguments))
    }
}
var createSingleObj = getSingle(createObj)

var a = createSingleObj()
var b = createSingleObj()
var c = createObj()

a === b // true
b === c // false
```

## 第5章 策略模式

> 俗话说，条条大路通罗马。在美剧《越狱》中，主角 Michael Scofield 就设计了两条越狱的 道路。这两条道路都可以到达靠近监狱外墙的医务室。 同样，在现实中，很多时候也有多种途径到达同一个目的地。比如我们要去某个地方旅游， 可以根据具体的实际情况来选择出行的线路

策略模式的定义是：**定义一系列算法，把它们一个个封装起来，并且它们可以相互替换**。

### 5.1 使用策略模式计算奖金



> 本次阅读至 P72 5.1 使用策略模式计算奖金 91