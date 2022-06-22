---
name: 回调vs协程
title: 回调vs协程
tags: ["技术","学习笔记","个人翻译"]
categories: 学习笔记
info: "加油啊不愿意同步的大哥哥！"
time: 2021/11/9
desc: '个人翻译, Callbacks vs Coroutines'
keywords: ['Git', '个人翻译', '学习笔记', 'Callbacks vs Coroutines']
---

# 回调vs协程

> 原文链接：[Callbacks vs Coroutines](https://medium.com/@tjholowaychuk/callbacks-vs-coroutines-174f1fe66127)

最近一段时间，出现了很多有关于 Google V8 引擎提供的 ES6 generators（生成器）补丁的争论，这是由一篇名为[《关于使用 JavaScript 生成器来解决回调问题的研究》](http://jlongster.com/A-Study-on-Solving-Callbacks-with-JavaScript-Generators)的文章引起的。虽然生成器这个特性依旧还藏在`--harmony`或者`--harmony-generators`标志的后面，但已经能让我们学习到很多经验了！在这篇文章里面，笔者想通过自己的一些有关于协程的经验来解释，为什么笔者个人认为这是一个非常好的工具。

## 回调 vs 生成器

在我们进入协程与生成器的区分之前，让我们先来看看在 Node.js 或是浏览器这类被回调统治的生态系统里面，是什么让生成器变得有用的。

首先，生成器是一种回调的补充，一些回调的形式对于生成器的补充来说是必要的。无论你喜欢称呼这些能够允许某些逻辑延迟执行的方式为“futures”、“thunks”还是“promises”都好，这就是一种允许你产生一个值并且允许生成器来处理其余部分的方法。

每当这些 yield 生成的值被抛出给调用者，调用者就会等待回调然后再继续恢复生成器。以这种方式来使用生成器的机制实际上与回调机制相同，但是我们很快就会看到一些额外的好处。

如果你还是不太确定生成器是如何出现的，这里有一个基于 generator 进行构建的流控制库的简单实现。

```javascript
var fs = require('fs')

function thread(fn) {
  var gen = fn()
  function next(err, res) {
    var ret = gen.next(res)
    if (ret.done) return
    ret.value(next)
  }
  next()
}

function read(path) {
  return function(done) {
    fs.readFile(path, 'utf8', done)
  }
}

thread(function *(){
  var a = yield read('Readme.md')
  var b = yield read('package.json')
  
  console.log(a)
  console.log(b)
})
```

## 为什么协程让代码更加强壮

与典型的浏览器环境或 Node.js 环境相比，每个协程都会在自己的堆栈中运行一个轻量级的“线程”。这些线程的实现各不相同，但通常来说它们都会有一个相对较小的堆栈（大约 4Kb），只要在需要时才会增长。

为什么协程这么棒呢？因为错误处理！如果你曾经使用 Node.js 工作过就会知道，即使相比于浏览器环境来说它的异常状态也非常常见，你就会知道错误处理并非那么容易面对。有时候你会收到很多个具有副作用未知的回调（或者是一个完全忘记进行错误处理的回调和没有对异常进行上报的回调）。又或者你忘记了监听 error 事件，从而导致了一个未被捕获的异常并让你的进程意外中断了。

对于一些人是很乐于见到这样的处理过程并认为这没什么问题的。但是作为一个从 Node.js 出生就开始使用它的人来说，我认为还是有很多事情可以做来提高这个工作流程的。而 Node.js 在其他方面都很棒，但这个就是它致命的弱点（译者注：Achilles' heel，[阿喀琉斯之踵](https://language.chinadaily.com.cn/a/202108/30/WS612c517fa310efa1bd66c095.html)）。

---

让我们来举一个简单的例子，下面是一段使用回调来对同一个文件进行读写的代码：

```javascript
function read(path, fn) {
  fs.readFile(path, 'utf-8', fn)
}

function write(path, str, fn) {
  fs.writeFile(path, str, fn)
}

function readAndWrite(fn) {
  read('Readme.md', function(err, str) {
    if (err) return fn(err)
    str = str.replace('Something', 'Else')
    write('Readme.md', str, fn)
  })
}
```

你可能会认为这并没有多么糟，毕竟你总是会看到像这样的代码。好吧但这段代码其实是很容易崩溃的 :)，为什么，因为 node 核心库里面很多的函数，还有很多第三方的库都不会使用 try/catch 去捕获他们的回调调用。

下面的代码会抛出一个未捕获的异常，而你在使用的时候却没有办法把它 catch 住。而且即便核心代码将这个异常返回给被调用者（译者注：使用`fn`去调用`error`），这也是有潜在的出错风险的，因为很多的回调调用的行为是未定义的（译者注：`fn(error)`也有可能出错）。

```javascript
function readAndWrite(fn) {
  read('Readme.md', function(err, str) {
    throw new Error('oh no, reference error etc')
    if (err) return fn(err)
    str = str.replace('Something', 'Else')
    write('Readme.md', str, fn)
  })
}
```

---

所以生成器要怎么帮助我们改进这一点呢？

下面的代码块展示了跟上面同样的逻辑，但是用的是生成器和[Co](https://github.com/visionmedia/co)库。你也许会认为“这只不过是愚蠢的语法糖罢了”——但如果这么想的话就错了。正因为我们将生成器函数作为入参传给了`co()`方法，并且将多个 yield 委托给调用者，所以 Co 也为我们带来了极其健壮的错误处理方法。

```javascript
function read(path) {
  return function(done) {
    fs.readFile(path, 'utf8', done)
  }
}

function write(path) {
  return function(done) {
    fs.writeFile(path, 'utf8', done)
  }
}

co(function *() {
  var str = yield read(‘Readme.md’)
  str = str.replace(‘Something’, ‘Else’)
  yield write(‘Readme.md’, str)
})
```

就如同下面的代码一样，像 Co 这样的库可以将异常“抛回”到源代码调用的地方，这也意味着你可以像编程语言想要的那样，使用 try/catch 来进行异常处理。当然你也可以不进行捕获让 Co 最后的的回调来进行统一的处理。

```javascript
co(function *() {
  try {
    var str = yield read(‘Readme.md’)
  } catch(err) {
    // whatever
  }
  str = str.replace(‘Something’, ‘Else’)
  yield write(‘Readme.md’, str)
})
```

直至到编写本文的时候，Co 看起来都是唯一一个实现了强大的错误处理的库，而如果你看过 Co 的源代码，就会留意到这些 try/catch 的代码块。如果你不使用生成器又想要真正健壮的代码的话，就只能将这些 try/catch 代码块有效地内联到每一个你写过的库的代码里面——而这几乎是不可能的。这就是为什么时至今日在 Node.js 中几乎不可能编写出真正健壮的代码的原因。

---

## 生成器 vs 协程

生成器有时候被称为是“半协程”，一种更有限的协程形式，只能由调用者来控制程序挂起（yield）。这使得生成器的用法比起协程来说更加明确，因为只有当你生成一个值得时候，“线程”才会挂起。

协程则在这方面更加的灵活，而且代码看上去也更加常规，并不需要依赖 yield。

```javascript
// 协程模式下得代码示例
var str = read('Readme.md')
str = str.replace('Something', 'Else')
write('Readme.md', str)
console.log('all done')
```

---

一些人可能会认为完全的协程模式是很危险的，因为没有明确的标志来表示哪个方法挂起了线程哪个方法又没挂起。而笔者个人认为这种观点很愚蠢，一般来说哪些方法会挂起线程是很明显的，像是文件读写、套接字（sockets）、http 请求、sleeps 和其他一些方法，这些都是即便挂起了线程也没有任何人会感觉到惊讶的方法。

如果觉得这种方法是不可取的话，那么就像你在 Go 语言里面做的那样，去分叉(fork)任务并且强制他们变成异步吧。

在笔者的观点中，相对于协程来说，生成器反而是更加有潜在的风险的（虽然风险依旧比回调小多了），因为只要简单地忘记一个`yield`表达式，就会让人陷入困惑，或者说，在剩余的代码执行中导致一些未定义的行为。无论哪种方式，半协程和完整地协程都有着不同的缺点和优点，笔者很高兴我们至少拥有其中一种方式。

让我们来看看通过生成器你可以怎样来使用这种新的代码结构。

---

## 通过协程做到简单的异步流程控制

你已经看到了读/写操作在协程模式下，比在回调模式下更加优雅，接下来让我们看看更多的模式。

假设当所有的操作都能够以默认的顺序编写的话，会大大减少我们的心智负担。而有些人会声称生成器或者协程会让状态（state）变得复杂，但这是个错误的结论。协程下状态的使用跟回调是一样的，全局变量还是全局变量，局部变量还是局部变量，闭包还是闭包。

为了阐述这个流程，我们来展示一个例子：你希望访问一个页面的 html，解析链接，然后并行地请求这些主体并且输出他们的文本类型（content-types）。

当使用常规的回调方式且不使用任何第三方流程控制库时，代码看上去是这样的。

```javascript
function showTypes(fn) {
  get('http://cloudup.com', function(err, res) {
    if (err) return fn(err)
    var done
    var urls = links(res.text)
    var pending = urls.length
    var results = new Array(pending)
    
    urls.forEach(function(url, i) {
      get(url, function(err, res) {
        if (done) return
        if (err) return done = true, fn(err)
        results[i] = res.header['content-type']
        --pending || fn(null, results)
      })
    })
  })
}

showTypes(function(err, types) {
  if (err) throw err
  console.log(types)
})
```

这样的一个使用回调方式编写的简单任务很快就会失去它的所有含义。在添加了一堆错误声明功能，双重回调功能，存储所有结果的功能以及回调本身以后，你甚至都不知道这个方法是用来做什么的了。如果你还想要让他的代码健壮性更强的话，甚至还不得不舱室使用 try/catch 最后的函数结果（`fn(null, results)`）。

---

而这里有一个同样的`showTypes()`方法，使用生成器编写。就像你看到的那样，协程实现的函数，最终的使用方式跟回调实现的使用方式相同，这两种概念是可以共存的。在这个例子中，Co 自动处理了所有的普通错误响应和错误填充，这些操作在上面的形式中是需要我们手动处理的。通过`urls.map(get)`方法生成的数组是并行执行的，但是会保持响应的顺序。

```javascript
function header(filed) {
  return function(res) {
    return res.headers[field]
  }
}

function showTypes(fn) {
  co(function *() {
    var res = yield get('http://cloudup.com')
    var responses = yield links(res.text).map(get)
    return responses.map(header('content-type'))
  })(fn)
}
```

---

笔者并没有建议每个 npm 模块都必须开始使用生成器，而且如果要让每个开发者都强制依赖 Co 类库的话，笔者依旧会反对。但是处于应用程序的界别来说，笔者依旧非常推荐它。

笔者希望这篇文章能够帮助到你们，并且阐述清楚在非阻塞的编程工作中，协程是如何成为一个强有力的工具的。



> 译者注：顺便附带一个使用 Generator + yield + Promise 实现的简易版 async 函数实现，帮助理解。
>
> ```javascript
> function myAsync(fn) {
>   return new Promise((resolve, reject) => {
>     const gen = fn()
>     function throwErr(err) {
>       let ret
>       try {
>         ret = gen.throw(err)
>       } catch (e) {
>         reject(e)
>       }
>       if (ret.done) {
>         return reject(ret.value)
>       }
>       Promise.resolve(ret.value).then(data => {
>         next(data)
>         return data
>       }, err => {
>         throwErr(err)
>         return err
>       })
>     }
>     function next(val) {
>       let ret
>       try {
>         ret = gen.next(val)
>       } catch (e) {
>         throwErr(e)
>       }
>       if (ret.done) {
>         return resolve(ret.value)
>       }
>       Promise.resolve(ret.value).then(data => {
>         next(data)
>         return data
>       }, err => {
>         throwErr(err)
>         return err
>       })
>     }
>     next()
>   })
> }
> 
> 
> myAsync(function* () {
>   console.log(
>     yield new Promise((resolve) => setTimeout(() => resolve(1), 1000))
>   )
> 
>   console.log(
>     yield new Promise((resolve) => setTimeout(() => resolve(2), 2000))
>   )
>   try {
>     yield new Promise((resolve, reject) => setTimeout(() => reject(3), 3000))
>   } catch (e) {
>     console.log(e)
>   }
> 
>   try {
>     yield new Promise((resolve, reject) => setTimeout(() => reject(4), 1000))
>   } catch (e1) {
>     console.log(e1)
>   }
> 
> 
>   console.log(yield 'all')
>   console.log('done')
> })
> 
> ```



