---
name: 你不知道的JavaScript学习笔记（五）
title: 《你不知道的JavaScript》学习笔记（五）
tags: ['读书笔记', '你不知道的JavaScript']
categories: 学习笔记
info: "你不知道的JavaScript 第6章 行为委托"
time: 2019/3/4
desc: '你不知道的JavaScript, 资料下载, 学习笔记, 第6章 行为委托'
keywords: ['javascirpt高级程序设计资料下载', '前端', '你不知道的JavaScript', '学习笔记', '第6章 行为委托']
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



> 本次应阅读至P185 6.5 内省 200