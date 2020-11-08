---
name: JavaScript高级程序设计（第4版）学习笔记（十一）
title: JavaScript高级程序设计（第4版）学习笔记（十一）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：15. DOM扩展"
time: 2020/11/6
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']

---

# JavaScript高级程序设计（第4版）学习笔记（十一）

## 第 15 章 DOM 扩展

DOM 扩展的两个标准：Selectors API 和 HTML5。这两个标准体现了社区需求和标准化某些手段及 API 的愿景。

本章所有内容已经得到了主流浏览器的支持，除非特别说明。

### 15.1 Selectors API

JavaScript 库中最流行的一种能力就是根据 CSS 选择符的模式匹配 DOM 元素。

#### 15.1.1 querySelector

querySelector() 方法接收 CSS 选择符参数，返回匹配模式的第一个后代元素，如果没有匹配选项返回 null。

#### 15.1.2 querySelectorAll

跟 querySelector 一样接收一个用于查询的参数，会返回所有匹配的节点，是一个 NodeList 的静态实例。

> 再强调一次，querySelectorAll() 返回的 NodeList 实例一个属性和方法都不缺，但它是一个静态的“快照”，而非“实时”的查询。这样的底层实现避免了使用 NodeList 对象可能造成的性能问题。

#### 15.1.3 matches

`matches`方法（在规范草案中称为`matchesSelector`）接收一个 CSS 选择符参数，如果元素匹配则该选择符返回`true`，否则返回`false`。

```javascript
if (document.body.matches('body')) {
  console.log('匹配')
}
// 匹配
```

### 15.2 元素遍历

Element Traversal API 为 DOM 元素添加了 5 个属性：

- childElementCount：返回子元素数量（不包含文本节点和注释）
- firstElementChild，指向第一个 Element 类型的子元素（Element 版 firstChild）
- lastElementChild，指向最后一个 Element 类型的子元素
- previousElementSibling，指向前一个 Element 类型的同胞元素（Element 版的 nextSibling）
- nextElementSibling：指向后一个 Element 类型的同胞元素

### 15.3 HTML5

> HTML5 代表着与以前的 HTML 截然不同的方向。在所有以前的 HTML 规范中，从未出现过描述 JavaScript 接口的情形，HTML 就是一个纯标记语言。JavaScript 绑定的事，一概交给 DOM 规范去定义。
>
> 然而，HTML5 规范却包含了与标记相关的大量 JavaScript API 定义。其中有的 API 与 DOM 重合， 定义了浏览器应该提供的 DOM 扩展。

#### 15.3.1 CSS 类扩展

- getElementsByClassName：取得所有类名中包含 username 和 current 元素

  ```javascript
  // 取得所有类名中包含 username 和 current 元素
  document.getElementByClassName('username current')
  // 取得 ID 为 myDiv 的元素子树中所有包含 selected 类的元素
  document.getElementById('myDiv').getElementsByClassName('selected')
  ```

- classList 属性

  HTML5 之前要修改类名，只能通过 className 属性实现添加，但该属性是个字符串，使用时需要先把 className 拆开，删除不想要那个，再把剩余类的字符串设置回去。

  HTML 5 添加了 classList 提供了更简单也更安全的实现方式，其返回一个 DOMTokenList 类型的实例，包含以下属性或方法：

  - item()：或是中括号，用于取得个别元素
  - add()：向类名列表添加指定字符串值，若这个值亿存在，则什么也不做
  - contains()：返回布尔值，表示给定的属性是否存在
  - remove()：从类名列表中删除指定的字符串值
  - toggle()：如果类名列表中已经存在指定的 value，则删除，若不存在，则添加
  - length：属性表示自己包含多少项

#### 15.3.2 焦点管理

HTML5 新增了辅助 DOM 焦点管理的功能：

- document.activeElement：始终包含当前拥有焦点的 DOM 元素。页面加载时，可以通过用户输入或者按 Tab 键或代码中使用 focus 方法让某个元素获得焦点。

  默认情况下，document.activeElement 会在页面加载完后自动被设置为 document.body。而在页面完全加载前，该值为 null。

- document.hasFocus()，返回布尔值，查看文档是否获得了焦点

#### 15.3.3 HTMLDocument 扩展

- readyState 属性，当页面加载未完成，该属性为 loading，当加载完成，该属性为 complete
- compatMode 属性，用于检测浏览器当前处于什么渲染模式：
  - CSS1Compat：标准模式
  - BackCompat：混杂模式
- head 属性：指向文档的 head 节点

#### 15.3.4 字符集属性

document.characterSet 表示文档实际使用的字符集，默认为"UTF-16"。

#### 15.3.5 自定义数据属性

dataset 冷饭

#### 15.3.6 插入标记

用于一次性大量插入 HTML

- innerHTML 属性

- outerHTML 属性

- insertAdjacentHTML 与 insertAdjacentText 方法

  接收两个参数：要插入标记的位置和要插入的 HTML 或文本，第一个参数必须是下列值中的一个：

  - beforebegin：插入当前元素前面，作为前一个同胞节点
  - afterbegin：插入当前元素内部，作为新的第一个子节点
  - beforeend：插入当前元素内部，作为新的最后一个子节点
  - afterend：插入当前元素后面，作为下一个同胞节点

#### 15.3.7 scrollIntoView

该方法可以用来滚动浏览器窗口或容器元素让对应元素进入视口。

### 15.4 专有扩展

> 除了已经标准化的，各家浏览器还有很多未被标准化的专有扩展。这并不意味着它们将来不会被纳 入标准，只不过在本书编写时，它们还只是由部分浏览器专有和采用。

- children 属性
- contains 方法
- innerText 属性
- outerText 属性

## 第 16 章 DOM2 和 DOM3











> 本次阅读至 P460 第 16 章 DOM2 和 DOM3 485
