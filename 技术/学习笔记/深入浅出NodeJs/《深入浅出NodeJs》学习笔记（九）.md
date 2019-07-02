---
name: 《深入浅出NodeJs》学习笔记（九）
title: 《深入浅出NodeJs》学习笔记（九）
tags: ['读书笔记', '深入浅出NodeJs']
categories: 学习笔记
info: "深入浅出NodeJs 第8章 构建Web应用(下)"
time: 2019/6/27
desc: '深入浅出NodeJs, 资料下载, 学习笔记, 第8章 构建Web应用'
keywords: ['深入浅出NodeJs资料下载', '前端', '深入浅出NodeJs', '学习笔记', '第8章 构建Web应用']
---

# 《深入浅出NodeJs》学习笔记（九）

## 第8章 构建Web应用(下)

### 8.3 路由解析

对于路由选择问题，一般有文件路径、MVC、RESTful等路由方式。

#### 8.3.1 文件路径型

1. 静态文件

   这种路由的处理方式十分简单，将请求路径对应的文件发送给客户端即可。

2. 动态文件

   在 MVC 模式流行起来之前，根据文件路径执行动态脚本是比较基本的方式，其处理原理是 Web 服务器根据 URL 路径找到对应的文件，如 /index.asp 或 /index.php。

> 解析器执行脚本，并输出响应报文，达到完成服务的目的。现今大多数的服务器都能很智能 地根据后缀同时服务动态和静态文件。这种方式在Node中不太常见，主要原因是文件的后缀都是.js，分不清是后端脚本，还是前端脚本，这可不是什么好的设计。而且Node中Web服务器与应 用业务脚本是一体的，无须按这种方式实现

####  8.3.2 MVC

MVC 模型的主要思想是将业务逻辑按职责分离，因为事实上，**URL路径完全没必要和具体脚本所在的路径完全一致**。

MVC 最为经典的分层模式工作模式如下：

- 路由解析，根据 URL 查询到对应的控制器和行为
- 行为调用相关的模型，进行数据操作
- 调用视图和相关数据进行页面渲染，输出到客户端

控制器调用模型和如何渲染页面，日后会进行展开。如何根据 URL 做路由映射有两个分支可以实现：

- 通过手工关联映射，用一个对应的路由文件来将 URL 映射到对应的控制器
- 自然关联映射

![MVCmode.jpg](./images/MVCmode.jpg)

1. 手工映射

   > 手工映射除了需要手工配置路由外较为原始外，它对URL的要求十分灵活，几乎没有格式上 的限制。如下的URL格式都能自由映射：
   >
   > - /user/setting
   > - /setting/user
   >

   我们需要一个处理设置用户信息的控制器，假如该控制器方法如下：

   ```javascript
   exports.setting = function (req, res) {
       //TODO
   }
   ```

   再添加一个映射的方法，如下：

   ```javascript
   var routes = []
   var use = function (path, action) {
       routes.push([path, action])
   }
   ```

   我们在入口程序判断 UTL， 然后执行对应的逻辑，就可以完成基本的路由映射过程，如下所示：

   ```javascript
   function (req, res) {
       var pathname = url.parse(req.url).pathname
       for (var i = 0; i < routes.length; i++) {
           var route = routes[i]
           if (pathname === route[0]) {
               var action = route[1]
               action(req, res)
               return
           }
       }
       // 404
       handle404(req, res)
   }
   ```

   我们可以将这两个路径映射到相同的业务上去

   ```javascript
   use('/user/setting', exports.setting)
   use('/setting/user', exports.setting)
   ```

   对于简单的路径，可以采用上述的硬匹配方式，但是如下的路径请求就无法满足需求了：

   ```shell
   /profile/jacksontian
   /profile/hoover
   ```

   对于这样的路径，我们期望通过以下的方式来匹配到：

   ```javascript
   use('profile/:username', function (req, res) {
       // TODO
   })
   ```

   于是改进我们需要改进匹配的方式，在通过 use 注册路由时需要将路径转换为一个正则表达式，然后通过它来匹配。

   ![pathRegexp.jpg](./images/pathRegexp.jpg)

   上述的正则表达式能实现如下匹配：

   ```shell
   /profile/:username
   /user.:ext
   ```

   use 函数和匹配函数也要重新改进：

   ```javascript
   var use = function (path, action) {
       routes.push([pathRegexp(path), action])
   }
   ```

   匹配函数：

   ```javascript
   function (req, res) {
       var pathname = url.parse(req.url).pathname
       for (var i = 0; i < routes.length; i++) {
           var route = routes[i]
           // 正则对象执行exec方法进行正则匹配
           if (route[0].exec(pathname)) {
               var action = route[1]
               action(req, res)
               return
           }
       }
       // 404
       handle404(req, res)
   }
   ```

   **参数解析**

   尽管我们完成了正则匹配，但我们还需要进一步将匹配到的内容抽取出来，用于在业务中像下面这样调用：

   ```javascript
   use('/profile/:username', function(req, res) {
       var username = req.params.username
       // TODO
   })
   ```

   首要目标是将键值设置到 req.params 中，首先我们要将键值抽取出来，如下所示：

   ![paramPathRegexp.jpg](./images/paramPathRegexp.jpg)

   我们将根据抽取的键值和实际的 URL 得到键值匹配到的实际值，并设置到 req.params 处，如下：

   ![utlToParams.jpg](./images/utlToParams.jpg)

   至此，除了从查询字符串或提交数据中取到值外，还可以从路径的映射中取到值。

2. 自然映射

   如果项目较大，路由映射的数量比较多，也可以通过映射的方式，将某个路径映射到特定的文件路径下，其余部分采用自然映射的方式。如下面的路径：

   ```shell
   # 文件夹路径规定
   /controller/action/param1/param2/param3
   # url路径
   /user/setting/12/1987
   ```

   使用自然映射的方式，它会按照约定去找 controllers 目录下的 user 文件，将其 require 出来后，调用这个文件模块的 setting 方法，将其余的值作为参数直接传递：

   ```javascript
   function (req, res) {
       var pathname = url.parse(req.url).pathname
       var paths = pathname.split('/')
       var controller = paths[1] || 'index'
       var args = paths.slice(3)
       var module
       try {
           // require 的缓存机制使得只有第一次是阻塞的
           module = require('./controllers/' + controller)
       } catch (e) {
           handle500(req, res)
           return
       }
       var method = module[action]
       if (method) {
           method.apply(null, [req, res].concat(args))
       } else {
           handle500(req, res)
       }
   }
   ```

   这种自然映射的方式没有指明参数名称，无法采用 req.params 的方式提取，但是可以直接通过参数，使得获取更简洁，如下：

   ```javascript
   exports.setting = function (req, res, month, year) {
       // TODO
   }
   ```

#### 8.3.3 RESTful

RESTful 的流行使得大家意识到 URL 也可以设计得十分规范。请求方法也能作为逻辑分发的单元。

为了让 Node 能够支持 RESTful 需求，我们可以如下设计，进行请求方法的区分：

```javascript
var routes = {'all': []}
var app = {}
app.use = function (path, action) {
    routes.all.push([pathRegexp(path), action])
}
['get', 'put', 'delete', 'post'].forEach(function (method) {
    route[method] = []
    app[method] = function (path, action) {
        routes[method].push([pathRegexp(path), action])
    }
})
```

使用上面的代码，我们希望可以使用这样的方式完成路由映射：

```shell
// add user
app.post('/user/:username', addUser)
// delete user
app.delete('/user/:username', removeUser)
// modify user
app.put('/user/:username', updateUser)
// query user
app.get('/user/:username', getUser)
```

这样的路由能识别请求方法，并将业务进行分发。其中匹配部分可以抽象为如下方法：

```javascript
var match = function (pathname, routes) {
    for (var i = 0; i < routes.length; i++) {
        var route = routes[i]
        // 正则
        var reg = route[0].regexp
        var keys = route[0].keys
        var matched = reg.exec(pathname)
        if (matched) {
            // 抽取具体值
            var params = {}
            for (var i = 0, l = keys.length; i < 1; i++) {
                var value = matched[i + 1]
                if (value) {
                    params[keys[i]] = value
                }
            }
            req.params = params
            var action = route[1]
            action(req, res)
            return true
        }
    }
    return false
}
```

分发部分更新如下：

```javascript
function (req, res) {
    var pathname = url.parse(req.url).pathname
    // 将请求方法变为小写
    var method = req.method.toLowerCase()
    if (routes.hasOwnPerperty(method)) {
        // 根据请求方法分发
        if (match(pathname, routes[method])) {
            return
        } else {
            // 如果路径不匹配，使用 all() 来处理
            if (match(pathname, routes.all)) {
                return
            }
        }
    } else {
        // 使用 all() 处理
        if (match(pathname, routes.all)) {
            return
        }
    }
    // 处理 404
    handle404(req, res)
}
```

> 目前RESTful应用已经开始广泛起来，随着业务逻辑前端化、客户端的多样化，RESTful模式 以其轻量的设计，得到广大开发者的青睐。对于多数的应用而言，只需要构建一套RESTful服务 接口，就能适应移动端、PC端的各种客户端应用

### 8.4 中间件

> 片段式地接触完Web应用的基础功能和路由功能后，我们发现从响应Hello World的示例代码 到实际的项目，其实有太多琐碎的细节工作要完成，上述内容只是介绍了主要的部分。对于Web 应用而言，我们希望不用接触到这么多细节性的处理，为此我们引入中间件（middleware）来简 化和隔离这些基础设施与业务逻辑之间的细节，让开发者能够关注在业务的开发上，以达到提升 开发效率的目的

简单来说，中间件就是在进入具体的业务处理之前，先让数据经过一层过滤器的处理，其工作模型如下：

![middleware.jpg](./images/middleware.jpg)

一个基本的中间件形式如下：

```javascript
var middleware = function (req, res, next) {
    // TODO
    next()
}
```

中间件具体的实现方法可见本书的P213 ~ P214

通过中间件和路由的协作，我们可以将复杂的事情简化下来使得开发时只需要关注业务就能胜任整个开发工作。

#### 8.4.1 异常处理

当某个中间件出现错误时，我们需要为自己构建的 Web 应用的稳定性和健壮性负责，为此我们需要为 next 方法添加 err 参数，用于捕获中间件直接抛出的同步异常。

具体实现方法可见 P214 ~ P215

#### 8.4.2 中间件与性能

一个高效的中间件要体现两点：

- 提升单个处理单元的处理速度，尽早调用 next() 执行后续逻辑。缓存需要重复计算的结果，必要时可以通过 jsperf.com 测试基准性能。
- 合理使用路由，提高匹配成功率，尽量不要浪费磁盘 IO，使得 QPS 直线下降

### 8.5 页面渲染

> 对于过去流行的ASP、PHP、JSP等动态网页技术，页面渲染是一种内置的功能。但对于Node 来说，它并没有这样的内置功能，在本节的介绍中，你会看到正是因为标准功能的缺失，我们可 以更贴近底层，发展出更多更好的渲染技术，社区的创造力使得Node在HTTP响应上呈现出更加 丰富多彩的状态

#### 8.5.1 内容响应

通过响应报头中的 Content-* 字段，客户端可以判断应该以什么方式来处理报文，进而编译渲染文档。

```shell
Content-Encoding: gzip
Content-Length: 21170
Content-Type: text/javascript; charset=utf-8
```

客户端在接收到这个报文后，正确的处理过程是通过gzip来解码报文体中的内容，用长度校 验报文体内容是否正确，然后再以字符集UTF-8将解码后的脚本插入到文档节点中。 

1. MIME
2. 附件下载
3. 响应 JSON
4. 响应跳转





> 本次阅读至 P217 8.5.1 内容响应MIME 235