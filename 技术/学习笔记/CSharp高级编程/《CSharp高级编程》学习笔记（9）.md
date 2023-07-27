---
name: 《C#高级编程》学习笔记（9）
title: 《C#高级编程》学习笔记（9）
tags: ["技术","学习笔记","C#高级编程"]
categories: 学习笔记
info: "C#高级编程 第9章 字符串和正则表达式 第 10 章 集合"
time: 2023/7/24
desc: 'C#高级编程, 学习笔记, 第9章 字符串和正则表达式 第 10 章 集合'
keywords: ['学习笔记', 'C#', 'C#高级编程', '第9章 字符串和正则表达式', '第 10 章 集合']

---

#  《C#高级编程》学习笔记（9）

## 第9章 字符串和正则表达式

在 C# 中，string 关键字的映射实际上指向 System.String，这是一个功能非常强大且用途广泛的基类，但它并不是唯一与字符串相关的类。

### 9.1 System.String 类

![7-10.png](./images/7-10.png)

#### 9.1.1 构建字符串

String 类存在一个问题：重复修改给定的字符串效率会很低，因为它实际上是一个不可变的数据类型，这意味着表面上修改字符串内容的方法和运算符实际上是在创建一个新的字符串。

为了执行性能和内存空间，微软提供了 System.Text.StringBuilder 类，它并不像 String 类那样支持非常多的方法，StringBuilder 上可以进行的处理仅限于替换和追加或删除字符串中的文本，但是它的工作方式非常高效。

> ChatGPT：
>
> StringBuilder 类是 C# 中用于处理字符串操作的一个类，它位于 System.Text 命名空间中。与 String 类不同，StringBuilder 类提供了可变字符串的功能，可以高效地进行字符串的拼接、插入、替换等操作。
>
> 主要属性和方法：
>
> 1. Length：获取或设置 StringBuilder 对象中字符的数量。
> 2. Capacity：获取或设置 StringBuilder 对象内部缓冲区的容量。
> 3. Append()：将指定的字符串追加到当前 StringBuilder 对象的末尾。
> 4. Insert()：将指定的字符串插入到当前 StringBuilder 对象的指定位置。
> 5. Replace()：将指定的字符串从当前 StringBuilder 对象中的指定位置开始替换为新的字符串。
> 6. ToString()：将当前 StringBuilder 对象转换为一个字符串。
>
> 下面是一个简单的示例代码，展示了 StringBuilder 的用法：
>
> ```csharp
> using System;
> using System.Text;
> 
> class Program
> {
>     static void Main()
>     {
>         StringBuilder sb = new StringBuilder();
>         
>         sb.Append("Hello");
>         sb.Append(" ");
>         sb.Append("World!");
>         
>         Console.WriteLine(sb.ToString()); // 输出：Hello World!
>     }
> }
> ```
>
> 与 String 类相比，StringBuilder 类的优势在于它可以避免频繁创建新的字符串对象。当需要进行大量的字符串拼接操作时，使用 StringBuilder 可以提高性能和效率。这是因为 String 类是不可变的，每次进行字符串拼接时都会创建一个新的字符串对象，而 StringBuilder 类则可以在原有的字符串基础上进行修改，避免了创建新对象的开销。
>
> 因此，当需要进行频繁的字符串操作时，使用 StringBuilder 是更好的选择。但是对于少量的字符串操作或者只是简单的字符串拼接，使用 String 类也是可以的，因为 String 类的使用更加简洁和直观。

![7-11.png](./images/7-11.png)

不能把 StringBuilder 强制转换为 String（隐式转换和显式都不行），如果要把内容输出为 String，唯一的方式就是使用 ToString() 方法。

### 9.2 字符串格式

#### 9.2.1 字符串插值

C# 6 引入了字符串使用 $ 符号前缀的字符串插值，这个前缀允许在花括号中包含占位符来引用代码的结果。

在现实中，这只是语法糖，对于带 $ 前缀的字符串，编译器实际上会创建 String.Format 方法调用。

```csharp
string s1 = "World";
string s2 = $"Hello, ${s1}";

// 相当于
string s1 = "World";
string s2 = String.Format("Hello, {0}", s1);
```

![7-12.png](./images/7-12.png)

如果希望在插值字符串中包含花括号，可以使用两个花括号转义它们：

```csharp
string s = "Hello";
Console.WriteLine($"{{s}} displays the value of s: {s}");
// {s} displays the value of s: Hello
```

#### 9.2.3 自定义字符串格式

> ChatGPT：
>
> 常用的格式化指令包括：
>
> - `{index[,alignment][:format]}`：指定变量的索引、对齐方式和格式。
> - `D`：将数字格式化为十进制整数。
> - `F`：将数字格式化为定点数。
> - `C`：将数字格式化为货币。
> - `P`：将数字格式化为百分比。
> - `N`：将数字格式化为带有千位分隔符的数值。
>
> 示例：
>
> ```csharp
> decimal price = 12.3456m;
> string formattedPrice = string.Format("The price is: {0:C}", price);
> // or
> string formattedPrice1 = $"The price is: {price:C}"
> Console.WriteLine(formattedPrice);
> // The price is: $12.35
> ```

格式字符串不限于内置类型，还可以为自己的类型创建自定义格式字符串，为此，只需要实现接口 IFormattable 。

![7-13.png](./images/7-13.png)

### 9.3 正则表达式

正则表达式作为小型技术领域的部分，在各种程序中都有着自己的作用。

在 C# 中，定义正则表达式需要用符号“@”开头，使用 Regex.Matches 方法进行匹配，如下：

```csharp
const string pattern = @"\bn";
MatchCollection myMathes = Regex.Matches("nssf", pattern, RegexOptions.IgnoreCase | RegexOptions.ExplicitCapture);
```

最后一个参数，RegexOptions 枚举有以下成员：

![7-14.png](./images/7-14.png)

使用 Console.WriteMatches 方法，可以把 MatchCollection 中的所有匹配以比较详细的格式显示出来。

![7-15.png](./images/7-15.png)

#### 9.3.4 匹配、组和捕获

假定要从一个 URI 中提取协议、地址和端口，且不考虑 URI 后面是否紧跟着空白，可以用下面的表达式：

```txt
\b(https?)(://)([.\w]+)([\s:]([\d]{2,5})?)\b
```

与这个表达式匹配的代码是 Match.Groups 方法，该方法会迭代匹配到的所有 Group 对象，在控制台上输出每组得到的索引和值。

![7-16.png](./images/7-16.png)

也可以修改正则表达式，在组的开头指定`?<name>`给组命名。如下：

![7-17.png](./images/7-17.png)

### 9.4 字符串和 Span

`Span<T>`类型除了数组以外，同样可以用来引用一个字符串的片段，而不需要复制原始内容。

![7-18.png](./images/7-18.png)

## 第 10 章 集合

### 10.1 概述

Array 类，即数组的大小是固定的，如果元素个数是动态的，就应该使用集合类`List<T>`。

本章也会介绍其他的集合类以及它们的 API 性能差异，如：队列、栈、链表、字典和集。

### 10.2 集合接口和类型



















> 本次阅读至 P238  10.2 集合接口和类型下次阅读应至 P253