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

当然我们在编写代码的时候，使用一个框架，IDE 或者其他构建工具的可能性很大，而不是每次都将你的代码复制粘贴到 Web 应用程序中。大多数的现代系统都有内置的工具，并能够在转换过程中将开发文件与部署分开，并且能够在此过程中执行各种转换，就像代码最小化一样。

举个例子，一个从开发环境到部署环境的 Gulp 任务（包含 HTML 缩小功能）可能如下所示：

```javascript
var gulp = require('gulp');
var htmlmin = require('gulp-html-minifier');
gulp.task('minify', function() {
  gulp.src('./src/*.html') //development location
    .pipe(htmlmin({collapseWhitespace: true}))
    .pipe(gulp.dest('./dist')) //deployment location
});
```

执行该任务的命令可能是：

`gulp minify`

（插件来源： [npmjs](https://www.npmjs.com/package/gulp-html-minifier)）

该任务会将 HTML 文件从它的原始位置输出到部署的位置，并在构建过程中最小化代码。这不仅可以防止对源文件进行潜在且不可恢复的修改，还可以避免在以后的开发和测试的过程中污染生产环境。

### 压缩文本资源

如果服务器能够自动压缩整个文件的话能够更好的帮助我们，而这就是 Gzip 的用武之地。

Gzip 是一种用来压缩和解压缩文件（及其文件格式）的应用程序。跟文件的压缩类似，它也能通过减少资源的大小来缩短服务器的响应时间。它可以通过 GNU 网站来进行使用：

https://www.gnu.org/software/gzip/

Gzip 提供的压缩能力在文本资源上的效果表现最佳，通常能够压缩高达 70% 的空间（对于大文件来说甚至会更高）。但是，在压缩非文本资源时，像图片这类，就通常不会提供这么显著的压缩效果了。

和桌面或浏览器级别的本地压缩不同，Gzip 在服务器上工作并且识别和处理您指定文件类型。虽然所有的现代浏览器都支持 HTTP 请求的 Gzip 压缩。但你也必须在服务器上进行配置以确保在请求时能够提供压缩资源。当然，不同的服务器会有不同的设置要求，比如说就可以通过`.htaccess`文件来配置 Apache 服务器，可以像下面这样配置：

```xml
<IfModule deflate_module>
    # Enable compression for the following file types
    AddOutputFilterByType           \
     DEFLATE                        \
      application/javascript        \
      text/css                      \
      text/html                     \
      text/javascript               \
      text/plain                    \
      text/xml
</IfModule>
```

在 BetterExplained 有一篇非常好的[文章](https://betterexplained.com/articles/how-to-optimize-your-site-with-gzip-compression/)，介绍了了 Gzip 的背景信息，示例和注意事项。

在服务器上开启了 GZip 以后，要怎么样知道文件实际上被压缩了多少呢？一个简单的方法是在 GIDNetwork 的 Gzip 测试站点上进行检查。

http://www.gidnetwork.com/tools/gzip-test.php

![loading-1.png](./images/loading-1.png)

该报告包含了有关站点压缩的通常信息，一个“有意思”的“假设”图表，显示站点在 Gzip 压缩级别下，网站，页面资源和响应头将会获得多少压缩。

就像上图一样，我们对于 gidnetwork 的官网进行了测试，有趣的事，这个网站看起来并没有被压缩。

Gzip 可以更进一步的对已经压缩过的文件进行压缩，并且这是一种有效的方法。事实上，对于文本资源来说，为了获得更多的压缩率，需要在部署之前就将它们单独缩小，然后通过支持 Gzip 的服务器来进行传输。

### 减少库的使用





> 下一段：Popular CSS and JavaScript libraries do their best to minify and compress their download files, but generally they're still pretty serious bandwidth consumers. jQuery, for example -- depending on the version and the compression algorithms applied -- might range from 28k to over 250k. If you need most of a given library's features, fine; but if you only need one or two specific things, you can save a lot of download time by replacing those features with single-use functions or CSS rules.





