---
name: 《RustCourse》学习笔记（5）
title: 《RustCourse》学习笔记（5）
tags: ["技术","学习笔记","RustCourse"]
categories: 学习笔记
info: "第2章 Rust基本概念 2.4 复合类型 2.4.2 元组"
time: 2024/2/18
desc: 'RustCourse, 学习笔记'
keywords: ['RustCourse', '学习笔记', 'rust']
---

# 《RustCourse》学习笔记（5）

## 第2章 Rust基本概念

### 2.4 复合类型

#### 2.4.2 元组

> https://course.rs/basic/compound-type/tuple.html

元组是复合类型，可以由多个类型组合到一起，它的长度是固定的，元素的顺序也是固定的。

创建一个元组：

```rust
fn main() {
    let tup: (i32, f64, u8) = (500, 6.4, 1);
}
```

##### 2.4.2.1 用模式匹配解构元组

```rust
fn main() {
    let tup = (500, 6.4, 1);

    let (x, y, z) = tup;

    println!("The value of y is: {}", y);
}
```













