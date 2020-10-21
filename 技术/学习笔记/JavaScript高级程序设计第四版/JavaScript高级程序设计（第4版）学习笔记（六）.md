---
name: JavaScript高级程序设计（第4版）学习笔记（六）
title: JavaScript高级程序设计（第4版）学习笔记（六）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：8. 对象、类与面向对象编程"
time: 2020/10/20
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']


---

# JavaScript高级程序设计（第4版）学习笔记（六）

## 第 8 章 对象、类与面向对象编程

### 8.1 理解对象

#### 8.1.1 属性的类型

对象的属性分两种：数据类型和访问器类型。

**1. 数据类型**

数据类型拥有以下四类属性：

- [[Configurable]]：表示属性是否可以通过`delete`删除并重新定义，是否可以修改其特性，以及是否可以将它改为访问器属性，默认为 true。
- [[Enumerable]]：表示是否可以通过`for-in`循环返回，默认为 true
- [[Writable]]
- [[Value]]

可以使用`Object.defineProperty()`对这些特性进行设置。

**2. 访问器属性**

访问器属性包含一个 getter 和一个 setter。拥有下列特性：

- [[Configurable]]
- [[Enumerable]]
- [[Get]]
- [[Set]]

访问器属性不能直接定义，必须使用`Object.defineProperty`进行设置。（？？）

PS：新版（ES7 还是 ES8 ）添加了 get set 声明符，已经可以直接设置了，如下：

```javascript
var a = {
  b_:1,
  get b () {
    return this.b_
  },
  set b (val) {
    this.b_ = val
  }
}
a.b
// 1
a.b = 2
a.b
// 2
```

> 在不支持 Object.defineProperty()的浏览器中没有办法修改[[Configurable]]或[[Enumerable]]。

#### 8.1.2 定义多个属性

使用`Object.defineproperties()`可以一次性定义多个属性的特性。

```javascript
var book = {}
Object.defineProperties(book, {
  year_: {
    value: 111
  },
  year: {
    get () {
      return this.year_
    },
    set (val) {
      this.year_ = val
    }
  }
})
```

#### 8.1.3 读取属性的特性

使用`Object.getOwnPropertyDescriptor()`方法可以取得指定属性的属性描述符。

ES8 新增了`Object.getOwnPropertyDescriptors()`静态方法，用于在每个属性中调用`Object.getOwnPropertyDescriptor()`并在一个新对象中返回。

#### 8.1.4 合并对象

使用`Object.assign`或拓展合并符`...`都可以对对象进行浅复制。

如果赋值期间出错，则操作会中止并退出，同时抛出错误。Object.assign() 没有“回滚”之前赋值的概念，因此它是一个尽力而为、可能只会完成部分复制的方法。 

#### 8.1.5 对象标识及相等判定

使用`Object.is`可以进行精准判定，与`===`很像，但考虑了很多边界情形，比如 NaN 相等，+0 和 -0 不相等等等。

#### 8.1.6 增强的对象语法

- 属性值简写

- 可计算属性

  ```javascript
  const nameKey = 'name'
  const person = {
    [nameKey]: 'Matt'
  }
  ```

- 简写方法名

#### 8.1.7 对象解构

有以下解构场景：

- 嵌套解构
- 部分解构
- 参数上下文匹配

### 8.2 创建对象







> 本次阅读至P220 245 8.2 创建对象

