---
name: JavaScript高级程序设计（第4版）学习笔记（十三）
title: JavaScript高级程序设计（第4版）学习笔记（十三）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：18. 动画与 Canvas 图形"
time: 2020/11/16
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']

---

# JavaScript高级程序设计（第4版）学习笔记（十三）

## 第 18 章 动画与 Canvas 图形

`<canvas>`是 HTML5 最受欢迎的新特性，这个元素会占据一块页面区域，让 JavaScript 可以动态在上面绘制图片。

### 18.1 使用 requestAnimationFrame

> 拓展阅读：[从RAF聊到EventLoop](https://blog.liubasara.info/#/blog/articleDetail/mdroot%2F%E6%8A%80%E6%9C%AF%2F%E4%BB%8ERAF%E8%81%8A%E5%88%B0EventLoop.md)

用于解决多个任务之间**间隔过短**，导致浏览器将多次 DOM 变化只渲染了一次而导致的页面帧数卡顿问题。对于多次触发的函数，还可以用于节流。

```javascript
var enqueued = false
function expensiveOperation () {
  console.log('Invoked at', Date.now())
  enqueued = false
}
window.addEventListener('scroll', () => {
  if (!enqueued) {
    enqueued = true
    window.requestAnimationFrame(expensiveOperation)
  }
})
```

> 但因为重绘是非常频繁的操作，所以这还算不上真正的节流。更好的办法是配合使用一个计时器来限制操作执行的频率（经典限流）。

#### 18.1.4 cancelAnimationFrame

与`setTimeout`类似，RAF 也返回一个请求 ID，可以使用`cancelAnimationFrame`来取消重绘任务。

### 18.2 基本的画布功能

创建`<canvas>`元素时至少要设置其 width 和 height 属性，才能告诉浏览器在多大面积上绘图。

要在画布上绘制图形，首先要取得绘图上下文，使用`getContext()`方法可以获取该引用。

对于平面图形，需要给这个方法传入"2d"，表示要获取 2D 上下文对象。

如果要导出`canvas`元素上的图像，可以使用`toDataURL()`方法，导出一张图片。

### 18.3 2D 绘图上下文

2D 绘图上下文提供了绘制 2D 图形的方法。2D 上下文的坐标原点（0, 0）在`canvas`元素的左上角，所有坐标值都相对于该点计算，因此 x 坐标向右增长，y 坐标向下增长。默认情况下，width 和 height 表示两个方向上元素的最大值。

以下是用于绘图的属性和 API：

- fillStyle：默认 #000，填充颜色
- strokeStyle：默认 #000，描边，图形边界着色
- fillRect(x, y, width, height)：在画布上绘制并填充矩形（颜色由 fillStyle 决定）
- strokeRect(x, y, width, height)：使用 strokeStyle 指定的颜色绘制矩形轮廓
- clearRect(x, y, width, height)：可以擦除画布中某个区域，用于把绘图上下文中的某个区域变透明，比如可以从已有的矩形中开个孔

除了直接绘制图形外，2D 绘图上下文支持很多在画布上绘制路径的方法，通过路径可以创建复杂的形状和线条。以下是方法：

- beginPath()：表示要开始绘制新路径，要绘制路径之前必须先调用
- arc(x, y, radius, startAngle, endAngle, counterclockwise)：以 x，y 为圆心，以 radius 为半径绘制一条弧线，起始角度为 startAngle，结束角度是 endAngle，最后一个参数 counterclockwise 表示是否逆时针计算起始角度和结束角度。（默认为顺时针）
- bezierCurveTo(c1x, c2y, c2x, c2y, x, y)：以 c1x，c1y 和 c2x，c2y 为控制点，绘制一条从上一点到 x, y 的三次贝塞尔弧线。
- lineTo(x, y)：绘制一条从上一点到 x, y 的直线
- moveTo(x, y)：不绘制线条，只把绘制光标移动到 x, y
- qudraticCurveTo(cx, cy, x, y)：以 cx，cy 为控制点，绘制一条从上一点到 x,y 的二次贝塞尔弧线
- rect(x, y, width, height)：以给定宽度和高度在 x, y 绘制一个矩形。这个方法与 strokeRect 和 fillRect 的区别在于，它创建的是一条路径而不是独立的图形。
- closePath()：创建路径之后，可以使用 closePath 方法绘制一条返回起点的线，如果路径已经返回了起点，可以指定 fillStyle 属性，并调用 fill() 方法来填充路径。
- stroke()：若不需要返回起点，也可以指定 strokeStyle 属性并调用 stroke() 方法来描画路径，还可以调用 clip() 方法基于已有路径创建一个新剪切区域。

路径是 2D上下文的主要绘制机制，因为路径经常被使用，所以也有一个`context.isPointInPath(x, y)`方法，接收 x 轴和 y 轴作为参数，判断该点是否在路径上，**可以在关闭路径前随时调用**。

```javascript
// demo. 画一个时钟表盘和时针分针
var context = document.getElementById('drawing').getContext('2d')
context.beginPath() // 创建路径
context.arc(100, 100, 99, 0, 2 * Math.PI, false) // 外圆
context.arc(100, 100, 94, 0, 2 * Math.PI, false) // 内圆
// 分针
context.moveTo(100, 100)
context.lineTo(100, 15)
// 时针
context.moveTo(100, 100)
context.lineTo(35, 100)
// 描画路径
context.stroke()
```

#### 18.3.4 绘制文本

文本和图像混合也是常见的绘制需求，因此 2D context 还提供了绘制文本的方法。

- fillText(str, x, y, maxwidth)：使用 fillStyle 属性绘制文本，因为模拟在网页中渲染文本，所以使用较多
- strokeText(str, x, y, maxwidth)：使用 strokeStyle 属性绘制文本

两个方法都接收 4 个参数：要绘制的字符串，x 坐标、y 坐标，可选的最大像素宽度。

两个方法最终绘制的结果都取决于以下 3 个属性：

- font：CSS 语法指定的字体样式、大小、字体等，如"10px Arial"
- textAlign：指定的文本对齐方式，可能的值包括：start、end、left、right、center。推荐使用 start 和 end 来代替 left 和 right。
- textBaseLine：指定文本的基线，可能的值包括：top、hanging、middle、alphabetic、ideographic、bottom

由于绘制文本很复杂，特别是想把文本绘制到特定区域的时候，因此 2D上下文提供了用于辅助确定文本大小的方法：

- measureText(str)：接收一个即将要绘制的文本，然后返回一个 TextMetrics 对象。这个返回的对象目前只有一个属性 width，代表指定文本绘制后的大小。

```javascript
// 确保最后文本绘制后的宽度为 140px
var fontSize = 100
context.font = fontSize + 'px Arial'
while (context.measureText('Hello world!').width > 140) {
  fontSize--
  context.font = fontSize + 'px Arial'
}
context.fillText('Hello world!', 10, 10)
context.fillText('Font size is ' + fontSize + 'px', 10, 50)
```

此上面的方法外，还可以通过 fillText 和 strokeText 方法的第四个参数进行限制。

#### 18.3.5 变换

上下文变换可以操作绘制在画布上的图像来进行变换。

> 在创建绘制上下文时，会以默认值初始化变换矩阵，从而让绘制操作如实应用到绘制结果上。对绘制上下文应用变换，可以导致以不同的变换矩阵应用绘制操作，从而产生不同的结果。 

有以下方法：

- rotate(angle)：围绕原点把图像旋转 angle 弧度

- scale(scaleX, scaleY)：通过在 x 轴乘以 scaleX、在 y 轴乘以 scaleY 来缩放图像。scaleX 和 scaleY 的默认值都是 1.0

- translate(x, y)：把**原点**移动到 x、y

- transform(m1_1, m1_2, m2_1, m2_2, dx, dy)：可以通过矩阵乘法直接修改矩阵

  m1_1 m1_2 dx

  m2_1 m2_2 dy

  0        0         1

- setTransform(m1_1, m1_2, m2_1, m2_2, dx, dy)：把矩阵重置为默认值，再以传入的参数调用 transform()

变换可以简单，也可以复杂，比如如果把坐标原点移动到表盘中心，那么再绘制表针就非常简单了。

变换之后可以使用`save()`方法，调用这个方法后，所有的这一刻的设置会被放到一个暂存栈中。保存之后，可以继续修改上下文，如果需要恢复设置，就可以通过 restore 可以系统的恢复（出栈）。

#### 18.3.6 绘制图像

可以把现有图像绘制到画布上，使用`drawImage(image, x, y)`进行绘制。操作的结果可以通过`toDataURL()`方法获取。

#### 18.3.7 阴影

2D context 可以根据以下属性的值自动为已有形状或路径生成阴影。

- shadowColor：阴影颜色，默认黑色
- shadowOffsetX：相对于形状或路径的 x 坐标的偏移量，默认为 0
- shadowOffsetY：相对于形状或路径的 y 坐标的偏移量，默认为 0
- shadowBlur：像素，表示阴影的模糊量。默认值为 0，表示不模糊

设置好之后再调用 fillRect 绘制矩形，就会出现阴影了。

#### 18.3.8 渐变

调用该方法可以创建一个渐变对象：

- var gradient = context.createLinearGradient(x, y, x, y)：创建一个线性渐变，接受的入参为起点 x 坐标，起点 y 坐标，终点 x 坐标，终点 y 坐标
- var gradient = context.createRadialGradient(x, y, radius, x, y, radius)：创建一个径向渐变
- gradient.addColorStop(0, 'white')：0 是第一种颜色
- gradient.addColorStop(1, 'white')：1 是最后一种颜色

#### 18.3.9 图案

- var pattern = context.createPattern(image, 'repeat')：

用于填充和描画图形的重复图像（需要将 fillStyle 设为 pattern 后再调用 fillRect）。

传给 createPattern() 方法的第一个参数也可以是`<video>`元素或者另一个`<canvas>`元素。 

#### 18.3.10 图像数据

2D 上下文中，可以使用`getImageData(x, y, width, height)`方法获取原始图像数据，返回的是一个 ImageData 的实例，实例中包含三个属性：

- data：包含图像原始像素信息的数组
- width
- height

对原始图像数据进行访问可以更灵活地操作图像，例如通过更改图像数据可以创建一个简单的灰阶过滤器。

```javascript
var imageData = context.getImageData(0, 0, image.width, image.height)
data = imageData.data
for (let i = 0, len = data.length; i < len; i += 4) {
  red = data[i]
  green = data[i + 1]
  blue = data[i + 2]
  alpha = data[i + 3]
  // RGB 平均值
  average = Math.floor((red + green + blue) / 3)
  // 设置颜色，不管透明度
  data[i] = average
  data[i+ 1] = average
  data[i + 2] = average
}
// 将修改后的数据写回 ImageData 并应用到画布上显示出来
imageData.data = data
context.putImageData(imageData, 0, 0)
```

如上，使用`putImageData()`方法可以把图像数据再绘制到画布上。结果就能得到原始图像的黑白版。

#### 18.3.11 合成

context 中的所有内容都会应用两个属性：

- globalAlpha：一个范围在 0~1 的值，用于指定接下来所有绘制内容的透明度
- globalCompositionOperation：表示新绘制的形状如何与上下文中已有的形状融合。该属性可以取多个值

### 18.4 WebGL

WebGL 是画布的 3D 上下文，与其他 Web 技术不同，使用的标准也不一样。

#### 18.4.1 WebGL 上下文

在完全支持的浏览器中，WebGL 2.0 上下文名叫“webgl2”，webGL 1.0 上下文名字叫 webgl1。在使用上下文前应该检测返回值是否存在。

#### 18.4.2 WebGL 基础

取得 WebGL 上下文后，就可以开始 3D 绘图了。由于 WebGL 是 OpenGL ES 2.0 的 Web 版，所以本节讨论的概念实际上是 JavaScript 所实现的 OpenGL。

调用`getContext`取得 WebGL 上下文时可以指定一些选项：

- alpha：布尔值，表示是否为上下文创建透明通道缓冲区，默认 true
- depth：布尔值，表示是否使用 16 位深缓冲区，默认 true
- stencil：布尔值，表示是否使用 8 位模板缓冲区，默认 false
- antialias：布尔值，表示是否使用默认机制执行抗锯齿操作，默认 true
- premultipliedAlpha：布尔值，表示绘图缓冲区是否预乘透明度值，默认 true
- preserveDrawingBuffer：布尔值，表示绘图完成后是否保留绘图缓冲区，默认为 false

使用方式如下：

```javascript
var drawing = document.getElementsByTagName('canvas')
// 确保支持 canvas
if (drawing.getContext) {
  var g1 = drawing.getContext('webgl', { alpha: false })
  if (fl) {
    // 使用 WebGL
  }
}
```

> PS：3D 的 API 内容暂不详细学习，况且本书里写的也不详细（我要有那水平为什么不去做游戏呢）。

