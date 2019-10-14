---
name: 《JavaScript框架设计》学习笔记（一）
title: 《JavaScript框架设计》学习笔记（一）
tags: ["技术","学习笔记","JavaScript框架设计"]
categories: 学习笔记
info: "前言、第 1 章 种子模块、第 2 章 模块加载系统、第 3 章 语言模块"
time: 2019/10/10
desc: 'JavaScript框架设计, 资料下载, 学习笔记'
keywords: ['JavaScript框架设计资料下载', '前端', '学习笔记']
---

# 《JavaScript框架设计》学习笔记（一）

> 资料下载地址(equb, mobi, awz3, pdf):
>
> [百度网盘](https://pan.baidu.com/s/1gqEf3LIddxin14xRLfZAQg)
>
> 提取码: 2xar
>
> **本资料仅用于学习交流，如有能力请到各大销售渠道支持正版！**

## 第 1 章 种子模块

种子模块也叫核心模块，是框架最先执行的部分，里面的方法不一定要求有多么强大，但一定要十分稳定，常用以及具有扩展性。绝大多数模块都需要引用种子模块，以防止做重复的工作。

本书作者认为，种子模块应该包含如下功能：

- 对象扩展
- 数组化
- 类型判定
- 简单的事件绑定与卸载
- 无冲突处理
- 模块加载与 domReady

### 1.1 命名空间

IIFE（立即调用函数表达式）是现代 JavaScript 框架最主要的基础设施，用于防止变量污染。纵观各大类库的实现，一开始基本都是定义一个全局变量作为命名空间，然后对它进行扩展。

### 1.2 对象扩展

框架需要一种机制可以将新功能添加到命名空间上，这方法在 JavaScript 中通常被称为 extend 或者 mixin。

```javascript
function extend (destination, source) {
    for (var property in source) {
        destination[property] = source[property]
    }
    return destination
}
```

### 1.3 数组化

类数组对象是一个比较好的存储结构，不过功能太弱了，我们通常会在处理它们之前做一下转换。

```javascript
function toArray (array) {
    return [].slice.call(array)
}
```

### 1.4 类型的判定

JavaScript 存在两套类型系统，一套是基本数据类型，另一套是对象类型系统。

基本数据类型一般是通过 typeof 来检测，对象类型系统一般通过 instanceof 来检测。但很可惜的是在 JavaScript 中这么朴素的检测方法并不算靠谱。

所以对于各种类型，各大框架都实现了 isXXX 方法。

### 1.5 主流框架引入的机制——domReady

主流框架所实现的 domReady 使用的事件名为 DOMContentLoaded。与 window.onload 的主要区别在于 domReady 会在静态资源还未加载完成时就执行。

### 1.6 无冲突处理

无冲突处理也叫多库共存，主要用于解决不同的库之间使用了同样的全局变量作为自己的命名空间的情况。jQuery 发明了一个 noConflict 函数用于处理这种情况。

```javascript
var window = this,
    undefined,
    _jQuery = window.jQuery,
    _$ = window.$,
    // 把 window 存入闭包中的同名变量，方便内部函数在调用时不用大费力气找它
    // _jQuery 与 _$ 用于以后重写
    jQuery = window.jQuery = window.$ = function (selector, context) {
        // 用于返回一个 jQuery 对象
        return new jQuery.fn.init(selector, context)
    }
jQuery.extend({
    noConflict: function (deep) {
        window.$ = _$; // 相当于 window.$ = undefined
        if (deep) {
            window.jQuery = _jQuery // 相当于 window.jQuery = undefined
        }
        return jQuery
    }
})
```

这样在使用时，就可以先引入别的库，然后引入 jQuery，调用 $.noConflict() 进行改名，就可以不影响其他库的运作了。

## 第 2 章 模块加载系统

### 2.1 AMD 规范

AMD 意为异步模块定义，有效避免了采用同步加载方式导致页面卡死的现象，主要接口有 define 和 require 两个，其中 define 用于导出模块，require 用于使用模块。

define 的参数情况为`define(id?, deps?, factory)`，第一个为模块 ID，第 2 个为依赖列表，第 3 个是工厂方法。

```javascript
define('xxx', ['aaa', 'bbb'], function (aaa, bbb) {})
```

require 的参数情况为 `require(deps, callback)`，第一个为依赖列表，第二个为回调，deps 有多少个元素，callback 就有多少个传参，情况与 define 的方法一致。

```javascript
require(['aaa', 'bbb'], function (aaa, bbb) {})
```

### 2.2 require 方法

require 方法取得依赖的加载过程分为以下几步：

- 取得依赖列表的第一个 ID，转换为 URL（一般情况下默认为`basePath + ID + '.js'`），如路径有特殊规定，也可以通过`require.config`来更改，如下所示：

  ```javascript
  require.config({
      alias: {
          'jquery': {
              src: 'http://test.com/jquery.js',
              exports: '$'
          },
          'jquery.tooltip': {
              src:'http://test.com/tooltip.js',
              exports: '$',
              deps: ['jquery']
          },
          'test.css': 'http://test.com/test.css'
      }
  })
  ```

## 第 3 章 语言模块





> 本次应阅读至 P30 第 3 章 语言模块 43