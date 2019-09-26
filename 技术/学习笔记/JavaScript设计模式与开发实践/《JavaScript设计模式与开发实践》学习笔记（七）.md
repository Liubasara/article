---
name: 《JavaScript设计模式与开发实践》学习笔记（七）
title: 《JavaScript设计模式与开发实践》学习笔记（七）
tags: ["技术","学习笔记","JavaScript设计模式与开发实践"]
categories: 学习笔记
info: "第二部分、第 9 章 命令模式、第 10 章 组合模式"
time: 2019/9/26,
desc: 'JavaScript设计模式与开发实践, 资料下载, 学习笔记'
keywords: ['JavaScript设计模式与开发实践资料下载', '前端', '学习笔记']
---

# 《JavaScript设计模式与开发实践》学习笔记（七）

## 第 9 章 命令模式

### 9.1 命令模式的用途

> 命令模式常见的应用场景是：有时候需要向某些对象发送请求，但是并不知道请求的接收 者是谁，也不知道被请求的操作是什么。此时希望用一种松耦合的方式来设计程序，使得请求发送者和请求接收者能够消除彼此之间的耦合关系。 

命令模式需要把一个请求封装成 command 对象，这个对象可以在程序中传递，请求者无需知道执行程序的名字，以达到请求调用者和接收者之间的耦合关系。

### 9.2 命令模式例子 

在传统语言环境下（Java，C++）实现命令模式，需要借助命令类来达到请求和执行分割开的目的。

```javascript
function runCommand = function (commnad) {
    command.excute()
}

// 执行
var actionA = {
    refresh: function () {console.log('refresh')}
}
var actionB = {
    add: function () {console.log('add')}
}

// 命令类
var ActionACommand = function (receiver) {
    this.receiver = receiver
}
ActionACommand.prototype.excute = function () {
    this.receiver.refresh()
}
var ActionBCommand = function (receiver) {
    this.receiver = receiver
}
ActionBCommand.prototype.excute = function () {
    this.receiver.refresh()
}

// 请求
runCommand(new ActionACommand(actionA))
runCommand(new ActionBCommand(actionB))
```

### 9.3 JavaScript 中的命令模式 ~ 9.7 宏命令

命令模式在 JavaScript 中是一种隐形的模式，由于函数作为一等对象，本身就可以被四处传递，无需借助传入类来实现。

此外，宏命令可以用于达到一次指令，执行一系列命令的目的。

下面的例子就是二者的体现。

```javascript
var commandA = {
    execute: function () {
        console.log('commandA')
    }
}
var commandB = {
    excute: function () {
        console.log('commandB')
    }
}

var MacroCommand = function () {
    return {
        commandsList: [],
        add: function (command) {
            this.commandsList.push(command)
        },
        excute: function () {
            this.commandsList.forEach(command => {
                command.excute()
            })
        }
    }
}

var macroCommand = MacroCommand()
macroCommand.add(commandA)
macroCommand.add(commandB)

macroCommand.execute()
```



## 第 10 章 组合模式



> 本次阅读至P137 第 10 章 组合模式 156