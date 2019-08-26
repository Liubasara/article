---
name: 你不知道的JavaScript学习笔记（二）
title: 《你不知道的JavaScript》学习笔记（二）
tags: ["技术","学习笔记","你不知道的JavaScript"]
categories: 学习笔记
info: "你不知道的JavaScript 第4章 提升 第5章 作用域闭包"
time: 2019/2/28
desc: '你不知道的JavaScript, 资料下载, 学习笔记, 第4章 提升, 第5章 作用域闭包'
keywords: ['javascirpt高级程序设计资料下载', '前端', '你不知道的JavaScript', '学习笔记', '第4章 提升', '第5章 作用域闭包']
---

# 《你不知道的JavaScript》学习笔记（二）

## 第4章 提升

关于变量提升，两段经典的代码如下

```javascript
// 片段一
a = 2
var a
console.log(a) // 变量提升 输出2

// 片段二
console.log(b)
var b = 2 // 神了个奇的，居然没有变量提升，输出的是undefined
```

要搞懂为什么会出现这个问题，就要先搞懂在编译过程中，声明和赋值在JavaScript中的关系。

### 4.2 编译器再度来袭

上一个问题的答案是，**在编译的过程中，只有声明出现的位置会被"移动"，其余操作都不动**。也就是说只有声明本身会被提升。

而对于函数来说，只有函数声明会被提升，但是函数表达式却不会。

### 4.3 函数优先

函数声明和变量声明都会被提升，但是在编译过程中，**函数首先会被提升，然后才是变量**。

而且对于函数声明来说，函数的生成并不会被条件判断所控制。如遇到需要条件控制的情况，建议使用**函数表达式**。

这些绕来绕去的理论告诉我们，**在同一个作用域中进行重复定义时非常糟糕的，而且经常会导致各种奇怪的问题**。

## 第5章 作用域闭包

JavaScript中闭包无处不在。

### 5.2 实质问题

定义：**当函数可以记住并访问所在的词法作用域时，就产生了闭包，即使函数是在当前词法作用域之外执行**。

下面是我认为最好的例子，**单例模式**。

```javascript
function Single () {}
Single.getInstance = (function () {
    let instance
    return function () {
        if (instance) {
            return instance
        } else {
            instance = new Single()
            return instance
        }
    }
})()

var a = Single.getInstance()
var b = Single.getInstance()
a === b // true
```

闭包的神奇之处就在于它创建了一个不会被销毁的内部作用域，因为作用域其中的某些变量一直在被引用着(如上面例子中的`instance`)，而这个引用，其实就是闭包。

### 5.3 现在我懂了(...这标题)

**既非风动，亦非幡动，仁者心动耳**......（译者你出来我们好好聊聊）

### 5.4 循环和闭包

当`let`还没有出现的时候，闭包是解决在循环中调用异步函数或是引用当前循环变量的函数的最佳途径。以下是一段经典代码。

```javascript
// 不使用闭包造成的惨痛后果
var arr = []
for (var i = 0; i < 10; i++) {
    arr.push(function () {console.log(i)})
}
arr[0]() // 10

// 使用闭包
var arr2 = []
for (var i = 0; i < 10; i++) {
    (function (index) {
        arr2.push(function () {console.log(index)})
    })(i)
}
arr2[0]() //0
```

出现第一种情况的原因在基本就是因为上一章说的JavaScript中没有块级作用域，arr中引用的i是当前词法作用域中的全局变量，也就是说都是同一个变量i，所以在循环结束之后，i等于10，arr中的所有函数都只能输出10 。

为了摆脱这种情况，一是使用在ES6之前并不存在的块级作用域，二是在当前循环中直接使用一个立即执行的匿名函数，将当前词法作用域中循环中的i值引入(也可以理解为是拷贝了一份)，造成一个闭包，从而获取一个正确的i值。

而`let`之所以不同于`var`，是因为`let`声明有一个特殊的行为，它在每次迭代都会声明一次，随后的每个迭代都会使用上一个迭代结束时的值来初始化这个变量。

### 5.5 模块

使用模块可以在作用域外访问到在函数内部定义的变量。如下

```javascript
function Foo () {
    var a = 1
    var b = [1,23]
    function sayA () {console.log(a)}
    function sayB () {console.log(b)}
    return {sayA: sayA, sayB: sayB}
}
foo = Foo()
foo.sayA()
foo.sayB()
```

#### 5.5.1 现代的模块机制

现在的库一般会在模块上加上一层友好的包装工具，用于定义各种内部方法。

#### 5.5.2 未来的模块机制

ES6中为模块添加了一级语法支持。`import`可以将一个模块中的一个或多个API导入到当前作用域中，`export`会将当前模块的一个标识符导出为公共API并使用。
