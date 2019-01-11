---
name: 基于Vue-Cli3用Vue搭建一个GitHub Page博客
title: 基于Vue-Cli3用Vue搭建一个GitHub Page博客
info: "从零开始的博客搭建~"
categories: 技术
tags: ['技术']
time: 2018/11/29 12:00
---

# 基于Vue-Cli3用Vue搭建一个GitHub Page博客

---

> 引用资料：
>
> - [使用 github pages, 快速部署你的静态网页](https://blog.csdn.net/baidu_25464429/article/details/80805237)
> - [ Vue CLI 3](https://cli.vuejs.org/zh/)
> - [ 手把手教你用vue搭建个人站](https://segmentfault.com/a/1190000015721550)
> - [gray-matter](https://github.com/jonschlinkert/gray-matter)
> - [深入浅出 VuePress（一）：如何做到在 Markdown 中使用 Vue 语法](https://www.jianshu.com/p/c7b2966f9d3c)
> - 

之前自己申请过域名搞过个人Blog，但是后来由于自己前端技术实在太渣，写出来的页面不敢直视，所以写了两天就放弃了。

这次好歹自己也已经写了半年前端，自己积累的东西也是时候总结出来为自己所用一波了。虽然网络上已经有很多成熟的基于GitHub Page的博客系统，但所谓程序员的天性就是把简单的东西复杂化。而且用别人的轮子始终还是比不上自己手撸一个来得有成就感，正好之前用Vue都是基于Vue-cli2的，Vue-cli3还没用过，所以说干就干，搭一个博客出来玩玩！

## 需求梳理

- 一个简易的博客系统，可以发布不同类型的文章
- 识别Markdown文件，将article文件中写好的文章自动转换为博客
- other feature……

## 需求分析

> 看到这些需求，其实重点不在于你要用什么框架来写。vue也好react也好甚至Jquery或者原生的JS，都可以。
>
> 重点在于你如何处理Markdown文件，把它转换成你需要的对象，并且在你的页面中，可以通过路由来控制页面的内容的切换。
>
> 简而言之，就是两点：
>
> - 博客数据
> - 页面路由

## 正式开始

> 在搭建个人博客的时候遇到了非常多的难题，在此非常推荐一个[开源项目](https://github.com/DendiSe7enGitHub/vue-blog-generater)，一样是使用了vue+markdown自己生成的博客，做得非常漂亮之余代码也写得十分简洁，十分推荐各位通读这个项目的源码。

如何安装Vue-cli3就不在此赘述，烦请各位看官前往Vue-cli3官网自行解决。

如何在GitHub上创建自己的项目和如何生成GitHub Page也也不在此啰嗦，但有以下一点是要注意的。

![选择GitHub Page地址](https://raw.githubusercontent.com/ssthouse/d3-blog/master/use-github-page-efficiently/github_page_setting_use_docs.png)



> 可以看到这里有一个选项是 master branch /docs folder . 当前状态是不可选的, 原因是我们的项目代码里面没有 /docs 目录.
>
> 这个选项的意思是 GitHub Page 可以识别我们项目中的 docs 文件夹, 并在这个文件夹中寻找 index 文件进行部署. 选中这个选项后, 我们只需要将之前 webpack 默认的 dist 文件夹改为 docs 文件夹即可

------

## vue.config.js的相关配置

Vue-cli3已经将Webpack4集成到了脚手架里面，所以你在目录文件下是看不到关于Webpack的配置文件的，**官方推荐我们在项目根目录下创建一个vue.config.js的文件**，用于修改以往在webpack中的配置。Vue-cli3的目的很简单，想要在Webpack4的基础上继续通过更高的抽象化和集成化来达到零配置，开箱即用的效果。

### First Step

在设置好GitHub Page以后，会得到一个地址，我们要将相应的地址配置在baseUrl选项中。

例如我们的GitHub Page地址是  **[https://liubasara.github.io/vue-blog-template/]**，那么我们BaseUrl的地址应该是：

```js
// vue.config.js
module.exports = {
    baseUrl: process.env.NODE_ENV === "production" ? "/vue-blog-template/" : "/",
    outputDir: "docs"
}
```

随后我们再像上面一样将outputDir设为docs，这样以后在写完blog以后运行npm run build以后就能直接push上仓库进行部署了。

------

### second step

在准备步骤搞定之后，就要来正式进行框架的搭建了。

根据需求分析我们知道的是，一个markdown博客首先需要解决的是***路由生成***和***数据获取***这两步关键点。

说是两步，其实这两步应该是不分彼此共同完成的。

在每次运行*npm run serve*命令的时候， vue-cli会自动执行vue.config.js文件下的所有语句，也就是说，我们可以在这一步将所有的博客文件打包，并且生成相应的路由文件。

1. 在根目录下生成一个**build_utils**文件夹，加入以下文件

   ```javascript
   // routegen.js
   exports.genRoutesFile = async function (pages) {
     function genRoute ({ pagePath, name}) {
       let filePath = `'../posts/${name}.md'`
       let code = `
     {
       path: ${JSON.stringify(pagePath)},
       component: () => import(${filePath})
     }`
       return code
     }
     const notFoundRoute = `,
     {
       path: '*',
       component: ThemeNotFound
     }`
   
     return (
       `let pageroutes = [${pages.map(genRoute).join(',')}]\n`+
       `export default pageroutes`
     )
   }
   ```

   ```javascript
   // datagen.js
   const path = require('path')
   const fs = require('fs')
   const rm = require('rimraf')
   const { genRoutesFile } = require('./routegen')
   const matter = require('gray-matter');
   // 先移除存放博客信息的data.js文件
   const FILE_DATE_PATH = path.resolve(__dirname, '../src/utils/data.js');
   const DEFAULT_SOURCE_DIR = path.resolve(__dirname, '../src/posts/');
   module.exports = async function getData() {
     rm(FILE_DATE_PATH, err => {
       if (err) throw err
       fs.readdir(DEFAULT_SOURCE_DIR, function (err, files) {
         if (err) {
           console.warn(err)
         } else {
           // 用来存放所有文章信息的数组
           var posts = [];
           var routes = [];
           for (filename in files) {
             if ((/\.md$/).test(files[filename])) {
               var filedir = path.join(DEFAULT_SOURCE_DIR, files[filename]);
               var data = fs.readFileSync(filedir, 'utf8')
               if (err) throw err;
               var result = matter(data);
               var post = Object.assign({}, result.data)
               // var date = new Date(`${post.date}`.replace(/-/g, "/"));
               // var currentDate = new Date();
               // var days = currentDate.getTime() - date.getTime();
               // post.daysAgo = parseInt(days / (1000 * 60 * 60 * 24));
               // 当文章的内容不为空时，添加文章对象到数组中
               if (post.contents !== '') {
                 post.contents = '';
                 var route = {};
                 posts.push(post);
                 route.name = post.name;
                 route.pagePath = `/${post.categories}/${route.name}`;
                 routes.push(route);
                 var origin = {
                   name: post.name,
                   // pagePath: `/post/${post.name}`
                   pagePath: `${post.name}`
                 }
                 routes.push(origin);
                 for (var tag of post.tags) {
                   var route = {}
                   route.name = post.name;
                   if (tag !== post.categories) {
                     route.pagePath = `/${tag}/${route.name}`;
                     routes.push(route);
                   }
                 }
               }
             }
           }
           genRoutesFile(routes).then(routesCode => {
             rm(path.resolve(__dirname, '../src/router/page.js'), err => {
               if (err) throw err
               fs.writeFile(path.resolve(__dirname, '../src/router/page.js'), routesCode, { 'flag': 'a' }, function (err) {
                 if (err) {
                   return console.error(err);
                 }
               });
             })
           });
           let postsStr = `export let postData = '${JSON.stringify(posts)}'`
           // 将数组对象存入data.js
           fs.writeFile(path.resolve(__dirname, '../src/utils/data.js'), postsStr, { 'flag': 'a' }, function (err) {
             if (err) {
               return console.error(err);
             }
           });
         }
       });
     })
   }
   ```

   上述的两个函数看起来十分复杂，其实只要通读一遍就会发现其实逻辑十分的清晰。其中的关键点就在于**gray-matter**这个库，这个库能够识别markdown文件头部的yaml信息，就像下面这样。

   ```markdown
   ---
   name: test
   title:  "test"
   info: "test"
   categories: ['testcategories']
   tags: ['testtags']
   ---
   
   # whatever you want, write on here!!
   ```

   每个文件都会被gray-matter识别生成一个简略信息的对象，**datagen.js**所负责的就是将src目录中的posts文件夹下的每个markdown文件交给gray-matter解析，自动生成路由，随后存入data.js中供以后使用。

2. 如上一步所述，**在src文件夹中加入posts文件夹用于存放你写的markdown文章**，修改路由文件，引入pageroute。如下所示。

   ```javascript
   import Vue from 'vue'
   import Router from 'vue-router'
   import pageroutes from './page'
   
   Vue.use(Router)
   
   export default new Router({
     // mode: 'history',
     base: process.env.BASE_URL,
     routes: [
       {
         path: '/',
         name: 'home',
         component: () => import('@/views/Home')
       },
       ...pageroutes
     ]
   })
   ```

3. 随后在vue.config.js中加入

   ```javascript
   const getData = require('./build_utils/datagen')
   getData()
   ```

   这样在每次打包的时候，程序都会自动运行一遍上述的程序，生成新的路由文件。

4. 在src目录下新建utils文件夹，用于存放待会生成的data.js。

5. 在完成这些以后，我们又遇到了一个问题，现在我们虽然已经可以生成路由文件了，可是vue依然无法识别到markdown文件，也就是说，像这样的路由

   ```js
   let pageroutes = [
     {
       path: "/hicategories/hi",
       component: () => import('../posts/hi.md')
     },
     {
       path: "hi",
       component: () => import('../posts/hi.md')
     },
     {
       path: "/hitags/hi",
       component: () => import('../posts/hi.md')
     },
     {
       path: "/testcategories/test",
       component: () => import('../posts/test.md')
     },
     {
       path: "test",
       component: () => import('../posts/test.md')
     },
     {
       path: "/testtags/test",
       component: () => import('../posts/test.md')
     }]
   export default pageroutes
   ```

   虽然格式是正确的，但是却无法被webpack正常解析，而这正是我们接下来要做的，引入自定义的loader让webpack在打包的时候正确的解析markdown文件。

---

### third step

关于markdown的解析在这里也推荐[一篇blog](https://www.jianshu.com/p/a95c04a68d14)，十分深入浅出，很有意义。

---

### forth step  如何在build之后自动打包并发布到github上





---

文章的最后贴上我的**vue.config.js**文件的配置，这是网上的模板，其实大部分配置都是用不到的，需要自己配置的其实就几项：**baseUrl**, **outputDir**，**用于数据获取的getData函数**，**还有用于解析markdown的module模块中的rules模块**。

```javascript
var path = require('path')
const getData = require('./build_utils/datagen')
getData()
// vue.config.js 配置说明
//官方vue.config.js 参考文档 https://cli.vuejs.org/zh/config/#css-loaderoptions
// 这里只列一部分，具体配置参考文档
module.exports = {
  // 部署生产环境和开发环境下的URL。
  // 默认情况下，Vue CLI 会假设你的应用是被部署在一个域名的根路径上
  //例如 https://www.my-app.com/。如果应用被部署在一个子路径上，你就需要用这个选项指定这个子路径。例如，如果你的应用被部署在 https://www.my-app.com/my-app/，则设置 baseUrl 为 /my-app/。
  baseUrl: process.env.NODE_ENV === "production" ? "/vue-blog-template/" : "/",
 
  // outputDir: 在npm run build 或 yarn build 时 ，生成文件的目录名称（要和baseUrl的生产环境路径一致）
  outputDir: "docs",
  //用于放置生成的静态资源 (js、css、img、fonts) 的；（项目打包之后，静态资源会放在这个文件夹下）
  assetsDir: "static",
  //指定生成的 index.html 的输出路径  (打包之后，改变系统默认的index.html的文件名)
  // indexPath: "myIndex.html",
  //默认情况下，生成的静态资源在它们的文件名中包含了 hash 以便更好的控制缓存。你可以通过将这个选项设为 false 来关闭文件名哈希。(false的时候就是让原来的文件名不改变)
  filenameHashing: false,
 
  //   lintOnSave：{ type:Boolean default:true } 问你是否使用eslint
  lintOnSave: true,
  //如果你想要在生产构建时禁用 eslint-loader，你可以用如下配置
  // lintOnSave: process.env.NODE_ENV !== 'production',
 
  //是否使用包含运行时编译器的 Vue 构建版本。设置为 true 后你就可以在 Vue 组件中使用 template 选项了，但是这会让你的应用额外增加 10kb 左右。(默认false)
  // runtimeCompiler: false,
 
  /**
   * 如果你不需要生产环境的 source map，可以将其设置为 false 以加速生产环境构建。
   *  打包之后发现map文件过大，项目文件体积很大，设置为false就可以不输出map文件
   *  map文件的作用在于：项目打包后，代码都是经过压缩加密的，如果运行时报错，输出的错误信息无法准确得知是哪里的代码报错。
   *  有了map就可以像未加密的代码一样，准确的输出是哪一行哪一列有错。
   * */
  productionSourceMap: false,

  configureWebpack: {
    module: {
      rules: [
        {
          test: /\.md$/,
          use: [
            {
              loader: 'vue-loader',
              options: {
                compilerOptions: {
                  preserveWhitespace: false
                }
              }
            },
            {
              loader: require.resolve('./build_utils/markdown')
            }
          ]
        }
      ]
    }
  },
 
  // 它支持webPack-dev-server的所有选项
  devServer: {
    host: "localhost",
    port: 8099, // 端口号
    https: false, // https:{type:Boolean}
    open: false, //配置自动启动浏览器
    // proxy: 'http://localhost:4000' // 配置跨域处理,只有一个代理
 
    // 配置多个代理
    // proxy: {
    //   "/api": {
    //     target: "<url>",
    //     ws: true,
    //     changeOrigin: true
    //   },
    //   "/foo": {
    //     target: "<other_url>"
    //   }
    // }
  }
}
```

