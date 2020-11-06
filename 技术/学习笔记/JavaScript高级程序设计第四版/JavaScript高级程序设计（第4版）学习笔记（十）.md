---
name: JavaScript高级程序设计（第4版）学习笔记（十）
title: JavaScript高级程序设计（第4版）学习笔记（十）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：12. BOM 13. 客户端检测 14. DOM"
time: 2020/11/2
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']

---

# JavaScript高级程序设计（第4版）学习笔记（十）

## 第 12 章 BOM

>  BOM是使用 JavaScript开发 Web 应用程序的核心。BOM提供了与网页无关的浏览器功能对象。

第三版冷饭。

#### 12.1.3 窗口位置与像素比

可以使用`moveTo()`和`moveBy()`方法移动窗口。但这两个方法可能会被浏览器部分或全部禁用。

CSS 像素是 Web 开发中使用的统一像素单位。该单位的背后其实是一个角度，0.0213°

如果屏幕距离人眼是一臂长，则以这个角度计算的 CSS 像素大小约为 1/96 英寸。这样定义是为了在不同设备上统一标准，比如，低分辨率下的 12px 的文字应该与高清 4K 屏幕下的 12px 的文字具有相同大小。**这就带来一个问题，不同像素密度的屏幕下会有不同的缩放系数，以便将屏幕的物理分辨率转换为 CSS 像素**。

这个物理像素与 CSS 像素之间的转换比率由`window.devicePixelRatio`属性提供，如手机屏幕的武林分辨率为`1920 * 1080`，CSS 像素为`640 * 320`，那么`window.devicePixelRatio`的值为 3（一般只计算宽度之比）。

该属性实际上与每英寸像素数（DPI，dots per inch）是相对的，DPI 表示单位像素密度，而该属性表示物理像素与逻辑像素之间的缩放系数。

#### 12.1.6 导航与打开新窗口

使用`window.open`可以打开新窗口。

但现代浏览器很多为了防止弹窗被滥用，都会内置屏蔽程序。当被屏蔽时，`window.open`很可能返回`null`。

#### 12.1.7 定时器

- setTimeout（clearTimeout）
- setInterval（clearInterval）

### 12.3 navigator 对象

`navigator`对象的属性通常用于确定浏览器的类型，还可以用于检测浏览器的插件（除 ID10 及更低版本的浏览器，都可以通过`plugins`数组来确定）。

```javascript
function hasPlugin (name) {
  name = name.toLowerCase()
  for (let plugin of window.navigator.plugins) {
    if (~plugin.name.toLowerCase().indexOf(name)) {
      return true
    }
  }
}
// 检测 Flash
alert(hasPlugin('Flash'))
```

**旧版本 IE 中的插件检测**

```javascript
function hasIEPlugin (name) {
  try {
    new ActiveXObject(name)
    return true
  } catch (ex) {
    return false
  }
}
// 检测 Flash
console.log(hasIEPlugin('ShockwaveFlash.ShockwaveFlash'))
```

### 12.4 screen 对象

window 中的 screen 属性是一个很少用的对象，该对象中保存的纯粹是客户端能力信息，也就是浏览器窗口外的客户端显示器的信息，比如像素宽度和像素高度。每个浏览器都会在 screen 对象上暴露不同的属性。

## 第 13 章 客户端检测

第三版冷饭 too

## 第 14章 DOM

冷饭吐。

### 14.3 MutationObserver 接口

该接口可以在 DOM 被修改时异步执行回调。使用`MutationObserver`可以观察整个文档、DOM 树的一部分，或某个元素。此外还可以观察元素属性、子节点、文本或者前三者任意组合的变化。

**用法**

新建的 MutationObserver 实例不会关联 DOM 的任何部分。要把这个 observer 与 DOM 关联起来，需要使用 observe() 方法。这个方法接收两个必须的参数：

- 需要观察其变化的 DOM 节点
- 一个 MutationObserverInit 对象

`MutationObserverInit`对象用于控制观察哪些方面的变化，是一个 key/value 形式配置选项的字典，可以观察的事件包括属性变化、文本变化和子节点变化，有以下属性：

- subtree：布尔值，默认为 false，表示除了目标节点，是否观察目标节点的子树，默认不观察其子树。

  > 有意思的是，被观察子树中的节点被移出子树之后仍然能够触发变化事件。这意味着在子树中的节 点离开该子树后，即使严格来讲该节点已经脱离了原来的子树，但它仍然会触发变化事件

  

- attributes：布尔值，默认为 false，表示是否观察目标节点的属性变化，默认不观察

- attributeFilter：字符串数组，表示要观察哪些属性的变化，把这个值设为 true 也会将 attributes 的值转换为 true，默认为观察所有属性

- attributeOldValue：布尔值，默认为 false，表示 MutationRecord 是否记录变化之前的属性值。把这个值设置为 true 也会将 attributes 的值转换为 true

- characterData：布尔值，默认为 false，表示修改字符数据是否触发变化事件

- characterDataOldValue：布尔值，默认为 false，表示 MutationRecord 是否记录变化之前的字符数据。将该值设置为 true 也会将 characterData 的值转换为 true

- childList：布尔值，默认为 false，表示修改目标节点的子节点是否触发变化事件（与 subtree 的区别在于 childList 仅观察子节点，不会对子树进行深层观测）

```javascript
let observer = new MutationObserver(mutationRecords => {
  console.log(mutationRecords)
})
observer.observe(document.body, { attributes: true })
document.body.setAttribute('foo', 'bar')
```

**回调与 MutationRecord**

回调并非与实际的 DOM 变化同步执行（**微任务执行**），每个回调都会收到一个 MutationRecord 实例的数组。该对象包含的信息包括发生了什么变化，以及 DOM 的哪一部分受到了影响。

因为回调执行之前可能同时发生多个满足观察条件，的事件，所以每次执行回调都会传入一个包含按顺序入队的 MutationRecord 实例的数组。 

以下是 MutationRecord 实例的属性：

- target：被修改影响的目标节点
- type：字符串，表示变化的类型，"attributes"，"characterData"或"ChildList"
- oldValue：被代替的值
- attributeName：对于 attribute 类型的变化，保存被修改属性的名字
- attributeNamespace：对于使用了命名空间的 attribute 类型的变化，保存被修改属性的名字
- addedNodes：对于 childList 类型的变化，返回包含变化中添加节点的 NodeList，默认为空
- removedNodes：返回包含变化中删除的 NodeList
- previousSibling：返回变化节点的前一个节点 Node
- nextSibling：返回变化节点的后一个节点 Node

**disconnect()方法**

默认情况下，只要被观察的元素不被垃圾回收，MutationObserver 的回调就会响应 DOM 变化事件，从而被执行。如果要提前终止回调，可以调用 disconnect 方法。同步调用 disconnect 之后，不仅会停止此后变化事件的回调，也会抛弃已经加入任务队列想要异步执行的回调。

```javascript
let observer = new MutationObserver((mutationRecord) => console.log('attributes changed', mutationRecord))
observer.observe(document.body, { attributes: true })
document.body.className = 'foo'
setTimeout(() => {
  observer.disconnect()
  document.body.className = 'bar' // observer无响应
})
// attributes changed
```

可以多次调用 observer 方法，复用 MutationObserver 对象观察多个不同的目标节点。

**重用 MutationObserver**

调用 disconnect 后依然可以重新使用这个观察者，并将它关联到新的目标节点，

**异步回调与记录队列**

MutationObserver 接口是出于性能考虑而设计的，其核心是异步回调与记录队列模型。为了在大量变化事件发生时不影响性能，每次变化的信息（由观察者实例决定）会保存在 MutationRecord 中，然后添加到记录队列。这个队列对每个 MutationObserver 实例都是唯一的，是所有 DOM 变化事件的有序列表。

调用`takeRecords`方法可以清空记录队列，去除并返回其中所有的 MutationRecord 实例。

```javascript
let observer = new MutationObserver(mutationRecords => {
  console.log(mutationRecords)
})
observer.observe(document.body, { attributes: true })
document.body.className = 'foo'
document.body.className = 'bar'
document.body.className = 'baz'

console.log(observer.takeRecords()) // [MutationRecord, MutationRecord, MutationRecord]
console.log(observer.takeRecords()) // []
```

这在希望断开与观察目标的联系，但又希望处理由于调用 disconnect() 而被抛弃的记录队列中的 MutationRecord 实例时比较有用。 

**性能、内存与垃圾回收**

MutationObserver 实例与目标节点之间的引用关系是非对称的。MutationObserver 拥有对要观察的目标节点的弱引用。因为是弱引用，所以不会妨碍垃圾回收程序回收目标节点。 

然而，目标节点却拥有对 MutationObserver 的强引用。如果目标节点从 DOM中被移除，随后被垃圾回收，则关联的 MutationObserver 也会被垃圾回收。

记录队列中的每个 MutationRecord 实例至少包含对已有 DOM 节点的一个引用。如果变化是 childList 类型，则会包含多个节点的引用。记录队列和回调处理的默认行为是耗尽这个队列，处理每个 MutationRecord，然后让它们超出作用域并被垃圾回收。 

> 有时候可能需要保存某个观察者的完整变化记录。保存这些 MutationRecord 实例，也就会保存 它们引用的节点，因而会妨碍这些节点被回收。如果需要尽快地释放内存，建议从每个 MutationRecord 中抽取出有用的信息，然后保存到一个新对象中，后抛弃 MutationRecord。 
