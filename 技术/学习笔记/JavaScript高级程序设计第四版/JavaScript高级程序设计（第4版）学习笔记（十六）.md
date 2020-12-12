---
name: JavaScript高级程序设计（第4版）学习笔记（十六）
title: JavaScript高级程序设计（第4版）学习笔记（十六）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：25. 客户端存储 26. 模块"
time: 2020/12/4
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']
---

# JavaScript高级程序设计（第4版）学习笔记（十六）

## 第 25 章 客户端存储

部分冷饭。

安全标志`secure`是 cookie 中唯一的非键值对，只需一个 secure 就可以，比如：`Set-Cookie: name=value; domain=.example.com; path=/; secure`。

还有一种叫作 HTTP-only 的 cookie。HTTP-only 可以在浏览器设置，也可以在服务器设置，但只能在服务器上读取，这是因为 JavaScript 无法取得这种 cookie 的值。

### 25.3 IndexedDB

IndexedDB 是类似于 MySQL 或 Web SQL Database 的数据库。与传统数据库最大的区别在于，INdexedDB 使用对象存储而不是表格存储数据，它就是一个在公共命名空间下的一组对象存储，类似于 NoSQL 风格的实现。

使用 IndexedDB 数据库的第一步是调用`indexedDB.open()`方法。该方法会返回`IDBRequest`的实例，可以在这个实例上添加`onerror`和`onsuccess`事件处理程序。

```javascript
const version = 1
const request = indexedDB.open('admin', version)
let db

request.onerror = event => alert(`Failed to open: ${event.target.errorCode}`)
request.onsuccess = event => db = event.target.result
```

`open()`操作会创建一个新数据库，然后触发 upgradeneeded 事件。可以为这个事件设置处理程序，并在处理程序中创建数据库模式。

使用`db.createObjectStore('users', { keyPath: 'username' })`可以为数据库创建一个对象存储（PS：就是创建一个 users 表的意思），这里第二个参数的`keyPath`属性表示应该用于作为 key 的存储对象的属性名。

> 如果数据库存在，而你指定了一个升级版的版本号，则会立即触发 upgradeneeded 事件，因而可以在事件处理程序中更新数据库模式。

```javascript
const version = 2
const request = indexedDB.open('admin', version)
let db

request.onerror = event => alert(`Failed to open: ${event.target.errorCode}`)
request.onsuccess = event => {
  db = event.target.result
  console.log('onsuccess')
}
request.onupgradeneeded = (event) => {
  console.log('onupgradeneeded')
  const db = event.target.result
  // 如果存在则删除当前 objectStore，测试的时候可以这样做
  // 但这样会在每次执行事件处理程序时删除已有数据
  if (db.objectStoreNames.contains('users')) {
    db.deleteObjectStore('users')
  }
  // 该方法只能在 onupgradeneeded 或 onsucess 事件中调用
  db.createObjectStore('users', { keyPath: 'username' })
}
```

#### 25.3.3 事务

创建了对象存储之后，剩下的所有操作都是通过事务完成的。任何时候，只要想要读取或修改数据，都要通过事务把所有修改操作组织起来。

```javascript
const transaction = db.transaction()
```

事务对象本身有两个事件处理程序：onerror 和 oncomplete。

通过`transaction.objectStore`可以获得对应的表，然后就可以使用下列方法来进行 CRUD 了：

- add()：添加对象
- put()：更新对象
- get()：取得对象
- delete()：删除对象

## 第 26 章 模块

在 ECMAScript 6 模块规范出现之前，虽然浏览器原生不支持模块的行为，但迫切需要这样的行为。

因为 JavaScript 是异步加载的解释型语言，所以得到广泛应用的各种模块实现也表现出不同的形态。这些不同的形态决定了不同的结果，但最终它们都实现了经典的模块模式。

### 26.1 理解模块模式

因为 JavaScript 可以异步执行，可以让 JavaScript 通知模块系统在必要时加载新模块。

### 26.2 凑合的模块系统

为按照模块模式提供必要的封装，ES6 之前的模块有时候会使用函数作用域和 IIFE 将模块定义封装在匿名闭包之中。

类似的，还有一种返回一个对象的“泄露模块模式”。

### 26.3 使用 ES6 之前的模块加载器

> 拓展阅读：[JavaScript 模块化的历史进程](https://mp.weixin.qq.com/s/W4pbh5ivGu-RGkz1fdDqwQ)

#### 26.3.1 CommonJS

该规范概述了同步声明依赖的模块定义。这个规范主要用于在服务器端。

> 问：为何 CommonJS 不能用在浏览器端？
>
> 1. 由于外层没有 function 包裹，被导出的变量会暴露在全局中。
> 2. 在服务端 require 一个模块，只会有磁盘 I/O，所以同步加载机制没什么问题；但如果是浏览器加载，一是会产生开销更大的网络 I/O，**二是浏览器的网络请求天然异步，会导致产生时序上的错误**。

#### 26.3.2 异步模块定义

异步模块定义简称为 AMD（Asynchronous Module Definition）的模块定义系统则以浏览器为目标执行环境。

AMD 的核心是用函数包装模块定义，防止声明全局变量，并允许加载器库控制何时加载模块。包装模块的函数是全局 define 函数，它是由 AMD 加载库实现定义的。

AMD 模块可以使用字符串标识符指定自己的依赖，而 AMD 加载器会在所有依赖模块加载完毕后立即调用模块工厂函数。

```javascript
// 定义 moduleA 模块，moduleA 依赖 moduleB
// moduleB 会异步加载
define('moduleA', ['moduleB'], function (moduleB) {
  return {
    stuff: moduleB.doStuff()
  }
})
```

AMD 同样支持 require 对象和 exports 对象，require 用于动态依赖，而 exports 用于定义导出的模块对象。

```javascript
define('moduleA', ['require', 'exports'], function (require, exports) {
  // 动态依赖
  var moduleB = require('moduleB')
  // 导出 moduleA
  exports.stuff = moduleB.doStuff()
})
```

#### 26.3.3 通用模块定义

通用模块定义（UMD，Universal Module Definition）规范用于统一 CommonJS 和 AMD 生态系统。UMD 可用于创建这两个系统都可以使用的模块代码，本质上，UMD 定义的模块会在启动时检测要使用哪个模块系统，然后进行适当的配置，并把所有逻辑包装在一个 IIFE 中。

如下是一个 UMD 模块定义的示例：

```javascript
(function (root, factory) {
  if (typeof define === 'function' && define.amd) {
    // 证明当前环境是 AMD 模块
    define(['moduleB'], factory)
  } else if (typeof module === 'object' && module.exports) {
    // Node 环境，不支持严格 CommonJS，但可以在 Node 这样支持 module.exports 的类 CommonJS 环境下使用
    module.exports = factory(require('moduleB'))
  } else {
    // 浏览器全局上下文(root 是 window)
    root.returnExports = factory(root.moduleB)
  }
})(this, function (moduleB) {
  // 以某种方式使用 moduleB
  // 将返回值作为模块的导出，如该例子就返回了一个对象
  // 但是模块也可以返回函数作为导出值
  return {}
})
```

此模式有支持严格 CommonJS 和浏览器全局上下文的变体。不应该期望手写这个包装函数，它应该由构建工具自动生成。开发者只需专注于模块的内由容，而不必关心这些样板代码。

#### 26.3.4 模块加载器终将没落

随着 ECMAScript 6 模块规范得到越来越广泛的支持，本节展示的模式最终会走向没落。但 CommonJS 与 AMD 之间的冲突正是我们现在享用的 ECMAScript 6 模块规范诞生的温床。

### 26.4 使用 ES6 模块

ES6 最大的一个改进就是引入了模块规范，从很多方面看，ES6 模块系统是集 AMD 和 CommonJS 之大成者。

#### 26.4.1 模块标签及定义

ES6 的模块是作为一整块 JavaScript 代码而存在的，带有 type="module" 属性的 \<script\> 标签会告诉浏览器相关代码应该作为模块执行，而不是作为传统的脚本执行。这些模块脚本会像 \<script defer\> 一样按顺序下载，延迟到文档解析完成后才执行。

同一个模块无论在一个页面中被加载多少次，也不管它是如何加载的，实际上都只会加载一次。

```html
<!-- moduleA 在这个页面只会被加载一次 -->
<script type="module">
	import './moduleA.js'
</script>
<script type="module">
	import './moduleA.js'
</script>
<script type="module" src="./moduleA.js"></script>
<script type="module" src="./moduleA.js"></script>
```

#### 26.4.5 模块导入

`import`必须出现在模块的顶级，且路径必须是纯字符串，不能是动态计算的结果。

#### 26.4.6 模块转移导出

模块导入的值可以直接通过管道转移到导出，也可以将默认导出转换为命名导出，或者如果想把一个模块的所有命名导出集中到一块，可以像下面这样在 bar.js 中使用 * 导出。

```javascript
export * from './foo.js'
// 还可以明确列出要从外部模块转移本地导出的值。该语法支持使用别名：
export { foo, bar as myBar } from './foo.js'
// 类似地可以将外部模块的默认导出重用为当前模块的默认导出：
export { default } from './foo.js'
// 或者相反，将某个命名导出为默认
export { foo as default } from './foo.js'
```

#### 26.4.8 向后兼容

有些浏览器在遇到 \<script\> 标签上无法识别的 type 属性时会拒绝执行其内容，这意味着 module 为属性的脚本不会被执行。因此可以在 \<script type="module"\> 标签旁边添加一个回退 \<script\> 标签：

```html
<!-- 不支持模块的浏览器不会执行这里的代码 -->
<script type="module" src="module.js"></script>
<!--
  兼容标签: 支持模块的浏览器不会执行这段脚本，不支持模块的浏览器会忽略掉 nomodule 属性进行执行
-->
<script nomodule src="script.js"></script>
```



