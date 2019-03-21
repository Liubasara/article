---
name: 你不知道的JavaScript学习笔记（十一）
title: 《你不知道的JavaScript》学习笔记（十一）
tags: ['读书笔记', '你不知道的JavaScript']
categories: 学习笔记
info: "你不知道的JavaScript 下卷 第二部分 第1章 现在与未来 第2章 语法"
time: 2019/3/19
desc: '你不知道的JavaScript, 资料下载, 学习笔记, 下卷, 第二部分, 第1章 现在与未来, 第2章 语法'
keywords: ['前端', '你不知道的JavaScript', '学习笔记', '下卷', '第二部分', '第1章 现在与未来', '第2章 语法']

---

# 《你不知道的JavaScript》学习笔记（十一）

## 第1章 ES？现在与未来

对 ECMAScript 这门语言来说( JavaScript 是 ECMAScript 、 DOM 、 BOM 三部分的总称。)，ES6并不仅仅是为这个语言新增了一组API。它是一次激进的飞跃，让 ECMAScript 出现了更多的可能性和新的语法形式。

## 第2章 语法

本章介绍 ES6 的新语法。

### 2.1 块作用域声明

在以往，我们通常需要使用一个立即执行的匿名函数来创建一个块级作用域(IIFE)，但是ES6出现了以后，我们有了更多的选择。

#### 2.1.1 let 声明

使用`let`声明可以将任意的变量绑定到一个块级作用域，而创建块级作用域的创建仅仅只需要一个大括号`{}`，也就是说，任何`if`条件判断和`for`循环中生成的变量，都是该块级作用域的私有变量。

```javascript
var funcs = []
for (let i = 0; i < 5; i++) {
    funcs.push(function () {
        console.log(i)
    })
}
funcs[3]()
```

上述代码中，`for`循环头部的`let i`不止为 for 循环本身声明了一个 i ，**而是为循环的每一次迭代都重新声明了一个新的 i 。这意味着 loop 迭代内部创建的闭包封闭的是每次迭代中的变量，更加符合预期**。

let 放在`for..in`和`for..of`循环中也是一样的。

#### 2.1.2 const 声明

`const`用于创建常量，即设定了初始值以后就只读的变量。

除了不可变外，它的表现形式基本与`let`相同。

#### 2.1.3 块作用域函数

> ES6 引入了块级作用域，明确允许在块级作用域之中声明函数。ES6 规定，块级作用域之中，函数声明语句的行为类似于let，在块级作用域之外不可引用。若改变了块级作用域内声明的函数的处理规则，显然会对老代码产生很大影响。为了减轻因此产生的不兼容问题，ES6规定，浏览器的实现可以不遵守上面的规定，允许有自己的行为方式。

### 2.2 spread/rest

ES6引入了一个新的运算符`...`，称为`spread`或`rest`（展开或收集）运算符。有以下几种用法和使用场景：

- `...`用于数组之前时(实际上是任何`iterable`)，它会把这个变量"展开为"各个独立的值

- 也可以用于在其他上下文中用来展开/扩展一个值，代替`concat()`。如下

  ```javascript
  var a = [2, 3, 4]
  var b = [1, ...a, 5]
  b // [1,2,3,4,5]
  ```

- 用在函数参数处，将一系列值收集到一起成为一个数组。使用这种方式可以更好的代替`arguments`数组。

### 2.3 默认参数值

ES6 中可以在函数中使用默认参数值，如

```javascript
function foo (x = 11, y = 31) {
    console.log(x + y)
}
foo() // 42
```

上述中的`x = 11`更像是`x !== undefined ? x : 11`而不是常见技巧`x || 11`，所以在转换默认参数值语法时要格外小心。

**默认值表达式**

默认参数表达式可以是任何值，同时也遵循作用域嵌套的规律，如下。

```javascript
var x = 1; var y = 2;
function foo (w = x + 1, v = w + 1) {
    console.log(w, v)
}
foo() // 2 3
```

### 2.4 解构

可以把数组或者对象中带索引的值手动赋值看作结构化赋值，ES6为解构新增了一个专门语法，用于数组解构和对象解构。如下

```javascript
function foo () {return [1, 2, 3]}
function bar () {return {x: 4, y: 5, z: 6}}
var [a, b, c] = foo()
var {x: x, y: y, z: z} = bar()
```

#### 2.4.1 对象属性赋值模式

可以使用`{x, y, z} = bar()`这种方式来代替上述的对象属性赋值，该缩写语法省略了`{x: x}`中的`x:`部分。

这种解构方式的形式是`source-target`，与平常赋值对象时的定义相反，也就是说，`{x: x}`中的`x:`部分代表的是函数返回的目标变量，是**不可自定义的**，而后半部分则可以。

也就是说，上面的变量解构可以写成这样：

```javascript
var {x: hix, y: hiy, z: hiz} = bar()
console.log(hix, hiy, hiz)
```

这样就可以达到自定义返回属性名称变量的目的了。

#### 2.4.2 不只是声明

对于对象解构形式来说，**如果省略了`var/let/const`声明符，就必须把整个赋值表达式用()括起来，因为如果不这样做，语句左侧的{..}作为语句中的第一个元素会被当场是一个块语句而不是一个对象**。

实际上，赋值表达式并不必须是变量标识符，任何合法的赋值表达式都可以。

#### 2.4.3 重复赋值

对象解构形式允许多次列出同一个源属性。这也意味着可以解构子对象/ 数组属性，同时捕获子对象/类的值本身，如下：

```javascript
var {a: X, a: Y} = { a:1 }
X // 1
Y // 1

var {a: {x: X, x: Y}, a} = {a: {x: 1}}
X // 1
Y // 1
a // { x:1 }
```

**解构赋值表达式**

对象或者数组解构的复制表达式的完成值是所有右侧对象/数组的值。可以依此来构建赋值表达式组成链：

```javascript
var o = {a:1, b:2, c:3}
var p = [4, 5, 6]
var a, b, c, x, y, z
({a} = {b,c} = c)
[x,y] = [z] = p
console.log(a,b,c) // 1 2 3
console.log(x,y,z) // 4 5 4
```

### 2.5 太多，太少，刚刚好

你可以通过下面这样的方法，来抛弃掉一些不需要的返回值

```javascript
var [,b] = foo()
var {x, z} = bar()
console.log(b,x,z) // 2 4 6
```

同时，也可以使用解构符来执行集合的动作。

```javascript
var a = [2, 3, 4]
var [b, ...c] = a
console.log(b, c) // 2 [3, 4]

var a = {c: 1, d:2, p:3}
var {c, ...e} = a
console.log(c, e) // 1 {d: 2, p: 3}
```

#### 2.5.1 默认值赋值

使用与前面默认参数值类似的`=`语法，解构的两种形式都可以提供一个用来赋值的默认值。

```javascript
function foo () {return [1, 2, 3]}
function bar () {return {x: 4, y: 5, z: 6}}
var {a = 3, b = 6, c = 9, d = 12, ...dd} = foo()
console.log(a, b, c, d, dd) // 3 6 9 12 {0: 1, 1: 2, 2: 3}
var { x, y, z, w: WW = 20 } = bar()
console.log(x, y, z, WW) // 4 5 6 20
```

#### 2.5.2 嵌套解构

如果解构的值中有嵌套的对象或者数组，也可以解构这些嵌套的值。

```javascript
var a1 = [1, 2, [3, 4], 5]
var o1 = {x: {y: {z: 6}}}
var [a, b, [c, d], e] = a1
var {x: {y: {z: w}}} = o1
console.log(a, b, c, d, e, w) // 1 2 3 4 5 6
```

#### 2.5.3 解构参数

灵活使用解构参数、默认参数、扩展收缩符号可以灵活的实现在函数中命名参数的功能，这是 JavaScript 在ES6之前一直渴望拥有的功能。

```javascript
function custom ( { a = 1, b = 2, c = 3, ...args } = {} ) {
    console.log(a, b, c, args)
}
custom({a: 'a', b: 'b', aa: 'aa', bb: 'bb', cc: 'cc'}) // a b 3 {aa: "aa", bb: "bb", cc: "cc"}
```

### 2.6 对象字面量扩展

#### 2.6.1 简洁属性

ES6 为对象属性的声明提供了一种简洁的写法：

```javascript
var x = 2, y = 3
var o = {
    x,
    y
}
// 上面这段代码等同于
var x = 2, y = 3
var o = {
    x: x,
    y: y
}
```

#### 2.6.2 简洁方法

```javascript
var o = {
    x: function () {}
}
// 现在可以写为
var o = {
    x () {},
    // 生成器也有一种简写方法
    *foo () {}
}
```

但要注意的是，**简洁写法内部其实是一个匿名函数，也就说在该函数内部是无法引用自己的，也就表示无法递归**。

**ES5 Getter / Setter**

在 ES6 中，现在你可以直接在对象字面量中通过`get`和`set`关键词来定义一个 Getter 和 Setter ，而不需要借助`Object.defineProperty()`方法。

```javascript
var o = {
    __id: 10,
    get id () {return this.__id++},
    set id (v) {this.id = v}
}
```

这些 getter 和 setter 字面量也可以出现在类中，第三章将会进行详细介绍。

#### 2.6.3 计算属性名

ES6 现在支持在对象字面量中直接进行计算，返回一个属性名并进行定义。

```javascript
var o = {
    ['user' + 'foo']: function () {}
}
// 以上等同于
var o = {}
o['user' + 'foo'] = function () {}
```

计算属性名最常见的用法可能就是和 Symbols 共同使用，如`[Symbol.toStringTag]`等等。

#### 2.6.4 设定`__proto__`

`__proto__`作为一个对象内部的指针在某些浏览器中是可以访问的，但官方却不推荐直接对`__proto__`进行设置，ES6 新增了一个名为`Object.setPrototypeOf()`的方法，专门用于改变两个对象之间的`__proto__`指针指向。

#### 2.6.5 super 对象

通常把 super 看作只与类相关，但其实它也是一个有效的对象。详细介绍可等至 3.4 节，或是查看[这篇文章](https://blog.liubasara.info/#/post/%E6%B5%85%E8%B0%88JavaScript%E4%B8%AD%E7%9A%84super%E6%8C%87%E9%92%88)。

### 2.7 模版字面量

模版字面量，即``  ` ``这个字符在 ES6 中被视为了一个界定符，使用`` ` ``字符包裹起来的字符串将被视为模版字面量，可以插入状态表达式。

```javascript
var name = 'John'
console.log(`hello ${name}`) // hello John
```

任何在`${..}`中的表达式都会被立即在线解析求值。

#### 2.7.1 插入表达式

在`${..}`中可以插入任何合法的表达式，包括函数调用，在线函数表达式调用，甚至其他插入字符串字面量。而如果在其中出现了 IFFE ，它便没有任何形式的动态作用域。

#### 2.7.2 标签模版字面量

```javascript
function tag(strings, ...values) {
    return strings.reduce(function (acc, current, index) {
        return acc + (index > 0 ? values[index - 1] : '') + current
    }, '')
}
var desc = 'awesome'
var text = tag`Everything is ${desc}`
text // "Everything is awesome"
```

像上面这种使用`` tag`Everything is ${desc}` ``的奇葩用法是一种特殊的语法，称为标签模版字面量，是函数调用的一种特殊形式。该`tag`函数接收数个参数，第一个参数是一个数组，代表模版中含有的字符串，剩余的参数则是要被解析的`value`。

在上面的例子中，`tag`函数只是简单的对字符串做了拼接，但其实能做的还有更多，比如说常见的过滤 HTML 字符串防止 XSS 攻击，以及多语言转换(全球化、本地化)等等。

> 具体用法可看[这篇文章](https://www.cnblogs.com/sminocence/p/6832331.html)

**原始字符串**

ES6 提供了一个`String.raw()`用于提供 strings 的原始版本而无需转义，就是用到了标签模版的方法。

```javascript
console.log('Hello\nWorld')
// Hello
// World
console.log(String.raw`Hello\nWorld`)
// Hello\nWorld
```

### 2.8 箭头函数

ES6中加入了箭头函数。有以下几个特点：

- 没有用于递归或者事件绑定的命名引用
- 箭头函数总是函数表达式，并不存在箭头函数声明
- 在箭头函数内部，`this`绑定不是动态的，而是词法的
- 箭头函数中不存在`arguments`变量(可以用`...args`代替)

### 2.9 for..of 循环

> 本次阅读至P109 2.9 for..of 循环 130
