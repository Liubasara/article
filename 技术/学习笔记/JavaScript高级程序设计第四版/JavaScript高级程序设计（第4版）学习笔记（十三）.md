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
- closePath()：创建路径之后，可以使用 closePath 方法绘制一条返回起点的线，如果路径已经返回了起点，可以指定 fillStyle 属性，并调用 fill 方法来填充路径。
- stroke()：若不需要返回起点，也可以指定 strokeStyle 属性并调用 stroke() 方法来描画路径，还可以调用 clip() 方法基于已有路径创建一个新剪切区域。

路径是 2D上下文的主要绘制机制，因为路径经常被使用，所以也有一个`context.isPointInPath(x, y)`方法，接收 x 轴和 y 轴作为参数，判断该点是否在路径上，**可以在关闭路径前随时调用**。

#### 18.3.4 绘制文本





> 本次阅读至 P558 18.3.4 绘制文本 583
