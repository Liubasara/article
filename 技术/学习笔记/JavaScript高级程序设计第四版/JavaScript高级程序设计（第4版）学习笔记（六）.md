---
name: JavaScript高级程序设计（第4版）学习笔记（六）
title: JavaScript高级程序设计（第4版）学习笔记（六）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：8. 对象、类与面向对象编程"
time: 2020/10/20
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']


---

# JavaScript高级程序设计（第4版）学习笔记（六）

## 第 8 章 对象、类与面向对象编程

### 8.1 理解对象

#### 8.1.1 属性的类型

对象的属性分两种：数据类型和访问器类型。

**1. 数据类型**

数据类型拥有以下四类属性：

- [[Configurable]]：表示属性是否可以通过`delete`删除并重新定义，是否可以修改其特性，以及是否可以将它改为访问器属性，默认为 true。
- [[Enumerable]]：表示是否可以通过`for-in`循环返回，默认为 true
- [[Writable]]
- [[Value]]

可以使用`Object.defineProperty()`对这些特性进行设置。

**2. 访问器属性**

访问器属性包含一个 getter 和一个 setter。拥有下列特性：

- [[Configurable]]
- [[Enumerable]]
- [[Get]]
- [[Set]]

访问器属性不能直接定义，必须使用`Object.defineProperty`进行设置。（？？）

PS：新版（ES7 还是 ES8 ）添加了 get set 声明符，已经可以直接设置了，如下：

```javascript
var a = {
  b_:1,
  get b () {
    return this.b_
  },
  set b (val) {
    this.b_ = val
  }
}
a.b
// 1
a.b = 2
a.b
// 2
```

> 在不支持 Object.defineProperty()的浏览器中没有办法修改[[Configurable]]或[[Enumerable]]。

#### 8.1.2 定义多个属性

使用`Object.defineproperties()`可以一次性定义多个属性的特性。

```javascript
var book = {}
Object.defineProperties(book, {
  year_: {
    value: 111
  },
  year: {
    get () {
      return this.year_
    },
    set (val) {
      this.year_ = val
    }
  }
})
```

#### 8.1.3 读取属性的特性

使用`Object.getOwnPropertyDescriptor()`方法可以取得指定属性的属性描述符。

ES8 新增了`Object.getOwnPropertyDescriptors()`静态方法，用于在每个属性中调用`Object.getOwnPropertyDescriptor()`并在一个新对象中返回。

#### 8.1.4 合并对象

使用`Object.assign`或拓展合并符`...`都可以对对象进行浅复制。

如果赋值期间出错，则操作会中止并退出，同时抛出错误。Object.assign() 没有“回滚”之前赋值的概念，因此它是一个尽力而为、可能只会完成部分复制的方法。 

#### 8.1.5 对象标识及相等判定

使用`Object.is`可以进行精准判定，与`===`很像，但考虑了很多边界情形，比如 NaN 相等，+0 和 -0 不相等等等。

#### 8.1.6 增强的对象语法

- 属性值简写

- 可计算属性

  ```javascript
  const nameKey = 'name'
  const person = {
    [nameKey]: 'Matt'
  }
  ```

- 简写方法名

#### 8.1.7 对象解构

有以下解构场景：

- 嵌套解构
- 部分解构
- 参数上下文匹配

### 8.2 创建对象

 ES6的类定义本身就相当于对原有结构的封装（语法糖呗），在介绍 ES6 的类之前，本书会先介绍那些底层概念（炒第三版的冷饭）

创建对象的几种模式：

- 工厂模式
- 构造函数模式
- 原型模式

### 8.3 继承

实现继承是 ECMAScript 唯一支持的继承方式，而这主要是通过原型链实现的。

（继续炒第三版冷饭）

有以下几种继承方式：

- 原型链继承
- 盗用构造函数
- 组合继承
- 原型式继承
- 寄生式继承
- 寄生式组合继承

PS：当然还有 ES6 新增的最牛逼的`Object.setPrototypeof`继承大法。

### 8.4 类

ES6 新引入的`class`关键字具有正式定义类的能力，但它只是看起来可以支持正式的面向对象编程，实际上其背后使用的仍然是原型和构造函数的概念。

#### 8.4.1 类定义

定义类有两种主要方式，类声明和类表达式。

```javascript
class Person {} // 类声明
const Animal = class {} // 类表达式
```

与函数定义不同的是，虽然函数声明可以提升，但是类声明不能。

另一个不同的则是，函数受函数作用域限制，而类受块作用域的限制（就跟`const`和`let`一样）。

#### 8.4.2 类构造函数

`constructor`关键字用于在类定义块内部创建类的构造函数。该方法告诉解释器在使用`new`操作符创建类的新实例时，应该调用这个函数。

#### 8.4.3 实例、原型和类成员

类的语法可以非常方便地定义应该存在于实例上的成员（a.xxx）、应该存在在原型上的成员（A.prototype.xxx）以及应该存在于类本身的成员（A.xxx）。

**1.实例成员**

通过`constructor`可以为每次新创建的实例添加自有属性。

```javascript
class Test {
  constructor () {
    this._b = 'test'
  }
}
var test = new Test()
test.b
// "test"
```

**2. 原型方法**

可以以使用操作符给原型添加引用属性，在类块中定义原型方法。

```javascript
class Test {
  constructor () {
    this._b = 'test'
  }
  // 为原型对象添加 get 引用属性
  get b () {
    return this._b
  }
  set b (val) {
    this._b = val
  }
  getB () {
    return this._b
  }
}
var test = new Test()
test.b
// "test"
test._b = 123
// 123
test.b
// 123
test.b = 234
// 234
test._b
// 234
test.getB()
// 234
```

要注意的是，虽然类定义并不显示支持在原型上添加成员数据（因为一般来说，对象实例应该独自拥有通过 this 引用的数据，而不应该在原型上），但依然可以通过旧方法进行定义。

```javascript
Test.prototype.name = 'Jack'
```

**3. 静态类方法和属性**

可以在类上定义静态方法，ES7 后还可以通过 static 关键字进行自定义属性。

```javascript
class Test {
  static wow = '静态类基本属性'
	static get hi ()  { return '静态类引用属性' }
  static set hi (val) { this.wow = val }
  static locate () {
    console.log('静态类方法')
  }
}
console.log(Test.hi) // 静态类引用属性
console.log(Test.wow) // 静态类基本属性
Test.hi = 123
console.log(Test.wow) // 123
console.log(Test.locate()) // 静态类方法
```

静态类方法非常适合作为实例工厂。

```javascript
class Person {
  constructor (age) {
    this.age_ = age
  }
  sayAge() {
    console.log(this.age_)
  }
  static create () {
    return new Person(Math.floor(Math.random() * 100))
  }
}
console.log(Person.create())
```

**5. 迭代器与生成器方法**

类定义语法支持在原型和类本身上定义生成器方法。

```javascript
class Person {
  // 在原型上定义生成器方法
  *createNickNameIterator() {
    yield 'Jack'
    yield 'Jake'
    yield 'J-Dog'
  }
  // 在类上定义生成器方法
  static *createJobIterator() {
    yield 'Jack'
    yield 'Jake'
    yield 'J-Dog'
  }
}
```

#### 8.4.4 继承

ES6 类支持使用`extends`关键字进行单继承，不仅可以继承一个类，也可以继承普通的构造函数。在 ES6 中的继承，需要在`constructor`构造函数中调用`super`方法来进行继承。

> `super`使用方法，推荐延伸阅读：[浅谈JavaScript中的super指针](https://blog.liubasara.info/#/blog/articleDetail/mdroot%2F%E6%8A%80%E6%9C%AF%2F%E6%B5%85%E8%B0%88JavaScript%E4%B8%AD%E7%9A%84super%E6%8C%87%E9%92%88.md)

**抽象基类**

有时候可能需要定义这样的一个类，可供其他类继承，但不会被实例化。虽然 ECMAScript 没有专门支持这种类的语法，但 ES6 中支持一个名为`new.target`的指针，可以通过检测该指针指向的是不是抽象基类从而阻止其实例化。

```javascript
class Vehicle {
  constructor () {
    if (new.target === Vehicle) {
      throw new Error('Vehicle 不能被直接实例化')
    }
  }
}
class Bus extends Vehicle {}

new Vehicle() // Error
new Bus() // class Bus {}
```

**继承内置类型**

默认情况下，返回实例的类型与原始实例的类型是一致的。可以通过覆盖`Symbol.species`访问器来覆盖返回新实例的行为，这个访问器决定在创建返回的实例时使用的类。

```javascript
class OldSuperArray extends Array {}
let b1 = new OldSuperArray(1, 2, 3, 4, 5)
let b2 = b1.filter(x => !!(x % 2))
console.log(b1 instanceof OldSuperArray) // true
console.log(b2 instanceof OldSuperArray) // true

class SuperArray extends Array {
  static get [Symbol.species] () {
    return Array
  }
}
let a1 = new SuperArray(1, 2, 3, 4, 5)
let a2 = a1.filter(x => !!(x % 2))
console.log(a1 instanceof SuperArray) // true
console.log(a2 instanceof SuperArray) // false
```

**类混入**

虽然 ES6 没有显式地支持多累继承，但通过`extends`特性可以轻松地模拟这种行为。

一个策略是定义一组“可嵌套”的函数，每个函数分别接收一个超类作为参数，而将混入类定义为这个参数的子类，并返回这个类。这些组合函数可以连调用，终组合成超类表达式：

```javascript
class Vehicle {}
let FooMixin = (SuperClass) => class extends SuperClass {
  foo () { console.log('foo') }
}
let BarMixin = (SuperClass) => class extends SuperClass {
  bar () { console.log('bar') }
}
class Bus extends BarMixin(FooMixin(Vehicle)) {}

let b = new Bus()
b.foo() // foo
b.bar() // bar
```

同时还可以通过一个辅助函数来把这些嵌套分开：

```javascript
function mix (BaseClass, ...Mixins) {
  return Mixins.reduce((acc, curr) => curr(acc), BaseClass)
}
class Bus extends mix(Vehicle, FooMixin, BarMixin) {}
```
