---
name: 《JavaScript设计模式与开发实践》学习笔记（三）
title: 《JavaScript设计模式与开发实践》学习笔记（三）
tags: ["技术","学习笔记","JavaScript设计模式与开发实践"]
categories: 学习笔记
info: "第一部分、第 2 章 this、call 和 apply、第 3 章 闭包和高阶函数"
time: 2019/9/16,
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



> 本次阅读至P43 3.1.6 闭包与内存管理 62

