---
name: 《JavaScript设计模式与开发实践》学习笔记（三）
title: 《JavaScript设计模式与开发实践》学习笔记（三）
tags: ["技术","学习笔记","JavaScript设计模式与开发实践"]
categories: 学习笔记
info: "第一部分、第 2 章 this、call 和 apply、第 3 章 闭包和高阶函数"
time: 2019/9/16
desc: 'JavaScript设计模式与开发实践, 资料下载, 学习笔记'
keywords: ['JavaScript设计模式与开发实践资料下载', '前端', '学习笔记']
---

# 《JavaScript设计模式与开发实践》学习笔记（三）

## 第 2 章 this、call 和 apply

### 2.1 this

**JavaScript 的 this 总是指向一个对象，而具体指向哪个对象是在运行时基于函数的执行环境动态绑定的，而非函数被声明时的环境。**（**PS：ES6 箭头函数中的 this 例外**）

#### 2.1.1 this 的指向

this 的指向大致分为以下几种：

- 作为对象的方法调用，指向该对象
- 作为普通函数调用，默认指向全局对象，strict 模式下，指向 undefined
- 构造器调用，指向调用返回的对象
- Function.prototype.call 或 Function.prototype.apply 调用，指向传入的对象

#### 2.1.2 丢失的 this

当函数的默认执行环境被取代，（如：`var a = c.b` ，其中`c.b`是一个函数）这种情况发生的时候，很容易会发生`this`指针丢失的错误。

这时候，我们可以手动修改执行函数，也可以通过箭头函数将函数的执行环境绑定，又或者，我们可以借助`call`、`apply`、`bind`三大函数的力量。

### 2.2 call 和 apply

#### 2.2.1 call 和 apply 的区别

这两个函数的作用一模一样，区别仅在于传入参数形式的不同，也可以说，call 是包装在 apply 上面的一颗语法糖。

#### 2.2.2 call 和 apply 的用途

call 和 apply 最常见的用途就是用于改变函数内部的 this 指向。

此外，大部分浏览器都实现了一个 bind 函数，用于返回一个已经改变了 this 指向的函数。

```javascript
// 自己实现一个 bind 函数
Function.prototype.myBind = function (context) {
  if (typeof context !== 'function') throw new TypeError('类型错误')
  const args = [...arguments].slice(1)
  var _this = this
  return function F () {
    if (this instanceof F) {
      return new _this(...args, ...arguments)
    }
    return _this.apply(context, args.concat(...arguments))
  }
}
```



此外，call 和 apply 方法还会被用于借用其他对象的方法。如字符串借用 Array.prototype 的 concat 函数和 slice 函数，处理 arguments 或是元素列表时等等。

## 第 3 章 闭包和高阶函数

函数式语言的鼻祖是 LISP，JavaScript 在设计之初参考了这些语言，引入了 Lambda 表达式、闭包、高阶函数等特性。使用这些特性，我们可以十分灵活巧妙的编写 JavaScript 代码。

**PS**：笔者看闭包概念实在是有点看吐了，MD 怎么每本书都在讲......所以这部分就不做详细笔记了...

#### 3.1.5 用闭包实现命令模式

在 JavaScript 版本的各种设计模式实现中，闭包的运用非常广泛。

```html
<html>
    <body>
        <button id="execute">执行命令</button>
        <button id="undo">撤销</button>
    </body>
    <script>
        var Tv = {
            open: function () {console.log("打开电视机")},
            close: function () {console.log("关上电视机")}
        }
        var OpenTvCommand = function (receiver) {
            this.receiver = receiver
        }
        OpenTvCommand.prototype.execute = function () {
            this.receiver.open()
        }
        OpenTvCommand.prototype.undo = function () {
            this.receiver.close()
        }
        var setCommand = function (command) {
            document.getElementById('execute').onclick = function () {
                command.execute()
            }
            document.getElementById('undo').onclick = function () {
                command.undo()
            }
        }
        setCommand(new OpenTvCommand(Tv))
    </script>
</html>
```

**命令的模式的意图是把请求封装为对象，从而分离请求的发起者和请求的接收者（执行者）之间的耦合关系。在命令被执行前，可以预先往命令对象中植入命令的接收者**。

使用闭包可以进一步的优化上面的代码，命令接收者将会被封闭在闭包形成的环境中：

```javascript
var Tv = {
    open: function () {console.log("打开电视机")},
    close: function () {console.log("关上电视机")}
}
var createCommand = function (receiver) {
    var execute = function () {
        return receiver.open()
    }
    var undo = function () {
        return receiver.close()
    }
    return {
        execute,
        undo
    }
}
var setCommand = function (command) {
    document.getElementById('execute').onclick = function () {
        command.execute()
    }
    document.getElementById('undo').onclick = function () {
        command.undo()
    }
}
setCommand(createCommand(Tv))
```

#### 3.1.6 闭包与内存管理

正常的闭包使用并不会产生内存泄漏，历史上出现这种事件的原因并非是闭包的问题，也并非是 JavaScript 的问题，这个锅是浏览器的。

> **臭名昭著的 IE**
>
> 跟闭包和内存泄露有关系的地方是，使用闭包的同时比较容易形成循环引用，如果闭包的作用域链中保存着一些 DOM 节点，这时候就有可能造成内存泄露。
>
> 在 IE 浏览器中，由于 BOM 和 DOM 中的对象是使用 C++以 COM 对象的方式实现的，而 COM 对象的垃圾收集机制采用的是引用计数策略。在基于引用计数策略的垃圾回收机制中，如果两个对象之间形成了循环引用，那么这两个对象都无法被回收，但循环引用造成的内存泄露在本质上也不是闭包造成的。

### 3.2 高阶函数

高阶函数是指满足下列条件之一的函数：

- 函数可以作为参数被传递，比如说回调函数，Array.prototype.sort 的用法等等。
- 函数可以作为返回值输出，用于动态生成函数

#### 3.2.3 高阶函数实现 AOP

AOP（面向切面编程）的主要作用是把一些跟核心业务逻辑无关的功能抽离出来。把这些功能抽离之后，再通过“动态织入”的方式掺入业务逻辑模块中。这样的好处是既可以保持业务逻辑的纯净和高内聚，其次也可以方便地复用日志统计等功能模块。

> 在 Java语言中，可以通过反射和动态代理机制来实现 AOP技术。而在 JavaScript这种动态 语言中，AOP的实现更加简单，这是 JavaScript与生俱来的能力。 

在 JavaScript 中实现 AOP，都是指**把一个函数“动态织入”到另外一个函数中**，比如我们可以通过扩展`Function.prototype`来做到这一点。

```javascript
Function.prototype.before = function (beforeFn) {
    var self = this
    return function () {
        beforeFn.apply(this, arguments)
        return self.apply(this, arguments)
    }
}

Function.prototype.after = function (afterFn) {
    var self = this
    return function () {
        var res = self.apply(this, arguments)
        afterFn.apply(this, arguments)
        return res
    }
}

var func = function () {
    console.log(2)
}
func = func.before(function () {console.log(1)}).after(function () {console.log(3)})
func()
// 1
// 2
// 3
```

这种模式又称为**装饰器模式**，我们将在 15 章进行详细讲解。

#### 3.2.4 高阶函数的其他应用

1. currying 柯里化函数，又称部分求值函数
2. uncurrying 用于让对象借用一个原本不属于他的方法，相比 call 和 apply 更加泛用
3. 函数节流，阻止过于频繁的函数调用
4. 分时函数，将影响性能的执行函数主动分为多次执行
5. 惰性加载函数，修改函数自身代码，精简优化执行效率