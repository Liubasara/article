---
name: TextContent
title: 页面加载性能-文字内容
tags: ["技术","学习笔记", "个人翻译", "WebFundamentalsPerformance", "谷歌开发者文档"]
categories: 学习笔记
info: "页面加载性能-文字内容"
time: 2021/10/12
desc: '个人翻译, Text Content, Web'
keywords: ['学习笔记', '个人翻译', 'Text Content']
---

# 页面加载性能-文字内容

该系列为谷歌开发者文档的一些翻译，对应章节目录链接可以[访问这里](https://developers.google.com/web/fundamentals?hl=zh-cn)

> 原文链接：https://developers.google.com/web/fundamentals/performance/get-started/textcontent-3?hl=zh-cn

文本，字母和数字，词语和短语，句子和段落。这是我们在网页中传达大部分意义的方法。文本内容会向我们的“读者”（并不单指“访问者”）告知、描述、解释概念和程序。这是网络通讯中非常基础的部分。

在网页中的文本经常包含一些结构（译者注：DOM？），即便只是在默认情况下，有一些自上而下的一些格式也是如此。它还可以表现出行为，移动或改变，出现或消失等特性，来响应读者的行为或作者的意图。不过对于文本内容本身来说（in and of itself），并不包含上述的特性和能力。它的结构，表现和行为是由其他的文本资源（HTML、CSS、JavaScript）来进行实施和影响的。

在网页中的每个角色，像内容、结构、格式还有行为都必须要从服务器上下载到浏览器，这是一项非常重要的任务。在本节中，我们会了解一些加速文本内容加载的有效方法。

## 将开发与部署分开

当你压缩了资源的文本量，或者做了其他操作影响了资源的可读性的操作时，一定要记住当你修改了用于部署的代码块时，就通常无法再阅读它了，更不用说维护它了，记住这点是很重要的。一定要始终将开发和部署文件分开，以避免用部署版本替换开发文件。但如果真的有一天发生了意外，一个代码美化器或是代码反压缩器（unminfier，比如说 http://unminify.com/）或许可以拯救。

## 最小化代码

一个简单而有效的方法就是压缩代码，这种方法本质上就是通过移除代码的空白和不必要的字符，且在不改变其功能的前提下来压缩文本资源。这听起来好像没那么有用，但确实是如此，像下面这段代码里的小函数（表排序脚本的一部分）最开始包含了 348 个字符。

```javascript
function sortables_init() {
    // Find all tables with class sortable and make them sortable
    if (!document.getElementsByTagName) return;
    var tbls = document.getElementsByTagName("table");
    for (ti=0;ti<tbls.length;ti++) {
     thisTbl = tbls[ti];
     if (((' '+thisTbl.className+' ').indexOf("sortable") != -1) && (thisTbl.id)) {
         ts_makeSortable(thisTbl);
     }
    }
}
```

但在最小化之后，就只包含 257 个字符了。

```javascript
function sortables_init(){if(!document.getElementsByTagName)return;var tbls=document.
getElementsByTagName("table");for(ti=0;ti<tbls.length;ti++){thisTbl=tbls[ti];
if(((''+thisTbl.className+'').indexOf("sortable")!=-1)&&(thisTbl.id)){ts_makeSortable(thisTbl)}}}
```

当然，我们现在已经无法阅读这段代码了，但是浏览器依然可以。对于大小和阅读时间来说，减少了 26%，即使是对一个简单的例子而言，这也是十分重要的。

从更大的角度来看，包含上面这个脚本的代码块大小超过了 10K，但在最小化之后，大小缩减到了 5411 个字符，整整降低了 48%。

HTML 和 CSS 也能用同样的方法进行优化，以便缩短这些可压缩代码的加载时间。

有很多（非常多）在线或者桌面工具能用于最小化代码。其中一个因为其长寿和稳定而闻名，并且最流行也是最被推荐的在线工具是 [Kangax HTML Minifier](https://kangax.github.io/html-minifier/)。该工具为缩小的代码提供了广泛的输出自定义选项。

其他最小化代码工具包括：

- [Minifier](http://www.minifier.org/): 一个通过复制粘贴来在线压缩 JavaScript 和 CSS 的工具。
- [HTML Minifier](http://www.willpeavy.com/minifier/): 同样是一个在线工具，而且也能处理 HTML，并能够自动识别代码类型。
- [Node module for Grunt](https://www.npmjs.com/package/grunt-html-minify): 一个用来最小化代码的 NPM 库，可以集成在 Grunt 构建工具的工作流中使用。
- [Node module for Gulp](https://www.npmjs.com/package/gulp-html-minifier): 同上，一个可以集成在 Gulp 工作流中的 NPM 库。
- [Node module for HTML Minifier](https://www.npmjs.com/package/html-minifier): 一个 NPM 库，包含了一个很有用的可视化图表，用来将它与其他的压缩方法进行比较。

### 框架



> 下一段：Of course, chances are good that you do (or will) use a framework, IDE, or other structured environment as you write, rather than copy/pasting your code into a web app one file at a time. Most modern systems have built-in facilities for keeping development files separate from deployment during the build process, and are able to perform a variety of transformations, such as minification, along the way.





