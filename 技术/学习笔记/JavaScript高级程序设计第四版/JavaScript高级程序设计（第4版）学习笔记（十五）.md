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











> 本次阅读至 P723 748 24.5.1 基本用法