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

   

2. 自然映射



> 本次阅读至 P205 8.3.2 2.自然映射 223页