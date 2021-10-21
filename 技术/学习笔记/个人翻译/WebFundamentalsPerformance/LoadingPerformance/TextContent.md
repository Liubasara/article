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



> 下一段：Sure, we can't read it now, but the browser still can. That's a 26% reduction in size and required download time; pretty significant, even for this small sample.





