---
name: 你不知道的JavaScript学习笔记（十二）
title: 《你不知道的JavaScript》学习笔记（十二）
tags: ['读书笔记', '你不知道的JavaScript']
categories: 学习笔记
info: "你不知道的JavaScript 下卷 第二部分 第4章 异步流控制 第5章 集合 第6章 新增API"
time: 2019/3/27
desc: '你不知道的JavaScript, 资料下载, 学习笔记, 下卷, 第二部分, 第4章 异步流控制, 第5章 集合, 第6章 新增API'
keywords: ['前端', '你不知道的JavaScript', '学习笔记', '下卷', '第二部分', '第4章 异步流控制', '第5章 集合', '第6章 新增API']
---

# 《你不知道的JavaScript》学习笔记（十二）

## 第4章 异步流控制

本章炒 Promise 的冷饭。

Promise对只用回调的异步方法给予了重大改进，即提供了有序性、可预测性和可靠性。

[这篇博客](https://blog.liubasara.info/#/post/%E4%BD%A0%E4%B8%8D%E7%9F%A5%E9%81%93%E7%9A%84JavaScript%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0%EF%BC%88%E4%B8%83%EF%BC%89)中已经详细记载了 Promise 的一些原理和细节，建议搭配本章和之前生成器的一些知识点一起食用。

## 第5章 集合

本章主要介绍一些 ES6 中新的內建数据结构(Map、Set、WeakMap、WeakSet)。

### 5.1 TypedArray

关于二进制存储数组位图多视图的内容，没看懂。

// TOREAD

### 5.2 Map

在 ES6 之前，对象是创建无序键值对数据结构(map)的主要机制，但是，对象作为映射的主要缺点是不能使用非字符串值作为键。

```javascript
var m = {}
var x = {id: 1}
var y = {id: 2}
m[x] = 'foo'
m[y] = 'bar'
console.log(m)
// {[object Object]: "bar"}
```

上述代码中，看似设置两个不同的键值对，但由于对象的特殊机制，m 中其实只设置了一个键。

在 ES6 中定义了一种新的数据形式 Map，使用Map可以完美实现hash中的键值对。

```javascript
var m = new Map()
var x = {id: 1}
var y = {id: 2}
m.set(x, 'foo')
m.set(y, 'bar')

m.get(x)
m.get(y)
```

这里唯一的缺点就是不能使用方括号`[]`语法设置和获取值，只能使用`get()`方法和`set()`方法。

要从 map 中删除一个元素，不要使用 delete 运算符，而要使用`delete()`方法。

```javascript
m.delete(x)
```

也可以通过`clear()`方法来清除整个 map 的内容。

更多 Map 的用法，可以参考[这里](http://es6.ruanyifeng.com/#docs/set-map)

### 5.3 WeakMap

WeakMap 是 Map 的变体，二者的多数外部行为特性都是一样的，区别在于内部内存分配的工作方式。

WeakMap 只接受对象作为键。这些对象是被**弱持有**的，也就是说如果对象本身是被垃圾回收的话，在  WeakMap 中的这个项目也会被移除。

WeakMap 没有`size`属性或`clear()`方法，也不会暴露任何键、值或项目上的迭代器。所以即使你解除了对`x`的引用，它将会在垃圾回收时从m中移除。虽然没有什么办法能观测到这一现象，但 JavaScript 是这么解释的，姑且也就这么相信吧（真是随便啊喂）。

需要注意的是，WeakMap 只是弱持有它的键，而不是值。

### 5.4 Set

set 是一个值的集合，其中的值唯一（重复会被忽略）。

set 的 API 和 map 类似。只是`add(..)`方法代替了`set(..)`方法，没有`get(..)`方法。

set 的唯一性不允许强制转换，所以`1`和`"1"`被认为是不同的值。

更多 Set 的用法，可以参考[这里](http://es6.ruanyifeng.com/#docs/set-map)

### 5.5 WeakSet

跟 WeakMap 一样，WeakSet 对其值也是弱持有的，且 WeakSet 中的值夜必须是对象，不能是原生类型值。

## 第6章 新增API

本章系统介绍 ES6 中新增的各类 API。

### 6.1 Array

- Array.of(..) 取代了 Array(..) 称为了数组的推荐函数形式构造器。用法与区别如下

  ```javascript
  var a = Array(3)
  a.length // 3
  a[0] // undefined
  
  var b = Array.of(3)
  b.length // 1
  b[0] // 3
  
  var c = Array.of(1, 2, 3)
  c.length // 3
  c // [1, 2, 3]
  ```

- 静态函数 Array.from(..) 用于将 JavaScript 中的类数组对象，具体来说是有`length`属性且大于等于0的整数值对象，转换为真正的数组。

  ```javascript
  var a = Array.from({length: 4})
  a // [undefined, undefined, undefined, undefined]
  ```

  此外，如果为该方法提供第二个参数，一个回调方法的话，该函数会把来自于源的每个值映射 / 转换到返回值。

  ```javascript
  var arrLike = {
    length: 4,
    2: 'foo'
  }
  var test = Array.from(arrLike, function (val, index) {
    if (typeof val === 'string') {
      return 'test'
    } else {{
      return index
    }}
  })
  test // [0, 1, "test", 3]
  ```

- 原型方法 `Array.prototype.fill()`,用指定值完全(或部分)填充已存在的数组。

> 本次阅读至P206 6.1.5 原型方法fill(..) 228