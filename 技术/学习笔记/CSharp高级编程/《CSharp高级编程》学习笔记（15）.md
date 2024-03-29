---
name: 《C#高级编程》学习笔记（15）
title: 《C#高级编程》学习笔记（15）
tags: ["技术","学习笔记","C#高级编程"]
categories: 学习笔记
info: "C#高级编程 第 18 章 Visual Studio 2017 第 19 章 库、程序集、包和NuGet 第 20 章 依赖注入"
time: 2023/8/20
desc: 'C#高级编程, 学习笔记, 第 18 章 Visual Studio 2017, 第 19 章 库、程序集、包和NuGet, 第 20 章 依赖注入 第 20 章 依赖注入'
keywords: ['学习笔记', 'C#', 'C#高级编程', '第 18 章 Visual Studio 2017', '第 19 章 库、程序集、包和NuGet', '第 20 章 依赖注入']

---

#  《C#高级编程》学习笔记（15）

## 第 18 章 Visual Studio 2017

> 无聊的一章，略过

**第二部分 .NET Core 与 Windows Runtime**

## 第 19 章 库、程序集、包和NuGet

简单来说，在 NuGet 包管理器出现之前，C# 的程序会由于多版本依赖造成库的依赖非常复杂，而且对于不同版本的库没有一个好的兼容机制。

而 NuGet 包在库中添加了另一个抽象层，NuGet 包可以包含一个或多个程序集的多个版本，以及一些手动重定向的版本配置。

## 第 20 章 依赖注入

### 20.1 依赖注入的概念

依赖注入（DI）允许从类的外部注入依赖项，因此注入的依赖项只需要知道一个协议（接口）即可。

使用依赖注入，可以使用不同的实现来区分生产模式和开发模式，也可以在不同的平台上使用不同的实现，还允许用自定义特性替换标准功能。

DI 是敏捷软件开发和持续软件交付实践的核心模式。

![17-22.png](./images/17-22.png)

### 20.2 使用 .NET Core DI 容器

虽然依赖注入可以不需要依赖注入容器，但该容器有助于管理依赖项，依赖注入容器管理的服务列表越长，就越能看到它的优点。

在依赖注入容器中，可以定义一个服务，将某个 Interface 映射到哪个具体的实现类上，还可以指定将该服务，是作为一个单例来使用，还是每次使用都创建一个新的实例。

Microsoft.Extensions.DependencyInjection 是 C# 自带的一个依赖注入容器的实现。

![17-23.png](./images/17-23.png)

> ChatGPT：
>
> **Q：详细介绍 C# 中的 Microsoft.Extensions.DependencyInjection 包**
>
> A：`Microsoft.Extensions.DependencyInjection` 是 .NET Core 和 .NET 5+ 中的一个扩展包，用于支持依赖注入（Dependency Injection，简称 DI）模式。依赖注入是一种设计模式，通过将组件之间的依赖关系从代码中解耦，提高了代码的可维护性、可测试性和灵活性。
>
> 该包主要提供了一组 API，用于配置和管理应用程序中的依赖关系。以下是一些常用的用法和示例：
>
> ### 1. 添加服务到容器
>
> ```csharp
> using Microsoft.Extensions.DependencyInjection;
> 
> // 创建一个服务容器
> var serviceProvider = new ServiceCollection()
>     .AddTransient<IMyService, MyService>()  // 注册一个瞬时生命周期的服务
>     .AddSingleton<ISingletonService, SingletonService>()  // 注册一个单例生命周期的服务
>     .AddScoped<IScopedService, ScopedService>()  // 注册一个作用域生命周期的服务
>     .BuildServiceProvider();  // 构建服务提供程序
> 
> // 从容器中获取服务实例
> var myService = serviceProvider.GetRequiredService<IMyService>();
> ```
>
> ### 2. 构造函数注入
>
> ```csharp
> public class Consumer
> {
>     private readonly IMyService _myService;
> 
>     public Consumer(IMyService myService)
>     {
>         _myService = myService;
>     }
> 
>     public void DoSomething()
>     {
>         _myService.DoWork();
>     }
> }
> ```
>
> ### 3. 属性注入
>
> ```csharp
> public class Consumer
> {
>     [Inject]
>     private IMyService _myService { get; set; }
> 
>     public void DoSomething()
>     {
>         _myService.DoWork();
>     }
> }
> ```
>
> ### 4. 通过接口获取服务
>
> ```csharp
> public interface IMyService
> {
>     void DoWork();
> }
> 
> public class MyService : IMyService
> {
>     public void DoWork()
>     {
>         Console.WriteLine("MyService is doing work.");
>     }
> }
> 
> // 在 Main 方法中使用
> var myService = serviceProvider.GetRequiredService<IMyService>();
> myService.DoWork();
> ```
>
> ### 5. 配置服务
>
> ```csharp
> // 在 Startup.cs 中的 ConfigureServices 方法中配置服务
> public void ConfigureServices(IServiceCollection services)
> {
>     services.AddTransient<IMyService, MyService>();
>     services.AddControllers();
> }
> ```
>
> ### 6. 中间件中使用
>
> ```csharp
> public class MyMiddleware
> {
>     private readonly RequestDelegate _next;
>     private readonly IMyService _myService;
> 
>     public MyMiddleware(RequestDelegate next, IMyService myService)
>     {
>         _next = next;
>         _myService = myService;
>     }
> 
>     public async Task InvokeAsync(HttpContext context)
>     {
>         // 使用 _myService 执行操作
>         await _next(context);
>     }
> }
> ```
>
> 这里的示例展示了如何使用 `Microsoft.Extensions.DependencyInjection` 包来实现依赖注入，它有助于解耦组件之间的关系，使代码更加可维护和可测试。在一个真实的应用程序中，通常会使用更多的服务和配置选项，但上述示例应该能够帮助你入门。

![17-24.png](./images/17-24.png)

### 20.3 服务的生命周期

#### 20.3.1 使用单例和临时服务

临时对象：transient

单例对象：singleton

![17-25.png](./images/17-25.png)

#### 20.3.2 使用 Scoped 服务

服务也可以在一个作用域内注册，即介于临时对象和单例对象之间的服务，在 Scoped 中时，总是从相同的作用域中返回相同的实例，而不同的 Scoped 时，就会返回不同的实例。

![17-26.png](./images/17-26.png)

![17-27.png](./images/17-27.png)

#### 20.3.3 使用自定义工厂

除了定义使用 transient、scoped 和 singleton 之外，还可以创建自定义工厂或将现有实例传递给容器。

![20-1.png](./images/20-1.png)

### 20.4 使用选项初始化服务

在 DI 中，一个服务的依赖只能是另一个服务的接口，而不能够使用服务的构造函数来定义其依赖。但是在 .NET 中，也可以使用一些 C# 中包装好的服务，来传递这部分特殊的依赖参数。

> ChatpGPT：
>
> 在 C# 中的依赖注入 (DI) 中，`services.AddOptions` 方法用于注册和配置选项模式。选项模式允许你定义一组配置选项，并将它们注入到应用程序的各个组件中，从而实现配置的集中管理。`AddOptions` 方法是这一过程中的一部分，它会将选项类注册到 DI 容器中，以便在需要时进行注入。
>
> 以下是对 `services.AddOptions` 方法的详细介绍：
>
> **方法签名：**
> ```csharp
> public static IServiceCollection AddOptions(this IServiceCollection services);
> ```
>
> **参数：**
> - `services`: `IServiceCollection` 接口的实例，表示依赖注入容器。`AddOptions` 方法是一个扩展方法，通过传递 `services` 实例来进行调用。
>
> **工作原理：**
> `AddOptions` 方法将选项配置类注册到 DI 容器中，以便后续可以在需要的地方将其注入。选项配置类通常包含应用程序的不同配置属性，这些属性可以在配置文件、环境变量等来源中进行配置。
>
> **示例：**
> 假设你正在构建一个应用程序，需要配置数据库连接字符串和日志级别，可以通过选项模式来管理这些配置。首先，你需要定义一个选项配置类：
>
> ```csharp
> public class AppSettings
> {
>     public string ConnectionString { get; set; }
>     public string LogLevel { get; set; }
> }
> ```
>
> 然后，在依赖注入容器中使用 `services.AddOptions` 方法注册选项配置类：
>
> ```csharp
> using Microsoft.Extensions.DependencyInjection;
> using Microsoft.Extensions.Options;
> 
> class Program
> {
>     static void Main(string[] args)
>     {
>         IServiceCollection services = new ServiceCollection();
>         
>         services.AddOptions<AppSettings>().Configure<IConfiguration>((settings, configuration) =>
>         {
>             configuration.GetSection("AppSettings").Bind(settings);
>         });
> 
>         IServiceProvider serviceProvider = services.BuildServiceProvider();
> 
>         var appSettings = serviceProvider.GetRequiredService<IOptions<AppSettings>>().Value;
> 
>         Console.WriteLine($"Connection String: {appSettings.ConnectionString}");
>         Console.WriteLine($"Log Level: {appSettings.LogLevel}");
>     }
> }
> ```
>
> 在这个示例中，`AddOptions` 方法注册了 `AppSettings` 类，并通过 `.Configure<IConfiguration>` 来配置选项的值。在真实应用中，可以从配置文件中读取这些值。然后，通过 `GetRequiredService<IOptions<AppSettings>>().Value` 来获取配置的选项。
>
> 总结：`services.AddOptions` 方法是在 C# 依赖注入中用于注册选项模式的方法。它将选项配置类注册到 DI 容器中，以便在需要的地方注入选项。选项模式允许你更好地管理应用程序的配置，并将配置集中到一个地方。

### 20.5 使用配置文件

除了用上面的方式来使用配置中心，还有一种更直接的方法，使用 Microsoft.Extensions.Options.ConfigurationExtendsions 中的配置进行扩展。

### 20.6 创建平台独立性

依赖注入也可以在平台独立的库中使用特定于平台的特性。

### 20.7 使用其他 DI 容器

还可以使用其他第三方依赖注入容器，如：

![20-2.png](./images/20-2.png)





