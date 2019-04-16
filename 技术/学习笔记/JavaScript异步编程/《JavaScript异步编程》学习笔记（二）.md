---
name: 《JavaScript异步编程》学习笔记（二）
title: 《JavaScript异步编程》学习笔记（二）
tags: ['读书笔记', 'JavaScript异步编程']
categories: 学习笔记
info: "JavaScript异步编程 第2章 分布式事件"
time: 2019/4/14
desc: 'JavaScript异步编程, 资料下载, 学习笔记, 第2章 分布式事件'
keywords: ['前端', 'JavaScript异步编程', '学习笔记', '第2章 分布式事件']
---

# 《JavaScript异步编程》学习笔记（二）

## 第二章 分布式事件

本章讲述发布订阅模式，对于有进阶程序设计，编写简洁代码追求的人来说，**很有用**。

### 2.1 PubSub 模式

DOM1 标准允许向 DOM 元素附加事件处理器，例如：

```javascript
link.onclick = clickHandler
```

如果想向元素附加两个点击事件处理器，则可以这样：

```javascript
link.onclick = function (...args) {
    clickHandler1.apply(this, args)
    clickHandler2.apply(this, args)
}
```

上面的写法显然过于冗长复杂，而且也不利于实现解耦，所以我们一般会使用 DOM2 中定义的`addEventListener`方法来实现。

从软件架构的角度看，这样子的代码属于将 link 元素的时间**发布**给了任何想**订阅**此事件的人。这正是称其为 PubSub 模式的原因。

#### 2.1.2 玩转自己的 PubSub

PubSub 模式十分简单，用十几行代码就能自己实现。对于支持的每种事件类型，**唯一需要存储的状态值就是一个事件处理器清单**。

```javascript
PubSub = {handlers: {}}
```

需要添加事件监听器时，只要将监听器推入数组末尾即可。等到触发事件的时候，再循环遍历所有的事件处理器。

```javascript
PubSub.on = function (eventType, handler) {
    if (!(eventType in this.handlers)) {
        this.handlers[eventType] = []
    }
    this.handlers[eventType].push(handler)
    return this
}
PubSub.emit = function (eventType, ...args) {
    for (let i = 0; i < this.handlers[eventType].length; i++) {
        this.handlers[eventType][i].apply(this, handlerArgs)
    }
    return this
}
```

#### 2.1.3 同步性

尽管 PubSub 模式是一项处理异步事件的重要技术，但是其内在跟异步没有任何关系。换句话说，事件处理器本身无法知道自己是从事件队列中还是从应用代码中运行的。

如果事件按顺序出发了过多的处理器，就会有阻塞线程且导致浏览器不响应的风险。而如果事件处理器本身又触发了事件，就很容易会造成无限循环。

```javascript
link.onclick = function () {
    alert('点击！')
    link.click()
}
```

对于一些有着复杂计算和耗时操作的程序，如果在完成这些以后再返回事件队列，就会制造出响应迟钝的应用。

而在这种情况下，我们可以使用一个`setTimeout()`函数对那些无需即刻发生的事情进行异步操作，从而缩短程序响应的流程。

### 2.2 事件化模型

> 只要对象带有 PubSub 接口，就可以称之为事件化对象。特殊情况出 现在用于存储数据的对象因内容变化而发布事件时，这里用于存储数 据的对象又称作模型。模型就是 MVC（Model-View-Controller，模型 视图控制器）中的那个 M。MVC三层架构设计模式在近几年里已 经成为 JavaScript编程中热点的主题之一。MVC的核心理念是应用 程序应该以数据为中心，所以模型发生的事件会影响到 DOM（即 MVC中的视图）和服务器（通过 MVC中的控制器而产生影响）。 

MVC 这种关注层面的分离会带来更优雅，更直观的代码。

#### 2.2.1 模型事件的传播

MVC 三层架构最大的好处在于出现在 change 事件冒泡，上溯数据树的时候。不用再去订阅数据树每片叶子上发生的事件，而只需订阅数据树根和枝处发生的事件即可。

#### 2.2.2 事件循环与嵌套式变化

> 从一个对象向另一个对象传播事件的过程提出了一些需要关注的问 题。如果每次有个对象上的事件引发了一系列事件并终对这个对象 本身触发了相同的事件，则结果就是事件循环。如果这种事件循环还 是同步的，那就造成了堆栈上溢
>
> 然而在很多时候，变化事件的循环恰恰是我们想要的。最常见的情况就是双向绑定——两个模型的取值会彼此关联。

在遇到这种双向绑定的需求的时候，有两道保险是必须要加上的：

- 当新值等于旧值时，set 方法不会导致触发 change 事件
- 模型正处于自身的 change 事件期间时，不会再触发 change 事件。

也有一些框架利用了另外一种形式，即一个值发生变化时，另一个值会通过延时事件作异步更新。于是，在触发这个异步更新事件之前，应用程序的数据将一直处于不一致的状态。

### 2.3 jQuery 自定义事件

> jQuery自定义事件是PubSub模式的忤逆产物，因为这里由可选择的 DOM 元素而不是脚本中的对象来触发事件。事件化模型更像是一种 直观表达状态相关事件的方式，而 jQuery 的自定义事件允许直接通过 DOM来表达 DOM相关的事件，不必再把 DOM变化的状态复制 到应用程序的其他地方。请大方地取用这些特性，但要尽量避免依赖应用程序的标记语言结构——你肯定不希望下次修改设计的时候破坏自己的脚本。

本小节略

