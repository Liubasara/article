---
name: 你不知道的JavaScript学习笔记（三）
title: 《你不知道的JavaScript》学习笔记（三）
tags: ['读书笔记', '你不知道的JavaScript']
categories: 学习笔记
info: "你不知道的JavaScript 第1章 关于this 第2章 this全面解析"
time: 2019/3/1
desc: '你不知道的JavaScript, 资料下载, 学习笔记, 第1章 关于this, 第2章 this全面解析'
keywords: ['javascirpt高级程序设计资料下载', '前端', '你不知道的JavaScript', '学习笔记', '第1章 关于this', '第2章 this全面解析']
---

# 《你不知道的JavaScript》学习笔记（三）

**this和对象原型**

## 第1章 关于this

本章详细介绍`this`关键词的使用方法和原理。

### 1.1 为什么要用this

`this`指代的是当前上下文对象，如果不使用`this`，就需要在每个函数调用时传入一个上下文对象。

```javascript
var test = {a: 'hello'}
function foo (context) {console.log(context.a)}
foo(test) // hello

// 以上代码使用this会更简洁
var test = {a: 'hello', foo: function () {console.log(this.a)}}
test.foo() // hello

// or
var test = {a: 'hello'}
function foo () {console.log(this.a)}
foo.call(test)
```

简单来说，`this`提供了一种更优雅的方式来隐式传递一个对象引用，因此可以将API设计的更加简洁且易于复用。

### 1.2 误解

关于`this`的两个常见**误解**：

- `this`指向函数本身
- `this`指向函数作用域

**以上两种说法都是错误的**，`this`在任何情况下都不指向函数的词法作用域，更不指向函数自己本身，`this`所代表的是**执行上下文**，即执行的时候所在的环境对象。

### 1.3 this到底是什么

`this`实际上是在函数被调用时发生的绑定，它指向什么完全取决于函数在哪里被调用。（ES6的箭头函数除外，ES6箭头函数的`this`指向定义时所处的环境对象）

## 第2章 this全面解析

一般来说（本章以下的讨论除非特别声明否则都不讨论ES6箭头函数中的`this`），每个函数的`this`是在调用函数时绑定的，它的值完全取决于函数的调用位置。

### 2.1 调用位置

查找调用函数时当前JavaScript的调用栈，便可以知道当前的调用位置。

### 2.2 绑定规则

找到调用位置，然后根据下面四条规则选择应用，确定`this`的值。

#### 2.2.1 默认绑定

当函数直接调用，没有传入上下文时，如`foo()`，此时`this`会默认绑定到`window`对象。若是在严格模式下，全局对象将无法使用默认绑定，因此`this`会绑定到`undefined`。

#### 2.2.2 隐式绑定

当调用位置包含有上下文对象时，`this`会被绑定到这个上下文对象。

对象属性引用链中只有最后一层会影响调用位置，如下

```javascript
var obj1 = {a: 42, foo: function () {console.log(this.a)}}
var obj2 = {a: 2, obj1: obj1}
obj2.obj1.foo() // 42
```

- 隐式丢失：

  ```javascript
  var a = 'window'
  var obj1 = {a: 'obj1', foo: function () {console.log(this.a)}}
  var test = obj1.foo
  test() // window
  ```

#### 2.2.3 显式绑定

使用`call()`和`apply()`这两个实例方法可以解决`this`指针丢失的问题，强制为函数传入一个上下文绑定`this`。

同时，也可以使用`bind()`函数来返回一个对`this`值进行了硬绑定的函数。

**被进行了bind硬绑定的函数，它的`this`值无论如何都不会再随着上下文的更改而更改了**。

#### 2.2.4 new绑定

使用`new`来调用函数，或者说发生构造函数调用时，会经过以下4步：

- 创建一个新的对象

- 这个新对象会被执行[[原型]]连接

- 这个新对象会绑定到函数调用的`this`

- 如果函数没有返回其他对象，那么`new`表达式中的函数调用会自动返回这个新对象。

- ```javascript
  // 我所理解的 new 操作符
  function myNew (func) {
      var obj = {} // 创建一个新对象
      // 最好不要用__proto__指针，该属性至今未被官方承认而且据说性能不好
      // obj.__proto__ = func.prototype // 链接__proto__链
      Object.setPrototypeOf(obj, func.prototype) // 使用该函数可以达到与上面一样的效果
      var result = func.call(obj) // 将该实例作为执行上下文传入到构造函数的作用域中，执行该函数
      return result instanceof func ? result : obj // 若构造函数没有return一个构造函数的实例，则返回自己创建的实例
  }
  ```

### 2.3 优先级

以上四种的优先级，自高到低排序为：

- new绑定
- 显式绑定(`bind`函数做了兼容，当使用`new`操作符时，会放弃硬绑定转而调用`new`操作符来生成实例)
- 隐式绑定
- 默认绑定

以上情况虽然适用于大多数的开发情况，但是，凡事总有例外。

### 2.4 绑定例外

#### 2.4.1 被忽略的this

当把`null`或者`undefined`作为`this`的参数传入显式绑定函数时，这些调用会被忽略，转而应用默认绑定规则。

```javascript
var wow = 'wow'
function hi () {console.log(this.wow)}
hi.call(null) // wow
```

但要注意的是，这种方法虽然能够成功调用函数，但也有可能会产生一些难以追踪和分析的副作用（把`this`值绑定为了`window`，有可能会修改全局对象。）

- 更安全的`this`

  使用`Object.create(null)`可以创建出一种原子对象，相比于传入`null`让函数显式绑定全局对象，这是一种性能更高(没有`__proto__`链)，更安全，且更能表达出让`this`值置空意愿的对象。

  > [详解Object.create(null)](https://juejin.im/post/5acd8ced6fb9a028d444ee4e)

  ```javascript
  var noop = Object.create(null)
  function foo (woo) {console.log(this);console.log(woo);}
  foo.call(noop, [1, 2, 3])
  // {} No properties
  // (3) [1, 2, 3]
  ```

#### 2.4.2 间接引用

```javascript
function foo() {console.log( this.a ); }
var a = 2;  var o = { a: 3, foo: foo };  var p = { a: 4 }; 
o.foo(); // 3
(p.foo = o.foo)(); // 2
```

由于`p.foo = o.foo`这条语句返回的值是对目标函数的引用，因此这里的调用位置是`foo()`而不是`p.foo`或`o.foo`，所以这里会应用到默认绑定。

#### 2.4.3 软绑定

通过使用各种条件判断，可以实现一种软绑定，即在调用上下文是`undefined`或`window`时实行硬绑定，上下文是其他时允许`this`指针进行更改。

### 2.5 this词法



> 本次应阅读至P99 2.5 this词法 P114