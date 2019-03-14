---
name: 你不知道的JavaScript学习笔记（八）
title: 《你不知道的JavaScript》学习笔记（八）
tags: ['读书笔记', '你不知道的JavaScript']
categories: 学习笔记
info: "你不知道的JavaScript 第4章 生成器"
time: 2019/3/14
desc: '你不知道的JavaScript, 资料下载, 学习笔记, 第4章 生成器'
keywords: ['前端', '你不知道的JavaScript', '学习笔记', '第4章 生成器']
---

# 《你不知道的JavaScript》学习笔记（八）

## 第4章 生成器

本章介绍**ES6 generator**，生成器。

### 4.1 打破完整运行

```javascript
var x = 1
// 同样的写法还有 function* foo() 和 function*foo() 几种写法完全等义，都表示一个生成器函数
function *foo() { 
    x++
    yield // 哦，在这停顿！
    console.log('x:', x)
}
function bar() {
    x++
}
var it = foo() // 构造一个迭代器来控制这个生成器
it.next() // 在这里启动foo()
x // 2
bar()
x // 3
it.next() // x: 3
```

以上是一段完整的生成器示例代码。

上面的代码中，`foo()`函数启动了，但是没有完整运行，它在`yield`处暂停了。后面恢复了`foo()`并让它运行到技术，但这不是必需的。

因此，**生成器函数是一个特殊的函数，可以一次或多次启动和停止，但不一定非得要完成**。

#### 4.1.1 输入和输出

生成器函数虽然如此特殊，但它依旧拥有函数的所有特性和功能，也能够接收参数和返回值。

然而，与普通函数不同的是，**生成器函数必须要通过迭代器执行相应的next方法才能执行，并且会返回一个拥有两个属性的对象，分别是`value`用于表示返回结果，`done`用于表示迭代器状态**。

```javascript
function *foo(...args){
  return args[0] * args[1]
}
var it = foo(6, 7)
it
// foo {<suspended>}
// __proto__: Generator
// [[GeneratorLocation]]: VM258:1
// [[GeneratorStatus]]: "suspended"
// [[GeneratorFunction]]: ƒ *foo(...args)
// [[GeneratorReceiver]]: Window
// [[Scopes]]: Scopes[2]
it.next()
// {value: 42, done: true}
it
// foo {<closed>}
// __proto__: Generator
// [[GeneratorLocation]]: VM258:1
// [[GeneratorStatus]]: "closed"
// [[GeneratorFunction]]: ƒ *foo(...args)
// [[GeneratorReceiver]]: Window
```

`yield`和`next`这一对组合起来，在生成器的执行环境中构成了一个双向消息传递系统。

```javascript
function *foo(x) {
    var y = x * (yield 'Hello') // yield一个值
    return y
}
var it = foo(6)
var res = it.next() // 第一个next()，不传入任何东西
res.value // 'Hello'
res = it.next(7) // 向等待的yield传入7
res.value // 42
```

#### 4.1.2 多个迭代器

**每次构建一个迭代器，实际上是隐式构建了生成器的一个实例，通过这个迭代器来控制的不是生成器本身，而是它的对应实例**。

实际上，同一个生成器的不同实例之间的返回值不会受到相互的干扰，甚至可以任意组合起来使用。

```javascript
function *foo(x) {
    var y = x * (yield 'Hello') // yield一个值
    return y
}
var it1 = foo(6)
var it2 = foo(6)
var res1 = it1.next() // 'Hello'
var res2 = it2.next()
var res3 = it2.next(7) //42
res1.value + res3.value // 'Hello42'
res2 === res1 // false
```

生成器可以用于在多个函数之间交替运行，然而在实际的生产环境中，编写这种代码其实是会让人非常迷惑的。

### 4.2 生成器产生值

在了解生成器之前，要先了解的是迭代器。

#### 4.2.1 生产者与迭代器

迭代器是一个定义良好的接口，用于从一个生产者一步步得到一系列值(遍历)。JavaScript迭代器的接口，与众多语言类似，就是每次想要从生产者得到下一个值的时候调用next()。

```javascript
// 自定义一个迭代器接口
var something = (function () {
    var nextVal
    return {
        // for...of循环需要
        [Symbol.iterator]: function() {
            return this
        },
        // 标准迭代器的接口方法next
        // @params done{boolean} 标识迭代器完成状态
        // @params value{any} 放置迭代值
        next: function () {
            if (nextVal === undefined) {
                nextVal = 1
            } else {
                nextVal++
            }
            // 本例中该迭代器会固定返回done: false 所以若在使用时不加以边界条件，就会导致永远循环直至爆栈
            return {done: false, value: nextVal}
        }
    }
})()
something.next().value // 1
something.next().value // 9
// ...
for (var v of something) {
    console.log(v)
    // 禁止死循环
    if (v > 500) break
}
```

#### 4.2.2 iterable

**iterable**指一个包含在可以在其值上进行迭代的迭代器对象。

从ES6开始，从一个`iterable`中提取迭代器的方法是，该对象必须含有一个名称为`[Symbol.iterator]`的方法属性。要求调用该函数时，它能够返回一个迭代器。(像上面的例子中，`something`就返回了自己这个具有`next`实现方法的对象)。

`for...of`会请求一个迭代器，并自动使用这个迭代器的`next`方法遍历值。

#### 4.2.3 生成器迭代器



> 本次阅读至P247 生成器迭代器 267