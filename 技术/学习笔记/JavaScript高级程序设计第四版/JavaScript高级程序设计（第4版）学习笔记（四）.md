---
name: JavaScript高级程序设计（第4版）学习笔记（四）
title: JavaScript高级程序设计（第4版）学习笔记（四）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：6. 集合引用类型"
time: 2020/10/15
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']

---

# JavaScript高级程序设计（第4版）学习笔记（四）

## 第 6 章 集合引用类型

### 6.1 Object

创建一个 Object 的实例有两种方式，使用`new Object`或者直接采用对象字面量（object literal）表示法，如`let a = {}`

### 6.2 Array

ES6 中新增了两个用于创建数组的静态方法：`from()`和`of()`。`from()`用于将类数组结构转换为数组实例。

```javascript
var a = {}
Object.defineProperty(a, Symbol.iterator, {
  value: function *() {
    yield 1
    yield 2
    yield 3
  }
})
// 可以使用任何可迭代对象
Array.from(a) // [1, 2, 3]

// 也可以使用类数组类型（有 length 属性）的对象
var b = {0: 1, 1: 2, length: 2}
Array.from(b) // [1, 2]
```

Array.of 方法主要解决数组声明不一致的问题，之前我们在声明一个数组的时候可以使用下面的方法。同时可作为`Array.prototype.slice.call`用法的替代品。

```javascript
var arrays = new Array(10); //数组长度是10 [empty * 10]
var array2 = new Array(1,2,3,4,5); //有参数组成的数组 [1,2,3,4,5]
// 而 Array.of 方法声明出来的数组都是由参数组成的数组 。
Array.of(10) // [10]
```

#### 6.2.2 数组空位

使用字面量方式初始化数组时，可以使用一串逗号来创建空位。

```javascript
const a = [,,,,,] // 创建了包含 5 个元素的数组
```

使用`for-of`方法可以遍历到这些空位，但如果使用 ES6 之前的方法，如 map、forEach 之类的方法，就会忽略这个空位。

```javascript
var a = [,,,,,]
for (let i of a) console.log(i) // undefined * 5
a.forEach(item => console.log(item)) // 无效果
var b = a.map((item, index) => index) // [empty * 5]
```

> 由于行为不一致和存在性能隐患，因此实践中要避免使用数组空位。如果确实需要 空位，则可以显式地用 undefined 值代替。

#### 6.2.3 数组索引

数组中最后一个元素的索引始终是 length - 1，因此下一个新增槽位的索引就是 length。如果修改了 length 值的大小，相当于同时修改了数组的长度。length 之后的元素会无法被迭代。

> 数组最多可以包含 4 294 967 295 个元素，这对于大多数编程任务应该足够了。如果 尝试添加更多项，则会导致抛出错误。以这个最大值作为初始值创建数组，可能导致脚本 运行时间过长的错误。

#### 6.2.4 检测数组

ECMAScript 提供了 Array.isArray() 方法。这个方法的目的就是确定一个值是否为数组，而不用管它是在哪个全局执行上下文中创建的。

**本节其他内容与第三版类似**

#### 6.2.14 归并方法

ECMAScript 为数组提供了两个归并方法，`reduce()`和`reduceRight()`，两者都会迭代数组的所有项并在此基础上构建一个最终返回值。区别是一个是从第一项遍历到最后一项，而另一个则是从最后一项遍历至第一项。

### 6.3 定型数组 typed array

JavaScript 并没有“TypedArray”类型，它所指的其实是一种特殊的包含数值类型的数组。在 WebGL 的早期版本中，因为 JavaScript 数组与原生数组之间不匹配，所以出现了性能问题。图形驱动程序 API 不需要以 JavaScript 默认双精度浮点格式传递它们的数值，而这恰恰是 JavaScript 数组存在内存中的格式，所以以前每次 WebGL 都需要在目标环境分配新数组，然后以当前格式迭代数组将其传唤为新数组中的适当格式，造成了严重的性能浪费。

为了解决这个问题，JavaScript 开始为一些定型的数据格式提供接口，这些生成的类数组中只能存储以特定格式保存的数据，硬性的存储规则换来的则是高效的存储性能。

#### 6.3.2 ArrayBuffer

`ArrayBuffer()`是一个普通的 JavaScript 构造函数，可用于在内存中分配特定数量的字节空间。某种程度上类似于 C++的 `malloc()`。

要读取或写入 ArrayBuffer，就必须通过视图。视图有不同的类型，但引用的都是 ArrayBuffer 中存储的二进制数据。

以下是一些视图类型：

- DataView

  ```javascript
  const buf = new ArrayBuffer(16)
  // DataView 默认使用整个 ArrayBuffer
  const fullDataView = new DataView(buf)
  fullDataView.setInt8(0, 1)
  // 输出内容
  fullDataView.getInt8(0) // 1
  fullDataView.getInt8(1) // 0
  ```

- Int32Array

  一种类型更加明确的 DataView。

  > 虽然概念上与 DataView 接近，但定型数组的区别 在于，它特定于一种 ElementType 且遵循系统原生的字节序。相应地，定型数组提供了适用面更广的 API 和更高的性能。设计定型数组的目的就是提高与 WebGL 等原生库交换二进制数据的效率。由于定 型数组的二进制表示对操作系统而言是一种容易使用的格式，JavaScript 引擎可以重度优化算术运算、 按位运算和其他对定型数组的常见操作，因此使用它们速度极快。

### 6.4 Map

作为 ES6 的新增特性，`Map`是一种新的类型集合，为这门语言带来了真正的 key/value 存储机制。

#### 6.4.1 基本 API









> 本次阅读至P164 6.4.1 基本API 189

