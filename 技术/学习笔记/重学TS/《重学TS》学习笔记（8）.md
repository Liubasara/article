---
name: 《重学TS》学习笔记（8）
title: 《重学TS》学习笔记（8）
tags: ["技术","学习笔记","重学TS"]
categories: 学习笔记
info: "第10章 TypeScript 进阶之控制反转和依赖注入"
time: 2021/6/21
desc: '第10章 TypeScript 进阶之控制反转和依赖注入'
keywords: ['前端', '重学 TS', '学习笔记', 'typeScript']
---

# 《重学TS》学习笔记（8）

## 第10章 TypeScript 进阶之控制反转和依赖注入

本章介绍 IoC（控制反转）和 DI（依赖注入）设计思想，了解如何使用 TypeScript 实现一个 IoC 容器，并了解装饰器、反射的相关知识。

### 二、IoC 是什么

IoC（Inversion of Control），即“控制反转”。在开发中，IoC 意味着将设计好的对象交给容器控制，而不是使用传统的方式，在对象内部直接控制。

要理解 IoC，关键是要明确以下几点：

- **谁控制谁，控制什么**：在传统的程序设计中，是程序主动创建依赖对象（也就是直接在对象内部通过`new`的方式创建对象）；而 IoC 是有专门一个容器来创建这些对象，即由 IoC 容器控制对象的创建；

  谁控制谁？IoC 容器控制了对象。

  控制什么？主要是控制外部资源（依赖对象）获取。

- **为何是反转，哪些方面反转了**：传统的应用程序是由开发者自己在程序中主动控制去获取依赖对象，而反转则是容器来帮忙创建以及注入依赖对象；

  为何是反转？因为由容器来注入依赖对象，而对象只是被动的接受依赖对象，所以是反转。

  哪些方面反转了？依赖对象的获取被反转了

比如说，在传统的程序中，一个类被这样创建：

```typescript
class Car {
  engine: Engine;
	chassis: Chassis;
  body: Body;
  
  constructor() {
    this.engine = new Engine()
    this.body = new Body()
    this.chassis = new Chassis()
  }
}
const car = new Car()
```

但是在控制反转的程序中，一个类是这样的：

```typescript
class Car {
  engine: Engine;
	chassis: Chassis;
  body: Body;
  
  constructor(engine, body, chassis) {
    this.engine = engine
    this.body = body
    this.chassis = chassis
  }
}

const engine = new Engine()
const body = new Body()
const chassis = new Chassis()

const car = new Car(engine, body, chassis)
```

### 三、IoC 能做什么

IoC 不是技术，而是一种思想和设计原则，用于减少代码之间的耦合度，以及方便测试，更重要的是，使得程序的整个体系结构变得非常灵活。

### 四、IoC 与 DI 之间的关系











> 本次阅读至 171 四、IoC 与 DI 之间的关系