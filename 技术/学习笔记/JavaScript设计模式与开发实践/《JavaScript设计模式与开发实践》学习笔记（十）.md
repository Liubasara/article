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
```

### 15.7 装饰者模式和代理模式

装饰者模式和第 6 章的代理模式的结构看起来非常像，这两种模式都描述了怎么样为对象提供一定程度上的间接引用，并且向那个对象发送请求。

这两者最重要的区别在于它们的设计意图和设计目的：

- 代理模式的目的是，当不方便或者无需直接访问本体时，为这个本体提供一个替代者。本体用于定义功能，而代理者用于做一些准入或者验证的功能，这种关系是在一开始就确定了的。
- 而装饰器模式则用于一开始不能准确定义对象的全部功能，需要通过层层装饰链来添加功能的场景，本体只实现了部分的核心功能，而装饰器用于实现更多的功能。

## 第 16 章 状态模式







>  本次阅读至 P223 第 16 章 状态模式 243