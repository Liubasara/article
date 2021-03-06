---
name: JavaScript高级程序设计（第4版）学习笔记（七）
title: JavaScript高级程序设计（第4版）学习笔记（七）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：9. 代理与反射"
time: 2020/10/23
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']

---

# JavaScript高级程序设计（第4版）学习笔记（七）

PS：本章很有用（可能是第四版到目前为止最有干货的一章），推荐认真阅读

## 第 9 章 代理与反射

ES6 新增的代理和反射为开发者提供了拦截并向基本操作嵌入额外行为的能力。

### 9.1 代理基础

代理是目标对象的抽象，从很多方面看，类似于 C++ 的指针，既可以用作目标对象的替身，但又完全独立于目标对象。

目标对象既可以直接操作，也可以通过代理来操作，而直接操作会绕过代理施予的行为。

#### 9.1.1 创建空代理

代理是使用`Proxy`构造函数创建的，该构造函数接收两个参数：目标对象（target）和处理程序对象（handler）。缺少任何一个都会抛出 TypeError。

如下面的代码所示，在代理对象上执行的任何操作实际上都会应用到目标对象。唯一可感知的不同就是代码中操作的是代理对象。

```javascript
const target = { id: 'target' }
const handler = {}
const proxy = new Proxy(target, handler)

console.log(target.id) // target
console.log(proxy.id) //target

target.id = 'foo'
console.log(target.id) // foo
console.log(proxy.id) // foo

proxy.id = 'bar'
console.log(target.id) // bar
console.log(proxy.id) // bar

// hasOwnProperty() 方法在两个地方
// 都会应用到目标对象
console.log(target.hasOwnProperty('id')) // true
console.log(proxy.hasOwnProperty('id')) // true

// Proxy.prototype 是 undefined 因此无法使用 instanceof 操作符
console.log(target instanceof Proxy) // TypeError: Function has non-object prototype 'undefined' in instanceof check
console.log(proxy instanceof Proxy) // TypeError: Function has non-object prototype 'undefined' in instanceof check

// 严格相等 === 可以用于区分代理和目标
proxy === target // false
```

#### 9.1.2 定义捕获器

使用代理的主要目的是可以定义捕获器，捕获器就是在处理程序对象中定义的“基本操作的拦截器”。每个处理程序对象（handler）可以包含零个或多个捕获器，每个捕获器都对应一种基本操作，可以直接或间接在代理对象上调用。

例如可以定义一个 get 捕获器，在代理对象执行 get 操作时就会触发。

```javascript
const target = { foo: 'bar' }
const handler = {
  // 捕获器在处理程序对象中以方法名为 key
  get () {
    return 'handler override'
  }
}
const proxy = new Proxy(target, handler)
console.log(target.foo) // bar
console.log(proxy.foo) // handler override
```

#### 9.1.3 捕获器参数和反射 API

所有捕获器都可以访问相应的参数，并基于这些参数重建被捕获方法的原始行为，比如说，get 捕获器在被调用时会接收到以下三个参数：

- 目标对象 trapTarget
- 要查询的属性 property
- 代理对象 receiver

基于这三个对象，可以重建被捕获方法的原始行为：

```javascript
const handler = {
  get (trapTarget, property, receiver) {
    return trapTarget[property]
  }
}
```

并非所有捕获器行为都像 get() 那么简单，因此，通过手动写代码如法炮制所有方法的默认行为的想法是不现实的。实际上，开发者可以通过全局 Reflect 对象上的同名方法来轻松重建。

handler 中所有可以定义的捕获器方法都有相应的 Reflect API 方法，且这些方法与捕获器拦截的方法一样具有相同的名称和入参，也具有与被拦截方法相同的行为。因此可以像下面这样定义：

```javascript
const handler = {
  get () {
    return Reflect.get(...arguments)
  }
}
// 甚至还可以更简洁一点
const handler = {
  get: Reflect.get
}
```

实际上，如果真的想创建一个可以捕获所有方法，又将每个方法转发给对应 Reflect API 的空代理，那么甚至不需要定义 handler。

```javascript
const target = { foo: 'bar' }
const proxy = new Proxy(target, Reflect)
```

Reflect API 为开发者准备好了样板代码，因此开发者可以在此基础上用最少的代码修改捕获的方法。

```javascript
const target = { foo: 'bar', ha: 'ha' }
const handler = {
  get (trapTarget, property, receiver) {
    return property === 'foo' ?
      Reflect.get(...arguments) + '!!!':
    	Reflect.get(...arguments)
  }
}
const proxy = new Proxy(target, handler)
console.log(proxy.ha) // ha
console.log(proxy.foo) // bar!!!
```

#### 9.1.4 捕获器不变式

使用捕获器几乎可以改变所有基本方法的行为，但并不是没有限制，比如如果目标对象有一个不可配置不可写的属性，那么在捕获器返回一个与该属性不同的值时，会抛出 TypeError：

```javascript
const target = {}
Object.defineProperty(target, 'foo', {
  configurable: false,
  writable: false,
  value: 'bar'
})
const handler = {
  get () {
    return 'qux'
  }
}
const proxy = new Proxy(target, handler)
console.log(proxy.foo) // TypeError
```

#### 9.1.5 可撤销代理

对于使用`new Proxy()`创建的普通代理来说，没有什么办法能撤销代理与普通对象之间的关联。

Proxy 暴露了`revocable()`方法用于支持撤销代理对象与目标对象之间的关联，撤销代理的操作是不可逆的。若撤销之后再调用代理会抛出 TypeError。

撤销函数和代理对象是在实例化时同时生成的：

```javascript
const target = { foo: 'bar' }
const handler = { get () {return 'intercepted'} }
const { proxy, revoke } = Proxy.revocable(target, handler)

console.log(proxy.foo) // intercepted
console.log(target.foo) // bar

revoke() // 取消关联

console.log(proxy.foo) // TypeError
```

#### 9.1.6 实用反射 API

Reflect API 的使用并不局限于捕获器，且多数的 Reflect API 在 Object 类型上有对应的方法，区别是 Object 上的方法适用于通用程序，而反射方法则适用于细粒度和对象控制与操作。

**状态标记**

相比起普通方法在执行失败时抛错或事返回修改后的对象， Reflect API 在函数行为上显得更加统一，很多反射方法会返回一个“状态标记”布尔值，用于表示意图执行的操作是否成功。

相比起直接抛错的需要在使用时通过`try...catch`来捕获错误的代码，Reflect API 显得更为语义化。

```javascript
const o = {}
// 旧形式
try {
  Object.defineProperty(o, 'foo', 'bar')
  console.log('success')
} catch (e) {
  console.log('failure')
}
// 使用 Reflect API
if (Reflect.defineProperty(o, 'foo', { value: 'bar'} )) {
  console.log('success')
} else {
  console.log('failure')
}
```

以下反射方法都会提供状态标记：

- Reflect.defineProperty
- Reflect.preventExtensions
- Reflect.setPrototypeOf
- Reflect.set
- Reflect.deleteProperty

**一等函数代替操作符**

以下反射方法提供只有操作符才能完成的操作：

- Reflect.get
- Reflect.set
- Reflect.has 可以代替`in`操作符或`with()`
- Reflect.deleteProperty 可以代替`delete`操作符
- Reflect.construct 可以替代`new`操作符

**代替函数的 call apply 应用方法**

`Function.prototype.apply.call(myFunc, thisVal, argumentsList)`

上面这种可怕的代码完全可以使用`Reflect.apply`来避免：

`Reflect.apply(myFunc, thisVal, argumentsList)`

#### 9.1.7 代理另一个代理

代理之间可以层层嵌套，构建多层拦截网。

```javascript
const target = { foo: 'bar' }
const firstProxy = new Proxy(target, {
  get () {
    console.log('first')
    return Reflect.get(...arguments)
  }
})
const secondProxy = new Proxy(firstProxy, {
  get () {
    console.log('second')
    return Reflect.get(...arguments)
  }
})
console.log(secondProxy.foo)
// second
// first
// bar
```

#### 9.1.8 代理的问题与不足

代理作为对象的虚拟层可以正常使用，但在某些情况下，其并不能与 ECMAScript 的机制很好地协同。

**1. 代理中的 this**

通过代理调用原对象上的方法，会使得`this`指针指向 proxy 对象而不是原对象，而如果该方法对 this 指针有所依赖，就有可能会碰到意料之外的问题。比如说在外部定义了一个以 this 为 key 的 Map 这种情况。

```javascript
const wm = new WeakMap()
const target = {
  setId (id) {
    wm.set(this, id)
  },
  getId () {
    return wm.get(this)
  }
}
target.setId(123)
console.log(target.getId()) // 123
const proxy = new Proxy(target, {})
proxy.getId() // undefined
```

**2. 代理与内部槽位**

有些内置类型可能会依赖代理无法控制的机制，结果导致代理在某些地方调用某些方法会出错。

一个典型的例子就是`Date`类型。Date 类型方法的执行依赖`this`值上的内部槽位 [[NumberDate]]。代理对象上不存在这个槽位，而且这个槽位的值也无法通过普通的 get 和 set 访问到，导致本该转发给目标对象的方法会抛出 TypeError。

```javascript
const target = new Date()
const proxy = new Proxy(target, {})
console.log(proxy instanceof Date) // true
proxy.getDate() // TypeError
```

### 9.2 代理捕获器与反射方法

代理可以捕获 13 种不同的基本操作，这些操作对应各自不同的 Reflect API。

PS：到底是什么晦涩难懂的单词才会翻译出“不变式”这个不明所以的词出来啊...这跟不翻译有区别吗

#### 9.2.1 get

对应反射 API 方法：Reflect.get()

返回值无限制。

触发拦截的操作：

- proxy.property
- proxy[property]
- Object.create(proxy)[property]
- Reflect.get(proxy, property, receiver)

捕获器参数：

- target
- property
- receiver

捕获器不变式：

- 对应属性不可写且不可配置，处理程序返回的值必须与 target.property 匹配
- target.property 不可配置且 [[Get]] 特性为 undefined，处理程序的返回值也必须是 undefined

> 严格来讲，property 参数除了字符串键，也可能是符号(symbol)键。后面几处也一样。——译者注

#### 9.2.2 set

对应反射 API：Reflect.set()

返回值：返回 true 表示成功，false 表示失败，严格模式下会抛出 TypeError

拦截的操作：

- proxy.property = value
- proxy[property] = value
- Object.create(proxy)[property] = value
- Reflect.set(proxy, propery, value, receiver)

捕获器参数：

- target
- property
- value 要赋给属性的值
- receiver

#### 9.2.3 has

对应反射 API：Reflect.has()

返回值：必须返回布尔值，表示属性是否存在。返回非布尔值会被转型为布尔值。

拦截的操作：

- property in proxy
- property in Object.create(proxy)
- with(proxy) {(property)}
- Reflect.has(proxy, property)

捕获器处理参数：

- target
- property

#### 9.2.4 defineProperty

对应的反射器 API：Reflect.defineProperty()

返回值：返回布尔值，表示属性是否成功定义

拦截的操作：

- Object.defineProperty
- Reflect.defineProperty

处理参数：

- target 目标对象
- property 引用的目标对象上的 key
- descriptor

不变式：

- 如果对象不可扩展，则无法定义
- 如果对象有一个可配置的属性，则不能添加**同名**的不可配置属性
- 如果目标对象有一个不可配置的属性，则不能添加**同名**的可配置属性

#### 9.2.5 getOwnPropertyDescriptor

对应反射 API 为：Reflect.getOwnPropertyDescriptor

返回值：必须返回对象，或者在属性不存在时返回 undefined

拦截的操作：

- Object.getOwnPropertyDescriptor(proxy, property)
- Reflect.getOwnPropertyDescriptor(proxy, property)

捕获器处理程序参数：

- target
- property

#### 9.2.6 deleteProperty

对应的反射 API 方法为 Reflect.deleteProperty

返回值：返回布尔值，表示删除属性是否成功

拦截操作：

- delete proxy.property
- delete proxy[property]
- Reflect.deleteProperty(proxy, property)

捕获器入参：

- target 目标对象
- property 引用的目标对象上的 key

不变式：若自有的 target.property 存在且不可配置，则无法删除该属性

#### 9.2.7 ownKeys

对应的反射 API 为 Reflect.ownKeys()

返回值：包含字符串或符号的可枚举对象。

拦截的操作：

- Object.getOwnPropertyNames(proxy)
- Object.getOwnPropertySymbols(proxy)
- Object.keys(proxy)
- Reflect.ownKeys(object)

不变式：

- 返回的可枚举对象必须包含 target 的所有不可配置的自有属性
- 如果 target 不可拓展，则返回的可枚举对象必须准确地包含自由属性 key

#### 9.2.8 getPrototypeOf

对应反射 API 为 Reflect.getPrototypeOf

返回值：返回对象或 null

拦截操作：

- Object.getPrototypeOf(proxy)
- Reflect.getPrototypeOf(proxy)
- proxy.\_\_proto\_\_
- Object.prototype.isPrototypeOf(proxy)
- proxy instanceof object

不变式：如果 target 不可拓展，则 Object.getPrototypeOf(proxy) 唯一有效的返回值就是 Object.getPrototypeOf(target) 的返回值

#### 9.2.9 setPrototypeOf

对应反射 API 为 Reflect.setPrototypeOf

返回值：setPrototype 必须返回布尔值，表示原型赋值是否成功。

拦截的操作：

- Object.setPrototypeOf(proxy)
- Reflect.setPrototypeOf(proxy)

捕获器参数：

- target：目标对象
- prototype：target 的替代原型

#### 9.2.10 isExtensible

对应 Reflect API 为：Reflect.isExtensible

返回值：返回布尔值，表示 target 是否可扩展

拦截的操作：

- Object.isExtensible(proxy)
- Reflect.isExtensible(proxy)

捕获器参数：

- target：目标对象

#### 9.2.11 preventExtensions

对应的反射 API 为 Reflect.preventExtensions()

返回值：返回布尔值，表示 target 是否已经不可扩展

拦截操作：

- Object.preventExtensions(proxy)
- Reflect.preventExtionsions(proxy)

捕获器参数：

- target: 目标对象

不变式：

PS：如果 Object.isExtensible(proxy) 是 false，则必须返回 true

#### 9.2.12 apply

对应的反射 API 为 Reflect.apply

返回值：无限制

拦截的操作：

- proxy(...argumentsList)
- Function.prototype.apply(thisArg, argumentsList)
- Function.prototype.call(thisArg, ...argumentsList)
- Reflect(target, thisArgument, argumentsList)

捕获器入参：

- target
- thisArg 调用函数时的 this 参数
- argumentsList 调用函数时的参数列表

不变式：target 必须得是一个函数对象

#### 9.2.13 construct

对应的反射 API 方法为 Reflect.construct

返回值：必须返回一个对象

拦截的操作：

- new 操作，new proxy(...argumentsList)
- Reflect.construct(target, argumentsList, newTarget)

捕获器处理参数：

- target：目标构造函数
- argumentsList：传给目标构造函数的参数列表
- newTarget：最初被调用的构造函数

不变式：

target 必须可以用作构造函数

### 9.3 代理模式

使用代理可以在代码中实现一些有用的编程模式。

#### 9.3.1 跟踪属性访问

通过 get set 和 has 操作，可以知道对象属性什么时候被访问，被查询。

#### 9.3.2 隐藏属性

```javascript
const hiddenProperties = ['foo', 'bar']
const targetObj = {
  foo: 1,
  bar: 2,
  baz: 3
}
const proxy = new Proxy(targetObj, {
  get (target, property) {
    if (hiddenProperties.includes(property)) {
      return undefined
    } else {
      return Reflect.get(...arguments)
    }
  },
  has (target, property) {
    if (hiddenProperties.includes(property)) {
      return undefined
    } else {
      return Reflect.has(...arguments)
    }
  }
})
```

#### 9.3.3 属性验证

所有赋值都会触发 set 捕获器，可以根据所赋的值决定是允许还是拒绝赋值。

```javascript
var handler = {
  set (target, property, value) {
    if (typeof value !== 'number') {
      return false
    } else {
      return Reflect.set(...arguments)
    }
  }
}
```

#### 9.3.4 函数与构造函数参数验证

在`new`操作符时使用`construct`捕获器方法进行参数验证，跟属性验证的做法类似。

#### 9.3.5 数据绑定与可观察对象

> 通过代理可以把运行时中原本不相关的部分联系到一起。这样就可以实现各种模式，从而让不同的代码互操作。 

### 9.4 小结

> 代理的应用场景是不可限量的。开发者使用它可以创建出各种编码模式，比如（但远远不限于）跟踪属性访问、隐藏属性、阻止修改或删除属性、函数参数验证、构造函数参数验证、数据绑定，以及可观察对象。 

