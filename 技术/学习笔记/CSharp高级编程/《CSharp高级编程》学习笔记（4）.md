---
name: 《C#高级编程》学习笔记（4）
title: 《C#高级编程》学习笔记（4）
tags: ["技术","学习笔记","C#高级编程"]
categories: 学习笔记
info: "C#高级编程 第3章 对象和类型(中)"
time: 2023/6/27
desc: 'C#高级编程, 学习笔记, 第3章 对象和类型'
keywords: ['学习笔记', 'C#', 'C#高级编程', '第3章 对象和类型']

---

#  《C#高级编程》学习笔记（4）

## 第 3 章 对象和类型

### 3.8 部分类

partial 关键字允许把类、结构或者方法或者接口放在多个文件中，然后让编译器去将它们自动合并。

该关键字的用法是：把 partial 放在 class、struct 或 interface 关键字的前面。

如果声明类时使用了下面的关键字，则这些关键字必须应用于同一个类的所有部分：public、private、protected、internal、abstract、sealed、new、一般约束。

![3-9.png](./images/3-9.png)



部分类中也可以包含【部分方法】，【部分方法】的实现代码可以放在【部分类】的任何地方，也可以没有具体的实现（编译器会自动删除这个方法调用，但【部分方法】必须是 void 类型，否则编译器在没有实现代码的情况下无法删除调用）

```c#
partial class SampleClass
{
  public partial void APartialMethod();
}

// another file
partial class SampleClass: IOtherSampleClass
{
  public void APartialMethod()
  {
    // 具体实现
  }
}
```

### 3.9 扩展方法

扩展方法是给对象添加功能的另一个选项，在不能使用继承时（比如类是密封的），也可以使用这个选项。

> 扩展方法也可以用于扩展接口，这样实现该接口的所有类就有了公共功能。









> 本次阅读至 P118  3.9 扩展方法 下次阅读应至 P135

