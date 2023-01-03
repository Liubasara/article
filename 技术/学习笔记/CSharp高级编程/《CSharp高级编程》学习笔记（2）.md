---
name: 《C#高级编程》学习笔记（2）
title: 《C#高级编程》学习笔记（2）
tags: ["技术","学习笔记","C#高级编程"]
categories: 学习笔记
info: "C#高级编程 第2章 核心C#"
time: 2023/1/2
desc: 'C#高级编程, 学习笔记, 第2章 核心C#'
keywords: ['学习笔记', 'C#', 'C#高级编程', '第2章 核心C#']

---

#  《C#高级编程》学习笔记（2）

## 第 2 章 核心C#

### 2.1 C# 基础

namespace 关键字声明了与类相关的名称空间。编译器在 using 语句指定的名称空间中查找没有在当前名称空间中定义，但在代码中引用了的类。这与 Java 中的 import 语句和 C++ 中的 using namespace 语句非常类似。

使用 using static 声明，不仅可以打开名称空间，还可以打开类的所有静态成员。声明`using static System.Console`，就可以调用 Console 类的 WriteLine 方法但不使用类名。

```c#
using static System.Console;

namespace HelloWorld {
  class Program {
    public static void Main() {
      WriteLine("Hello world!");
    }
  }
}
```

标准的 System 名称空间包含了最常见的 .NET 类型。

所有的 C# 代码都必须包含在类中。类的声明包括 class 关键字。

每个 C# 可执行文件都必须有一个入口点——Main() 方法，注意 M 必须大写。该方法要么没有返回值（void），要么返回一个整数（int）。

在本例中，只调用了 System.Console 类的 WriteLine() 方法，WriteLine() 是一个静态方法，在调用之前不需要实例化 Console 对象。

### 2.2 变量

在 C# 中使用`datatype identifier;`来声明变量，例如：`init i;`。该语句声明 int 变量 i，然后就可以使用赋值运算符（=）给它赋值。还可以在一行代码中同时声明变量并赋值：

```c#
int i;
i = 10;
// 或者
int i = 10;
```

#### 2.2.1 初始化变量

C# 有两个办法确保变量在使用前进行了初始化：

- 变量在创建时，如果不是类或结构，则默认值就是 0
- 方法的局部变量必须在代码中显式初始化才能进行使用，如果检测到局部变量在初始化之前就使用了它的值，就会标记错误。
- 在 C# 中实例化一个引用对象，需要使用 new 关键字

#### 2.2.2 类型推断

类型推断使用 var 关键字。使用 var 关键字替代实际的类型，编译器可以根据变量的初始化值“推断”变量的类型。

```c#
var someNumber = 0;
// 就变成
int someNumber = 0;
```

声明了变量且推断出类型后，就不能再改变变量的类型了。变量的类型确定后，对该变量进行任何赋值时，其强类型化规则必须以推断出的类型为基础。

#### 2.2.3 变量的作用域





> 本次阅读至 P68 下次阅读应至 P79