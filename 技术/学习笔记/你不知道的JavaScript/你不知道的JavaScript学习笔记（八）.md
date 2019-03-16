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

上面的代码中，`foo()`函数启动了，但是没有完整运行，它在`yield`处暂停了。后面恢复了`foo()`并让它运行到最后，但这不是必需的。

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
        next: function () {
            if (nextVal === undefined) {
                nextVal = 1
            } else {
                nextVal++
            }
            // 本例中该迭代器会固定返回done: false 所以若在使用时不加以边界条件，就会导致永远循环直至爆栈
            // done{boolean} 标识迭代器完成状态
            // value{any} 放置迭代值
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
something.next()
// {done: false, value: 502}
```

#### 4.2.2 iterable

**iterable**指一个包含在可以在其值上进行迭代的迭代器对象。

从ES6开始，从一个`iterable`中提取迭代器的方法是，该对象必须含有一个名称为`[Symbol.iterator]`的方法属性。要求调用该函数时，它能够返回一个迭代器。(像上面的例子中，`something`就返回了自己这个具有`next`实现方法的对象)。

`for...of`会请求一个迭代器，并自动使用这个迭代器的`next`方法遍历值。

#### 4.2.3 生成器迭代器

在了解了迭代器以后，让我们把注意力转回生成器上，可以把生成器看作一个值得生产者，我们通过调用迭代器的`next()`调用一次提取出一个值。

**生成器本身并不是iterable——当你执行一个生成器，就得到了一个迭代器**。

```javascript
// 实现一个函数可以用于生成上面的something迭代器
function *something() {
    var nextVal
    while (true) {
        if (nextVal === undefined) {
            nextVal = 1
        } else {
            nextVal++
        }
        yield nextVal
    }
}
var it = something()
for (let i of it) {
  console.log(i)
  if (i > 50) break
}
it
// something {<closed>}
// __proto__: Generator
// [[GeneratorLocation]]: VM695:2
// [[GeneratorStatus]]: "closed"
// [[GeneratorFunction]]: ƒ *something()
// [[GeneratorReceiver]]: Window
it.next()
// {value: undefined, done: true}
```

**停止生成器**

在上面的例子中，我们能明显发现，**由生成器生成的迭代器与我们自己定义的迭代器有所不同，我们自己定义的迭代器会在循环结束后处于挂起状态，而生成器生成的迭代器却会直接处于关闭状态**。

这是因为当你调用`for...of`来遍历一个**由生成器生成的迭代器时**，当块级代码中出现`break`、`return`或者未捕获的异常，JavaScript就会自动向生成器的迭代器发送一个信号使其终止。该操作也同样会发生在`for...of`循环正常结束以后。

当然，你也可以通过使用`it.return()`函数来在外部手工终止生成器的迭代器实例：

```javascript
function *something() {
    try {
        var nextVal
        while (true) {
            if (nextVal === undefined) {
                nextVal = 1
            } else {
                nextVal++
            }
            yield nextVal
        }
    }
    finally {
        console.log('cleaning up !')
    }
}
var it = something()
for (var v of it) {
    console.log(v)
    if (v > 50) {
        console.log(
          // 完成迭代器
          it.return('Hello World').value
        )
    }
}
// 1....50
// cleaning up!
// Hello World
```

通过手动调用`it.return()`可以决定最后一个迭代器的value值，同时将done属性设为`true`，通过这样不需要`break`也可以结束`for...of`循环。

### 4.3 异步迭代生成器

使用生成器可以使得我们看似阻塞同步的代码，实际上并不会阻塞整个程序，它只是暂停或者阻塞了生成器本身的代码。

生成器`yield`暂停的特性意味着我们不仅能够从异步函数调用得到看似同步的返回值，还可以同步捕获来自这些异步函数调用的错误。

```javascript
function *main () {
    var x = yield 'Hello World'
    yield x.toLowerCase()
}
var it = main()
it.next().value // Hello World
try {
    it.next(42)
} catch (err) {
    console.error(err) // TypeError
}
```

同样的，也可以使用`it.throw()`来向暂停中的迭代器内部传入一个错误，让函数处理。

### 4.4 生成器 + Promise

使用生成器 + Promise，可以实现**看似同步的异步代码 + 可信任可组合**的异步结合。

在一堆非常牛逼的介绍之后，发现其实就是原生实现了ES7的`async + await`。

### 4.5 生成器委托

使用`yield *foo()`可以实现暂停迭代控制，而不是生成器控制。

简单来说，使用`yield *foo()`可以实现在当前迭代器中进入另一个迭代器的效果。

```javascript
function *foo() {
  var r1 = yield 123
  var r3 = yield 234
  return r3
}
function *bar() {
  var r1 = yield 456
  // 进入foo迭代器进行迭代
  var r3 = yield *foo()
  console.log(r3)
  return r3
}
var it = bar()
for (let i of bar()) {
  console.log(i)
}
// 456
// 123
// 234
```

实际上，yield委托并不要求必须转到另一个生成器，它可以转到一个非生成器的一般`iterable`。如`yield *[]`这种。

所以，`yield`委托可以跟踪任意多委托步骤，只要把它们连在一起，你甚至可以使用`yield`委托实现异步的生成器递归，即一个`yield`委托到它自身的生成器。

### 4.6 生成器并发

// TOREAD

概念过于深奥，没看懂...

### 4.7 形实转换程序

形实转换程序是指一个用于调用另外一个函数的函数，没有任何参数。

换句话说，用一个函数定义封装函数调用，包括需要的任何参数，来定义这个调用的执行，那么这个封装函数就是一个形实转换程序。

```javascript
// example
function foo (x, y) {
    return x + y
}
function fooTunk () {
    // 形实转换程序
    return foo(3, 4)
}
fooTunk() // 7
```

而异步thunk也同理，可以让thunk接收一个回调函数，对其余参数进行调用。

```javascript
// example
function foo (x, y) {
    return x + y
}
function thunkify(fn) {
    let args = [].slice.call(arguments, 1)
    return function(cb) {
        args.push(cb)
        return fn.apply(null, args)
    }
}
var fooThunk = thunkify(foo, 3, 4)
fooThunk(function(sum){
    console.log(sum)
})
```

这种将回调函数放在参数最末尾的方式是一种普遍成立的标准，称为`callback-last`风格。

### 4.8 ES6之前的生成器

本节介绍`yield`生成器的原理。