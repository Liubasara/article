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

扩展方法是静态方法，它是类的一部分，但实际上没有放在类的源代码中（PS：这句话是给正常人理解的吗？？？）。

（还是 AI 靠谱一点）

> chatGPT：
>
> 在 C# 中，可以使用扩展方法来扩展一个类的方法，而无需使用继承。
>
> 扩展方法是一种特殊的静态方法，它可以在现有的类中添加新的方法，而无需修改原始类的定义。扩展方法的语法如下所示：
>
> ```csharp
> public static class ExtensionClass
> {
>     public static void NewMethod(this OriginalClass original)
>     {
>         // 扩展方法的实现
>     }
> }
> ```
>
> 在上面的代码中，`ExtensionClass` 是一个静态类，其中定义了一个扩展方法 `NewMethod`。这个方法的第一个参数使用 `this` 关键字来指定要扩展的类型，这里是 `OriginalClass`。在方法体内，可以实现扩展方法的具体逻辑。
>
> **使用扩展方法时，需要注意以下几点**：
>
> 1. 扩展方法必须定义在一个静态类中。
> 2. 扩展方法必须是静态的。
> 3. 第一个参数必须使用 `this` 关键字来指定要扩展的类型。
>
> 使用扩展方法时，可以像调用普通方法一样调用它们：
>
> ```csharp
> OriginalClass original = new OriginalClass();
> original.NewMethod();
> ```
>
> 通过扩展方法，可以在不修改原始类定义的情况下，为现有的类添加新的方法，从而实现对类的功能进行扩展。这种方式可以提高代码的可读性和可维护性。

![3-10.png](./images/3-10.png)

### 3.10 Object 类

所有的 .NET 类最终都派生自 System.Object。实际上如果在定义类的时候没有指定基类，编译器就会自动假定这个类派生自 Object。对于结构，这个派生是间接的：结构总是派生自 System.ValueType，而 System.ValueType 又派生自 System.Object。

它的实际意义是，开发者除了可以访问自己定义的方法和属性外，还可以访问许多共有的和受保护的成员方法，这些方法也可以自己来定义并覆盖。







> 本次阅读至 P119  3.10 Object 类 下次阅读应至 P136

