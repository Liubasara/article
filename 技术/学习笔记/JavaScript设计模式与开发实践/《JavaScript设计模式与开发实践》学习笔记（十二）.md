---
name: 《JavaScript设计模式与开发实践》学习笔记（十二）
title: 《JavaScript设计模式与开发实践》学习笔记（十二）
tags: ["技术","学习笔记","JavaScript设计模式与开发实践"]
categories: 学习笔记
info: "第三部分、第 21 章 接口和面向接口编程、第 22 章 代码重构"
time: 2019/10/7
desc: 'JavaScript设计模式与开发实践, 资料下载, 学习笔记'
keywords: ['JavaScript设计模式与开发实践资料下载', '前端', '学习笔记']
---

# 《JavaScript设计模式与开发实践》学习笔记（十二）

## 第 21 章 接口和面向接口编程

接口在编程世界中通常有几种不同的含义：

- API 接口，这种接口通过暴露接口来进行通信，可隐藏内部的工作细节
- 语言提供的关键字，比如说 Java 的 interface，这种关键字可以产生一个完全抽象的类，这种类表示一种契约，用于负责建立类与类之间的联系
- 第三种接口是指面向接口编程中的接口，是对象能够响应的请求的集合。

本章我们主要讨论的是第二和第三种接口。

因为 JavaScript 中并没有提供对抽象类和接口的支持，我们会从 Java 开始来了解面向接口编程的概念和作用。

### 21.1 回到 Java 的抽象类

抽象类主要有两种作用：

- 向上转型，用于让静态语言的对象也能表现出多态性，比如以前我们介绍过的 Animal 类与 Duck 和 Chicken 类之间的关系。
- 建立契约，对子类进行约束，强迫子类实现一些方法和属性从而达到规范代码防止运行出错的效果。

### 21.2 interface

面向接口编程其实说到底就是面向抽象编程，使用 abstract 可以完成，使用 interface 也能达到同样的效果。相对于单继承的抽象类，一个类可以实现多个 interface。**接口比抽象类更为抽象**，抽象类可以包含一些供子类公用的具体方法，而接口则是一个完全抽象的类，不提供任何具体实现，只允许 interface 的创建者确定方法名、参数列表和返回类型。相当于提供一些行为上的约定，但不关心具体的实现过程。

interface 同样可以用于向上转型，实现了同一个接口的两个类就可以被互相替换使用。

```java
public interface Animal {
  abstract void makeSound();
}

public class Duck implements Animal {
  public void makeSound () {
    System.out.println('嘎嘎嘎');
  }
}

public class Chicken implements Animal {
  public void makeSound () {
    System.out.println('咯咯咯');
  }
}

public class AnimalSound {
  public void makeSound (Animal animal) {
    animal.makeSound();
  }
}

public class Test {
  public static void main (String args[]) {
    Animal duck = new Duck();
    Animal chicken = new chicken();
    
    AnimalSound animalSound = new AnimalSound();
    animalSound.makeSound(duck);
    animalSound.makeSound(chicken);
  }
}
```

### 21.3 JavaScript 是否需要抽象类和接口

抽象类和接口的作用主要都是两点：

- 通过向上转型来隐藏对象的真正类型，表现对象的多态性
- 约定类与类之间的一些契约行为

对于 JavaScript 来说，由于是动态语言，所以基本上不需要利用抽象类和接口来进行向上转型，也正因如此很少有人会在 JavaScript 的开发中去关心对象真正的类型。

所以接口和抽象类的意义也就剩下了契约行为这一项，很可惜的是对此 JavaScript 对此并没有替代方案（再次强烈推荐 TypeScript），我们只能在代码中加入防御性代码来进行传入参数的类型检查。

### 21.5 用 TypeScript 编写基于 interface 的设计模式

> TypeScript 是微软开发的一种编程语言，是 JavaScript 的一个超集。跟 CoffeeScript 类似， TypeScript 代码最终会被编译成原生的 JavaScript 代码执行。通过 TypeScript，我们可以使用静态 语言的方式来编写 JavaScript 程序。用 TypeScript 来实现一些设计模式，显得更加原汁原味。

## 第 22 章 代码重构

模式和重构之间有着一种与生俱来的关系。从某种角度来看，这几模式的目的就是为许多重构行为提供目标。

本章会提出一些重构的目标和手段，在重构代码时可以对此进行借鉴。

### 22.1 提炼函数

提炼函数是一种很常见的工作，其好处主要有一下几点：

- 避免出现超大函数
- 独立出来的函数有助于代码复用
- 独立出来的函数更容易被覆写
- 独立出来的函数只要命名良好，本身就有注释的作用

### 22.2 合并重复的条件片段

如果一个函数体内有一些条件分支语句，而这些条件分支语句内部散布了一些重复的代码，那么就有必要进行合并去重工作。

```javascript
// 伪代码
if (a > b) {
    // dosomething
    jump()
} else {
    // dosomething2
    jump()
}

// 上面的代码可优化为
// 伪代码
if (a > b) {
    // dosomething
} else {
    // dosomething
}
jump()
```

### 22.3 把条件分支语句提炼成函数

在程序设计中，复杂的条件分支语句是导致程序难以阅读和理解的重要原因，所以可以将一些条件语句转变为函数，既可以简化代码又可以起到注释的作用。

### 22.4 合理使用循环

在函数体内，如果有些代码实际上负责的是一些重复性的工作，那么合理利用循环不仅可以 完成同样的功能，还可以使代码量更少

### 22.5 提前让函数退出代替嵌套条件分支

活用 return 退出函数可以有效减少 else-if 这种条件判断的存在

### 22.6 传递对象参数代替过长的参数列表 && 尽量减少参数数量

### 22.8 少用三目运算符

复杂的条件逻辑最好还是用 if else，三目运算符在某些情况下会严重影响可读性。

### 22.9 合理使用链式调用

使用链式调用的方式并不会造成太多阅读上的困难，也确实能省下一些字符和中间变量，但 节省下来的字符数量同样是微不足道的。链式调用带来的坏处就是在调试的时候非常不方便，如 果我们知道一条链中有错误出现，必须得先把这条链拆开才能加上一些调试 log或者增加断点， 这样才能定位错误出现的地方。如果该链条的结构相对稳定，后期不易发生修改，那么使用链式调用无可厚非。但如果该链 条很容易发生变化，导致调试和维护困难，那么还是建议使用普通调用的形式

### 22.10 分解大型类

像策略模式、状态模式这种模式中，都会对类进行分解（策略类，状态类，上下文类）从而精简单一类的功能与逻辑，增强可读性和可维护性。





