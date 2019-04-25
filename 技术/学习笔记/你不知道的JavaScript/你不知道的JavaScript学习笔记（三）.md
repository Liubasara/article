---
name: 你不知道的JavaScript学习笔记（三）
title: 《你不知道的JavaScript》学习笔记（三）
tags: ['读书笔记', '你不知道的JavaScript']
categories: 学习笔记
info: "你不知道的JavaScript 第1章 关于this 第2章 this全面解析 第3章 对象"
time: 2019/3/1
desc: '你不知道的JavaScript, 资料下载, 学习笔记, 第1章 关于this, 第2章 this全面解析, 第3章 对象'
keywords: ['javascirpt高级程序设计资料下载', '前端', '你不知道的JavaScript', '学习笔记', '第1章 关于this', '第2章 this全面解析', '第3章 对象']
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

  ```javascript
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

**2019/4/25 更新 new 操作符的实现方法**

来看下面这个例子

```javascript
function Person(name) { 
  this.name = name 
  return 1; 
} 
var p1 = new Person('Tom') 
// {name: 'Tom'}
p1 instanceof Person // true


function Person2(name) { 
  this.name = name 
  return {a:1}; 
} 
var p2 = new Person2('Tom')
// {a: 1}
p2 instanceof Person2 // false
```

由以上这个例子我们可以看出，new 操作符在发生构造函数调用时，不会去判断函数返回的是否是构造函数的实例，而只会判断返回的是否为对象，若为对象，则返回这个对象。所以上面的*我所理解的 new 操作符*应该改为下面这样。

```javascript
// 我所理解的 new 操作符(update)
function myNew (func) {
    var obj = {} // 创建一个新对象
    // 最好不要用__proto__指针，该属性至今未被官方承认而且据说性能不好
    // obj.__proto__ = func.prototype // 链接__proto__链
    Object.setPrototypeOf(obj, func.prototype) // 使用该函数可以达到与上面一样的效果
    var result = func.call(obj) // 将该实例作为执行上下文传入到构造函数的作用域中，执行该函数
    return result instanceof Object ? result : obj // 若构造函数没有return一个对象，则返回自己创建的实例
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

ES6新增了箭头函数，其`this`词法并不适用于上述的所有规则。箭头函数在定义时即绑定了`this`，其后无论通过什么调用，`this`的值都不能被更改（`new`也不行）

```javascript
function foo () {
    // 返回一个箭头函数
    return (a) => {
        // this值取决于foo()被调用时的上下文
        console.log(this.a)
    }
}
var obj1 = {a: 1}
var obj2 = {a: 2}
var bar = foo.call(obj1) // 传入this值
bar.call(obj2) // 结果为1 不为2
```

## 第3章 对象

大多数程序员都可以创建对象，可是并没有对象（小声逼逼...）

### 3.1 语法

两种定义对象的方式：

- 声明（文字）形式

  ```javascript
  var myObj = {key: ''}
  ```

- 构造形式

  ```javascript
  var myObj = new Object()
  myObj.key = ''
  ```

### 3.2 类型

在JavaScript中一共有6种主要类型（ES6中新添加了Symbol变成了7种）：

- object
- number
- string
- boolean
- null
- undefined
- Symbol

其中，简单基本类型(String、boolean、number、null和undefined)本身并不是对象。`null`因为某个著名的底层BUG导致会被JavaScript认为是对象，但实际上它也是基本类型。

**内置对象**

JavaScript中还有一些对象子类型，通常被称为内置对象，常见的有下列几种

- String
- Number
- Boolean
- Object
- Function
- Array
- Date
- RegExp
- Error

在JavaScript中，它们实际上只是一些内置函数，可以当做构造函数来使用。

### 3.3 内容

访问对象中的内容，从底层的角度来说其实是访问该指针所指向的内存区域中的一个属性。引用类型的值一般来讲都是一个特殊的指针，这也是将它们跟基础类型区分开来的一个重大特点。

#### 3.3.4 复制对象

使用`JSON.parse(JSON.stringfy(someobj))`可以用于深拷贝多数的对象，但是这种方法只适用于对象中没有方法、`undefined`或者循环引用的情况。

对于只有一层属性的对象，使用`Object.assign({}, someObj)`可以解决`undefined`和`function`的情况。但对于进行了多层嵌套的属性(这很常见)，或是进行了循环嵌套的对象，**`assign`函数便只能处理第一层的数据而并没有递归进行深拷贝**。所以对于这种情况，我们只能自己手动实现一个深拷贝函数或者使用第三方类库(Lodash)了。

```javascript
// 自己手写一个深拷贝
// 自定义方法用于判断Object和Array
function isObject (obj) {
  return typeof obj === 'object' && obj !== null
}

function myDeepClone (source, hash = new WeakMap()) {
  if (!isObject(source)) return source // 非Object和Array直接返回它的值
  if (hash.has(source)) return hash.get(source) // 若hash表中有该对象，则直接返回该对象的值(解决循环引用)
  
  let target = Array.isArray(source) ? [] : {}
  hash.set(source, target)
  
  for (let key in source) {
    if (Object.prototype.hasOwnProperty.call(source, key)) {
      if (isObject(source[key])) {
        target[key] = myDeepClone(source[key], hash) // 递归调用，传入hash表
      } else {
        target[key] = source[key]
      }
    }
  }
  return target
}
```

#### 3.3.9 Getter和Setter

当你使用`Object.defineProperty`给一个对象定义`getter`、`setter`或者两者都有时，这个属性会被定义为“访问描述符”，对于访问描述符，JavaScript会忽略掉它们的`value`和`writable`特性。

#### 3.3.10 存在性

对于一些在对象中定义为`undefined`的属性，它们在对象中的表现与那些不存在的属性表现无异。要确定对象中是否存在这个属性，可以使用`Object.prototype.hasOwnProperty.call(obj, keyName)`来确定。

该方法会确定在对象实例中是否存在该名称的属性。

当然也可以通过`if (keyName in Obj) {}`的方式来确定，但是`in`操作符会遍历`__proto__`链上的所有属性，所以需要慎重根据场景选用。

**可枚举** ：当将一个属性的`enumerable`设为`false`时，该属性将被设为不可枚举，此时用`for(key in obj)`或者`obj.keys()`就无法遍历到该属性了。但是使用`if (key in obj) {}`依然可以检测到该属性。

### 3.4 遍历

几种方法：

- 常规for下标遍历
- forEach()、every()、some()、for...of、for...in、map、filter

此外，还可以在对象中自定义`[Symbol.itertor]`方法来自定义for...of时的行为。

```javascript
// 用for...of遍历该对象会产生无限个随机数，并且永不停止
var randoms = {
    [Symbol.iterator]: function () {
        return {
            next: function () {
                return {value: Math.random()}
            }
        }
    }
}
var randoms_pool = []
for (var n of randoms) {
    randoms_pool.push(n)
    if (randoms_pool.length === 100) break // 防止无限运行卡死
}
```

