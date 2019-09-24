---
name: 《JavaScript设计模式与开发实践》学习笔记（六）
title: 《JavaScript设计模式与开发实践》学习笔记（六）
tags: ["技术","学习笔记","JavaScript设计模式与开发实践"]
categories: 学习笔记
info: "第二部分、第 7 章 迭代器模式、第 8 章 发布-订阅模式"
time: 2019/9/23,
desc: 'JavaScript设计模式与开发实践, 资料下载, 学习笔记'
keywords: ['JavaScript设计模式与开发实践资料下载', '前端', '学习笔记']
---

# 《JavaScript设计模式与开发实践》学习笔记（六）

## 第 7 章 迭代器模式

迭代器模式是指提供一种方法顺序访问一个聚合对象中的各个元素，而又不需要暴露该对象的内部表示。在使用迭代器模式以后，即使不关心对象的内部构造，也可以按照顺序访问其中的每个元素。

JavaScript 中已经有了许多方法内置了迭代器，比如`Array.prototype.forEach`、`Array.prototype.map`等等。

### 7.2 实现自己的迭代器

我们来实现一个`myEach`函数，接收循环中的每一步后将被触发的回调函数：

```javascript
Array.prototype.myEach = function (callback) {
    for (var i = 0, l = this.length; i < l; i++) {
        callback.call(this[i], this[i], i) // 把元素和下标传给 callback 函数
    }
}

var a = [1, 2, 3]
a.myEach((item, index) => {console.log(item)})
```

### 7.3 内部迭代器和外部迭代器

迭代器可以分为内部迭代器和外部迭代器两种。

> 现在有个需求要判断 2个数组里元素的值是否完全相等，比如数组 [1, 2, 3] 和 [1, 2, 3, 4]

1. 内部迭代器

   内部迭代的调用非常方便，像我们上面实现的就是一个内部迭代器，但由于内部迭代器的迭代规则已经被提前规定，上面的 each 函数无法同时迭代 2 个数组。要实现上面的需求，我们只能从回调函数着手。

   ```javascript
   var compare = function (arr1, arr2) {
       if (arr1.length !== arr2.length) throw new Error('两个数组不相等')
       arr1.myEach((i, n) => {
           if (i !== arr2[n]) {
               throw new Error('两个数组不相等')
           }
       })
       alert('两个数组相等')
   }
   compare([1,2,3], [1,2,3,4])
   ```

   这种写法虽然能得出结果，却显得十分“蹩脚”，完全依赖于 JavaScript 能够任意传递回调函数的特性。

   > 在一些没有闭包的语言中，内部迭代器本身的实现也相当复杂。比如C语言中的内部迭代器是用函数指针来实现的，循环处理所需要的数据都要以参数的形式明确地从外面传递进去

   

2. 外部迭代器

   外部迭代器规定了必须显式地请求迭代下一个元素，虽然增加了一些调用的复杂度，但也增强了迭代的灵活性，使我们可以手工控制迭代的过程或者顺序。

   下面是一个外部迭代器的实现：

   ```javascript
   let Iterator = function (obj) {
       let current = 0
       let next = function () {
           current += 1
       }
       let isDone = function () {
           return current >= obj.length
       }
       let getCurrItem = function () {
           return obj[current]
       }
       return {
           next,
           isDone,
           getCurrItem
       }
   }
   ```

   在这种迭代器下，我们可以将 compare 函数改写如下：

   ```javascript
   let compare = function (iterator1, iterator2) {
       while (!iterator1.isDone() && !iterator2.isDone()) {
           if (iterator1.getCurrItem() !== iterator2.getCurrItem()) {
               throw new Error('不相等')
           }
           iterator1.next()
           iterator2.next()
       }
       if (iterator1.isDone() && iterator2.isDone()) {
           alert('相等')
       } else {
           throw new Error('长度不相等')
       }
   }
   
   var iter1 = Iterator([1, 2, 3])
   var iter2 = Iterator([1, 2, 3, 4])
   compare(iter1, iter2)
   ```

   外部迭代器虽然调用方式相对复杂，但它的适用面更广，也更能满足多变的需求。

两种迭代器没有优劣之分，使用哪个要根据具体需求而定。

### 7.4 迭代类数组和字面量对象

在 JavaScript 中，迭代器模式不仅可以迭代数组，还可以迭代一些类数组的对象，无论内部迭代器还是外部迭代器，只要被迭代的对象拥有 length 属性且可以用下标访问，那它就可以被迭代。

此外，JavaScript 的`for...in`语句也可以用来迭代普通字面量对象的属性。

### 7.7 迭代器模式的应用举例 —— 根据不同的浏览器获取响应的上传组件对象

```javascript
/** 以下为伪代码 **/
// 将获取各种 upload 对象的方法封装在各自的函数里，然后使用一个迭代器获取这些 upload 对象，直到获取到一个可用的为止

var getActiveUploadObj = function () {
    try {
        return new ActiveXObject("TXFTNActiveX.FTNUpload") // IE 上传
    } catch (e) {
        return false
    }
}

var getFlashUploadObj = function () {
    // Flash 上传
    // ...
}

var getFormUploadObj = function () {
    // 表单上传
    var str = `<input name="file" type="file" class="ui-file"></input>`
    return document.body.appendChild(document.createTextNode(str))
}

// 迭代器
var iteratorUploadObj = function () {
    let args = [...auguments]
    for (var i = 0, fn;fn = arguments[i++];) {
        var uploadObj = fn()
        if (uploadObj !== false) {
            return uploadObj
        }
    }
}

// 根据优先级添加 upload 对象方法
var uploadObj = iteratorUploadObj(getActiveUploadObj, getFlashUploadObj, getFormUploadObj)
```

使用上面这种方法我们可以让不同的获取上传对象方法隔离互不干扰，同时也方便拓展，以后如果有新的 upload 对象，也能很方便的拓展进来。

## 第 8 章 发布-订阅模式





> 本次阅读至P110 第 8 章 发布-订阅模式 129