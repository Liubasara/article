---
name: 《RustCourse》学习笔记（4）
title: 《RustCourse》学习笔记（4）
tags: ["技术","学习笔记","RustCourse"]
categories: 学习笔记
info: "第2章 Rust基本概念 2.3 所有权和借用 2.3.2 引用与借用 2.4 复合类型"
time: 2024/2/11
desc: 'RustCourse, 学习笔记'
keywords: ['RustCourse', '学习笔记', 'rust']
---

# 《RustCourse》学习笔记（2）

## 第2章 Rust基本概念

### 2.3 所有权和借用

#### 2.3.2 引用与借用

> https://course.rs/basic/ownership/borrowing.html

如果仅仅支持通过转移所有权的方式获取一个值，程序会变得很复杂。Rust 因此通过`借用（Borrowing）`这个概念来获取变量的引用。

##### 引用与解引用

常规引用是一个指针类型，引用可以使用`&`符号，解引用可以使用`*`符号，如下：

```rust
fn main() {
    let x = 5;
    let y = &x;

    assert_eq!(5, x);
    assert_eq!(5, *y);
}
```

而如果不使用解引用，就会报错：

```rust
assert_eq!(5, y)
```

![2-3.png](./images/2-3.png)

因此，在函数的使用时，可以用传递引用来代替传递所有权的变量。

```rust
fn main() {
    let s1 = String::from("hello");

    let len = calculate_length(&s1);

    println!("The length of '{}' is {}.", s1, len);
}

fn calculate_length(s: &String) -> usize {
    s.len()
}
```

这样就可以无需像上一章一样，先通过函数参数传入所有权，再通过函数返回来传出所有权，代码更加简洁。

正如变量默认不可变一样，引用指向的值也是默认不可变的。

如果要改变引用变量的值，可以使用可变引用。

##### 可变引用

创建可变引用的语法是：`&mut s`。示例如下：

```rust
fn main() {
    let mut s = String::from("hello");

    change(&mut s);
}

fn change(some_string: &mut String) {
    some_string.push_str(", world");
}
```

##### 注意：同一个作用域，特定数据只能有一个可变引用

否则会报错：

```rust
fn main() {
    let mut s = String::from("hello");

    let r1 = &mut s;
    let r2 = &mut s;

    println!("{}, {}", r1, r2);
}

```

![2-4.png](./images/2-4.png)

> 这种限制的好处就是使 Rust 在编译期就避免数据竞争，数据竞争可由以下行为造成：
>
> - 两个或更多的指针同时访问同一数据
> - 至少有一个指针被用来写入数据
> - 没有同步数据访问的机制

很多时候，使用大括号可以手动限制变量的作用域，这样就可以在同一个函数内使用多个可变引用。

```rust
fn main() {
    let mut s = String::from("hello");

    {
        let r1 = &mut s;
    } // r1 在这里离开了作用域，所以我们完全可以创建一个新的引用

    let r2 = &mut s;
}

```

##### 注意：可变引用与不可变引用不能同时存在

这是因为正在使用不可变引用的时候，不会希望这个引用在某个时刻突然改变了，因此，下面的这段代码会报错：

```rust
fn main() {
    let mut s = String::from("hello");

    let r1 = &s; // 没问题
    let r2 = &s; // 没问题
    let r3 = &mut s; // 大问题

    println!("{}, {}, and {}", r1, r2, r3);
}
```

（个人理解：这个地方会报错是因为同时使用了不可变引用和可变引用。如果声明了可变引用之后，之前的不可变引用没有再被使用过，在新的编译器下应该是可行的。也就是如果是这样的话，是不会报错的：

```rust
fn main() {
    let mut s = String::from("hello");

    let r1 = &s; // 没问题
    let r2 = &s; // 没问题
  	println!("{}, {}", r1, r2);
    let r3 = &mut s; // 大问题

    println!(", and {}", r3);
}
```

）

![2-5.png](./images/2-5.png)

> 注意，引用的作用域 `s` 从创建开始，一直持续到它最后一次使用的地方，这个跟变量的作用域有所不同，变量的作用域从创建持续到某一个花括号 `}`
>
> Rust 的编译器一直在优化，早期的时候，引用的作用域跟变量作用域是一致的，这对日常使用带来了很大的困扰，你必须非常小心的去安排可变、不可变变量的借用，免得无法通过编译，例如以下代码：
>
> ```rust
> fn main() {
>    let mut s = String::from("hello");
> 
>     let r1 = &s;
>     let r2 = &s;
>     println!("{} and {}", r1, r2);
>     // 新编译器中，r1,r2作用域在这里结束
> 
>     let r3 = &mut s;
>     println!("{}", r3);
> } // 老编译器中，r1、r2、r3作用域在这里结束
>   // 新编译器中，r3作用域在这里结束
> ```
>
> 在老版本的编译器中（Rust 1.31 前），将会报错，因为 `r1` 和 `r2` 的作用域在花括号 `}` 处结束，那么 `r3` 的借用就会触发 **无法同时借用可变和不可变**的规则。
>
> 但是在新的编译器中，该代码将顺利通过，因为 **引用作用域的结束位置从花括号变成最后一次使用的位置**，因此 `r1` 借用和 `r2` 借用在 `println!` 后，就结束了，此时 `r3` 可以顺利借用到可变引用。
>
> 对于这种编译器优化行为，Rust 专门起了一个名字 —— **Non-Lexical Lifetimes(NLL)**，专门用于找到某个引用在作用域(`}`)结束前就不再被使用的代码位置。

##### 悬垂引用（Dangling References）

悬垂引用的意思是指针指向某个值以后，但是这个值的内存被释放掉了，而指向这个内存区域的指针却永远存在。

Rust 通过编译器的所有权判定，可以保证这种错误永远不存在于可编译的代码中。

```rust
fn main() {
    let reference_to_nothing = dangle();
}

fn dangle() -> &String { // dangle 返回一个字符串的引用

    let s = String::from("hello"); // s 是一个新字符串

    &s // 返回字符串 s 的引用
} // 这里 s 离开作用域并被丢弃。其内存被释放。
  // 危险！

```

报错信息如下：

```txt
error[E0106]: missing lifetime specifier
 --> src/main.rs:5:16
  |
5 | fn dangle() -> &String {
  |                ^ expected named lifetime parameter
  |
  = help: this function's return type contains a borrowed value, but there is no value for it to be borrowed from
help: consider using the `'static` lifetime
  |
5 | fn dangle() -> &'static String {
  |                ~~~~~~~~
```

> 因为 `s` 是在 `dangle` 函数内创建的，当 `dangle` 的代码执行完毕后，`s` 将被释放，但是此时我们又尝试去返回它的引用。这意味着这个引用会指向一个无效的 `String`

所以，最好的解决方法是直接返回 String，**把 String 的所有权转移给外面的调用者**。

```rust
fn no_dangle() -> String {
    let s = String::from("hello");

    s
}
```

##### 借用引用规则总结

> 总的来说，借用规则如下：
>
> - 同一时刻，你只能拥有要么一个可变引用, 要么任意多个不可变引用
> - 引用必须总是有效的

### 2.4 复合类型

复合类型是由其他类型组合而成的，最典型的结构体是`struct`和枚举`enum`。

```rust
#![allow(unused_variables)]
type File = String;

fn open(f: &mut File) -> bool {
    true
}
fn close(f: &mut File) -> bool {
    true
}

#[allow(dead_code)]
fn read(f: &mut File, save_to: &mut Vec<u8>) -> ! {
    unimplemented!()
}

fn main() {
    let mut f1 = File::from("f1.txt");
    open(&mut f1);
    //read(&mut f1, &mut vec![]);
    close(&mut f1);
}
```

> 在这个阶段我们需要排除一些编译器噪音（Rust 在编译的时候会扫描代码，变量声明后未使用会以 `warning` 警告的形式进行提示），引入 `#![allow(unused_variables)]` 属性标记，该标记会告诉编译器忽略未使用的变量，不要抛出 `warning` 警告。
>
> `read` 函数也非常有趣，它返回一个 `!` 类型，这个表明该函数是一个发散函数，不会返回任何值，包括 `()`。`unimplemented!()` 告诉编译器该函数尚未实现，`unimplemented!()` 标记通常意味着我们期望快速完成主要代码，回头再通过搜索这些标记来完成次要代码，类似的标记还有 `todo!()`，当代码执行到这种未实现的地方时，程序会直接报错。你可以反注释 `read(&mut f1, &mut vec![]);` 这行，然后再观察下结果。
>
> 同时，从代码设计角度来看，关于文件操作的类型和函数应该组织在一起，散落得到处都是，是难以管理和使用的。而且通过 `open(&mut f1)` 进行调用，也远没有使用 `f1.open()` 来调用好，这就体现出了只使用基本类型的局限性：**无法从更高的抽象层次去简化代码**。
>
> 接下来，我们将引入一个高级数据结构 —— 结构体 `struct`，来看看复合类型是怎样更好的解决这类问题。 开始之前，先来看看 Rust 的重点也是难点：字符串 `String` 和 `&str`。

#### 2.4.1 字符串与切片

##### 2.4.1.1 字符串



