---
name: SVG symbol使用实践及反思
title: SVG symbol使用实践及反思
tags: ["技术", "瞎折腾"]
categories: 瞎折腾
info: "img 一把梭"
time: 2022/3/30
desc: SVG symbol使用实践及反思
keywords: ['web前端', 'svg', 'javascript', 'symbol', 'iconfont']
---

# SVG symbol使用实践及反思(TODO)

> 参考资料：
>
> - [未来必热：SVG Sprites技术介绍](https://www.zhangxinxu.com/wordpress/2014/07/introduce-svg-sprite-technology/)
> - [Multi-Colored SVG Symbol Icons with CSS Variables](https://frontstuff.io/multi-colored-svg-symbol-icons-with-css-variables)

## 问题

### 为什么要使用 svg symbol

- 通过 img src 引入的 svg 图片无法套色，只能用一些黑科技手段如 filter 等属性进行转换，除此以外，就只能傻乎乎的每一种状态用一种图片，消耗资源而且替换起来十分麻烦。

- 如果只是套色的话，其实可以使用 iconfont 来作为代替解决，但是一来 font-face 作为字体，实现彩色图标的属性控制只能靠 color，不太灵活而且其实还是有些 hack 的成分在里边。二来对于一些苛刻的设计来说，font-face 在字体较小时所实现的图标依旧会有锯齿和模糊的问题。而作为其上位替代的 svg 则是完全的矢量图形，不会有这些问题。

svg symbol 通过在网页端原生引入的方式，通过 use 属性能够更好的发挥 svg 中的 fill 属性及其方便套色的优点。一个最简单的使用例子如下：

 `<svg><use href="#icon-id"></use></svg>`

### svg symbol 在带来这些好处的同时会引发什么问题

- 如果使用 use 方法引用外部 svg（常见于  cdn 的场景下），会造成跨域问题，需要将 svg 文件转换为 js 文件，通过 script 标签不会跨域的特性的方法对 svg 进行动态创建，带来了一定的构建成本。

- 要实现变量套色，除了使用 fill 属性以外（使用 fill 属性也有一定的前提条件，要求这个 icon 必须要足够简单且没有预先设置 fill 属性），更好用的是如同 [Multi-Colored SVG Symbol Icons with CSS Variables](https://frontstuff.io/multi-colored-svg-symbol-icons-with-css-variables) 文章中介绍的，使用 css var 变量来对特定的颜色进行管理。可是在实践之后发现，这样做虽然很灵活，但是不易对批量的 svg 进行管理。

  具体的原因是，目前可以提供 svg 管理能力的网站，无论是国内的 iconfont 还是国外的 icomoon，似乎在上传完 svg 图标以后，重新压缩并下载下来后，symbol-defs 里面的 css var 变量都会被吞掉，这对于整个开发流程来说是致命的，因为不可能让开发者在下载完这些图标以后，再一个个把对应的 css 变量添加到对应 id 的 symbol 上去，所以就导致了这一强大的功能就像空中楼阁一样，还有待研究如何去实现。

## 简易使用步骤

> （TOOD：待补充流程图片）

1. 准备好几个 svg 图片

2. 将它们上传到 icomoon 的项目中进行管理 TODO

3. 将需要的 svg 选中，统一再下载成压缩包，能在压缩包中看见其自动生成的 symbol-defs.svg  文件，打开查看，会发现自己的 svg 已经以特定的 id 为格式封装在一个个 symbol 里面了。TODO

4. 通过一个统一的 node 脚本，将 symbol-defs.svg 雪碧图转换为 js 文件，具体作用就是生成一个 js 脚本，在引入之后立即创建一个`<script>`标签，然后将雪碧图中的所有 svg 插入到页面中。TODO：node 脚本待补充

5. 随后在项目中引用这个生成好的 js 脚本，即可在组件里通过 `<svg><use href="#icon-id"></use></svg>`的方式对 svg 进行引用。如果要进行套色，只需要在 css 中，给对应的 svg 指定一个 fill 属性即可，如以下伪代码：

   ```html
   <svg class="demo-svg"><use href="#demo"></use></svg>
   
   <style lang="less">
     .demo-svg {
       fill: red;
       &:hover {
         fill: green;
       }
       &:active {
         fill: black;
       }
     }
   </style>
   ```

   

