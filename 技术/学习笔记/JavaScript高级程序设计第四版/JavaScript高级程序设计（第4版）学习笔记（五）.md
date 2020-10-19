---
name: JavaScript高级程序设计（第4版）学习笔记（五）
title: JavaScript高级程序设计（第4版）学习笔记（五）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：7. 迭代器与生成器"
time: 2020/10/19
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']


---

# JavaScript高级程序设计（第4版）学习笔记（五）

## 第 7 章 迭代器与生成器

ES6 新增（照抄其他语言）的高级特性：迭代器和生成器能够更清晰、高效、方便地实现迭代。

### 7.1 理解迭代

最简单的迭代就是 for 循环迭代，但这种方法只适用于数组。还有一些像 forEach 这样的迭代函数，虽然比较常用，但却没有办法标识迭代何时终止，且回调结构也比较笨拙。

在此基础上，ES6 和其他语言一样支持了迭代器模式。

### 7.2 迭代器模式

可迭代对象（iterable）是一种抽象说法，任何实现`Iterable`接口的数据结构都可以被实现`Iterator`接口的结构“消费”（consume）（又是一段看不懂的神翻译.....擦）。

#### 7.2.1 可迭代协议 Iterable && 7.2.2 迭代器协议

（PS：这两小节得一块看才比较好理解，而且又是不该翻译的乱翻译......）

可迭代协议要求同时具备两种能力：

- 支持迭代的自我识别（？？）能力
- 创建实现 Iterator 接口的对象的能力

这意味着必须暴露一个特殊的`Symbol.iterator`作为 key，这个默认迭代器属性必须引用一个工厂函数（生成器），调用该函数会返回一个新的迭代器。

迭代器是一种一次性使用的对象，用于迭代与其关联的可迭代对象。迭代器 API 使用`next()`方法在可迭代对象中遍历数据，每次成功调用，都会返回一个`IteratorResult`对象。（我真是谢谢作者没翻译这个名词，不然险些又看不懂...）

```javascript
// 一个 IteratorResult 类型的对象包含两个属性：done 和 value
// done 代表是否还可以通过调用 next 取得下一个值，value 包含可迭代对象的当前值

// eg. 可迭代对象
let arr = ['foo', 'bar']
// 调用生成器生成
let iter = arr[Symbol.iterator]()
console.log(iter.next()) // {value: "foo", done: false}
console.log(iter.next()) // {value: "bar", done: false}
console.log(iter.next()) // {value: undefined, done: true}
```

迭代器并不知道 怎么从可迭代对象中取得下一个值，也不知道可迭代对象有多大。只要迭代器到达 done: true 状态，后续调用 next 就一直返回同样的值了。

不同迭代器的实例相互之间没有联系，只会独立地遍历可迭代对象。

#### 7.2.3 自定义迭代器

利用这个原理，**就可以自定义迭代器来迭代任何一个自定义对象了**：

```javascript
var a = {}
a[Symbol.iterator] = function () {
  var count = 1
  return {
    next () {
      return {done: count >= 3, value: count++}
    }
  }
}
for (let i of a) {console.log(i)} // 1 2

// 在某些奇葩的情况下，可能会出现要求每个对象只能迭代一次的需求
// 此时可以这样，确保每次生成器生成的都是一样的迭代器
var b = {}
b.count = 1
b.next = function () {
  return {done: this.count >= 3, value: this.count++}
}
b[Symbol.iterator] = function () { return this }
for (let i of b) {console.log(i)} // 1 2
for (let i of b) {console.log(i)} // undefinded
```

#### 7.2.4 提前终止迭代器

在某些情况下，如需要提前关闭迭代的时候，比如`break`或者`throw`的情况下，可以使用`return()`方法执行提前关闭时候的逻辑。（不当人的翻译...简单来说就是个停止迭代时候的钩子函数）

`return()`方法必须返回一个有效的 IteratorResult 对象。简单情况下，可以只返回`{ done: true }`。 

```javascript
var a = {}
a[Symbol.iterator] = function () {
  var count = 1
  return {
    next () {
      return {done: count >= 3, value: count++}
    },
    return () {
      console.log('尚未迭代完成，提前终止')
      return { done: true }
    }
  }
}
for (let i of a) {
  if (i === 2) break
  console.log(i)
} // 1 尚未迭代完成
```

> 因为 return() 方法是可选的，所以并非所有迭代器都是可关闭的。要知道某个迭代器是否可关闭， 可以测试这个迭代器实例的 return 属性是不是函数对象。不过，仅仅给一个不可关闭的迭代器增加这 个方法并不能让它变成可关闭的。这是因为调用 return()不会强制迭代器进入关闭状态。即便如此， return() 方法还是会被调用。

下次如果重新调用这个迭代器，迭代会从暂停的地方重新开始（PS：但这个好像只能在数组的迭代器使用，自定义的不行，**初步猜测也许是上面的自定义 iterator 不是生成器函数的原因**，具体原因暂时不明）。

```javascript
let a = [1, 2, 3, 4, 5]
let iter = a[Symbol.iterator]()
iter.return = function () {
  console.log('提前退出')
  return { done: true }
}
for (let i of iter) {
  console.log(i)
  if (i === 2) break
}
// 1 2 提前退出
for (let i of iter) {
  console.log(i)
}
// 3 4 5
```

### 7.3 生成器







> 本次阅读至 P192 7.3生成器 217
