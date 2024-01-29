---
name: 《RustCourse》学习笔记（2）
title: 《RustCourse》学习笔记（2）
tags: ["技术","学习笔记","RustCourse"]
categories: 学习笔记
info: "第2章 Rust基本概念"
time: 2024/1/28
desc: 'RustCourse, 学习笔记'
keywords: ['RustCourse', '学习笔记', 'rust']
---

# 《RustCourse》学习笔记（2）

## 第2章 Rust基本概念

Rust 中有许多之前没有听过的概念：

- 所有权、借用、生命周期
- 宏编程
- 模式匹配

通过一段代码简单浏览 Rust 的语法：

```rust
// Rust 程序入口函数，跟其它语言一样，都是 main，该函数目前无返回值
fn main() {
    // 使用let来声明变量，进行绑定，a是不可变的
    // 此处没有指定a的类型，编译器会默认根据a的值为a推断类型：i32，有符号32位整数
    // 语句的末尾必须以分号结尾
    let a = 10;
    // 主动指定b的类型为i32
    let b: i32 = 20;
    // 这里有两点值得注意：
    // 1. 可以在数值中带上类型:30i32表示数值是30，类型是i32
    // 2. c是可变的，mut是mutable的缩写
    let mut c = 30i32;
    // 还能在数值和类型中间添加一个下划线，让可读性更好
    let d = 30_i32;
    // 跟其它语言一样，可以使用一个函数的返回值来作为另一个函数的参数
    let e = add(add(a, b), add(c, d));

    // println!是宏调用，看起来像是函数但是它返回的是宏定义的代码块
    // 该函数将指定的格式化字符串输出到标准输出中(控制台)
    // {}是占位符，在具体执行过程中，会把e的值代入进来
    println!("( a + b ) + ( c + d ) = {}", e);
}

// 定义一个函数，输入两个i32类型的32位有符号整数，返回它们的和
fn add(i: i32, j: i32) -> i32 {
    // 返回相加值，这里可以省略return
    i + j
}
```

> 注意 在上面的 `add` 函数中，不要为 `i+j` 添加 `;`，这会改变语法导致函数返回 `()` 而不是 `i32`，具体参见[语句和表达式](https://course.rs/basic/base-type/statement-expression.html)。

要注意：

- 字符串使用双引号`""`而不是单引号`''`，Rust 中的单引号是留给`char`单字符类型使用的
- Rust 使用 `{}` 来作为格式化输出占位符。由于`println!`会自动推导出具体的类型，因此无需手动指定。

### 2.1 变量绑定与解构

> https://course.rs/basic/variable.html

#### 为何要手动设置变量的可变性？

Rust 可以手动设置变量的可变性，可以避免一些多余的 runtime 检查，会使得运行性能有所提升，但也意味着 Rust 语言底层代码的实现复杂度大幅提升。

#### 变量绑定

其他语言都是把赋值的过程称为**变量赋值**，为什么 rust 跟其他语言不一样要称为**变量绑定**呢？

这涉及到了 Rust 最核心的原则——所有权，在 Rust 中任何内存对象都是有主人的，绑定就是把这个对象绑定给一个变量，让这个变量成为它的主人。

#### 变量可变性

Rust 的变量在默认情况下是不可变的。当然也可以通过`mut`关键字让变量变为可变的。

#### 变量解构及赋值

```rust
fn main() {
    let (a, mut b): (bool,bool) = (true, false);
    // a = true,不可变; b = false，可变
    println!("a = {:?}, b = {:?}", a, b);

    b = true;
    assert_eq!(a, b);
}
```

```rust
struct Struct {
    e: i32
}

fn main() {
    let (a, b, c, d, e);

    (a, b) = (1, 2);
    // _ 代表匹配一个值，但是我们不关心具体的值是什么，因此没有使用一个变量名而是使用了 _
    [c, .., d, _] = [1, 2, 3, 4, 5];
    Struct { e, .. } = Struct { e: 5 };

    assert_eq!([1, 2, 1, 4, 5], [a, b, c, d, e]);
}
```

#### 变量和常量之间的差异

常量使用`const`关键字而不是`let`关键字来声明，而且值得类型**必须标注**。

#### 变量遮蔽

Rust 允许声明相同的变量名，且后面声明的变量会遮蔽掉前面声明的。

```rust
fn main() {
    let x = 5;
    // 在main函数的作用域内对之前的x进行遮蔽
    let x = x + 1;

    {
        // 在当前的花括号作用域内，对之前的x进行遮蔽
        let x = x * 2;
        println!("The value of x in the inner scope is: {}", x);
    }

    println!("The value of x is: {}", x);
}
```

> 这和 `mut` 变量的使用是不同的，第二个 `let` 生成了完全不同的新变量，两个变量只是恰好拥有同样的名称，涉及一次内存对象的再分配 ，而 `mut` 声明的变量，可以修改同一个内存地址上的值，并不会发生内存对象的再分配，性能要更好。

### 2.2 基本类型

> https://course.rs/basic/base-type/index.html







