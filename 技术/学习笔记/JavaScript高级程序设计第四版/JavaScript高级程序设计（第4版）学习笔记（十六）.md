---
name: JavaScript高级程序设计（第4版）学习笔记（十六）
title: JavaScript高级程序设计（第4版）学习笔记（十六）
tags: ["技术","学习笔记","JavaScript高级程序设计第四版"]
categories: 学习笔记
info: "十年磨一剑，红宝书：25. 客户端存储"
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
const request = indexedDB.open('admin', version)
let db

request.onerror = event => alert(`Failed to open: ${event.target.errorCode}`)
request.onsuccess = event => db = event.target.result
```

使用`db.createObjectStore('user', { keyPath: 'username' })`可以为数据库创建一个对象存储，这里第二个参数的`keyPath`属性表示应该用于作为 key 的存储对象的属性名。

#### 25.3.3 事务

创建了对象存储之后，剩下的所有操作都是通过事务完成的。









> 本次阅读至 P764 25.3.3 事务 789