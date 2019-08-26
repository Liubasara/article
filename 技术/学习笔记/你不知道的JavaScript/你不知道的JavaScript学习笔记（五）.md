---
name: 你不知道的JavaScript学习笔记（五）
title: 《你不知道的JavaScript》学习笔记（五）
tags: ["技术","学习笔记","你不知道的JavaScript"]
categories: 学习笔记
info: "你不知道的JavaScript 第6章 行为委托 《你不知道的JavaScript》中卷 第1章 类型 第2章 值 第3章 原生函数"
time: 2019/3/4
desc: '你不知道的JavaScript, 资料下载, 学习笔记, 第6章 行为委托, 《你不知道的JavaScript》中卷, 第1章 类型, 第2章 值, 第3章 原生函数'
keywords: ['前端', '你不知道的JavaScript', '学习笔记', '第6章 行为委托', '《你不知道的JavaScript》中卷', '第1章 类型', '第2章 值', '第3章 原生函数']
---

# 《你不知道的JavaScript》学习笔记（五）

## 第6章 行为委托

本章继续深入了解原型链。

顺便再diss一下那帮用类来理解JavaScript的程序员。

### 6.1 面向委托的设计

和父类、子类、继承、多态等概念完全不同，JavaScript中的对象不是按照父类到子类的关系垂直组织的，而是通过任意方向的委托关联并排组织的。

### 6.2 类与对象

使用对象关联风格来编写代码比用类更加牛逼和简洁。

### 6.3 更简洁的设计

同上节

### 6.4 更好的语法

ES6中的`class`语法实际上只是`prototype`的语法糖。

```javascript
class A {}
class B extends A{
    constructor(data) {
        super(data)
    }
}
// 上面这段继承代码干的事情如下
Object.setPrototypeOf(B, A)
Object.setPrototypeOf(B.prototype, A.prototype)
// 没了，就这么简单。实际上这俩货也是函数，只不过引擎规定了这两个函数只能用new调用而已
```

此外，在ES6中，你可以使用对象的字面形式来改写之前繁琐的复赋值语法。

```javascript
var Foo = {
    bar(){},
    baz: function baz(){}
}
// 上面这段代码去掉语法糖后变成
var Foo = {
    bar: function() {},
    baz: function baz() {}
}
```

可以看到，想`Foo.bar`这种赋值方式会有一个缺点，即生成的是一个匿名函数，没有`name`标识符，这会导致自我引用更难，毕竟在严格模式下是不支持使用`arguments.callee`指针调用自身的。

### 6.5 内省

内省（自省）就是检查实例的类型。在JavaScript中，可以使用`instanceof`或者`Object.prototype.isPrototypeOf.call()`来进行自省判断。

```javascript
function Super () {}
function Sub () {}
Sub.prototype = Object.create(Super.prototype, {
    constructor: {
        configurable: true,
        enumerable: false,
        writable: true,
        value: Sub
    }
})
// or
Object.setPrototypeOf(Sub.prototype, Super.prototype)

var test = new Sub()
test instanceof Sub // true
test instanceof Super // true
Object.prototype.isPrototypeOf.call(Super.prototype, test) // true
Object.prototype.isPrototypeOf.call(Sub.prototype, test) // true
```

**《你不知道的JavaScript》中卷**

**第一部分：类型和语法**

## 第1章 类型

JavaScript有7种内置类型：

- null
- undefined
- boolean
- number
- string
- object
- symbol（ES6新增，符号）

使用`typeof`操作符检测JavaScript中的任一合法对象，有可能会返回7种不同的结果：

- undefined
- boolean
- number
- string
- object
- symbol
- function

值得注意的是，由于某个著名的底层BUG，所以在JavaScript中实施`typeof null`时会出现返回`object`的奇葩景象。而在对函数使用`typeof`时，则会返回`function`，但`function`其实是`object`的一个内置类型。

## 第2章 值

本章介绍JavaScript中的几个内置值类型。

- 使用`Array.prototype.slice.call()`和`Array.from()`可以实现将一些类数组转化为数组的目的。

- 对于一些数组有而字符串没有的方法，有些我们可以借助`call`函数来调用(**join, map等不会改变原来数组的方法**)，有的则不可以(**reverse、splice等会改变原来数组的方法**)，归根结底，是因为字符串在JavaScript中是只可替换而不可改变的。

- `42.toFixed(3)`是无效的，但`(42).toFixed`或`42..toFixed`是有效的，因为JavaScript需要先把数字转换为一个有效的数字字符才能调用其方法，而`42.toFixed(3)`中的`.`会被视为数字的一部分，所以代码会报错。

- 使用`void`运算符可以返回一个`undefined`

  ```javascript
  console.log(void 0, 12) // undefined 12
  ```

- NaN是个特殊的值，本质上它是个数字，却不与任何值相等(NaN !== NaN)，用于表示计算错误的情况(如1除以字符串这种，结果为NaN)，只能使用`Number.isNaN()`来确定它是否为NaN。

- Infinity用于处理无穷数和不应该出现的值，比如1除以0这种情况，结果为Infinity。

#### 2.4.4 特殊等式

使用ES6中新加入的`Object.is()`方法可以完美实现所有的判断。

### 2.5 值和引用

- JavaScript中，除了基本数据类型以外，其余的都是引用值。本质来说，就是**指针**。
- 此外，对于基本类型的对象来说(比如Number、String)等，虽然它们看起来是个引用值，但在使用它们的时候，它们经常会神不知鬼不觉的转化成基本数据类型，从而失去引用关系。所以不到万不得已，请不要使用这些函数来`new`一个基本类型对象。

## 第3章 原生函数

常用的原生函数：

- String()
- Number()
- Boolean()
- Array()
- Object()
- Function()
- RegExp()
- Date()
- Error()
- Symbol()

### 3.1 内部属性[[class]]

[[class]]属性无法直接访问，一般通过`Object.prototype.toString()`来查看。

### 3.2 封装对象

```javascript
var a = 123
var b = Number(123)
typeof a // number
typeof b // object
a instanceof Number // true
b instanceof Number // true
Object.prototype.toString.call(a) // [object Number]
Object.prototype.toString.call(b) // [object Number]
```

### 3.3 拆封

使用`valueOf()`可以获取封装对象中的值。

### 3.4 原生函数作为构造函数

应该尽量避免使用原生函数作为构造函数，因为大多数时候，这和直接调用它们所返回的结果是一样的。

#### 3.4.4 Symbol

ES6新增的基本数据类型。

ES6中有一些预定义的符号，以Symbol的静态属性形式出现，如Symbol.create、Symbol.iterator等。

```javascript
// 可以这样使用
obj[Symbol.iterator] = function () {}
```

#### 3.4.5 原生原型

原生构造函数都有自己的`prototype`原型对象，其上也有一些内置的方法。