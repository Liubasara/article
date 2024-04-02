---
name: 《RustCourse》学习笔记（11）
title: 《RustCourse》学习笔记（11）
tags: ["技术","学习笔记","RustCourse"]
categories: 学习笔记
info: "第2章 Rust基本概念 2.11 返回值和错误处理"
time: 2024/3/30
desc: 'RustCourse, 学习笔记'
keywords: ['RustCourse', '学习笔记', 'rust']
---

# 《RustCourse》学习笔记（11）

## 第2章 Rust基本概念

### 2.11 返回值和错误处理

> https://course.rs/basic/result-error/intro.html

Rust 中的错误主要分为两类：

- **可恢复错误**，通常用于从系统全局角度来看可以接受的错误，例如处理用户的访问、操作等错误，这些错误只会影响某个用户自身的操作进程，而不会对系统的全局稳定性产生影响
- **不可恢复错误**，刚好相反，该错误通常是全局性或者系统性的错误，例如数组越界访问，系统启动时发生了影响启动流程的错误等等，这些错误的影响往往对于系统来说是致命的

很多编程语言，并不会区分这些错误，而是直接采用异常的方式去处理。Rust 没有异常，但是 Rust 也有自己的卧龙凤雏：`Result<T, E>` 用于可恢复错误，`panic!` 用于不可恢复错误。

#### 2.11.1 panic 深入剖析

对于严重到影响程序运行的错误，比如数组访问越界，触发 `panic` 是很好的解决方式。在 Rust 中触发 `panic` 有两种方式：被动触发和主动调用.

- 被动触发，如数组的越界访问

- 主动调用，开发者主动抛出一个异常，可以使用`panic!`来做到

  ```rust
  fn main() {
      panic!("crash and burn");
  }
  /*
  thread 'main' panicked at 'crash and burn', src/main.rs:2:5
  note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
  
  	以上信息包含了两条重要信息：
  
    main 函数所在的线程崩溃了，发生的代码位置是 src/main.rs 中的第 2 行第 5 个字符（包含该行前面的空字符）
    在使用时加上一个环境变量可以获取更详细的栈展开信息：
    Linux/macOS 等 UNIX 系统： RUST_BACKTRACE=1 cargo run
    Windows 系统（PowerShell）： $env:RUST_BACKTRACE=1 ; cargo run
  */
  ```

  > 切记，一定是不可恢复的错误，才调用 `panic!` 处理，你总不想系统仅仅因为用户随便传入一个非法参数就崩溃吧？所以，**只有当你不知道该如何处理时，再去调用 panic!**.

##### 2.11.1.1 backtrace 栈展开

在真实场景中，错误往往涉及到很长的调用链甚至会深入第三方库，如果没有栈展开技术，错误将难以跟踪处理。在发生错误时，使用如下命令润兴程序就能捕获到出错的详细调用栈：

```shell
RUST_BACKTRACE=1 cargo run
# or
$env:RUST_BACKTRACE=1 ; cargo run
```

要获取到栈回溯信息，你还需要开启 `debug` 标志，该标志在使用 `cargo run` 或者 `cargo build` 时自动开启（这两个操作默认是 `Debug` 运行方式）。同时，栈展开信息在不同操作系统或者 Rust 版本上也有所不同。

##### 2.11.1.2 panic 时的两种终止方式

当出现 `panic!` 时，程序提供了两种方式来处理终止流程：**栈展开**和**直接终止**。

默认的方式是栈展开。这意味着 Rust 会回溯栈上的数据和函数调用。而直接终止则是不清理数据就直接退出。

当你关心最终编译出的二进制文件可执行文件的大小时，可以尝试使用直接终止的方式。

修改`Cargo.toml`文件即可实现在 release 模式下遇到 `panic` 直接终止：

```rust
[profile.release]
panic = 'abort'
```

线程 panic 后，如果是 main 线程，程序会直接终止。如果是其它子线程，该线程会终止，但是不会影响 main 线程。

##### 2.11.1.3 何时该使用 panic!









