---
name: JavaScript高级程序设计（第4版）学习笔记（十一）
title: JavaScript高级程序设计（第4版）学习笔记（十一）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：15. DOM扩展"
time: 2020/11/6
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']


---

# JavaScript高级程序设计（第4版）学习笔记（十一）

## 第 15 章 DOM 扩展

DOM 扩展的两个标准：Selectors API 和 HTML5。这两个标准体现了社区需求和标准化某些手段及 API 的愿景。

本章所有内容已经得到了主流浏览器的支持，除非特别说明。

### 15.1 Selectors API

JavaScript 库中最流行的一种能力就是根据 CSS 选择符的模式匹配 DOM 元素。

#### 15.1.1 querySelector

querySelector() 方法接收 CSS 选择符参数，返回匹配模式的第一个后代元素，如果没有匹配选项返回 null。

#### 15.1.2 querySelectorAll

跟 querySelector 一样接收一个用于查询的参数，会返回所有匹配的节点，是一个 NodeList 的静态实例。

> 再强调一次，querySelectorAll() 返回的 NodeList 实例一个属性和方法都不缺，但它是一个静态的“快照”，而非“实时”的查询。这样的底层实现避免了使用 NodeList 对象可能造成的性能问题。

#### 15.1.3 matches

`matches`方法（在规范草案中称为`matchesSelector`）接收一个 CSS 选择符参数，如果元素匹配则该选择符返回`true`，否则返回`false`。

```javascript
if (document.body.matches('body')) {
  console.log('匹配')
}
// 匹配
```

### 15.2 元素遍历

Element Traversal API 为 DOM 元素添加了 5 个属性：

- childElementCount：返回子元素数量（不包含文本节点和注释）
- firstElementChild，指向第一个 Element 类型的子元素（Element 版 firstChild）
- lastElementChild，指向最后一个 Element 类型的子元素
- previousElementSibling，指向前一个 Element 类型的同胞元素（Element 版的 nextSibling）
- nextElementSibling：指向后一个 Element 类型的同胞元素

### 15.3 HTML5

> HTML5 代表着与以前的 HTML 截然不同的方向。在所有以前的 HTML 规范中，从未出现过描述 JavaScript 接口的情形，HTML 就是一个纯标记语言。JavaScript 绑定的事，一概交给 DOM 规范去定义。
>
> 然而，HTML5 规范却包含了与标记相关的大量 JavaScript API 定义。其中有的 API 与 DOM 重合， 定义了浏览器应该提供的 DOM 扩展。

#### 15.3.1 CSS 类扩展

- getElementsByClassName：取得所有类名中包含 username 和 current 元素

  ```javascript
  // 取得所有类名中包含 username 和 current 元素
  document.getElementByClassName('username current')
  // 取得 ID 为 myDiv 的元素子树中所有包含 selected 类的元素
  document.getElementById('myDiv').getElementsByClassName('selected')
  ```

- classList 属性

  HTML5 之前要修改类名，只能通过 className 属性实现添加，但该属性是个字符串，使用时需要先把 className 拆开，删除不想要那个，再把剩余类的字符串设置回去。

  HTML 5 添加了 classList 提供了更简单也更安全的实现方式，其返回一个 DOMTokenList 类型的实例，包含以下属性或方法：

  - item()：或是中括号，用于取得个别元素
  - add()：向类名列表添加指定字符串值，若这个值亿存在，则什么也不做
  - contains()：返回布尔值，表示给定的属性是否存在
  - remove()：从类名列表中删除指定的字符串值
  - toggle()：如果类名列表中已经存在指定的 value，则删除，若不存在，则添加
  - length：属性表示自己包含多少项

#### 15.3.2 焦点管理

HTML5 新增了辅助 DOM 焦点管理的功能：

- document.activeElement：始终包含当前拥有焦点的 DOM 元素。页面加载时，可以通过用户输入或者按 Tab 键或代码中使用 focus 方法让某个元素获得焦点。

  默认情况下，document.activeElement 会在页面加载完后自动被设置为 document.body。而在页面完全加载前，该值为 null。

- document.hasFocus()，返回布尔值，查看文档是否获得了焦点

#### 15.3.3 HTMLDocument 扩展

- readyState 属性，当页面加载未完成，该属性为 loading，当加载完成，该属性为 complete
- compatMode 属性，用于检测浏览器当前处于什么渲染模式：
  - CSS1Compat：标准模式
  - BackCompat：混杂模式
- head 属性：指向文档的 head 节点

#### 15.3.4 字符集属性

document.characterSet 表示文档实际使用的字符集，默认为"UTF-16"。

#### 15.3.5 自定义数据属性

dataset 冷饭

#### 15.3.6 插入标记

用于一次性大量插入 HTML

- innerHTML 属性

- outerHTML 属性

- insertAdjacentHTML 与 insertAdjacentText 方法

  接收两个参数：要插入标记的位置和要插入的 HTML 或文本，第一个参数必须是下列值中的一个：

  - beforebegin：插入当前元素前面，作为前一个同胞节点
  - afterbegin：插入当前元素内部，作为新的第一个子节点
  - beforeend：插入当前元素内部，作为新的最后一个子节点
  - afterend：插入当前元素后面，作为下一个同胞节点

#### 15.3.7 scrollIntoView

该方法可以用来滚动浏览器窗口或容器元素让对应元素进入视口。

### 15.4 专有扩展

> 除了已经标准化的，各家浏览器还有很多未被标准化的专有扩展。这并不意味着它们将来不会被纳 入标准，只不过在本书编写时，它们还只是由部分浏览器专有和采用。

- children 属性
- contains 方法
- innerText 属性
- outerText 属性

## 第 16 章 DOM2 和 DOM3

### 16.1 DOM 的演进

#### 16.1.1 XML 命名空间

可以使用`xmlns`给命名空间创建一个前缀。

```html
<xhtml:html xmlns:xhtml="http//test.org/xhtml"></xhtml:html>
```

上面为 XHTML命名空间定义了一个前缀 xhtml，同时所有 XHTML元素都必须加上这个前。为 避免混淆，属性也可以加上命名空间前，比如： 

```html
<xhtml:boxy xhtml:class="home"></xhtml:boxy>
```

如果文档中只使用一种 XML 语言，那么命名空间其实是多余的，只有当一个文档混合使用多种 XML 语言，比如同时使用 XHTML 和 SVG 两种语言时，命名空间才有意义。

```html
<html xmlns="http://test.org/xhtml">
  <body>
    <svg xmlns="http://test.org/svg" version="1.1"></svg>
  </body>
</html>
```

如上面的例子，通过`<svg>`元素设置自己的命名空间，将其标识为当前文档的外来元素。虽然这个文档从技术角度上讲是 XHTML 文档，但由于使用了命名空间，其中包含的 SVG 代码也是有效的。

当需要访问节点的命名空间时，可以通过`Node`节点访问以下属性：

- localName：不包含命名空间前缀的节点名
- namespaceURI：节点的命名空间 URL，如果未指定则是 null
- prefix：命名空间前缀，如果未指定则为 null
- isDefaultNamespace(namespaceURI)：返回布尔值，表示是否为节点的默认命名空间
-  lookupNamespaceURI(prefix)：返回给定 prefix（前缀...该翻译的就不翻译了，我服了）的命名空间 URL
-  lookupPrefix(namespaceURI)：返回给定 URL 对应命名空间的前缀

此外，可以通过其他一些内置的方法来进行命名空间的增删查改：

#### 16.1.2 其他变化

- isSameNode() 和 isEqualNode()，接收一个节点参数，判断两个节点是否相同
- contentElement：包含 iframe 内容对象的指针

### 16.2 样式

多数情况下，使用节点的`style`属性就可以实现操作样式规则的任务。

使用`getBoundingClientRect()`方法，可以获得元素在页面中相对于视口的位置。

### 16.3 遍历

#### 16.3.1 NodeIterator

如果想要遍历`<div>`元素内部的所有元素，那么可以使用如下代码：

```javascript
var div = document.getElementById('div1')
var iterator = document.createNodeIterator(div, NodeFilter.SHOW_ELEMENT, null, false)
var node = iterator.nextNode()
while (node !== null) {
  console.log(node.tagName) // 输出标签名
  node = iterator.nextNode()
}
```

使用`nextNode()`和`previousNode()`用于遍历下一个和上一个节点。

`createNodeIterator()`方法接收以下四个参数：

- root：作为遍历根节点的节点
- whatToShow：NodeFilter 数值代码，表示应该访问哪些节点
- filter：NodeFilter 对象或函数，表示是否接收或跳过特定节点
- entityReferenceExpansion：布尔值，表示是否扩展实体引用（在 HTML 中，该参数没有效果）

whatToShow 参数是一个常量，定义在 NodeFilter 中：

- NodeFilter.SHOW_ALL：所有节点
- NodeFilter.SHOW_ELEMENT：元素节点
- NodeFilter.SHOW_ATTRIBUTE：属性节点
- NodeFilter.SHOW_TEXT：文本节点
- NodeFilter.SHOW_COMMENT：注释节点
- NodeFilter.SHOW_DOCUMENT：文档节点
- NodeFilter.SHOW_DOCUMENT_TYPE：文档类型节点

还有一些属性是不在 HTML 文档中使用的。

`filter`参数可以用来指定自定义 NodeFilter 对象，或者一个作为节点过滤器的函数。如果不需要过滤器，可以给这个参数传入`null`

```javascript
var filter = {
  acceptNode(node) {
    // 过滤 p 标签
    return node.tagName.toLowerCase() === 'p' ? NodeFilter.FILTER_ACCEPT : NodeFilter.FILTER_SKIP
  }
}
// 还可以是一个函数，与 acceptNode() 的形式一样
var filter = function(node) {
  return node.tagName.toLowerCase() === 'p' ? NodeFilter.FILTER_ACCEPT : NodeFilter.FILTER_SKIP
}
```

#### 16.3.2 TreeWalker

TreeWalker 是 NodeIterator 的高级版，包含同样的`nextNode()`和`previousNode()`方法，此外，还有以下不同的遍历方法：

- parentNode()：遍历当前节点的父节点
- firstChild()：遍历当前节点的第一个子节点
- lastChild()：遍历当前节点的最后一个子节点
- nextSibling()：遍历当前节点的下一个同胞节点
- previousSibling()：遍历当前节点的上一个同胞节点

TreeWalker 对象使用`document.createTreeWalker()`方法来创建，接收与 createNodeIterator 同样的参数。

TreeWalker 类型有一个名为`currentNode`的属性，表示遍历过程中返回的节点，可以通过修改这个属性来影响接下来遍历的起点。

### 16.4 范围

使用`createRange`可以创建一个 DOM 范围对象，使用该`range`对象可以进行文档的选择，每个实例都有下列属性，与范围在文档中的位置有关：

- startContainer：返回起点所在的节点（选区第一个节点的父节点）
- startOffset：范围起点在 startContainer 中的偏移量
- endContainer：范围终点所在的节点
- endOffset：范围起点在 startContainer 中的偏移量
- commonAncestorContainer：文档中以 startContainer 和 endContainer 为后代的深的节点。

#### 16.4.2 简单选择

通过范围选择文档中某个部分最简单的方式，是使用实例的这两个方法：

- selectNode()：选择整个节点，包括其后代节点
- selectNodeContents()：只选择节点的后代，从第一个子节点开始到最后一个子节点结束

在调用这两个方法选定节点后，还可以调用相应的方法实现对范围中选区更精细的控制：

- setStartBefore(refNode)：把范围的起点设置到 refNode 之前，从而将 refNode 成为选区的第一个子节点
- setStartAfter(refNode)：把范围的起点设置到 refNode 之后，从而将 refNode 排除在选区之外
- setEndBefore(refNode)：把范围的终点设置到 refNode 之前，从而将 refNode 排除在选区之外
- setEndAfter(refNode)：把范围的终点设置到 refNode 之后，让 refNode 成为选区的最后一个节点

#### 16.4.3 复杂选择

要创建复杂的范围，需要使用实例的以下两个方法：

- setStart(refNode, offset)
- setEnd(refNode, offset)

```javascript
var range1 = document.createRange()
var range2 = document.createRange()
p1 = document.getElementById('p1')
// 模拟 selectNode
range1.setStart(p1.parentNode, p1Index)
range1.setEnd(p1.parentNode, p1Index + 1)
// 模拟 selectNodeContents
range2.setStart(p1, 0)
range2.setEnd(p1, p1.childNodes.length)
```

setStart 和 setEnd 的真正威力是选择节点中的某个部分，很简单，先取得所有相关节点的引用，如：

```javascript
var p1 = document.getElementById('p1')
var firstWordNode = p1.firchChild.firstChild
var secondWordNode = p1.lastChild
// 传入起点开始的地方及选择的偏移量，从偏移量开始选择
range.setStart(firstWordNode, 2)
// 传入终点节点及选择的偏移量，偏移量以后的值不选择
range.setEnd(secondWordNode, 3)
```

#### 16.4.4 操作范围

创建范围之后，浏览器会在内部创建一个文档片段节点，用于包含范围选区中的节点。

此后，可以使用很多方法来操作范围的内容：

- range.deleteContents()：删除选区中的内容。
- range.extractContensts()：剪切内容，会返回一个 fragment，可以使用 appendChild 添加到别的地方
- range.cloneContents()：复制选择内容

#### 16.4.5 范围插入

可以使用以下方法：

- range.insertNode()：在范围选区的开始位置插入一个节点

- range.surroundContents()：插入包含范围的内容，可以用于高亮网页中的某些关键词

  ```javascript
  range.selectNode(helloNode)
  var span = document.createElement('span')
  span.style.backgroundColor = 'yello'
  range.surroundContents(span)
  ```

  执行以上代码会在选择范围周围插入一个 span 标签，背景为黄色。（为了插入`<span>`元素，范围中必须包含完整的 DOM 结构。如果范围中包含部分选择的非文节点，这个操作会失败并报错）

#### 16.4.6 范围折叠

如果范围并没有选择文档的任何部分，则称为折叠（collapsed）（PS：其实就是移动光标...）。

- range.collapse(boolean)：接收一个布尔值，true 折叠到范围的起点，false 表示折叠到终点

使用 range 范围的 collapsed 属性可以检测范围是否被折叠。 当选择的起点之前，终点之后没有任何内容，那么 collapsed 默认为 true。

#### 16.4.7 范围比较

如果有多个范围，可以使用 compareBoundaryPoints() 方法确定范围之间是否存在公共的边界（起点或终点）。这个方法接收两个参数：要比较的范围和一个常量值，表示比较的方式。

- Range.START_TO_START(0)：比较两个范围的起点
- Range.START_TO_END(1)：比较第一个范围的起点和第二个范围的终点
- Range.END_TO_END(2)：比较两个范围的终点
- Range.END_TO_START(3)：比较第一个范围的终点和第二个范围的起点

如果二者有重合，则返回 1，无重合则返回 0。

#### 16.4.8 复制范围

调用 cloneRange() 方法可以复制范围

#### 16.4.9 清理

在使用完范围后，可以使用 detach() 方法把范围从创建它的文档中剥离。调用 detach() 以后，就可以解除对范围的引用以便垃圾回收。

```javascript
range.detach() // 从文档中剥离范围
range = null // 解除引用
```

剥离之后的范围就不能再使用了。
