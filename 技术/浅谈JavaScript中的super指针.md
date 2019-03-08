---
name: 浅谈JavaScript中的super指针
title: 浅谈JavaScript中的super指针
tags: ['读书笔记']
categories: 学习笔记
info: "模仿Java跌跌撞撞的双脚羊"
time: 2019/3/6 10:05
desc: '学习笔记, 前端面试, super指针, JavaScript'
keywords: ['前端面试', '学习笔记', 'super指针', 'JavaScript']
---

# 浅谈JavaScript中的super指针

> 引用资料：
>
> - [super关键字——阮一峰](http://es6.ruanyifeng.com/#docs/class-extends#super-%E5%85%B3%E9%94%AE%E5%AD%97)

 `super`关键字既可以作为一个函数调用(Base.call(this, args...))，作为函数时，`super()`只能用在子类的构造函数之中，用在其他地方就会报错。

此外，阮一峰老师认为super()函数在ES6中用来为类构造一个`this`指针，但这种说法其实是没道理的。

  > “第二个问题实际上是问 super(...) 到底做了什么。其实 super(...) 做的事情就是生成一个 this。”我觉得这句话大大的有问题。**super只是调用父类的构造方法(Base.call(this, args...))**，语法只是来自java，并没有“生成this”这样特别的能力
  >
  > 首先：this这个对象在new操作符调用对应contructor之前已经生成，他就是一个空对象。不要忘了ES6的class只是ES5原型对象继承的语法糖，class做的事情与ES5的new function并没有什么不同。
  >
  > 另外可以反驳博主的是这个：“Uncaught ReferenceError: this is not defined”，这里是说this完全没定义过，这个标识符不存在；而不是“this的值没被初始化，是undefined“。这里抛的是ReferenceError而非TypeError。但是说super()定义了一个this是行不通的，因为this在js里是关键字，不存在定不定义的问题，你也不能var this = XXX。我认为这能这样理解：ES6的class语法做了这样的限制：（如果显式定义了父类）在调用super之前不能访问this，否则就报ReferenceError。
  >
  > 为什么有这样的限制呢？因为一个类的父类永远都应该优先于其子类被构造。ES5中的class只是单纯的function，没有这样的限制，于是容易出错。ES6的class“语法糖”作为更严格的ES5 function只是做了一些限制避免出错而已。

此外，`super`可以在方法内部作为一个对象调用，但它作为指针指向的地方却有两种不同的情况：

  - 当处于普通方法内时，`super`是一个指针，指向的是当前对象父类的原型对象，即可以取到父类原型对象上的属性(RHS查询)。**但当通过super调用父类原型对象上的方法或是对super上的属性进行赋值时(LHS查询)，该方法的`this`默认指向当前子类的实例，super也指向当前子类的实例**。

    ```javascript
    class A {
      constructor() {
        this.x = 1;
      }
    }
    
    class B extends A {
      constructor() {
        super();
        this.x = 2;
        super.x = 3;
        console.log(super.x); // undefined
        console.log(this.x); // 3
      }
    }
    
    let b = new B();
    ```

    

  - 当处于静态方法内时，`super`的指向变为父类(RHS查询)，**通过`super`调用父类方法或是对`super`上的属性进行赋值时(LHS查询)，函数内部的this指向当前子类，super指针也指向当前子类**。

    ```javascript
    class A {
      constructor() {
        this.x = 1;
      }
      static print() {
        console.log(this.x);
      }
    }
    
    class B extends A {
      constructor() {
        super();
        this.x = 2;
      }
      static m() {
        super.print();
      }
    }
    
    B.x = 3;
    B.m() // 3
    ```


此外，要注意的是，调用`super`的函数在对象中必须是使用简写语法声明的，而不能通过对象的属性来间接声明，如下。

  ```javascript
  // 正确定义
  var a = {
      wow () {
          console.log(super.toString === Object.prototype.toString)
      }
  }
  a.wow() // true
  
  // 错误定义
  var b = {
      wow: function wow () {
          console.log(super.toString === Object.prototype.toString)
      }
  } // 报错 Uncaught SyntaxError: 'super' keyword unexpected here
  ```

  