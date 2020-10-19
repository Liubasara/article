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

```javascript
// 创建空映射
const m = new Map()
// 也可以传入一个可迭代对象，包含 key/value 的数组
const m1 = new Map([
  ['key1', 'value1'],
  ['key2', 'value2'],
  ['key3', 'value3']
])
// 使用自定义迭代器初始化映射
const m2 = new Map({
  [Symbol.iterator]: function* () {
    yield ['key1', 'value1']
    yield ['key2', 'value2']
    yield ['key3', 'value3']
  }
})
console.log(m2.size) // 3

// key 值也可以是 undefined
const m3 = new Map([
  []
])
console.log(m2.has(undefined)) // true
console.log(m2.get(undefined)) // undefined

// 初始化之后，可以使用 has() 和 get() 进行查询
const a = {}
m.has(a) // false
m.get(a) // undefined
m.set(a, 'test')
m.get(a) // test
m.has(a) // true
// 可以通过 size 属性获取映射中 key/value 的总数
m.size // 1
// 还可以使用 delete() 和 clear() 删除值
m.delete(a)
m.clear() // 清除该映射中的所有 key/value 值

// set 方法会返回映射实例，所以可以把多个操作连缀起来
const m4 = new Map().set('key1', 'val1').set('key2', 'val2')
```

`Map`与对象不同的是，它可以使用任何 JavaScript 数据类型作为 key，其内部使用严格对象相等的标准来检查 key 的匹配性。

但有一点比较有意思的是，在 JavaScript 中`===`严格相等规定 NaN 不与任何值相等，但在 Map 中，作为 key 的两个 NaN 是相等的，也就是说会进行覆盖。

```javascript
var a = Number('adfasf')
undefined
a
NaN
var b = Number('www')
undefined
b
NaN
var c = new Map().set(a, 'a').set(b, 'b')
undefined
c.get(a) // b
```

#### 6.4.2 顺序与迭代

Map 的默认迭代器类似于 Object 的`entries`方法，每次迭代会返回一个代表了 key/value 值的数组，可以直接被`for-of`、`forEach`、`[...m]`等方法使用。

同时每个实例也有各自的`keys()`、`values()`方法，效果也与 Object 类似。

#### 6.4.3 选择 Object 还是 Map

对于多数 Web 开发任务来说，选择 Object 还是 Map 只是个人喜好问题，不过对于在乎内存和性能的开发者来说，两者之间确实存在区别。

- 内存占用角度上来说，给定固定大小的内存，Map 大约可以比 Object 多存储 50% 的键值对。
- 从插入性能中来说，如果代码涉及大量插入操作，Map 的性能更佳
- 查找速度来说，如果只包含少量的键值对，Object 有时候速度更快。在把 Object 当成数组使用的情况下(比如使用连续整数作为属性)，浏览器引擎可以进行优化，在内存中使用更高效的布局。这对 Map 来说是不可能的。如果代码涉及大量查找操作，那么某些情况下可能选择 Object 更好一些。
- 删除性能来说，使用`delete`来删除 Object 的属性的性能一直饱受诟病，对于大多数浏览器引擎来说，如果涉及到删除属性操作，都应该毫不犹豫地选择 Map

### 6.5 WeakMap

> 拓展阅读：
>
> - [WeakMap的优势和使用](https://zhuanlan.zhihu.com/p/25454328)

WeakMap 为这门语言带来了更强大的键值对存储机制，其中 weak 描述的是 JavaScript 垃圾回收中对待“弱映射”中 key 的方式。

#### 6.5.2 弱键

WeakMap 中对于 key 的引用不属于正式的引用，不会阻止垃圾回收。

```javascript
const wm = new WeakMap()
const container = {
  key: {}
}
wm.set(container.key, 'val')
function removeReference () {
  container.key = null
}
```

如上，container 对象维护着一个对弱映射键的引用，因此这个对象键不会成为垃圾回收的目 标。不过，如果调用了 removeReference()，就会摧毁键对象的最后一个引用，垃圾回收程序就可以 把这个键/值对清理掉。

#### 6.5.3 不可迭代键

因为 WeakMap 中 key 的值随时都可以被销毁，所以没必要提供迭代其键值对的 API（？？为什么？？），也不需要像`clear()`这样一次性销毁所有键值对的方法。

WeakMap 实例之所以限制只能用对象作为键，是为了保证只有通过键对象的引用才能取得值。如果允许原始值，那就没办法区分初始化时使用的字符串字面量和初始化之后使用的一个相等的字符串了。

#### 6.5.4 使用弱映射

以下是一些可以用到弱映射的场景：

- 私有变量

  ```javascript
  const User = (() => {
    const wm = new WeakMap()
    function MyUser (id) {
      this.idProperty = Symbol('id')
      this.setPrivateId(id)
    }
    MyUser.prototype.setPrivateId = function (id) {
      this.setPrivate(this.idProperty, id)
    }
    MyUser.prototype.getPrivateId = function () {
      return this.getPrivate(this.idProperty)
    }
    MyUser.prototype.setPrivate = function (property, value) {
      const privateMembers = wm.get(this) || {}
      privateMembers[property] = value
      wm.set(this, privateMembers)
    }
    MyUser.prototype.getPrivate = function (property) {
      return wm.get(this)[property]
    }
    return MyUser
  })()
  
  const user = new User(123)
  console.log(user.getPrivateId()) // 123
  console.log(user.setPrivateId(567))
  console.log(user.getPrivateId()) // 567
  ```

- DOM 节点元数据

  用于将 DOM 的节点和某些数据相关联的时候，当节点被删除后就可以立即释放内存而无需顾虑 WM 的引用。

  ```javascript
  const wm = new WeakMap()
  let button = document.querySelector('button')
  wm.set(button, 'firstButton')
  button.parentNode.removeChild(button)
  button = null
  // DOM 节点引用被清除，可被垃圾回收处理
  ```

### 6.6 Set

与 Map 很像，只不过相对于对象，更接近一个没有重复子元素的数组，常用于去重。

```javascript
var a = [1,1,3,4,5]
var b = new Set([...a]) // [1,3,4,5]
```

有下列方法或属性：

- has
- add
- delete
- clear
- size

### 6.7 WeakSet

与 Map 和 WeakMap 的区别类似，弱集合中的值同样只能是 Object 或是继承自 Object 的类型。其中的元素同样不可迭代，由于 Set 类型没有相应的 Get 方法，**这也就导致了一旦把对象放进了 WeakSet 中，就没有办法通过 WeakSet 访问它了，只能通过 has 方法来判断其是否存在**。

这也导致了相对于 WeakMap 而言，WeakSet 实例的用处没那么大，下面是它的应用场景之一：回收 DOM

```javascript
const disabledElements = new WeakSet()
const button = document.querySelector('button')
// 通过加入对应集合，给这个节点打上禁用标签
disabledElements.add(button)
disabledElements.has(button)
button.parentNode.removeChild(button)
button = null
// DOM 节点引用被清除，可被垃圾回收处理
```

这样，只要 WeakSet 中任何元素从 DOM 树中被删除，垃圾回收程序就可以忽略其存在，而立即释放其内存（假设没有其他地方引用这个对象）。 

### 6.8 迭代与扩展操作

ES6 的 ECMAScript 中，定义了 4 种原生集合类型拥有默认迭代器：

- Array
- 所有定型数组（这不知所以的翻译...应该指的是类数组对象吧？？）
- Map
- Set

这意味着上述所有类型都支持：

- 顺序迭代，都可以传入`for-of`循环
- 支持兼容扩展操作符`...`
- 支持多种构建方法，如`Array.of()`和`Array.from()`静态方法

