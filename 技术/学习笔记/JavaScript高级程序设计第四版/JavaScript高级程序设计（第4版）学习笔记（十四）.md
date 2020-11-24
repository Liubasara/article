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

HTML5 新增了两个与媒体相关的元素，即`<audio>`和`<video>`，从而为浏览器提供了嵌入音频和视频的统一解决方案。

基本使用方法为：

```html
<!-- 嵌入视频 -->
<video src="conference.mpg" id="myVideo">Video player not available.</video>
<!-- 嵌入音频 -->
<audio src="song.mp3" id="myAudio">Audio player not available.</audio>
```

其中开始和结束标签之间的内容是在媒体播放器不可用时显示的替代内容。

由于浏览器支持的媒体格式不同，因此可以指定多个不同的媒体源，为此，需要从元素中删除`src`属性，使用一个或多个`<source>`元素代替。

```html
<!-- 嵌入视频 -->
<video id="myVideo">
  <source src="conference.webm" type="video/webm; codecs='vp8, vorbis'">
  <source src="conference.ogv" type="video/ogg; codecs='theora, vorbis'">
  <source src="conference.mpg">
  Video player not available.
</video>
<!-- 嵌入音频 -->
<audio src="song.mp3" id="myAudio">
  <source src="song.ogg" type="audio/ogg">
  <source src="song.mp3" type="audio/mpeg">
  Audio player not available.
</audio>
```

> 讨论不同音频和视频的编解码器超出了本书范畴，但浏览器支持的编解码器确实可能有所不同，因 此指定多个源文件通常是必需的。 

#### 20.5.1 属性

这两个元素有很多共有属性，用于确定媒体的当前状态。

#### 20.5.2 事件

除此以外媒体元素还定义了很多事件，可以监控这些事件来监控由于媒体回访或用户交互导致的不同属性的变化。

#### 20.5.3 自定义媒体播放器

使用`<audio>`和`<video>`的 play 和 pause 方法，可以手动控制媒体文件的播放。综合使用属性、事件和这些方法，可以方便地创建自定义的媒体播放器。

```html
<div>
  <video id="player" src="movie.mov" poster="mymovie.jpg" width="200" width="200"></video>
  <div class="controls">
    <input type="button" value="play" id="video-btn">
    <span id="curtime">0</span>/<span id="duration">0</span>
  </div>
</div>

<script>
// 为按钮添加事件处理程序
btn.addEventListener('click', event => {
  if (player.paused) {
    player.play()
    btn.value = '暂停'
  } else {
    player.pause()
    btn.value = '开始'
  }
})
// 周期性更新当前时间
setInterval(() => {
  curtime.innerHTML = player.currentTime
}, 250)
</script>
```

#### 20.5.4 检测编解码器

两个媒体元素都有一个名为`canPlayType()`的方法，该方法接收一个格式/编解码字符串（如'audio/mpeg'），返回的值如下：

- 'probably'
- 'maybe'
- ''：空字符串

> 在只给 canPlayType()提供一个 MIME类型的情况下，可能返回的值是"maybe"和空字符串。这是因为文件实际上只是一个包装音频和视频数据的容器，而真正决定文件是否可以播放的是编码。在同时提供 MIME类型和编解码器（codecs）的情况下，返回值的可能性会提高到"probably"。
>
> 如下：
>
> ```javascript
> audio.canPlayType('audio/mpeg') // maybe
> audio.canPlayType('audio/ogg; codecs=\"vorbis\"') // probably
> ```
>
> 注意，编解码器必须放到引号中。

#### 20.5.5 音频类型

`<audio>`元素还有一个名为 Audio 的原生 JavaScript 构造函数，支持在任何时候播放音频。该类型与 Image 类型类似，都是 DOM 元素的对等体，区别是**不需要插入文档也可以进行工作**。

```javascript
// 创建新实例，就会开始下载指定文件
var audio = new Audio('sound.mp3')
// 下载完毕后，可以调用 play 来播放音频
audio.addEventListener('canplaythrough', function (event) {
  audio.play()
})
```

> 在 iOS 中调用 play() 方法会弹出一个对话框，请求用户授权播放声音。为了连续播放，必须在 onfinish 事件处理程序中立即调用 play()。 

### 20.6 原生拖放

某个元素被拖动时，会按顺序触发以下事件：

1. dragstart
2. drag
3. dragend

此外，dragstart 事件触发后，只要目标还被拖动就会持续触发 drag 事件，有点类似于 mousemove 事件

在把某个元素拖动到无效放置目标上时，会看到一个特殊光标（圆环中间一条斜杠）表示不能放下，如果把元素拖动到不允许放置的目标上，无论用户动作是什么都不会触发 drop 事件。不过，**通过覆盖元素的 dragenter 和 dragover 事件的默认行为**，可以把任何元素转换为有效的放置目标。

#### 20.6.3 dataTransfer 对象

除非数据受影响，否则简单的拖放并没有实际意义。为实现拖动操作中的数据传输，IE5 在 event 对象上暴露了 dataTransfer 对象。dataTransfer 对象现在已经纳入了HTML5工作草案。

dataTransfer 对象有两个主要方法：

- setData(type)：用于在拖放时设置要传输的值
- getData(type)：用于拖放后获取 setData() 存储的值

IE5 传递的 type 可以是 'text' 和 'URL'，但 HTML5 已经将其扩展为允许任何 MIME 类型，可以包含每种 MIME 类型的一个值，也就是说可以同时保存文本和 URL，两者不会相互覆盖。存储在 dataTransfer 对象中的数据只能在放置事件中读取。如果没有在 ondrop 事件处理程序中取得这些数据，dataTransfer 对象就会被销毁，数据也会丢失。

可以在 dragstart 事件中手动调用 setData() 存储自定义数据，以便将来使用。 

作为文本的数据和作为 URL 的数据有一个区别。当把数据作为文本存储时，数据不会被特殊对待。 而当把数据作为 URL 存储时，数据会被作为网页中的一个链接，意味着如果把它放到另一个浏览器窗口，浏览器会导航到该 URL。

#### 20.6.4 dropEffect 与 effectAllowed

dataTransfer 对象不仅可以用于实现简单的数据传输，还可以用于确定能够对被拖动元素和放置目标执行什么操作。可以使用两个属性：dropEffect 与 effectAllowed。

dropEffect  用于告诉浏览器允许哪种放置行为：











> 阅读至 P641 20.6.4 dropEffect 与 effectAllowed 658
