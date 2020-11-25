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

- none：被拖放的元素不能放到这里，这是除文本框之外所有元素的默认值
- move：被拖放元素应该移动到放置目标
- copy：被拖放元素应该复制到放置目标
- link：表示防治目标会导航到被拖动元素（仅在它是 URL 的情况下）

上述的每种值都会导致显示一种不同的光标。

effectAllowed 属性用于表示对被拖动元素是否允许 dropEffect，必须要 ondragstart 事件中设置这个属性。

> 假设我们想允许用户把文本从一个文本框拖动到一个`<div>`元素。那么必须同时把 dropEffect 和 effectAllowed 属性设置为"move"。因为`<div>`元素上放置事件的默认行为是什么也不做，所以文本 不会自动地移动自己。如果覆盖这个默认行为，文本就会自动从文本框中被移除。然后是否把文本插入 `<div>`元素就取决于你了。如果是把 dropEffect 和 effectAllowed 属性设置为"copy"，那么文本 框中的文本不会自动被移除。

#### 20.6.5 可拖动能力

默认情况下，图片、链接和文本是可拖动的，而其他元素则有一个`draggable`属性，可以通过该属性设置元素是否可拖动。

#### 20.6.6 其他成员

HTML5 规范还为`dataTransfer`对象定义了下列方法：

- addElement：为拖动操作添加元素
- clearData(format)：清除以特定格式存储的数据
- setDragImage(element, x, y)：允许指定拖动发生时显示在光标下面的图片
- types：当前存储的数据类型列表，以字符串形式保存数据类型

### 20.7 Notifications API

Notifications API 用于向用户显示通知，比起 alert 提供更灵活地自定义能力。Notifications API 在 Service Worker 中非常有用，通过触发通知可以在页面不活跃时向用户显示消息，看起来就像原生应用。

### 20.8 Page Visibility API

该 API 由三部分组成，用于让开发者得知页面什么时候在被使用，什么时候被隐藏：

- document.visibilityState 值
- visibilitychange 事件
- document.hidden 布尔值，表示页面是否被隐藏。这个值是为了向后兼容才继续被浏览器支持的，应该优先使用 document.visibilityState 检测页面可见性。

要想在页面从可见变为隐藏或从隐藏变为可见时得到通知，需要监听 visibilitychange 事件。document.visibilityState 的值是以下三个字符串之一： 

- hidden：被隐藏
- visible：使用中
- prerender：在屏幕外渲染

### 20.9 Streams API

用于流式处理大块数据，可用于解决处理网络请求和读写磁盘。有三种流：

- 可读流（ReadableStream）
- 可写流（WritableStream）
- 转换流（TransformStream）：由两种流组成，可写流用于接收数据，可读流用于输出数据，两个流之间是转换程序，可以根据需要检查和修改流内容

#### 20.9.5 通过管道连接流

流可以通过管道连接成一串，最常用的例子就是通过`pipeThrough()`方法把`ReadableStream`接入`TransformStream`。从内部看，`ReadableStream`先把自己的值传给`TransformStream`内部的`WritableStream`，然后执行转换，转换后的值又在新的`ReadableStream`上出现。

```javascript
async function* ints () {
  // 每 1000ms 生成一个递增的整数
  for (let i = 0; i < 5; i++) {
    yield await new Promise((resolve) => setTimeout(resolve, 1000, i))
  }
}

const integerStream = new ReadableStream({
  async start (controller) {
    for await (let chunk of ints()) {
      // 调用控制器的 qnqueue() 方法可以把值传入控制器
      controller.enqueue(chunk)
    }
    // 所有值传完以后，调用 close 关闭流
    controller.close()
  }
})

// 经过这个流处理转换的数据会翻倍
const doublingStream = new TransformStream({
  transform(chunk, controller) {
    controller.enqueue(chunk * 2)
  }
})
// 通过管道连接流
const pipedStream = integerStream.pipeThrough(doublingStream)
// 从连接流的输出中获得读取器
const pipedStreamDefaultReader = pipedStream.getReader()
// 消费者
(async function () {
  while (true) {
    const {done, value} = await pipedStreamDefaultReader.read()
    if (done) {
      break
    } else {
      console.log(value)
    }
  }
})()
```

类似的，也可以使用`pipeTo`方法将 ReadableStream 连接到 WritableStream，过程与`pipeThrough`类似。

```javascript
async function* ints () {
  // 每 1000ms 生成一个递增的整数
  for (let i = 0; i < 5; i++) {
    yield await new Promise((resolve) => setTimeout(resolve, 1000, i))
  }
}

const integerStream = new ReadableStream({
  async start (controller) {
    for await (let chunk of ints()) {
      // 调用控制器的 qnqueue() 方法可以把值传入控制器
      controller.enqueue(chunk)
    }
    // 所有值传完以后，调用 close 关闭流
    controller.close()
  }
})
const writableStream = new WritableStream({
  write (value) {
    console.log(value)
  }
})
const pipedStream = integerStream.pipeTo(writableStream)
// 0
// 1
console.log(writableStream.locked)
// true
// 2
// 3
// 4
console.log(writableStream.locked)
// false
const writer = writableStream.getWriter()
console.log(writer.ready) // fulfilled
```

### 20.10 计时API

Performance 接口通过 JavaScript API 暴露了浏览器内部的度量指标，允许开发者直接访问这些信息并基于此实现在即想要的功能，所有属性都暴露在了 window.performance 对象上。

### 20.11 Web 组件







> 阅读至 P648 20.11 Web 组件 673
