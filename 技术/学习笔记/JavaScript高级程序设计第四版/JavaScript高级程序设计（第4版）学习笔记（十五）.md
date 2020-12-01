---
name: JavaScript高级程序设计（第4版）学习笔记（十五）
title: JavaScript高级程序设计（第4版）学习笔记（十五）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：21. 错误处理与调试 22. 处理 XML 23. JSON 24. 网络请求与远程资源"
time: 2020/11/29
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']
---

# JavaScript高级程序设计（第4版）学习笔记（十五）

## 第 21 章 错误处理与调试

第三版冷饭。

ECMA-262 定义了以下 8 种错误类型：

- Error
- InternalError：JavaScript 内部错误，比如说递归过多导致的栈溢出
- EvalError：在使用 eval 函数发生异常时抛出，基本上只要不把 eval() 当成函数调用（比如说用 new 函数来调用）就会报告该错误
- RangeError：在数值越界时抛出
- ReferenceError：在找不到对象时发生，经常由于访问不存在的变量而导致
- SyntaxError：在 JavaScript 包含语法错误时发生
- TypeError：当访问不存在的方法或传入变量不是预期类型时发生
- URIError：只会在使用`encodeURI()`或`decodeURI()`但传入了错误的 URI 时发生。

### 21.3 调试技术

#### 21.3.1 把消息记录到控制台

多数浏览器支持通过`console`对象直接把 JavaScript 消息写入控制台，该对象包含如下方法：

- error(message)：记录错误消息，包含一个红叉图标
- info(msg)：记录信息性内容
- log(msg)：记录常规消息
- warn(msg)：记录警告消息，包含一个黄色叹号图标

## 第 22 章 处理 XML

自从有了 DOM 标准，所有浏览器都开始原生支持 XML 及很多其他相关技术了。

#### 22.1.2 DOMParser 类型

要将 XML 解析为 DOM，可以使用`DOMParser`类型。

```javascript
const parser = new DOMParser()
const xmldom = parser.parseFromString('<root><child /></root>', 'text/xml')
console.log(xmldom.documentElement.tagName) // 'root'
console.log(xmldom.documentElement.firstChild.tagName) // 'child'

const anotherChild = xmldom.createElement('child')
xmldom.documentElement.appendCHild(anotherChild)

const children = xmldom.getElementsByTagName('child')
console.log(children.length) // 2
```

#### 22.1.3 XMLSerializer 类型

```javascript
// 使用 XMLSerializer 可以把 DOM 文档序列化为 XML 字符串
const serializer = new XMLSerializer()
const xml = serializer.serialzeToString(xmldom)
console.log(xml)
```

> 注意 如果给serializeToString()传入非DOM对象，就会导致抛出错误。

### 22.2 对 XPath 的支持

XPath 是为了在 DOM 文档中定位特定节点而创建的。很多浏览器实现了，DOM Level3 也开始着手标准化，除了 IE。

### 22.3 对 XSLT 的支持

可扩展样式表语言转换（Extensible Stylesheet Language Transformations）是一种可以利用 XPath 将一种文档表示转换为另一种文档表示的技术。但迄今为止还没有正式标准的 API。

## 第 23 章 JSON

冷饭（纯的一点杂质没有...）。

## 第 24 章 网络请求与远程资源

部分冷饭。

XHR 对象的 API 被普遍认为比较难用，而 Fetch API 自从诞生以后就迅速成为了 XHR 更现代的替代。Fetch API 支持期约(promise)和服务线程(service worker)，已经成为极其强大的 Web 开发工具。

> 实际开发中，应该尽可能使用 fetch

#### 24.3.2 凭据请求

默认情况下，跨源请求不提供凭据（cookie、HTTP 认证和客户端 SSL 证书），可以通过将`withCredentials`属性设置为`true`来表明请求会发送凭据。如果服务器允许带凭据的请求，也可以在相应中包含`Access-Control-Allow-Credentials: true`这个字段。

### 24.5 Fetch API

Fetch API 能够执行 XMLHttpRequest 对象的所有任务，但更容易使用，接口也更现代化。不同的是，XMLHttpRequest 可以选择异步，而 Fetch API 则必须是异步。

#### 24.5.1 基本用法

`fetch()`方法是暴露在全局作用域中的，包括主页面执行线程、模块和工作线程。调用该方法，浏览器就会向给定 URL 发送请求。

**1. 分派请求**

`fetch()`只有一个必需的参数：input。多数情况下，这个参数是要获取资源的 URL。这个方法返回一个 Promise：

```javascript
const r = fetch('/bar')
console.log(r) // Promise <pending>
r.then((response) => {
  console.log(response)
})
// Response { type: 'basic', url: '...' }
```

URL 的格式（相对路径、绝对路径等）的解释与 XHR 对象一样。

**2. 读取响应**

要取得响应`response`的纯文本格式内容，要用到`text()`方法。这个方法同样返回一个 Promise，解决的内容为资源的完整内容。

```javascript
const r = fetch('/bar.txt')
console.log(r) // Promise <pending>
r.then(response => {
  response.text().then(data => {
    console.log(data)
  })
})
// or
r.then(response => response.text()).then(data => {
  console.log(data)
})
```

**3. 处理状态码和请求失败**

`response`对象可以使用`status`和`statusText`属性来进行响应的判断状态。但跟随重定向时，响应对象的 redirected 属性会被设置为 true，而状态码仍然是 200。

**4. 自定义选项**

只使用 URL 时，fetch 会发送 GET 请求，只包含最低限度的请求头，如果要进一步配置如何发送请求，需要传入可选的第二个参数 init 对象，该对象可以包含下面的值：

- body：指定使用请求体时请求体的内容，必须是 Blob、BufferSource、FormData、URLSearchParams、ReadableStream 或 String 的实例。

- cache：用于控制浏览器与 HTTP 缓存的交互。

- credentials：用于制定在外发请求中如何包含 cookie。

  - omit：不发送 cookie
  - same-origin：只在请求 URL 与发送 fetch() 请求的页面同源时发送 cookie，默认值
  - include：无论是同源还是跨源都包含

- headers：一个对象，用于指定请求对象。默认值为不包含键/值对的 Headers 对象。这不意味着请求不包含任何头部，浏览器仍然会随请求发送一些头部。虽然这些头部对 JavaScript 不可见，但浏览器的网络检查器可以观察到。

- integrity：用于强制子资源完整性

- keepalive：用于指示浏览器允许请求存在时间超出页面生命周期，默认为 false

- method：用于指定 HTTP 请求方法

- mode：用于指定请求模式。该模式决定来自跨源请求的响应是否有效，以及客户端可以读取多少响应。是下列的字符串值之一：

  - cors：允许遵守 CORS 协议的跨源请求
  - no-cors：允许不需要发送预检请求的跨源请求（即 HEAD、GET 和只带有满足 CORS 请求头部的 POST）。响应类型是 opaque，意思是不能读取响应内容。
  - same-origin：任何跨源请求都不允许发送
  - navigate：用于支持 HTML 导航

  在通过构造函数手动创建 Request 实例时，默认为 cors;否则，默认为 no-cors

- redirect：用于指定如何处理重定向响应，默认值为 follow，可能的值为：

  - follow：跟踪重定向请求
  - error：重定向请求会抛错
  - manual：不跟踪重定向请求

- referred：用于指定 HTTP 的 Referer 头部的内容，默认为 client/about:client

  - no-referrer：以 no-referrer 作为值
  - client/about:client：以当前 URL 或 no-referrer 作为值
  - \<URL\>：以伪造 URL 作为值，伪造 URL 的源必须与执行脚本的源相匹配

- referrerPolicy：用于指定 HTTP 的 Referer 头部，指定 Referer 头部的默认行为

- signal：用于支持通过 AbortController 中断进行中的 fetch() 请求，必须是 AbortSignal 的实例，默认为未关联控制器的 AbortSignal 实例。

#### 24.5.2 常见 Fetch 请求模式

`fetch()`既可以发送数据也可以接收数据。使用`init`对象参数，可以配置`fetch()`在请求体中发送各种序列化的数据。

**1. 发送 JSON 数据**

```javascript
const payload = JSON.stringify({
  foo: 'bar'
})
const jsonHeaders = new Headers({
  'Content-Type': 'application/json'
})
fetch('/send-me-json', {
  method: 'POST', // 发送请求体时必须使用一种 HTTP 方法
  body: payload,
  headers: jsonHeaders
})
```

**2. 在请求体中发送参数**

因为请求体支持任意字符串值，所以可以通过它发送请求参数。

```javascript
const payload = 'foo=bar&baz=qux'

const jsonHeaders = new Headers({
  'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
})
fetch('/send-me-params', {
  method: 'POST', // 发送请求体时必须使用一种 HTTP 方法
  body: payload,
  headers: jsonHeaders
})
```

**3. 发送文件**

因为支持 FormData 实现，所以 fetch() 也可以序列化并发送文件字段中的文件。

```javascript
const imageFormData = new FormData()
const imageInput = document.querySelector("input[type='file']")
imageFormData.append('image', imageInput.files[0])

fetch('/img-upload', {
  method: 'POST', // 发送请求体时必须使用一种 HTTP 方法
  body: imageFormData
})
```

**4. 加载 Blob 文件**

Fetch API 也能处理 Blob 类型的响应，为获取 blob 实例，可以使用响应对象上暴露的`blob()`方法。

```javascript
const imageElement = document.querySelector('img')

fetch('my-image.png')
  .then(response => response.blob())
  .then(blob => {
    imageElement.src = URL.createObjectURL(blob)
  })
```

**5. 发送跨源请求**

从不同的源请求资源，响应要包含 CORS 头部才能保证浏览器收到响应。没有这些头部，跨源请求会失败并抛出错误。

```javascript
fetch('//cross-origin.com')
// TypeError: Failed to fetch
// No 'Access-Control-Allow-Origin' header is present on the requested resource.
```

如果代码不需要访问响应，也可以发送 no-cors 请求。此时响应的 type 属性值为 opaque，因此无法读取响应内容。这种方式适合发送探测请求或者将响应缓存起来供以后使用。

```javascript
fetch('//cross-origin.com', { method: 'no-cors' })
  .then(response => {
    console.log(response.type)
    // opaque
  })
```

**6. 中断请求**

可以通过 AbortController/AbortSignal 对中断请求。调用 AbortController.abort() 会中断所有网络传输，适合希望停止传输大型负载的情况。中断进行中的 fetch 请求会导致包含错误的拒绝。

```javascript
const abortController = new AbortController()
fetch('wikipedia.zip', { signal: abortController.signal }).catch(() => {
  console.log('aborted')
})
setTimeout(() => {
  // 10 毫秒后中断请求
  abortController.abort()
}, 1000)
```

#### 24.5.3 Headers 对象













> 本次阅读至 P730 24.5.3 Headers 对象 755