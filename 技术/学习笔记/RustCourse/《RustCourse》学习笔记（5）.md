---
name: 《RustCourse》学习笔记（5）
title: 《RustCourse》学习笔记（5）
tags: ["技术","学习笔记","RustCourse"]
categories: 学习笔记
info: "第2章 Rust基本概念 2.4 复合类型 2.4.2 元组 2.4.3 结构体"
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

##### 2.4.2.1/2.4.2.2/2.4.2.3 用模式匹配解构元组/用.来访问元组/元组的使用示例

```rust
fn main() {
    let tup = (500, 6.4, 1);

    let (x, y, z) = tup;

    println!("The value of y is: {}", y);
}
```

和其它语言的数组、字符串一样，元组的索引从 0 开始，可以直接用`.`来访问

```rust
fn main() {
    let x: (i32, f64, u8) = (500, 6.4, 1);

    let five_hundred = x.0;

    let six_point_four = x.1;

    let one = x.2;
}
```

元组在函数返回值场景很常用，例如下面的代码，可以使用元组返回多个值。

```rust
fn main() {
    let s1 = String::from("hello");

    let (s2, len) = calculate_length(s1);

    println!("The length of '{}' is {}.", s2, len);
}

fn calculate_length(s: String) -> (String, usize) {
    let length = s.len(); // len() 返回字符串的长度

    (s, length)
}
```

> 有一个说法，`()`作为类型，是0个元素的Tuple，这种类型的值只有一个，恰好也是`()`

#### 2.4.3 结构体

结构体`struct`是一种复合数据结构，其他语言也有类似的数据结构，比如`object`、`record`等等。

##### 2.4.3.1 结构体语法

一个结构体由几部分组成：

- 通过关键字`struct`定义
- 一个清晰明确的结构体`名称`
- 几个有名字的结构体`字段`

比如下面的结构体：

```rust
// 该结构体名称是 User，拥有 4 个字段，且每个字段都有对应的字段名及类型声明，例如 username 代表了用户名，是一个可变的 String 类型。
struct User {
  active: bool,
  username: String,
  email: String,
  sign_in_count: u64,
}

// 创建结构体示例：
let user1 = User {
  email: String::from("someone@example.com"),
  username: String::from("someusername123"),
  active: true,
  sign_in_count: 1,
};
```

> 注意：
>
> 1. 初始化实例时，**每个字段**都需要进行初始化
> 2. 初始化时的字段顺序**不需要**和结构体定义时的顺序一致

通过`.`操作符即可访问结构体内部的字段值和修改他们。

```rust
let mut user1 = User {
  email: String::from("someone@example.com"),
  username: String::from("someusername123"),
  active: true,
  sign_in_count: 1,
};

user1.email = String::from("anotheremail@example.com");
```

> 注意：必须要将结构体实例声明为可变的，才能修改其中的字段，Rust 不支持将某个结构体某个字段标记为可变。



**简化结构体创建**，酷似 TypeScript：

```rust
fn build_user(email: String, username: String) -> User {
  User {
    email,
    username,
    active: true,
    sign_in_count: 1,
  }
}
```



**结构体更新语法**

根据已有的结构体实例，创建新的结构体实例：

```rust
let user2 = User {
  active: user1.active,
  username: user1.username,
  email: String::from("another@example.com"),
  sign_in_count: user1.sign_in_count,
};

// 或者可以用另一种方法

/**
  因为 user2 仅仅在 email 上与 user1 不同，因此我们只需要对 email 进行赋值，剩下的通过结构体更新语法 ..user1 即可完成。
  .. 语法表明凡是我们没有显式声明的字段，全部从 user1 中自动获取。需要注意的是 ..user1 必须在结构体的尾部使用。
*/
let user2 = User {
  email: String::from("another@example.com"),
  ..user1
};
```

**注意：上面的代码中，`user1`结构体的`username`字段和`email`字段的所有权被转移了，因此，`user1`结构体实例的这两个字段不能被继续使用了**。

```rust
let user1 = User {
    email: String::from("someone@example.com"),
    username: String::from("someusername123"),
    active: true,
    sign_in_count: 1,
};
let user2 = User {
    active: user1.active,
    username: user1.username,
    email: String::from("another@example.com"),
    sign_in_count: user1.sign_in_count,
};
println!("{}", user1.active);
// 下面这行会报错
println!("{:?}", user1);
```



##### 2.4.3.2 结构体的内存排列

































