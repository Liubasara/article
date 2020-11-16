---
name: JavaScript高级程序设计（第4版）学习笔记（十二）
title: JavaScript高级程序设计（第4版）学习笔记（十二）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：17. 事件"
time: 2020/11/12
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']

---

# JavaScript高级程序设计（第4版）学习笔记（十二）

## 第 17 章 事件

第三版冷饭。

#### 17.4.2 焦点事件

焦点事件在页面元素获得或失去焦点时触发。这些事件可以与`document.hasFocus()`和`document.activeElement`一起为开发者提供用户在页面中导航的信息。焦点事件有以下 6 种：

- blur：当元素失去焦点时触发，该事件不冒泡。
- DOMFocusIn：当元素获得焦点时触发。这个事件是 focus 的通用版。DOM3 Events 废弃了 DOMFocusIn，推荐 focusin。
- DOMFocusOut：当元素失去焦点时触发。这个事件是 blur 的通用版。Opera 是唯一支持这个事件的主流浏览器。DOM3 Events 废弃了 DOMFocusOut，推荐 focusout。
- focus：元素获得焦点时触发。这个事件不冒泡，所有浏览器都支持。
- focusin：当元素获得焦点时触发。这个事件是 focus 的冒泡版。
- focusout：当元素失去焦点时触发。这个事件是 blur 的通用版。

#### 17.4.3 鼠标和滚轮事件

DOM3 Events 定义了 9 种鼠标事件：

- click
- dbclick
- mousedown
- mouseenter
- mouseleave
- mousemove
- mouseout
- mouseover
- mouseup

click 事件触发的前提是 mousedown 事件触发后，紧接着又在同一个元素上触发了 mouseup 事件，如果 mousedown 和 mouseup 中的任何一个事件被取消，那么 click 事件就不会触发。类似的，只要有任何逻辑组织了两个 click 事件发生，那么 dbclick 就永远不会被触发。

鼠标事件不仅是在浏览器窗口中发生的，也是在整个屏幕上发生的，可以通过 event 对象的 screenX 和 screenY 属性获取鼠标光标在屏幕上的坐标。

此外，event 对象上有一个 button 属性，表示按下或释放的是哪个案件：

- 0：鼠标主键
- 1：鼠标中键
- 2：鼠标副键

**mousewheel 事件**

该事件在用户使用鼠标滚轮时触发，当鼠标向前滚动时，`event.wheelDelta`的值是 +120，当滚轮向后滚动时，值是 -120。

**触摸屏设备**

对于 ios 或安卓等触摸屏设备，有以下特点：

- 不支持 dbclick 事件
- 单指点触屏幕上的可点击元素会触发 mousemove 事件
- mousemove 事件也会触发 mouseover 和 mouseout 事件
- **双指**点触屏幕并滑动导致页面滚动时会触发 mousewheel 和 scroll 事件

#### 17.4.4 键盘与输入事件

3 个事件：

- keydown
- keypress
- keyup

#### 17.4.5 合成事件

合成事件用于检测和控制 IME（输入法）输入时的各种事件。

- compositionstart，IME 文本合成系统打开时触发，表示输入即将开始，事件中包含正在编辑的文本
- compositionupdate，新字符插入输入字段时触发，事件中包含了要插入的新字符
- compositionend，在 IME 的文本合成系统关闭时触发，表示恢复键盘正常输入，事件中包含本次合成过程中输入的全部内容

#### 17.4.7 HTML5 事件

本节讨论 HTML5 中得到浏览器较好支持的一些事件。注意这些并不是浏览器支持的所有事件。

- contextmenu 事件，用于专门用于表示何时该显示上下文菜单，从而允许开发者取消默认的上下文菜单并提供自定义菜单

  ```javascript
  const div = document.getElementById('myDiv')
  const menu = document.getElementById('menu')
  
  div.addEventListerner('contextmenu', event => {
    event.preventDefault()
    menu.style.left = event.clientX + 'px'
    menu.style.top = event.clientY + 'px'
    menu.style.visibility = 'visible'
  })
  document.addEventListener('click', event => {
    document.getElementById('menu').style.visibility = 'hidden'
  })
  ```

  上面就是一个自定义弹出上下文菜单的 demo 程序

- beforeunload 事件

  页面离开之前触发

- DOMContentLoaded 事件

  DOMContentLoaded 可以让开发者在外部资源下载的同时就能指定事件处理程序（load 事件需要在所有资源下载完毕后才触发），从而让用户能够更快地与页面交互。

- hashchange 事件

  用于在 URL 散列值（URL # 后面的部分）发生变化时触发。

  onhashchange 事件处理程序必须添加给 window，每次 URL 散列值发生变化时会调用它。event 对象有两个新属性，oldURL和 newURL，两个属性分别保存变化前后的 URL。

#### 17.4.8 设备事件

本节介绍移动设备事件：

- orientationchange 事件，方便开发者判断用户的设别是出于垂直模式还是水平模式

  每当用户旋转设备改变了模式，就会触发 orientationchange 事件，但 event 对象上没暴露任何有用的信息，因为所有相关信息都可以从 window.orientation 属性中获取。

- deviceorientation 事件，获取设备的加速计信息，反应设备在空间中的朝向

- devicemotion 事件，用于提示设备实际上在移动，而不仅仅是改变了朝向

#### 17.4.9 触摸及手势事件

- touchstart：手指放到屏幕上时触发（即使有一个手指已经放在了屏幕上）
- touchmove：手指在屏幕上滑动时连续触发。在这个事件中调用 preventDefault() 可以阻止滚动
- touchend：手指从屏幕上移开时触发
- touchcancel：系统停止追踪触摸时触发

这些事件都会冒泡，也都可以取消。触摸事件还提供了三个属性用于跟踪触点：

- touches：Touch 类型的实例的数组，表示当前屏幕上的每个触点
- targetTouches：Touch 类型实例的数组，表示特定于事件目标的触点
- changedTouches：Touch 类型实例的数组，表示自上次用户动作之后变化的触点

**手势事件**

- gesturestart: 一只手指已经放在屏幕上，另一个手指放到屏幕上时触发
- gesturechange：任何一个手指在屏幕上的位置发生变化时触发
- gestureend：其中一个手指离开屏幕时触发

### 17.5 内存与性能

> 在 JavaScript 中，页面中事件处理程序的数量与页面整体性能直接相关。原因有很多。首先，每个函数都是对象，都占用内存空间，对象越多，性能越差。其次，为指定事件处理程序所需访问 DOM 的次数会先期造成整个页面交互的延迟。只要在使用事件处理程序时多注意一些方 法，就可以改善页面性能。

#### 17.5.1 事件委托

利用事件冒泡，可以只使用一个事件处理程序来管理一种类型的事件。

### 17.6 模拟事件

#### 17.6.1 DOM 事件模拟

可以使用`document.createEvent()`方法创建一个`event`对象，DOM3 还增加了自定义事件的模型，自定义事件不会触发原生 DOM 事件，可以让开发者定义自己的事件，需要调用`createEvent('CustomEvent')`

> PS：也可以使用`CustomEvent()`来创建一个自定义事件，详情见[MDN](https://developer.mozilla.org/zh-CN/docs/Web/API/CustomEvent)

