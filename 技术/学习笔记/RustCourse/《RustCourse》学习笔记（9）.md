---
name: 《RustCourse》学习笔记（9）
title: 《RustCourse》学习笔记（9）
tags: ["技术","学习笔记","RustCourse"]
categories: 学习笔记
info: "第2章 Rust基本概念 2.9 集合类型 2.9.1 动态数组 Vector"
time: 2024/3/19
desc: 'RustCourse, 学习笔记'
keywords: ['RustCourse', '学习笔记', 'rust']
---

# 《RustCourse》学习笔记（9）

## 第2章 Rust基本概念

### 2.9 集合类型

> https://course.rs/basic/collections/intro.html

集合中的类型是分配在堆上的，因此都可以进行动态的增加和减少，比如下面的这些类型：

- `Vector`类型，创建一个动态数组
- `HashMap`类型，创建一个动态的`KV`对
- `String`类型，创建一个可动态修改的字符串

### 2.9.1 动态数组 Vector

##### 2.9.1.1 创建方式

1. Vec::new

   ```rust
   let v: Vec<i32> = Vec::new();
   ```

   或者：

   ```rust
   let mut v = Vec::new();
   // 只要有赋值，就能自动推导类型
   v.push(1);
   ```

2. vec![]

   ```rust
   // 可自动推导类型
   let v = vec![1, 2, 3];
   ```

##### 2.9.1.2 更新 Vector

向数组尾部添加元素，可以使用 `push` 方法：

```rust
let mut v = Vec::new();
v.push(1);
```

与其它类型一样，必须将 `v` 声明为 `mut` 后，才能进行修改。

##### 2.9.1.3 Vecotr 生命周期

跟结构体一样，`Vector` 类型在超出作用域范围后，会被自动删除：

```rust
{
    let v = vec![1, 2, 3];

    // ...
} // <- v超出作用域并在此处被删除
```

当 `Vector` 被删除后，它内部存储的所有内容也会随之被删除。目前来看，这种解决方案简单直白，但是当 `Vector` 中的元素被引用后，事情可能会没那么简单。

##### 2.9.1.4 在 Vector 中读取元素

- 通过下标索引访问
- 使用 get 方法

```rust
let v = vec![1, 2, 3, 4, 5];

let third: &i32 = &v[2];
println!("第三个元素是 {}", third);

match v.get(2) {
    Some(third) => println!("第三个元素是 {third}"),
    None => println!("去你的第三个元素，根本没有！"),
}
```

> 下标索引与 `.get` 的区别
>
> 这两种方式都能成功的读取到指定的数组元素，既然如此为什么会存在两种方法？何况 `.get` 还会增加使用复杂度，这就涉及到数组越界的问题了，让我们通过示例说明：
>
> ```rust
> let v = vec![1, 2, 3, 4, 5];
> 
> let does_not_exist = &v[100];
> let does_not_exist = v.get(100);
> ```
>
> 运行以上代码，`&v[100]` 的访问方式会导致程序无情报错退出，因为发生了数组越界访问。 但是 `v.get` 就不会，它在内部做了处理，有值的时候返回 `Some(T)`，无值的时候返回 `None`，因此 `v.get` 的使用方式非常安全。
>
> 既然如此，为何不统一使用 `v.get` 的形式？因为实在是有些啰嗦，Rust 语言的设计者和使用者在审美这方面还是相当统一的：简洁即正义，何况性能上也会有轻微的损耗。
>
> 既然有两个选择，肯定就有如何选择的问题，答案很简单，当你确保索引不会越界的时候，就用索引访问，否则用 `.get`。例如，访问第几个数组元素并不取决于我们，而是取决于用户的输入时，用 `.get` 会非常适合，天知道那些可爱的用户会输入一个什么样的数字进来！

##### 2.9.1.5 同时借用多个数组元素

```rust

fn main() {
	let mut v = vec![1, 2, 3, 4, 5];

    let first = &v[0];
    // let first - &mut v[0]
    // *first = 123;
    
    v.push(6);
    
    println!("The first element is: {first}");
    println!("The v element is: {:?}", v);
}
```

上面这段代码中，`first`这个不可变引用在可变借用`v.push`以后再被使用，编译器会进行报错。

```txt
Exited with status 101
---
   Compiling playground v0.0.1 (/playground)
error[E0502]: cannot borrow `v` as mutable because it is also borrowed as immutable
  --> src/main.rs:9:5
   |
5  |     let first = &v[0];
   |                  - immutable borrow occurs here
...
9  |     v.push(6);
   |     ^^^^^^^^^ mutable borrow occurs here
10 |     
11 |     println!("The first element is: {first}");
   |                                     ------- immutable borrow later used here

For more information about this error, try `rustc --explain E0502`.
error: could not compile `playground` (bin "playground") due to 1 previous error

For more information about this error, try `rustc --explain E0499`.
error: could not compile `playground` (bin "playground") due to 1 previous error
```

> 其实，按理来说，这两个引用不应该互相影响的：一个是查询元素，一个是在数组尾部插入元素，完全不相干的操作，为何编译器要这么严格呢？
>
> 原因在于：数组的大小是可变的，当旧数组的大小不够用时，Rust 会重新分配一块更大的内存空间，然后把旧数组拷贝过来。这种情况下，之前的引用显然会指向一块无效的内存，这非常 rusty —— 对用户进行严格的教育。

##### 2.9.1.6 迭代遍历 Vector 中的元素

下标访问会触发数组的边界检查，所以可以使用迭代的方式代替去遍历数组：

```rust
let v = vec![1, 2, 3];
for i in &v {
    println!("{i}");
}

// 也可以在迭代过程中，修改 Vector 中的元素：
let mut v = vec![1, 2, 3];
for i in &mut v {
    *i += 10
}
```

##### 2.9.1.7 存储不同类型的元素

可以通过枚举类型来实现在数组中进行不同类型元素的存储：

```rust
#[derive(Debug)]
enum IpAddr {
    V4(String),
    V6(String)
}
fn main() {
    let v = vec![
        IpAddr::V4("127.0.0.1".to_string()),
        IpAddr::V6("::1".to_string())
    ];

    for ip in v {
        show_addr(ip)
    }
}

fn show_addr(ip: IpAddr) {
    println!("{:?}",ip);
}
```

**除此以外，还可以使用特征对象来存储在数组中**。

```rust
trait IpAddr {
    fn display(&self);
}

struct V4(String);
impl IpAddr for V4 {
    fn display(&self) {
        println!("ipv4: {:?}",self.0)
    }
}
struct V6(String);
impl IpAddr for V6 {
    fn display(&self) {
        println!("ipv6: {:?}",self.0)
    }
}

fn main() {
    let v: Vec<Box<dyn IpAddr>> = vec![
        Box::new(V4("127.0.0.1".to_string())),
        Box::new(V6("::1".to_string())),
    ];

    for ip in v {
        ip.display();
    }
}

```

在实际使用场景中，**特征对象数组要比枚举数组常见很多**，主要原因在于[特征对象](https://course.rs/basic/trait/trait-object.html)非常灵活，而编译器对枚举的限制较多，且无法动态增加类型。

> ChatGPT：
>
> Q：在 rust 中，Box 类型的作用是什么？上面这段代码中，`Vec<Box>` 中的 dyn IpAddr 为什么要用 Box 包裹住？如果直接用 Vec 可以吗？
>
> A：在 Rust 中，`Box<T>` 类型是一种智能指针，它在堆上分配内存。它通常用于有以下需求的场景：
>
> 1. 当你有一个在编译时大小未知的类型，但又想在需要确切大小的上下文中使用这个类型值的时候；
> 2. 当你有一个大型数据并希望转移所有权但不进行数据复制的时候；
> 3. 当你希望拥有一个值并只关心它的类型是否实现了特定的 trait 而不是其具体类型的时候。
>
> 在你的代码中，`Vec<Box<dyn IpAddr>>` 中的 `dyn IpAddr` 是一个动态分发的 trait 对象。Rust 需要知道这个 trait 对象的大小，但由于不同的实现可能会有不同的大小，所以 Rust 并不知道具体的大小。因此，我们需要将它放在一个 box 中，这样 box 就可以为数据分配足够的内存，并且 box 的大小是已知的。
>
> 如果你尝试直接使用 `Vec<dyn IpAddr>`，Rust 会报错，因为它不知道需要为 `Vec` 中的每个元素分配多少内存。所以，我们需要使用 `Box<dyn IpAddr>` 来确保我们可以在运行时动态处理不同大小的 `IpAddr` 实现。

##### 2.9.1.8 Vector 常用方法

- 初始化 vec 的更多方式：

  ```rust
  fn main() {
      let v = vec![0; 3];   // 默认值为 0，初始长度为 3
      let v_from = Vec::from([0, 0, 0]);
      assert_eq!(v, v_from);
  }
  ```

- 动态数组意味着我们增加元素时，如果**容量不足就会导致 vector 扩容**（目前的策略是重新申请一块 2 倍大小的内存，再将所有元素拷贝到新的内存位置，同时更新指针数据），显然，当频繁扩容或者当元素数量较多且需要扩容时，大量的内存拷贝会降低程序的性能。

  可以考虑在初始化时就指定一个实际的预估容量，尽量减少可能的内存拷贝：

  ```rust
  fn main() {
      let mut v = Vec::with_capacity(10);
      v.extend([1, 2, 3]);    // 附加数据到 v
      println!("Vector 长度是: {}, 容量是: {}", v.len(), v.capacity());
  
      v.reserve(100);        // 调整 v 的容量，至少要有 100 的容量
      println!("Vector（reserve） 长度是: {}, 容量是: {}", v.len(), v.capacity());
  
      v.shrink_to_fit();     // 释放剩余的容量，一般情况下，不会主动去释放容量
      println!("Vector（shrink_to_fit） 长度是: {}, 容量是: {}", v.len(), v.capacity());
  }
  ```

- 常用方法：

  ```rust
  let mut v =  vec![1, 2];
  assert!(!v.is_empty());         // 检查 v 是否为空
  
  v.insert(2, 3);                 // 在指定索引插入数据，索引值不能大于 v 的长度， v: [1, 2, 3] 
  assert_eq!(v.remove(1), 2);     // 移除指定位置的元素并返回, v: [1, 3]
  assert_eq!(v.pop(), Some(3));   // 删除并返回 v 尾部的元素，v: [1]
  assert_eq!(v.pop(), Some(1));   // v: []
  assert_eq!(v.pop(), None);      // 记得 pop 方法返回的是 Option 枚举值
  v.clear();                      // 清空 v, v: []
  
  let mut v1 = [11, 22].to_vec(); // append 操作会导致 v1 清空数据，增加可变声明
  v.append(&mut v1);              // 将 v1 中的所有元素附加到 v 中, v1: []
  v.truncate(1);                  // 截断到指定长度，多余的元素被删除, v: [11]
  v.retain(|x| *x > 10);          // 保留满足条件的元素，即删除不满足条件的元素
  
  let mut v = vec![11, 22, 33, 44, 55];
  // 删除指定范围的元素，同时获取被删除元素的迭代器, v: [11, 55], m: [22, 33, 44]
  let mut m: Vec<_> = v.drain(1..=3).collect();    
  
  let v2 = m.split_off(1);        // 指定索引处切分成两个 vec, m: [22], v2: [33, 44]
  ```

  













