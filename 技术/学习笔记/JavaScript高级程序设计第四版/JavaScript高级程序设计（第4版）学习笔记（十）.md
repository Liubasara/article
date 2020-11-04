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













> 本次阅读至 P391 426 第14章 DOM
