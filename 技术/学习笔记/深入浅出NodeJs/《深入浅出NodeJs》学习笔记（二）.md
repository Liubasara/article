---
name: 《深入浅出NodeJs》学习笔记（二）
title: 《深入浅出NodeJs》学习笔记（二）
tags: ['读书笔记', '深入浅出NodeJs']
categories: 学习笔记
info: "深入浅出NodeJs 第2章 模块机制"
time: 2019/5/12
desc: '深入浅出NodeJs, 资料下载, 学习笔记, 第2章 模块机制'
keywords: ['深入浅出NodeJs资料下载', '前端', '深入浅出NodeJs', '学习笔记', '第2章 模块机制']
---

# 《深入浅出NodeJs》学习笔记（二）

## 第2章 模块机制

首先我们从模块来介绍 Node。

JavaScript 从出生到应用，再到真正流行，大概经历了下图的几个阶段变迁：

![javaScriptHistory.jpg](./images/javaScriptHistory.jpg)

但在这个过程中，始终有一项是 JavaScript 是欠缺的，那就是模块功能。（该功能在 ES6 中终于被原生支持了）

如同 Java 有类文件，Python 有 import 机制，Ruby 有 require ，PHP 有 include 和 require。JavaScript 却只能通过 `<script>`标签来引入，代码显得杂乱无章且没有组织性和约束能力。开发者只能用命名空间等方式来人为约束。

有鉴于此，社区也为 JavaScript 制定了相应的规范用于模块化，其中 CommandJS 规范的提出算是最为重要的里程碑。

### 2.1 CommonJS 规范

>CommonJS规范为JavaScript制定了一个美好的愿景——希望JavaScript能够在任何地方运行。

#### 2.1.1 CommonJS 的出发点

对于 JavaScript 自身而言，它的规范有以下缺陷：

- 没有模块系统
- 标准库较少
- 没有标准接口
- 缺乏包管理系统

CommonJS 规范的提出，主要是为了弥补当前 JavaScript 没有标准的缺陷，以达到像 Python、Ruby 和 Java 一样具备开发大型应用的基础能力，而非停留在小脚本程序阶段。最后使得使用 CommonJS API 开发出来的应用可以具备跨宿主环境的执行能力，这样就可以利用 JavaScript 来开发丰富的客户端应用了。其中包括但不限于：

- 服务器端 JavaScript 应用程序
- 命令行工具
- 桌面图形界面应用程序
- 混合应用

> Node借鉴CommonJS的Modules规范实现了一套非常易用的模块系统，NPM对Packages规范的完好支持使得Node应用在开发过程中事半功倍。在本章中，我们主要就Node的模块和包的实现进行展开说明。 

#### 2.1.2 CommonJS 的模块规范

CommonJS对模块的定义主要分为3个部分：

- 模块引用
- 模块定义
- 模块标识

下面是分开讲解。

1. 模块引用

   模块引用的示例代码如下：

   ```javascript
   var math = require('math')
   ```

   在 CommonJS 规范中存在一个 require 方法，这个方法接受模块标识，并以此引入一个模块的 API 到当前上下文中。

2. 模块定义

   对应引入的功能，上下文提供了 exports 对象用于导出当前模块的方法或者变量，并且它是**唯一**导出的出口。在模块中，还存在一个 module 对象代表模块自身，而 exports 是 module 的属性。在 Node 中，一个文件就是一个模块，将方法挂载在 exports 对象上作为属性即可定义导出的方式。

   ```javascript
   // math.js
   exports.add = function () {
       var sum = 0
       var i = 0
       var args = arguments
       var l = args.length
       while (i < l) {
           sum += args[i++]
       }
       return sum
   }
   ```

   在另一个文件中，通过 require 方法引入模块后，就能调用定义的属性或者方法了。

   ```javascript
   // program.js
   var math = require('math')
   exports.increment = function (val) {
       return math.add(val, 1)
   }
   ```

3. 模块标识

   模块标识其实就是传递给 require 方法的参数，**它必须是符合小驼峰命名的字符串，或者以相对路径或者绝对路径开头，可以没有文件名后缀.js**。

   > 模块的定义十分简单，接口也十分简洁。它的意义在于将类聚的方法和变量等限定在私有的作用域中，同时支持引入和导出功能以顺畅地连接上下游依赖。每个模块具有独立的空间，它们互不干扰，在引用时也显得干净利落。 
   >

![module-define.jpg](./images/module-define.jpg)

### 2.2 Node的模块实现

Node 在实现中并非完全按照规范实行，而是对模块规范进行了一定的取舍，同时也增加了一些自身需要的特性。

在 Node 中引入模块，需要经历以下三个步骤：

- 路径分析
- 文件定位
- 编译执行

在 Node 中，模块分为两类：

- Node提供的核心模块，在 Node 进程启动时就加载进了内存中，所以并没有路径分析和文件定位这两部，记载速度最快。
- 用户编写的文件模块，需进行完整的三个步骤，速度稍慢

#### 2.2.1 优先从缓存加载

> 展开介绍路径分析和文件定位之前，我们需要知晓的一点是，与前端浏览器会缓存静态脚本 文件以提高性能一样，Node对引入过的模块都会进行缓存，以减少二次引入时的开销。不同的地 方在于，浏览器仅仅缓存文件，而Node缓存的是编译和执行之后的对象。 不论是核心模块还是文件模块，require()方法对相同模块的二次加载都一律采用缓存优先的 方式，这是第一优先级的。不同之处在于核心模块的缓存检查先于文件模块的缓存检查。 

#### 2.2.2 路径分析和文件定位

1. 模块标识符分析

   模块标识符在 Node 中主要分为以下几类：

   - 核心模块，如 http、fs、path 等
   - .或者..开始的相对路径模块
   - 以/开始的绝对路径文件模块
   - 非路径形式的文件模块，如自定义的connect模块

   其中，加载速度从快到慢分别为 核心模块 > 路径形式的文件模块 > 自定义模块。

   自定义模块的路径生成会从当前的文件目录下的 node_modules 目录一直递归便利到根目录下的 node_modules，知道找到目标文件为止，因此当前文件的路径越深，模块查找的耗时也会越多。

2. 文件定位

   require() 方法在分析标识符的过程中允许不包含文件扩展名，在这种情况下，Node 会按 .js、.json、.node 的次序来补足扩展名，依次尝试。

   > 小诀窍是：如果是.node和.json文件，在传递给require() 的标识符中带上扩展名，会加快一点速度。

   当 require 通过分析文件扩展名后没有找到对应的文件，但却得到了一个目录时，Node 会将 index 当作默认文件名，然后依次查找 index.js、index.json、index.node。

#### 2.2.3 模块编译

在 Node 中，每个文件模块都是一个对象，其定义如下：

```javascript
function Module (id, parent) {
    this.id = id
    this.exports = {}
    this.parent = parent
    if (parent && parent.children) {
        parent.children.push(this)
    }
    this.filenanme = null
    this.loaded = false
    this.children = []
}
```

定义到具体的文件后，Node会新建一个模块对象，然后根据路径加载并编译。对于不同的文件，其载入方法也有所不同：

- .js文件。通过 fs 模块同步读取文件后编译执行
- .node 文件。这是用 C/C++ 编写的扩展文件，通过 dlopen() 方法加载最后编译生成的文件
- .json 文件。通过 fs 模块同步读取文件后，用 JSON.parse() 解析返回的结果
- 其余扩展文件名。它们都将被当做 .js 文件载入

> 每一个编译成功的模块都会将其文件路径作为索引缓存在Module._cache对象上，以提高二 次引入的性能。 

```javascript
// 对.json文件的读取
Module._extension['.json'] = function (module, filename) {
    var content = NativeModule.require('fs').readFileSync(filename, 'utf8')
    try {
        module.exports = JSON.parse(stripBOM(content))
    } catch (err) {
        err.message = filename + ':' + err.message
        throw err
    }
}
```

> 其中，Module._extensions会被赋值给require()的extensions属性，所以通过在代码中访问 require.extensions可以知道系统中已有的扩展加载方式

1. JavaScript 模块的编译

   回到 CommonJS 模块规范，我们知道每个模块文件中存在着 require、exports、module 这3个变量，但是它们在模块文件中并没有定义，那么它们是从何而来的呢？在 Node 的 API 文档中，我们知道每个模块中还有 `__filename`、`__dirname`这两个变量的存在，它们又是从何而来的呢？如果我们把直接定义模块的过程放在浏览器端，会出现污染全局变量的情况。

   事实上，在编译过程中，Node 对获取的 JavaScript 文件进行了头尾包装，在其头部和尾部添加了`(function (exports, require, module, __filename, __dirname) {\n，在尾部添加了\n})`。一个正常的 JavaScript 文件会被包装成如下样子。

   ```javascript
   (function (expoorts, require, module, __filename, __dirname) {
       var math = require('math')
       exports.area = function (radius) {
           return Math.PI * radius * radius
       }
   })
   ```

   如此，每个模块文件之间都进行了作用域隔离。包装后的代码会通过 vm 原生模块的 runInThisContext 方法执行，(类似 eval ，只是具有明确上下文，不污染全局)，返回一个具体 function 对象。最后，将当前模块对象的 exports 属性、require() 方法、module 以及在文件定位中得到的完整文件路径和文件目录作为参数传递给这个 function 执行。

   此外还有很多初学者纠结为何已经存在了 exports 的情况下，还存在 module.exports ，**这是为了能让 require 引入一个类而存在的**，来看下面的两种代码：

   ```javascript
   function change (exports) {
       exports = { test: 2 } // 改变了 exports 指针形参的引用
       console.log(exports) // {test: 2}
   }
   var exports = { test: 1 }
   change(exports)
   console.log(exports) // {test: 1} 由于传入的是一个指针形参，在函数外，a 指针依旧指向旧的地址，即 {test: 1}
   
   function change2 (module) {
       module.a = { test: 2 } // 未改变 module 指针形参的引用
       console.log(module.a) // { test:2 }
   }
   var module = { exports: { test: 1 }}
   change2(module)
   console.log(module.exports) // { test: 2 } 修改成功
   ```

   如上所示，直接赋值形参会改变形参的引用，但并不能改变作用域外的值，所以退而求其次，我们选择在外面包一层对象来达到曲线救国的方法。这也就是为什么要使用 module.exports 对象的原因。

2. C/C++ 模块的编译

   Node 调用 process.dlopen() 方法进行加载和执行。.node 文件并不需要编译，因为它是编译之后生成的，所以只有加载和执行的过程。在执行的过程中，模块的 exports 对象与 .node 模块产生联系，然后返回给调用者。

3. JSON 文件的编译

   JSON 文件的编译如上文所言，Node 会通过 fs 模块读取后调用 JSON 的方法得到对象，并将其赋值给模块对象的 exports，供外部调用。此外，你还可以享受到模块缓存的便利，在二次引入时也没有性能影响。

### 2.3 核心模块

JavaScript核心模块的定义如下面的代码所示，源文件通过process.binding('natives')取出， 编译成功的模块缓存到`NativeModule._cache`对象上，文件模块则缓存到`Module._cache`对象上： 

```javascript
function NativeModule(id) {
    this.filename = id + '.js'
    this.id = id
    this.exports = {}
    this.loaded = false
}
NativeModule._source = process.binding('natives')
NativeModule._cache = {}
```

PS：本小节内容有点过于硬核...还是等以后对 node 了解比较深了以后再回来看它的编译原理吧.. // TOREAD

### 2.4 C/C++ 扩展模块

// 硬核 +1... // TOREAD

### 2.6 包与 NPM

> 本次应阅读至 P33 2.6包与NPM 51