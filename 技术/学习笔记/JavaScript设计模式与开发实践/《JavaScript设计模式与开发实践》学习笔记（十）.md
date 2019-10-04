---
name: 《JavaScript设计模式与开发实践》学习笔记（十）
title: 《JavaScript设计模式与开发实践》学习笔记（十）
tags: ["技术","学习笔记","JavaScript设计模式与开发实践"]
categories: 学习笔记
info: "第二部分、第 15 章 装饰者模式、第 16 章 状态模式"
time: 2019/10/2,
desc: 'JavaScript设计模式与开发实践, 资料下载, 学习笔记'
keywords: ['JavaScript设计模式与开发实践资料下载', '前端', '学习笔记']
---

# 《JavaScript设计模式与开发实践》学习笔记（十）

## 第 15 章 装饰者模式

> 在传统的面向对象语言中，给对象添加功能常常使用继承的方式，但是继承的方式并不灵活， 还会带来许多问题：一方面会导致超类和子类之间存在强耦合性，当超类改变时，子类也会随之 改变；另一方面，继承这种功能复用方式通常被称为“白箱复用”，“白箱”是相对可见性而言的， 在继承方式中，超类的内部细节是对子类可见的，继承常常被认为破坏了封装性。
>
> 使用继承还会带来另外一个问题，在完成一些功能复用的同时，有可能创建出大量的子类， 使子类的数量呈爆炸性增长。    

装饰器模式是指在不改变对象自身的基础上，在程序运行期间给对象动态地添加职责。

### 15.1 模拟传统面向对象语言的装饰者模式

```javascript
class Plane {
  fire () {
    console.log('发射普通子弹')
  }
}

class MissileDecorator {
  constructor (plane) {
    this.plane = plane
  }
  fire () {
    this.plane.fire()
    console.log('发射导弹')
  }
}

var plane = new Plane()
plane = new MissileDecorator(plane)

plane.fire()
// 发射普通子弹
// 发射导弹
```

上面的例子中，导弹修饰器就像一个可拆卸装备一样，可以装饰在飞机这个类上，丰富了飞机的开火功能。

### 15.3 回到 JavaScript 的装饰者

JavaScript 语言动态改变对象相当容易，我们可以直接改写对象或者对象的某个方法，并不 需要使用“类”来实现装饰者模式。此外 ES7 还定义了属于 JavaScript 的装饰器实现方法，也可以使用这个官方的语法来实现装饰者模式。

```javascript
var plane = {
  fire: function () {
    console.log('发射普通子弹')
  }
}
var missileDecorator = function () {
  console.log('发射导弹')
}
var fire1 = plane.fire
plane.fire = function () {
  fire1()
  missileDecorator()
}
plane.fire()
```

```javascript
// ES7 decorator实现
// 类装饰
@missileDecorator
class Plane {
  fire () {
    console.log('发射普通子弹')
  }
}

function missileDecorator (target) {
  let fire1 = target.prototype.fire
  target.prototype.fire = function () {
    fire1.apply(this, arguments)
    console.log('发射导弹')
  }
}
let plane = new Plane()
plane.fire()
// 发射普通子弹
// 发射导弹
```

```javascript
// ES7 decorator实现
// 方法装饰
class Plane {
  @missileDecorator
  fire () {
    console.log('发射普通子弹')
  }
}

function missileDecorator (target, name, descriptor) {
  console.log('发射导弹')
}
// 发射导弹
// 发射普通子弹
```

### 15.7 装饰者模式和代理模式

装饰者模式和第 6 章的代理模式的结构看起来非常像，这两种模式都描述了怎么样为对象提供一定程度上的间接引用，并且向那个对象发送请求。

这两者最重要的区别在于它们的设计意图和设计目的：

- 代理模式的目的是，当不方便或者无需直接访问本体时，为这个本体提供一个替代者。本体用于定义功能，而代理者用于做一些准入或者验证的功能，这种关系是在一开始就确定了的。
- 而装饰器模式则用于一开始不能准确定义对象的全部功能，需要通过层层装饰链来添加功能的场景，本体只实现了部分的核心功能，而装饰器用于实现更多的功能。

## 第 16 章 状态模式

> 状态模式的关键是区分事物内部的状态，事物内部状态的改变往往会带来事物的行为改变。    

### 16.1 状态模式应用场景

一个类在不同的状态下可能会有不同的表现形式，在通常情况下我们会在类中定义一个状态符号用于区分其表现形式。同时在一些行为中通过 if-else 逻辑进行行为区分。

```javascript
class Light {
  state = 'off' // 电灯初始状态
  
  lightPress () {
    if (this.state == 'off') {
      this.state = 'on'
      console.log('开灯')
    } else if (this.state == 'on') {
      this.state = 'off'
      console.log('关灯')
    }
  }
}
```

上面完成了一个基本的状态机，而这段代码有以下几个缺点：

- 违反开放封闭原则，电灯开关每增加一种状态，lightPress 函数就要改动一次代码
- 所有跟状态有关的行为都被封装在了 lightPress 方法中，在上面的例子中表现为改变开关状态(this.state = 'on')和打印该行为(console.log('开灯'))，非常不利于职责的切分
- 状态的切换非常不明显，仅仅表现为对 state 变量赋值，也无法一眼就分辨出到底有多少种状态（当然你可以选择在旁边加注释 - -）
- 状态之间的切换不过是堆砌 if else 语句，增加一个状态可能需要更改若干个操作，维护成本太高

### 16.2 使用状态模式改进

**状态模式的关键是把事物的 每种状态都封装成单独的类，跟此种状态有关的行为都被封装在这个类的内部**。

同时我们还可以把状态的切换规则事先分布在状态类中， 这样就有效地消除了原本存在的大量条件分支语句。

```javascript
class OffLight {
  constructor (light) {
    this.light = light
  }
  lightPress () {
    this.light.currState = this.light.onLight
    console.log('开灯')
  }
}

class OnLight {
  constructor (light) {
    this.light = light
  }
  lightPress () {
    this.light.currState = this.light.offLight
    console.log('关灯')
  }
}

class Light {
  onLight = new OnLight(this)
	offLight = new OffLight(this)
	// 默认状态为关
	currState = this.offLight

  lightPress () {
		this.currState.lightPress()
  }
}

var a = new Light()
a.lightPress()
// 开灯
a.lightPress()
// 关灯
```

如此一来，我们不再使用一个字符串来记录当前的状态，而是使用更加立体化的**状态对象**，这样一来，我们就能很明显的看到电灯一共有几种状态。

而此时的 lightPress 函数也不会进行任何实质性的操作，而是将请求委托给当前持有的状态对象去执行。

状态的切换规律被事先定义在各个状态类中，不需要通过大量的 if-else 来进行条件切换。

### 16.3 状态模式的通用结构

事实上，状态模式在 Gof 中的定义为：

> 允许一个对象在其内部状态改变时改变它的行为，对象看起来似乎修改了它的类。

在上面的例子中，Light 类在状态模式中被称为 Context（上下文），Context 会持有所有状态对象的引用，以便把请求委托给状态对象。

### 16.4 缺少抽象类的变通方式

由于 JavaScript 并没有一些严格的约束行为，如接口和抽象类（TypeScript 就有），所以很难保证所有的子类都会实现同样的方法，也就难以保证在使用状态模式时不会出错。

所以我们能做的，就是给所有的状态类一个父类，让程序在运行时抛错，虽然没有在编译时就抛错来得优雅，但总好过犯错导致关键失误：

```javascript
class State {
  lightPress () {
    throw new Error('状态子类必须拥有lightPress方法！')
  }
}

class OffLight extends State {
  constructor (light) {
    super()
    this.light = light
  }
  lightPress () {
    this.light.currState = this.light.onLight
    console.log('开灯')
  }
}

class OnLight extends State {
  constructor (light) {
    super()
    this.light = light
  }
  lightPress () {
    this.light.currState = this.light.offLight
    console.log('关灯')
  }
}
```

### 16.6 状态模式的优缺点





>  本次阅读至 P241 16.6 状态模式的优缺点 260