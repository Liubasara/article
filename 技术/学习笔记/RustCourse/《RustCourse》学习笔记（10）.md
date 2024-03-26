---
name: 《RustCourse》学习笔记（10）
title: 《RustCourse》学习笔记（10）
tags: ["技术","学习笔记","RustCourse"]
categories: 学习笔记
info: "第2章 Rust基本概念 2.10 KV 存储 HashMap 2.10 认识生命周期"
time: 2024/3/26
desc: 'RustCourse, 学习笔记'
keywords: ['RustCourse', '学习笔记', 'rust']
---

# 《RustCourse》学习笔记（10）

## 第2章 Rust基本概念

### 2.10 KV 存储 HashMap

> https://course.rs/basic/collections/hashmap.html

Rust 中哈希类型为`HashMap<K, V>`。

跟其它集合类型一致，`HashMap` 也是内聚性的，即所有的 `K` 必须拥有同样的类型，`V` 也是如此。

#### 2.10.1 使用 new 新建 HashMap

```rust
use std::collections::HashMap;

// 创建一个HashMap，用于存储宝石种类和对应的数量
let mut my_gems = HashMap::new();

// 将宝石类型和对应的数量写入表中
my_gems.insert("红宝石", 1);
my_gems.insert("蓝宝石", 2);
my_gems.insert("河边捡的误以为是宝石的破石头", 18);
```

> 跟 `Vec` 一样，如果预先知道要存储的 `KV` 对个数，可以使用 `HashMap::with_capacity(capacity)` 创建指定大小的 `HashMap`，避免频繁的内存分配和拷贝，提升性能。

##### 2.10.2 使用迭代器和 collect 方法创建

如何将`Vec`快速写入到`HashMap`中？一个笨方法是用循环手动塞进去：

```rust
fn main() {
    use std::collections::HashMap;

    let teams_list = vec![
        ("中国队".to_string(), 100),
        ("美国队".to_string(), 10),
        ("日本队".to_string(), 50),
    ];

    let mut teams_map = HashMap::new();
    for team in &teams_list {
        teams_map.insert(&team.0, team.1);
    }

    println!("{:?}",teams_map)
}
```

而聪明的方法是：先将 `Vec` 转为迭代器，接着通过 `collect` 方法，将迭代器中的元素收集后，转成 `HashMap`。

```rust
fn main() {
    use std::collections::HashMap;

    let teams_list = vec![
        ("中国队".to_string(), 100),
        ("美国队".to_string(), 10),
        ("日本队".to_string(), 50),
    ];

    let teams_map: HashMap<_,_> = teams_list.into_iter().collect();
    
    println!("{:?}",teams_map)
}
```

> 代码很简单，`into_iter` 方法将列表转为迭代器，接着通过 `collect` 进行收集，不过需要注意的是，`collect` 方法在内部实际上支持生成多种类型的目标集合，因此我们需要通过类型标注 `HashMap<_,_>` 来告诉编译器：请帮我们收集为 `HashMap` 集合类型，具体的 `KV` 类型，麻烦编译器您老人家帮我们推导。

如果不指定类型，Rust 编译器会报错：

```txt
error[E0282]: type annotations needed // 需要类型标注
  --> src/main.rs:10:9
   |
10 |     let teams_map = teams_list.into_iter().collect();
   |         ^^^^^^^^^ consider giving `teams_map` a type // 给予 `teams_map` 一个具体的类型
```

##### 2.10.3 所有权转移

所有权规则跟其它的类型一样：

- 如果类型实现了`Copy`特征，给类型会被复制进`HashMap`，因此无所谓所有权
- 若没实现`Copy`特征，所有权被转移给`HashMap`中

如果将引用类型放入到 HashMap 中，则需要确保该引用的生命周期至少跟 HashMap 活得一样久。

##### 2.10.4 查询/更新 HashMap

通过`get`方法获取元素：

```rust
use std::collections::HashMap;

let mut scores = HashMap::new();

scores.insert(String::from("Blue"), 10);
scores.insert(String::from("Yellow"), 50);

let team_name = String::from("Blue");
let score: Option<&i32> = scores.get(&team_name);
```

如果 get 方法获取不到，会返回 None。如果不使用借用`&32`，可能会发生所有权的转移。



使用如下方法进行值的更新：

```rust
fn main() {
    use std::collections::HashMap;

    let mut scores = HashMap::new();

    scores.insert("Blue", 10);

    // 覆盖已有的值
    let old = scores.insert("Blue", 20);
    assert_eq!(old, Some(10));

    // 查询新插入的值
    let new = scores.get("Blue");
    assert_eq!(new, Some(&20));

    // 查询Yellow对应的值，若不存在则插入新值
    let v = scores.entry("Yellow").or_insert(5);
    assert_eq!(*v, 5); // 不存在，插入5

    // 查询Yellow对应的值，若不存在则插入新值
    let v = scores.entry("Yellow").or_insert(50);
    assert_eq!(*v, 5); // 已经存在，因此50没有插入
  
  let text = "hello world wonderful world";

  let mut map = HashMap::new();
  // 根据空格来切分字符串(英文单词都是通过空格切分)
  for word in text.split_whitespace() {
      let count = map.entry(word).or_insert(0);
      *count += 1;
  }

  println!("{:?}", map);
}
```

> 有两点值得注意：
>
> - `or_insert` 返回了 `&mut v` 引用，因此可以通过该可变引用直接修改 `map` 中对应的值
> - 使用 `count` 引用时，需要先进行解引用 `*count`，否则会出现类型不匹配

##### 2.10.5 哈希函数

一个类型能否作为`key`的关键就是能否进行相等比较，或者说该类型是否实现了`std::cmp::Eq`特征。换言之，就是使用一个密码学函数对不同的`key`进行加密后生成不同的结果。

> f32 和 f64 浮点数，没有实现 `std::cmp::Eq` 特征，因此不可以用作 `HashMap` 的 `Key`。

##### 2.10.6 高性能三方库

如果性能测试显示当前默认的哈希函数不能满足性能需求，则需要去`Crates.io`上去寻找其他的哈希函数实现：

```rust
use std::hash::BuildHasherDefault;
use std::collections::HashMap;
// 引入第三方的哈希函数
use twox_hash::XxHash64;

// 指定HashMap使用第三方的哈希函数XxHash64
let mut hash: HashMap<_, _, BuildHasherDefault<XxHash64>> = Default::default();
hash.insert(42, "the answer");
assert_eq!(hash.get(&42), Some(&"the answer"));
```

> 目前，`HashMap` 使用的哈希函数是 `SipHash`，它的性能不是很高，但是安全性很高。`SipHash` 在中等大小的 `Key` 上，性能相当不错，但是对于小型的 `Key` （例如整数）或者大型 `Key` （例如字符串）来说，性能还是不够好。若你需要极致性能，例如实现算法，可以考虑这个库：[ahash](https://github.com/tkaitchuck/ahash)。
>
> PS：不过安全性和准确性就没有那么好了。（即可能会出现哈希冲突）

### 2.10 认识生命周期

> https://course.rs/basic/lifetime.html

















