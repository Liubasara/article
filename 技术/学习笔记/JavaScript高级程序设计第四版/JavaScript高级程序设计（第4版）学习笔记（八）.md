---
name: JavaScript高级程序设计（第4版）学习笔记（八）
title: JavaScript高级程序设计（第4版）学习笔记（八）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：10. 函数"
time: 2020/10/26
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']

---

# JavaScript高级程序设计（第4版）学习笔记（八）

## 第 10 章 函数

函数是 ECMAScript 中最有意思的部分，这主要是因为函数实际上是对象。因为函数是对象，所以函数名就是指向函数对象的指针，且不一定与函数本身紧密绑定。

### 10.1 箭头函数

ES6 新增了胖箭头（=>）语法定义函数表达式的能力。其语法简洁，但也有很多场合不适用，箭头函数不能使用`arguments`、`super`和`new.target`。也不能用作构造函数，此外箭头函数也没有`prototype`属性。

> 扩展阅读：[箭头函数](https://es6.ruanyifeng.com/?search=hasInstance&x=0&y=0#docs/function#%E7%AE%AD%E5%A4%B4%E5%87%BD%E6%95%B0)

### 10.2 函数名

ES6 的所有函数对象都会暴露一个只读的`name`属性，其中包括函数的信息，即便函数没有名称，也会如实显示成空字符串。而若它是 Function 构造函数创建的，则会识别成 anonymous。

```javascript
var a = () => {}
a.name // "a"
var a = function b () {}
a.name // "b"
var a = new Function()
a.name // "anonymous"
```

而如果函数是一个获取函数、设置函数，或者使用`bind()`实例化，那么标识符前面会加上一个前缀：

```javascript
function foo () {}
console.log(foo.bind(null).name) // bound foo
var dog = {
  get age () {return 'age'},
  set age (val) {}
}
var propertyDescriptor = Object.getOwnPropertyDescriptor(dog, 'age')
console.log(propertyDescriptor.get.name) // get age
console.log(propertyDescriptor.set.name) // set age
```

### 10.5 默认参数值

**默认参数作用域与暂时性死区**

- 给多个参数定义默认值实际上跟使用`let`关键字顺序声明变量一样。

- 默认参数会按照定义它们的顺序依次被初始化。后定义默认值的参数可以引用先定义的参数，但不能倒过来。

  ```javascript
  function foo (name = 'Jack', test = name) {}
  function bar (name = test, test = 123) {}
  
  foo()
  bar() // Uncaught ReferenceError: Cannot access 'test' before initialization
  ```

  同样的道理，默认参数也不能引用函数体中定义的变量。

  ```javascript
  function foo (name = 'Jack', test = defaultName) {
    let defaultName = 123
  }
  foo() // Uncaught ReferenceError: defaultName is not defined
  ```

### 10.6 参数扩展与收集





> 本次阅读至 P295 320 10.6 参数扩展与收集
