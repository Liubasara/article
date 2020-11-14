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







> 本次阅读至 P523 548 17.4.7 HTML5 事件



