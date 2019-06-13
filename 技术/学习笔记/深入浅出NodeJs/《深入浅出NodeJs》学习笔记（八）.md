---
name: 《深入浅出NodeJs》学习笔记（八）
title: 《深入浅出NodeJs》学习笔记（八）
tags: ['读书笔记', '深入浅出NodeJs']
categories: 学习笔记
info: "深入浅出NodeJs 第8章 构建Web应用"
time: 2019/6/11
desc: '深入浅出NodeJs, 资料下载, 学习笔记, 第8章 构建Web应用'
keywords: ['深入浅出NodeJs资料下载', '前端', '深入浅出NodeJs', '学习笔记', '第8章 构建Web应用']
---

# 《深入浅出NodeJs》学习笔记（八）

## 第8章 构建Web应用

> Node 的出现将前后端的壁垒再次打破，JavaScript这门初就能运行在服务器端的语言，在经历了前端 的辉煌和后端的低迷后，借助事件驱动和V8的高性能，再次成为了服务器端的佼佼者。在Web应 用中，JavaScript将不再仅仅出现在前端浏览器中，因为Node的出现，“前端”将会被重新定义。 
>
> 单从框架而言，在后端数 得出来大名的就有Structs、CodeIgniter、Rails、Django、web.py等，在前端也有知名的BackBone、 Knockout. js、AngularJS、Meteor等。在Node中，有Connect中间件，也有Express这样的MVC框架。 值得注意的是Meteor框架，它在后端是Node，在前端是JavaScript，它是一个融合了前后端 JavaScript的框架。 

本章会展开描述Web应用在后端实现中的细节和原理。 

### 8.1 基础内容

> 本章的Web应用方面的内容， 将从http模块中服务器端的request事件开始分析。request事件发生于网络连接建立，客户端向 服务器端发送报文，服务器端解析报文，发现HTTP请求的报头时。在已触发reqeust事件前，它 已准备好ServerRequest和ServerResponse对象以供对请求和响应报文的操作。 

下面是一个调用 ServerResponse 来实现响应的最简单例子：

```javascript
var http = require('http')
http.createServer(function (req, res) {
    res.wirteHead(200, {'Content-Type': 'text/plain'})
    res.end('Hello World')
}).listen(1337, '127.0.0.1')
console.log('Server running at http://127.0.0.1:1337/')
```

当然，对于一个完整的 Web 应用来说，上面这种简单的响应肯定是不够的。在具体的业务中，我们至少还会有如下的需求：

- 请求方法判断
- URL 路径解析
- URL query字符串解析
- Cookie 解析
- Basic 认证
- 表单数据的解析
- 上传文件的处理

除此以外，可能还会有 Session 的需求。而我们要做的就是将所有的响应包装成一个函数传递给 createServer() 方法作为 request 事件的侦听器：

```javascript
var app = connect()
http.createServer(app).listen(1337)
```

#### 8.1.1 请求方法

HTTP_Parser在解析请求报文的时候，将报文头抽取出来，设置为req.method。

> 通常，我们 只需要处理GET和POST两类请求方法，但是在RESTful类Web服务中请求方法十分重要，因为它会 决定资源的操作行为。PUT代表新建一个资源，POST表示要更新一个资源，GET表示查看一个资源， 而DELETE表示删除一个资源。

```javascript
function (req, res) {
    switch (req.method) {
        case 'POST':
          create(req, res)
          break
        case 'GET':
        default:
          get(req, res)
    }
}
```

上面的伪代码可以根据请求方法将复杂的业务逻辑进行分发，化繁为简。

#### 8.1.2 路径解析

HTTP_Parser 将其解析为 req.url，其中 hash 部分会被丢弃，不存在于报文的任何地方。

我们可以使用这个路径来构造一个静态文件服务器。

```javascript
function (req, res) {
    var pathname = url.parse(req.url).pathname
    fs.readFile(path.join(ROOT, pathname), function (err, file) {
        if (err) {
            res.writeHead(404)
            res.end('---404 NOT FOUD---')
            return
        }
        res.writeHEAD(200)
        res.end(file)
    })
}
```

还有一种常见的分发场景是根据路径来选择控制器，通过预设路径为控制器和行为的组合，无需额外配置路由信息。

举个例子，如果访问 url 为 `/controller/action/a/b/c`该 url 会对应到控制器的行为，将剩余的值作为参数进行别的判断：

```javascript
function (req, res) {
    var pathname = url.parse(req,url).pathname
    var paths = pathname.split('/')
    var controller = paths[1] || 'index'
    var action = paths[2] || 'index'
    var args = paths.slice(3)
    if (handles[controller] && handles[controller][action]) {
        handles[controller][action].apply(null, [req, res].concat(args))
    } else {
        res.writeHead(500)
        res.end('找不到响应的控制器')
    }
}
```

这样我们就可以在控制器部分专心实现业务逻辑了：

```javascript
handles.index = {}
handles.index.index = function (req, res, foo, bar) {
    res.writeHead(200)
    res.end(foo)
}
```

#### 8.1.3 查询字符串

Node 提供了 querystring 模块用于 url 中属于 query 部分的数据：

```javascript
var url = require('url')
var querystring = require('querystring')
// 方法1
var query = querystring.parse(url.parse(req.url).query)
// 方法2
var query = url.parse(req.url, true).query
```

它会将 url 中 `foo=bar&baz=val` 解析成一个对象`{foo: 'bar', baz: 'val'}`。

要注意的是，如果查询字符串中的键出现多次，那么它的值会是一个数组：

```javascript
//  foo=bar&foo=baz
var query = url.parse(req.url, true).query
// { foo: ['bar', 'baz'] }
```

#### 8.1.4 Cookie





> 本次阅读至 P181 8.1.4 Cookie 199