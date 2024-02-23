---
name: 《RustCourse》学习笔记（6）
title: 《RustCourse》学习笔记（6）
tags: ["技术","学习笔记","RustCourse"]
categories: 学习笔记
info: "第2章 Rust基本概念 2.5 流程控制"
time: 2024/2/23
desc: 'RustCourse, 学习笔记'
keywords: ['RustCourse', '学习笔记', 'rust']
---

# 《RustCourse》学习笔记（6）

## 第2章 Rust基本概念

### 2.5 流程控制

我们可以通过循环、分支等流程控制方式，更好的实现相应的功能。

#### 2.5.1 使用 if/else/else if来做分支控制

```rust
fn main() {
  let condition = 100;

  if condition == 100 {
    // A...
  } else if condition - 1 == 98 {
    // B..
  } else {
    // C..
  }

  let number = if condition == 100 { 5 } else { 6 };
}
```

#### 2.5.2 循环控制

Rust 语言中有三种循环方式：`for`、`while`和`loop`





















