---
name: 《C#高级编程》学习笔记（3）
title: 《C#高级编程》学习笔记（3）
tags: ["技术","学习笔记","C#高级编程"]
categories: 学习笔记
info: "C#高级编程 第3章 对象和类型"
time: 2023/5/24
desc: 'C#高级编程, 学习笔记, 第3章 对象和类型'
keywords: ['学习笔记', 'C#', 'C#高级编程', '第3章 对象和类型']

---

#  《C#高级编程》学习笔记（3）

## 第 3 章 对象和类型

![3-1.png](./images/3-1.png)

### 3.1 创建及使用类

本章将讨论与类相关的基本语法，第 4 章将介绍继承以及与继承相关的特性。

### 3.2 类和结构

类和结构实际上都是创建对象的模板，每个对象都包含数据，并提供了处理和访问数据的方法。

结构不同于类的是，它们不需要在堆上分配空间（类是引用类型，总是存储在堆上），而结构是值类型，通常存储在栈上，且结构也不支持继承。

较小的数据类型可以使用结构，以提高性能。在堆栈上存储值类型可以避免垃圾收集。

>类的对象是存储在堆空间中，结构存储在栈中。堆空间大，但访问速度较慢，栈空间小，访问速度相对更快。故而，当我们描述一个轻量级对象的时候，结构可提高效率，成本更低。当然，这也得从需求出发，假如我们在传值的时候希望传递的是对象的引用地址而不是对象的拷贝，就应该使用类了。

对于类和结构，都是用`new`来声明实例，在下面的例子中，类和结构的字段值都默认为0：

```c#
var myCustomer = new PhoneCustomer(); // works for a class
var myCustomer2 = new PhoneCustomerStruct(); // works for a struct
```

在大多数情况下，类要比结构常用得多，但类的对象通过引用传递，而结构类型的对象按值传递，除非特别说明，否则就可以假定用于类的代码也适用于结构。

### 3.3 类

类包含成员，成员可以是静态成员或是实例成员。

静态成员属于类，而实例成员属于对象。

![3-2.png](./images/3-2.png)

```c#
class PhoneCustomer
{
  /**
  可以使用 const 关键字声明常量，声明 public，就可以在类的外部访问它
  const 会被编译器识别并优化，在使用的地方将其取代成该常量
  */
  public const string DayofSendingBill = "Monday";
  /**
  readonly 保证对象的字段不能改变，与 const 修饰符不同的是，只读字段不会被编译器识别并替换
  也就是说，只是保证它可变，但并不会被硬编码到编译后的代码中。
  */
  private static readonly unit s_maxDocuments;
}
var customer1 = new PhoneCustomer();
customer1.FirstName = "Simon";
```

#### 3.3.3 属性

属性（property）的概念是，它是一个方法或是一对方法，但在客户端代码看来，它们确实是一个字段。

```c#
class PhoneCustomer
{
  private string _firstName;
  // FirstName 就是一个属性，包含 get 和 set 访问器，来检索和设置支持字段的值
  public string FirstName
  {
    // get 访问器不带任何参数，且必须返回字段所声明类型的值
    get
    {
      return _firstName;
    }
    // set 访问器没有任何显式参数，但编译器假定它带一个 value 参数，类型与声明相同
    set
    {
      _firstName = value;
    }
  }
  
  // 在 C# 7 中，还支持使用 => 编写
  public string theFirstName
  {
    get => _firstName;
    set => _firstName = value;
  }
  
  // 如果属性的 set 和 get 访问器中没有任何逻辑，可以使用自动实现的属性，自动实现的属性可以使用属性初始化器来初始化
  public int Age { get; set; } = 42;
  
  // 允许给属性的 get 和 set 访问器设置不同的访问修饰符，所以属性可以有公有的 get 访问器和私有的或受保护的 set 访问器。在 get 和 set 访问器中，必须有一个具备`属性`的访问级别。
  public string Name
  {
    get => _name;
    private set => _name = value;
  }
  // 自动实现的属性, 也可以设置不同的访问级别
  public int RealAge { get; private set; }
  
  /**
  只读属性，在属性定义中省略 set 访问器，就可以创建只读属性
  用 readonly 修饰符声明字段，只允许在构造函数中初始化属性的值
  
  可以创建`只读属性`，就可以创建`只写属性`，只要在属性定义中省略 get 访问器即可。只是不推荐这么做，如果一定要做，最好使用一个方法替代。
  */
  private readonly string _readOnlyName;
  public string ReadOnlyName
  {
    get => _name;
  }
  
  // 自动实现的只读属性语法糖
  // 在后台编译器会创建一个只读字段和一个属性，其 get 访问器可以访问这个字段。初始化的代码进入构造函数的实现代码，并在调用构造函数体之前调用。
  public string Id { get; } = "an Id";
}

// 当然只读属性也可以显式地在构造函数中初始化，如下：
public class Person {
  public string Name { get; }
  public Person(string name)
  {
    Name = name;
  }
}

/**
表达式体属性: 从 C#6 开始可以使用
*/
public class Person2
{
  public string Firstname { get; }
  public string LastName { get; }
  public string FullName => $"{FirstName}-{LastName}"
  public Person(string firstName, string lastName)
  {
    FirstName = firstName;
    LastName = lastName;
  }
}
```

**不可变类型**

一个类型中如果包含可以改变的成员，那它就是一个可变的类型。使用`readonly`修饰符，编译器会在状态改变时报错。如果对象没有任何可以改变的成员，只有只读（readonly）成员，那它就是一个不可变的类型，其内容只能在初始化时设置。这种类型对于多线程非常有用。因为内容不可改变，所以不需要同步。

不可变类型的一个例子是 String 类。这个类没有定义任何允许改变其内容的成员，诸如 ToUpper 的方法总是会返回一个新的字符串，但传递到构造函数的原始字符串保持不变。

#### 3.3.4 匿名类型

第 2 章讨论了 var 关键字，用于表示隐式类型化的变量。`var`与`new`关键字一起使用时，可以创建匿名类型。匿名类型只是一个继承 Object 且没有名称的类，该类的定义从初始化器中推断，类似于隐式类型化的变量。

如下：

```c#
var captain = new
{
  FirstName = "James",
  MiddleName = "T",
  LastName = "Kirk"
};
```

这会生成一个包含 FirstName、MIddleName 和 LastName 属性的对象，如果创建另一个对象，如下所示：

```c#
var doctor = new
{
  FirstName = "Leonard",
  MiddleName = "string",
  LastName = "Kirk"
};
```

那么上面两个对象的类型就相同。**只有所有属性都匹配，才能相互赋值，如`captain = doctor`**

如果已有一个实例，captain 对象还可以初始化为：

```c#
var captain = new
{
  person.FirstName,
  person.MiddleName,
  person.LastName
}
```

person 对象的属性名会投射到新对象。因为这些新对象的类型名未知，所以我们不能也不应使用新对象上的类型反射，因为这不会得到一致的结果。

#### 3.3.5 方法

正式的 C# 术语区分函数和方法。方法的定义包括：任意方法修饰符（如方法的可访问性）、返回值的类型、然后依次是方法名、输入参数的列表和方法体：

```c#
class HaHa {
  public bool IsSquare(Rectangle rect)
  {
    return (rect.Height == rect.Width);
  }
}
```

上面的定义中，不能省略返回类型（如果没有返回值，就把返回类型指定为 void），但是可以省略参数和 return。

如果方法实现只有一条语句，可以使用一个简化的语法：表达体式方法。

```c#
class HaHa {
  public bool IsSquare(Rectangle rect) => rect.Height == rect.Width;
}
```

**方法调用**

![3-3.png](./images/3-3.png)

**方法的重载**

C# 支持方法的重载，只要方法的几个版本有不同的签名即可（即，方法名相同，但参数的个数或数据类型不同）。为了重载方法，只需要声明同名但参数个数或者类型不同的方法即可：

对于方法重载，仅仅通过**返回类型**、**参数名称**不足以区分它们，需要区分参数的数量或类型。

```c#
class ResultDisplayer
{
  public void DisplayResult(string result)
  {
    // implementation
  }
  
  public void DisplayResult(int result)
  {
    // implementation
  }
  
  // 参数的数量和类型也可以不同
  public int DoSomething(int x)
  {
    // invoke DoSomething with two parameters
    return DoSomething(x, 10)
  }
  
  public int DoSomething(int x, int y)
  {
    // implementation
  }
}
```

**命名的参数**

调用方法时，变量名可以不用添加到调用中，但是也可以改变调用，明确数字的含义（编译器会去掉变量名，创建一个方法调用，就像没有变量名一样，还可以改变变量的顺序，编译器会重新安排以获得正确的顺序。在使用早期的 C# 版本时，在使用了第一个命名参数以后，需要为所有参数提供名称）：

```c#
// 假如有如下方法
public void MoveAndResize(int x, int y, int width, int height)
  
// 以下几种调用是等价的
r.MoveAndResize(30, 40, 20, 40);
r.MoveAndResize(x: 30, y: 40, width: 20, height: 40);
r.MoveAndResize(x: 30, y: 40, width: 20, height: 40);
```

**可选参数**

参数也可以是可选的，必须为可选参数提供默认值，可选参数还必须是方法定义的最后的参数：

```c#
public void TestMethod(int notOptionalNumber, int optionalNumber = 42)
{
  Console.WriteLine(optionalNumber + notOptionalNumber);
}

// 这个方法可以使用一个或两个参数调用。传递一个参数，编译器就修改方法调用，给第二个参数传递 42。
TestMethod(11);
TestMethod(11, 22);

// 可以定义多个可选参数，如下所示
public void TestMethod1(int n, int opt1 = 11, int opt2 = 22, int opt3 = 33)
{
  Console.WriteLine(n + opt1 + opt2 + opt3);
}
// 这样就可以使用命名参数传递任何可选参数
TestMethod1(1, opt3: 4);
```

![3-4.png](./images/3-4.png)

**个数可变的参数**

使用可选参数，可以定义数量可变的参数，但还有另一种语法允许传递数量可变的参数，且没有版本控制问题。

声明数组类型的参数，提那家 params 关键字，就可以使用任意数量的 int 参数调用该方法。

```c#
// AnyNumberOrArguments 方法的参数类型是 int[]，因此可以传递一个 int 数组，又因为 params 关键字，所以可以传递一个或任意数量的 int 值
public void AnyNumberOrArguments(params int[] data)
{
  foreach (var x in data)
  {
    Console.WriteLine(x);
  }
}

AnyNumberOrArguments(1);
AnyNumberOrArguments(1, 3, 5, 7, 11, 13);

// 如果要把不同类型的参数传递给方法，可以使用 object 数组
// 则可以使用任何类型调用这个方法
public void AnyNumberOrArguments1(params object[] data)
{
  foreach (var x in data)
  {
    Console.WriteLine(x);
  }
}
AnyNumberOrArguments1("text", 42);

// 如果 params 关键字与方法签名定义的多个参数一起使用，则 params 只能使用一次，且它必须是最后一个参数
public void AnyNumberOrArguments2(string format, params object[] data)
{
  foreach (var x in data)
  {
    Console.WriteLine(x);
  }
}
```

#### 3.3.6 构造函数

构造函数是一种特殊的方法，声明其语法就是声明一个与包含的类同名的方法，**但该方法没有返回类型**。

```c#
public class MyClass
{
  public MyClass()
  {}
}
```











> 本次阅读至 P104  个数可变的参数 下次阅读应至 P119

