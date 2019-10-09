---
name: 《JavaScript设计模式与开发实践》学习笔记（九）
title: 《JavaScript设计模式与开发实践》学习笔记（九）
tags: ["技术","学习笔记","JavaScript设计模式与开发实践"]
categories: 学习笔记
info: "第二部分、第 13 章 职责链模式、第 14 章 中介者模式"
time: 2019/9/29
desc: 'JavaScript设计模式与开发实践, 资料下载, 学习笔记'
keywords: ['JavaScript设计模式与开发实践资料下载', '前端', '学习笔记']
---

# 《JavaScript设计模式与开发实践》学习笔记（九）

## 第 13 章 职责链模式

> 在 JavaScript开发中，职责链模式是最容易被忽视的模式之一。实际上只要运用得当，职责链模式可以很好地帮助我们管理代码，降低发起请求的对象和处理请求的对象之间的耦合性。职责链中的节点数量和顺序是可以自由变化的，我们可以在运行时决定链中包含哪些节点。 

职责链模式的定义是：使多个对象都有机会处理请求，从而避免请求的发送者和接收者之间的耦合关系，将这些对象连成一条链，并沿着这条链传递请求，直到有一个对象处理为止。

![dutyChain.jpg](./images/dutyChain.jpg)

职责链模式的最大优点是：请求发送者只需要直到链中的第一个节点，从而弱化了发送者和一组接收者之间的强联系。

### 13.1 实现职责链

首先来定义一个 Chian 类：

```javascript
class Chain {
    constructor (fn) {
        this.fn = fn
        this.successor = null
    }
    setNextSuccessor (successor) {
        return this.successor = successor
    }
    passRequest () {
        let ret = this.fn.apply(this, arguments)
        if (ret === 'nextSuccessor') {
            return this.successor && this.successor.passRequest.apply(this.successor, arguments)
        }
        return ret
    }
}
```

上面我们得到了一个职责链的节点类，每一个节点在生成时都应该传入一个实现方法，留待请求传入时调用，若该请求不由自己处理，则可以返回一个标志（上面的标志是字符串 ’nextSuccessor‘），接到标志后链将会自动调用下一个节点的方法，直到调用到对应的正确方法或者职责链完结为止。

下面是一个使用示例：

```javascript
var doSomething1 = function (type) {
    if (type === 1) {
        console.log('doSomething1')
    } else {
        return 'nextSuccessor'
    }
}

var doSomething2 = function (type) {
    if (type === 2) {
        console.log('doSomething2')
    } else {
        return 'nextSuccessor'
    }
}

var doSomething3 = function (type) {
    if (type === 3) {
        console.log('doSomething3')
    } else {
        return 'nextSuccessor'
    }
}

// 生成节点
var chainDoSomething1 = new Chain(doSomething1)
var chainDoSomething2 = new Chain(doSomething2)
var chainDoSomething3 = new Chain(doSomething3)

// 节点之间连接
chainDoSomething1.setNextSuccessor(chainDoSomething2)
chainDoSomething2.setNextSuccessor(chainDoSomething3)

// 传递请求
chainDoSomething1.passRequest(1)
chainDoSomething1.passRequest(2)
chainDoSomething1.passRequest(3)
```

### 13.2 异步的职责链

> 在上一节的职责链模式中，我们让每个节点函数同步返回一个特定的值"nextSuccessor"，来表示 是否把请求传递给下一个节点。而在现实开发中，我们经常会遇到一些异步的问题，比如我们要在 节点函数中发起一个ajax异步请求，异步请求返回的结果才能决定是否继续在职责链中 passRequest。

我们可以为原型添加一个 next 方法，表示手动传递请求给下一个节点。

```javascript
Chain.prototype.next = function () {
  return this.successor && this.successor.passRequest.apply(this.successor, arguments)
}
```

如此不仅可以支持同步，也可以支持异步请求传递：

```javascript
var doSomething1 = function (type) {
    if (type === 1) {
        console.log('doSomething1')
    } else {
        return 'nextSuccessor'
    }
}

var doSomething2 = function (type) {
    console.log('doSomething2')
    // 异步传递
    setTimeout(() => {
        this.next(type)
    }, 1000)
}

var doSomething3 = function (type) {
    if (type === 3) {
        console.log('doSomething3')
    } else {
        return 'nextSuccessor'
    }
}

chainDoSomething1.setNextSuccessor(chainDoSomething2).setNextSuccessor(chainDoSomething3)
chainDoSomething1.passRequest(3)
```

### 13.6 职责链模式的优缺点

优点：

- 使用职责链模式，链中的节点对象可以灵活的拆分重组，增加删除任意节点都不需要改动其他节点中的代码
- 职责链模式可以手动指定起始节点，在特定场景中可以有效减少判断数量，这是用单纯的 if else 所办不到的

弊端：

- 如果节点全都是事务性节点，则当所有节点都不符合要求时，程序将会静默或者抛错，所以职责链一般需要一个固定的尾节点用于处理即将离开链尾的请求
- 过长的职责链将会带来不菲的性能损耗

### 13.7 用 AOP 实现职责类

在 JavaScript 中，我们可以利用语言的特性，通过一种更简便的方式来创建简单的职责链。

```javascript
Function.prototype.after = function (fn) {
    let self = this
    return function () {
        let ret = self.apply(this, arguments)
        if (ret === 'nextSuccessor') {
            return fn.apply(this, arguments)
        }
        return ret
    }
} 
```

## 第 14 章 中介者模式

中介者模式的作用是接触对象与对象之间的紧耦合关系，在增加了中介者对象后，所有的相关对象都通过中介者对象来通信，而不是相互引用。当一个对象发生变化时，不需要挨个通知引用它的所有对象，只需要通知中介者即可。

### 14.2 中介者模式的例子

> 手机购买页面，在购买流程中，可以选择手机的颜色及输入购买数量，同时页面有两个展示区域，分别向用户展示刚选择好的颜色和数量。还有一个按钮动态显示下一步的操作，我们需要查询该颜色手机对应的库存，如果库存数量少于这次购买的数量，按钮将被禁用并显示库存不足，反之按钮可以点击并显示放入购物车。

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>中介者模式 购买商品</title>
</head>
<body>
    选择颜色： 
    <select id="colorSelect">
        <option value="">请选择</option>
        <option value="red">红色</option>
        <option value="blue">蓝色</option>
    </select>

    选择内存： 
    <select id="memorySelect">
        <option value="">请选择</option>
        <option value="32G">32G</option>
        <option value="16G">16G</option>
    </select>

    输入购买数量：
    <input type="text" id="numberInput">

    您选择了颜色：<div id="colorInfo"></div><br>
    您选择了内存：<div id="memoryInfo"></div><br>
    您输入了数量：<div id="numberInfo"></div><br>

    <button id="nextBtn" disabled>请选择手机颜色、内存和购买数量</button>
</body>
<script>
    var goods = {
        'red|32G': 3,
        'red|16G': 0,
        'blue|32G': 1,
        'blue|16G': 6
    }

    //引入中介者
    var mediator = (function(){
        var colorSelect = document.getElementById('colorSelect'),
            memorySelect = document.getElementById('memorySelect'),
            numberInput = document.getElementById('numberInput'),
            colorInfo = document.getElementById('colorInfo'),
            memoryInfo = document.getElementById('memoryInfo'),
            numberInfo = document.getElementById('numberInfo'),
            nextBtn = document.getElementById('nextBtn');

        return {
            changed: function(obj){
                var color = colorSelect.value,
                    memory = memorySelect.value,
                    number = numberInput.value,
                    stock = goods[color + '|' + memory];

                if(obj == colorSelect){      //如果改变的是选择颜色下拉框
                    colorInfo.innerHTML = color;
                }else if(obj == memorySelect){
                    memoryInfo.innerHTML = memory;
                }else if(obj == numberInput){
                    numberInfo.innerHTML = number;
                }

                if(!color){
                    nextBtn.disabled = true;
                    nextBtn.innerHTML = '请选择手机颜色';
                    return;
                }

                if(!memory){
                    nextBtn.disabled = true;
                    nextBtn.innerHTML = '请选择手机内存';
                    return;
                }

                if(!number){
                    nextBtn.disabled = true;
                    nextBtn.innerHTML = '请填写手机数量';
                    return;
                }

                if( ( (number-0) | 0 ) !== number-0 ){      //用户输入的购买数量是否为正整数
                    nextBtn.disabled = true;
                    nextBtn.innerHTML = '请输入正确的购买数量';
                    return;
                }

                if(number > stock){     //当前选择数量大于库存量
                    nextBtn.disabled = true;
                    nextBtn.innerHTML = '库存不足';
                    return;
                }

                nextBtn.disabled = false;
                nextBtn.innerHTML = '放入购物车';
            }
        }
    })()

    colorSelect.onchange = function(){
        mediator.changed(this)
    }

    memorySelect.onchange = function(){
        mediator.changed(this)
    }

    numberInput.oninput = function(){
        mediator.changed(this)
    }

    //以后如果想要再增加选项，如手机CPU之类的，只需在中介者对象里加上相应配置即可。
</script>
</html>
```

### 14.4 小结

中介者模式旨在让一个对象尽可能地少了解另外的对象，以避免在一个对象改变以后，影响过多的其它的对象。这种原则也被称为最少知识原则。

在中介者模式中，对象与对象只能通过中介者对象来互相影响对方。

但这种模式也有缺点，由于对象之间耦合的复杂性，中介者模式本身就是一个难以维护的对象。且对象之间本身有一些依赖关系是很正常的，对于一些简单的项目中，我们其实无需用到中介者模式来进行额外的解耦。



