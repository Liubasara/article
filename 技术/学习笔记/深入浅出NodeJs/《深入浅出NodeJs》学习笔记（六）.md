---
name: 《深入浅出NodeJs》学习笔记（六）
title: 《深入浅出NodeJs》学习笔记（六）
tags: ['读书笔记', '深入浅出NodeJs']
categories: 学习笔记
info: "深入浅出NodeJs 第6章 理解Buffer"
time: 2019/6/2
desc: '深入浅出NodeJs, 资料下载, 学习笔记, 第6章 理解Buffer'
keywords: ['深入浅出NodeJs资料下载', '前端', '深入浅出NodeJs', '学习笔记', '第6章 理解Buffer']
---

# 《深入浅出NodeJs》学习笔记（六）

## 第6章 理解Buffer

文件和网络 IO 对于前端开发者而言，都是不曾有的应用场景。（emmm...做上传的时候还是需要处理文件的啊），由于在 Node 中应用需要处理网络协议，错做数据库，处理图片、接收上传文件等等，在网络流和文件的操作中，还要处理大量二进制数据，JavaScript 自有的字符串远远不能满足这些需求，于是 Buffer 对象应运而生。

### 6.1 Buffer 结构

Buffer 是一个像 Array 的对象，但它主要用于操作字节。

#### 6.1.1 模块结构

Buffer 是一个典型的 JavaScript 与 C++ 结合的模块，它将性能相关的部分用 C++ 实现，将非性能相关部分用 JavaScript 实现。

Buffer 所占用的内存也不是通过 V8 分配的，属于堆外内存。

Node 在进程启动的时候会自动加载 Buffer 模块并放在全局对象 Global 上，所以无需通过 require 即可直接使用它。

#### 6.1.2 Buffer 对象

Buffer 对象类似于数组，其元素为16进制的两位数，即 0 到 255 的数值。

```javascript
var str = "hello"
var buf = new Buffer(str, 'utf-8')
console.log(buf)
// <Buffer 68 65 6c 6c 6f>
```

在 Buffer 中，中文字在 UTF-8 编码下占用3个元素，字幕和半角标点符号占用1个元素。

Buffer 也和 Array 一样可以访问 length 属性得到长度，也可以通过下标访问元素，在构造对象时也可以通过`new`来构造一个固定字节长度的对象。

> 给元素的赋值如果小于0，就将该值逐次加256，直到得到一个0到255之间的整数。如果得到 的数值大于255，就逐次减256，直到得到0~255区间内的数值。如果是小数，舍弃小数部分，只 保留整数部分

#### 6.1.3 Buffer 内存分配

Buffer 内存分配是在 Node 的 C++ 层面实现内存申请的，然后再在 JavaScript 中进行分配。Node 在内存分配时采用了 slab 动态内存管理机制。

slab 分配机制有点过于硬核，在此不过于深入。

### 6.2 Buffer 的转换

Buffer 对象可以和字符串之间相互转换，目前支持以下几种字符串编码：

- ASCII
- UTF-8
- UTF-16LE/UCS-2
- Base64
- Binary
- Hex

#### 6.2.1 字符串转 Buffer

通过`new Buffer(str, [encoding])`可以使用构造函数将字符串转为 Buffer 对象。

使用`write()`方法可以在一个 Buffer 对象中存储不同编码类型的字符串转码的值，如下

```javascript
buf.write(string, [offset], [length], [encoding])
```

就可以达到不断写入内容到 Buffer 对象的目的。

#### 6.2.2 Buffer 转字符串

调用 Buffer 实例的 toString() 方法就可以将对象转换为字符串，也可以指定 encoding,start,end 这3个参数实现整体或局部的转换。

```javascript
buf.toString([encoding], [start], [end])
```

#### 6.2.3 Buffer 不支持的编码类型

Buffer 提供了一个 isEncoding(encoding) 函数来判断编码是否支持转换。

对于不支持的编码类型，可以借助 Node 生态圈中的模块，如 iconv 和 iconv-lite 模块来进行更多的转换。

```javascript
var iconv = require('iconv-lite')
var str = iconv.decode(buf, 'win1251')
var buf = iconv.encode("Sample input string", 'win1251')
```



### 6.3 Buffer 的拼接

Buffer 在使用场景中，通常是以一段一段的方式传输。以下是常见的从输入流中读取内容的代码：

```javascript
var fs = require('fs')
var rs = fs.createReadStream('test.md')
var data = ''
rs.on('data', function (chunk) {
    data += chunk
})
rs.on('end', function () {
    console.log(data)
})
```

需要**注意的是：上面这段代码在输入流中存在中文或中文符号(宽字节编码)时，是会出现转译错误的**，核心原因在于`data += chunk`这一句隐藏的`toString()`操作，导致 Buffer 转出的字符串无法被识别。

> 乱码是如何产生的？
>
> 这首诗的原始Buffer应存 储为： 
> <Buffer e5 ba 8a e5 89 8d e6 98 8e e6 9c 88 e5 85 89 ef bc 8c e7 96 91 e6 98 af e5 9c b0 e4 b8 8a e9 9c 9c ef bc 9b e4 b8 be e5 a4 b4 e6 9c 9b e6 98 8e e6 9c 88 ...>
>
> 由于我们限定了Buffer对象的长度为11，因此只读流需要读取7次才能完成完整的读取，结果 是以下几个Buffer对象依次输出： 
> <Buffer e5 ba 8a e5 89 8d e6 98 8e e6 9c> <Buffer 88 e5 85 89 ef bc 8c e7 96 91 e6> ... 
>
> 上文提到的buf.toString()方法默认以UTF-8为编码，中文字在UTF-8下占3个字节。所以第 一个Buffer对象在输出时，只能显示3个字符，Buffer中剩下的2个字节（e6 9c）将会以乱码的形 式显示。第二个Buffer对象的第一个字节也不能形成文字，只能显示乱码。于是形成一些文字无法正常显示的问题。 

#### 6.3.2 setEncoding 与 string_decoder

可读流有一个设置编码的方法 setEncoding(encoding)，它可以让 data 事件中传递的不再是一个 Buffer 对象，而是编码后的字符串。

> 虽然string_decoder模块很奇妙，但是它也并非万能药，它目前只能处理UTF-8、Base64和 UCS-2/UTF-16LE这3种编码。所以，通过setEncoding()的方式不可否认能解决大部分的乱码问 题，但并不能从根本上解决该问题。 

#### 6.3.3 正确拼接Buffer

真正的解决方法是将多个小 Buffer 对象拼接为一个 Buffer 对象，然后通过 iconv-lite 一类的模块来转码这种方式。

正确的拼接方式是用一个数组来存储接收到的所有 Buffer 片段并记录下所有片段的总长度，然后调用 Buffer.concat() 方法生成一个合并的 Buffer 对象。

### 6.4 Buffer 与性能

> 通过预先转换静态内容为Buffer对象，可以有效地减少CPU的重复使用，节省服务器资源。 在Node构建的Web应用中，可以选择将页面中的动态内容和静态内容分离，静态内容部分可以通 过预先转换为Buffer的方式，使性能得到提升。由于文件自身是二进制数据，所以在不需要改变 内容的场景下，尽量只读取Buffer，然后直接传输，不做额外的转换，避免损耗

**文件读取**

可以通过在文件读取时设置 highWaterMark 来优化Buffer 内存的分配和使用，但 highWaterMark 不宜设置过小，否则可能会导致系统调用次数过多。

