---
name: JavaScript高级程序设计（第4版）学习笔记（十六）
title: JavaScript高级程序设计（第4版）学习笔记（十六）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：25. 客户端存储 26. 模块"
time: 2020/12/4
desc: 'javascirpt高级程序设计, 红宝书, 学习笔记'
keywords: ['javascirpt高级程序设计第四版', '前端', '红宝书第四版', '学习笔记']
---

# JavaScript高级程序设计（第4版）学习笔记（十六）

## 第 25 章 客户端存储

部分冷饭。

安全标志`secure`是 cookie 中唯一的非键值对，只需一个 secure 就可以，比如：`Set-Cookie: name=value; domain=.example.com; path=/; secure`。

还有一种叫作 HTTP-only 的 cookie。HTTP-only 可以在浏览器设置，也可以在服务器设置，但只能在服务器上读取，这是因为 JavaScript 无法取得这种 cookie 的值。

### 25.3 IndexedDB

IndexedDB 是类似于 MySQL 或 Web SQL Database 的数据库。与传统数据库最大的区别在于，INdexedDB 使用对象存储而不是表格存储数据，它就是一个在公共命名空间下的一组对象存储，类似于 NoSQL 风格的实现。

使用 IndexedDB 数据库的第一步是调用`indexedDB.open()`方法。该方法会返回`IDBRequest`的实例，可以在这个实例上添加`onerror`和`onsuccess`事件处理程序。

```javascript
const version = 1
const request = indexedDB.open('admin', version)
let db

request.onerror = event => alert(`Failed to open: ${event.target.errorCode}`)
request.onsuccess = event => db = event.target.result
```

`open()`操作会创建一个新数据库，然后触发 upgradeneeded 事件。可以为这个事件设置处理程序，并在处理程序中创建数据库模式。

使用`db.createObjectStore('users', { keyPath: 'username' })`可以为数据库创建一个对象存储（PS：就是创建一个 users 表的意思），这里第二个参数的`keyPath`属性表示应该用于作为 key 的存储对象的属性名。

> 如果数据库存在，而你指定了一个升级版的版本号，则会立即触发 upgradeneeded 事件，因而可以在事件处理程序中更新数据库模式。

```javascript
const version = 2
const request = indexedDB.open('admin', version)
let db

request.onerror = event => alert(`Failed to open: ${event.target.errorCode}`)
request.onsuccess = event => {
  db = event.target.result
  console.log('onsuccess')
}
request.onupgradeneeded = (event) => {
  console.log('onupgradeneeded')
  const db = event.target.result
  // 如果存在则删除当前 objectStore，测试的时候可以这样做
  // 但这样会在每次执行事件处理程序时删除已有数据
  if (db.objectStoreNames.contains('users')) {
    db.deleteObjectStore('users')
  }
  // 该方法只能在 onupgradeneeded 或 onsucess 事件中调用
  db.createObjectStore('users', { keyPath: 'username' })
}
```

#### 25.3.3 事务

创建了对象存储之后，剩下的所有操作都是通过事务完成的。任何时候，只要想要读取或修改数据，都要通过事务把所有修改操作组织起来。

```javascript
const transaction = db.transaction()
```

事务对象本身有两个事件处理程序：onerror 和 oncomplete。

通过`transaction.objectStore`可以获得对应的表，然后就可以使用下列方法来进行 CRUD 了：

- add()：添加对象
- put()：更新对象
- get()：取得对象
- delete()：删除对象

## 第 26 章 模块

在 ECMAScript 6 模块规范出现之前，虽然浏览器原生不支持模块的行为，但迫切需要这样的行为。

因为 JavaScript 是异步加载的解释型语言，所以得到广泛应用的各种模块实现也表现出不同的形态。这些不同的形态决定了不同的结果，但最终它们都实现了经典的模块模式。

### 26.1 理解模块模式











> 本次阅读至 P772 26.1 理解模块模式 797