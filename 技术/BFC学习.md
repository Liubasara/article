---
name: BFC学习
title: BFC学习
tags: ["技术"]
categories: 学习笔记
info: "html 里的皇母娘娘，分海的摩西"
time: 2020/12/17
desc: '学习笔记, 前端, CSS, BFC'
keywords: ['前端', '学习笔记', 'BFC']
---

# 从 clearfix 到 BFC 的学习

> 参考资料：
>
> - [为什么 .clear :after 和 :before 的 display 属性要定义为 table?](https://www.zhihu.com/question/37004035)
>- [前端精选文摘：BFC 神奇背后的原理](https://www.cnblogs.com/lhb25/p/inside-block-formatting-ontext.html)
> - [A new micro clearfix hack](http://nicolasgallagher.com/micro-clearfix-hack/)

在日常开发中遇到需要清除 float 属性浮动的需求，一般都会加上这样一段代码：

```html
<div class="clearfix">
  <div style="float: left; margin: 20px 0;">
    float
  </div>
</div>

<style>
  .clearfix::after {
    display: table;
    clear: both;
    content: "";
  }
</style>
```

但上面小小的一个 clearfix 类其实包含了两个知识点：

- clear: both，规定元素的两边不允许存在浮动元素，若存在，元素会另起一行，父元素也就能顺其自然将所有的浮动元素包裹进来了。
- display: table

## display: table 用于生成 BFC

上面的 CSS 代码，你会发现即便将 clearfix 中的 display 变成 block 也是可以生效的，因为清除浮动的任务是由 clear 属性完成的，跟 table 布局其实没有关系。table 布局在此处的作用是形成一个 BFC。

> BFC 全称（block formatting context），直译为"块级格式化上下文"。它是一个独立的渲染区域，只有Block-level box参与， 它规定了内部的Block-level Box如何布局，并且与这个区域外部毫不相干。

一个独立的 BFC 会隔离其上下的 margin 距离，换句话说就是子元素的 margin 无法突破 BFC 区域被泄露到外面，因此，一个看似没有用处高度为 0 的 BFC，就可以阻止父元素中最后一个子元素的 margin 泄露，并与父元素下一个元素的 margin 纠缠在一起。

```html
<div class="clearfix">
  <div style="margin-bottom: 10px;">234</div>
</div>
<div style="margin-top: 10px;">
  123
</div>
  
<style>
  .clearfix::after {
    display: table;
    clear: both;
    content: "";
  }
</style>
```

像上面的例子一样，如果 display 不是 table 而是其他值的话，两个元素就会出现间隔折叠的情况。

**PS：由于 clearfix::after 只会在父元素内部生成 BFC。所以如果 margin 是设置在父元素上而不是从子元素中泄露出去的话（`<div class="clearfix" style="margin-bottom: 10px;"></div>`），依然会出现间隔折叠的情况**

同样的，如果在 before 伪元素上加入 display: table，就可以生成 BFC 防止首个子元素的 margin 泄露到外面去。

```html
<div style="margin-bottom: 10px">234</div>
<div class="clearfix">
  <div style="margin-top: 10px">123</div>
</div>

<style>
  .clearfix::before {
    display: table;
    content: '';
  }
  .clearfix::after {
    display: table;
    clear: both;
    content: '';
  }
</style>
```

实际开发时，可以针对情况对这两种生成 BFC 的方式进行选用。