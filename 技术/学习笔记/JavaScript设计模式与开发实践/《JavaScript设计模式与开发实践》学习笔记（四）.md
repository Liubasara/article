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

> 很多公司的年终奖是根据员工的工资基数和年底绩效情况来发放的。例如，绩效为S的人年 终奖有 4倍工资，绩效为 A的人年终奖有 3倍工资，而绩效为 B的人年终奖是 2倍工资。假设财 务部要求我们提供一段代码，来方便他们计算员工的年终奖。 

要初步解决这个问题，我们可以编写一个函数接受两个参数，用于计算绩效等级为 X 工资为 Y 的员工的薪水：

```javascript
var calculateBonus = function (level, salary) {
    if (level === 'S') return salary * 4
    if (level === 'A') return salary * 3
    if (level === 'B') return salary * 2
}

calculateBonus('B', 2000) // 4000
```

上面这段代码可以初步达成目的，但也有着显而易见的缺点：

- 违反开闭原则，此时若有一种新的绩效等级，我们就需要修改函数的内部实现
- 复用性差
- 包含太多的 if 逻辑

**使用策略模式重构代码**

将不变的部分和变化的部分隔开是每个设计模式的主题，策略模式的目的就是将算法的使用与算法的实现分离开来。

在这个案例中，算法的使用方式是不变的——都是根据某个算法取得计算后的奖金数额。而变化的是算法的实现——每种绩效对应着不同的计算规则。

一个基于策略模式的程序至少由两部分组成：

- 策略类，封装了具体的算法，并负责具体的计算过程
- 环境类 Context，用于接受客户的请求，然后把请求委托给某一个策略类。要做到这一点，就要在 Context 中维持对某个策略对象的引用。

以下是使用策略模式后重构的代码：

```javascript
// 定义不同的绩效类
var LevelS = function () {}
LevelS.prototype.calculate = function (salary) {
    return salary * 4
}

var LevelA = function () {}
LevelA.prototype.calculate = function (salary) {
    return salary * 3
}

var LevelB = function () {}
LevelB.prototype.calculate = function (salary) {
    return salary * 2
}
// 定义奖金类
var Bonus = function () {
    this.salary = null // 原始工资
    this.strategy = null // 绩效等级对应的策略对象
}
Bonus.prototype.setSalary = function (salary) {
    this.salary = salary // 设置员工的初始工资用于计算
}
Bonus.prototype.setStrategy = function (strategy) {
    this.strategy = strategy // 设置员工对应的策略对象
}
Bonus.prototype.getBonus = function () {
    // 取得奖金数额
    return this.strategy.calculate(this.salary)
}

var bonus = new Bonus()
bonus.setSalary(1000)
bonus.setStrategy(new LevelS()) // 设置策略对象
bonus.getBonus() // 4000
```

上面这段代码可以体现出策略模式的各个要点，所谓**定义一系列的算法，把它们一个个封装起来，并且使它们可以相互替换**，其实详细地说，就是**定义一系列的算法，把它们封装成策略类（上面例子中的 Level 类），算法封装在策略类内部的方法里**。

在客户对 Context 发起请求的时候，Context 把请求委托给策略对象中的某一个来进行计算。

### 5.2 JavaScript 版本的策略模式

上面我们的做法其实是模拟传统面向对象语言的做法，实际在 JavaScript 中，我们没有必要这么麻烦。

```javascript
var strategies = {
    'S': function (salary) {
        return salary * 4
    },
    'A': function (salary) {
        return salary * 3
    },
    'B': function (salary) {
        return salary * 2
    }
}
var calculateBonus = function (level, salary) {
    return strategies[level](salary)
}

calculateBonus('S', 1000) // 4000
```

上面的代码中，充当 Context 的不再是一个类，而是`calculateBonus`函数，这是完全可行的。

### 5.3 多态在策略模式中的体现

> 通过使用策略模式重构代码，我们消除了原程序中大片的条件分支语句。所有跟计算奖金有关的逻辑不再放在 Context中，而是分布在各个策略对象中。Context并没有计算奖金的能力，而 是把这个职责委托给了某个策略对象。每个策略对象负责的算法已被各自封装在对象内部。当我们对这些策略对象发出“计算奖金”的请求时，它们会返回各自不同的计算结果，这正是对象多态性的体现，也是“它们可以相互替换”的目的。替换 Context中当前保存的策略对象，便能执行不同的算法来得到我们想要的结果。 

### 5.5 更广义的“算法”

策略模式如果仅仅用来封装算法，未免有些大材小用。在实际开发中，一些常用的“业务规则”只要指向的目标一致并且可以被替换使用，我们就可以用策略模式来封装他们。比如说表单校验。

### 5.6 表单校验

本小节提供了一个使用策略模式校验表单输入的完整例子。

### 5.7 策略模式的优缺点

策略模式的优点：

- 利用组合、委托和多态等技术思想，可以有效避免多重条件和选择语句
- 提供了对开闭原则的支持，算法被封装在独立的 strategy 对象中，易于理解和扩展
- 策略模式的算法可供复用
- 利用组合和委托让 Context 拥有执行算法的能力，可以算是一种更轻量的继承

策略模式的缺点：

- 要使用策略模式，必须了解所有的 strategy 和它们之间的不通电，需要向客户暴露它的所有实现，违反了最少知识原则。
- 策略模式会在程序中增加许多策略类或者策略对象（但这一般是传统语言面向对象语言才会出现的毛病）

### 5.8 一等函数对象与策略模式

> 在函数作为一等对象的语言中，策略模式是隐形的。 strategy 就是值为函数的变量。

在前面的学习中，为了清楚地表示这是一个策略模式，我们特意使用了 strategies 这个名字。 如果去掉 strategies，我们还能认出这是一个策略模式的实现吗？

```javascript
var S = function (salary) {
    return salary * 4
}
var A = function (salary) {
    return salary * 3
}
var B = function (salary) {
    return salary * 2
}
var calculateBonus = function (func, salary) {
    return func(salary)
}
calculateBonus(S, 10000)
```