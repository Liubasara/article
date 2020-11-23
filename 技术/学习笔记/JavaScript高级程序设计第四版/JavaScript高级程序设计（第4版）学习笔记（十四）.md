---
name: JavaScript高级程序设计（第4版）学习笔记（十四）
title: JavaScript高级程序设计（第4版）学习笔记（十四）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：19. 表单脚本 20. JavaScript API"
time: 2020/11/20
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']


---

# JavaScript高级程序设计（第4版）学习笔记（十四）

## 第 19 章 表单脚本

第三版冷饭。

## 第 20 章 JavaScript API

### 20.1 Atomics 与 SharedArrayBuffer

多个上下文访问`SharedArrayBuffer`时，如果同时对缓冲区执行操作，可能出现资源争用问题。Atomics API 通过强制同一时刻只能对缓冲区执行一个操作，可以让多个上下文安全地读写一个 SharedArrayBuffer。

> **来大家来欣赏一段非人类翻译**：
>
> 仔细研究会发现 Atomics API 非常像一个简化版的指令集架构(ISA)，这并非意外。原子操作的本质会排斥操作系统或计算机硬件通常会自动执行的优化(比如指令重新排序)。原子操作也让并发访问内存变得不可能，如果应用不当就可能导致程序执行变慢。为此，Atomics API 的设计初衷是在最少但很稳定的原子行为基础之上，构建复杂的多线程 JavaScript 程序。
>
> **这就是这本书的平均翻译水平，无力吐槽，能看懂多少看多少吧...**

#### 20.1.1 SharedArrayBuffer

SharedArrayBuffer 与 ArrayBuffer 具有相同的 API。二者的主要区别是 ArrayBuffer 必须在不同执行上下文之间切换，SharedArrayBuffer 则可以被任意多个执行上下文同时使用。

在多个执行上下文间共享内存意味着并发线程成为了可能。传统 JavaScript 操作对于并发内存访问到值的资源争用并没有提供保护。

Atomics API 可以保证 SharedArrayBuffer 上的 JavScript 操作时线程安全的。

### 20.2 跨上下文消息

介绍使用 postMessage() API 与其他窗口通信。

该方法接收 3 个参数：消息、表示目标接收源的字符串和可选的可传输对象的数组。

```javascript
var iframeWindow = document.getElementById('myframe').contentWindow
iframeWindow.postMessage('A secret', 'http://baidu.com')
```

如果不想限制接收目标，则可以给 postMessage()的第二个参数传"*"， 但不推荐这么做。

随后会在 iframe 的 window 上触发 message 事件，该事件包含3方面重要的信息：

- data：作为第一个参数传递给 postMessage 的字符串数据
- origin：发送消息的文档源
- source：发送消息的文档中 window 对象的代理，如果发送窗口同源，那么这个值就是 window 对象

### 20.3 Encoding API

用于实现字符串和定型数组之间的切换，规范中有 4 种用于执行转换的全局类：

- TextEncoder：以 Uint8Array 格式返回每个字符的 UTF-8 编码
- TextEncoderStream：流编码，将解码后的文本流通过管道输入流编码器会得到编码后文本块的流
- TextDecoder：文本解码，用于同步解码整个字符串
- TextDecoderStream：流解码，将编码后的文本流通 过管道输入流解码器会得到解码后文本块的流。

### 20.4 File API 与 Blob API

冷饭。

可以通过监听 input 标签的 change 事件，并通过`event.target.files`字段来获取 file 文件。

#### 20.4.3 FileReaderSync 类型

FileReaderSync 类型就是 FileReader 的同步版本。

```javascript
var syncReader = new FileReaderSync()
// 读取文件时阻塞工作线程
var result = syncReader.readAsDataUrl(file)
console.log(result)
```

#### 20.4.5 对象 URL 与 Blob

使用`window.URL.createObjectURL()`方法并传入 File 或 Blob 对象，返回的值是一个指向内存中地址的字符串，该字符串可以直接作为`<img>`标签的 src 属性来使用。

#### 20.4.6 读取拖放文件

通过`drop`事件的监听，可以将被放置的文件通过`event.dataTransfer.files`属性读到。

### 20.5 媒体元素















> 阅读至 P627 652 20.5 媒体元素
