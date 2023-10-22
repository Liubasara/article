---
name: unity自学笔记（1）
title: unity自学笔记（1）
tags: ["技术","学习笔记","unity自学笔记", "c#"]
categories: 学习笔记
info: "万人举火迎薪王"
time: 2023/9/11
desc: 'unity 基础学习'
keywords: ['学习笔记', 'C#', 'unity']
---

# Unity 自学笔记（1）

> 自学相关视频：
>
> - [【Unity游戏原型教程】使用Unity制作类宝可梦回合制战斗](https://www.bilibili.com/video/BV1gJ411G7mP/?spm_id_from=333.1007.top_right_bar_window_default_collection.content.click)
> - [合集·《勇士传说》Unity2022版教程](https://space.bilibili.com/370283072/channel/collectiondetail?sid=1187255)
> - [unity 2D 教程 brackeys合集](https://www.bilibili.com/video/BV1fi4y1K7bj/?spm_id_from=333.337.search-card.all.click&vd_source=d5fdda99d10569d57e2ca55ee3480c9b)
> - [unity的scriptableObject的使用](https://blog.csdn.net/Fenglele_Fans/article/details/77879295)
> - [在Unity中创建涌现式设计工具的探索(有趣)](https://zhuanlan.zhihu.com/p/411273963)

## Notes

- 可以使用 [Milanote](https://milanote.com/) 来管理项目
- unity 中的 ScriptableObject 是一种可实例化在 Assets 文件夹的资源，每个资源都会在游戏开始时实例化一次，天生适合单例模式，也可以用于简单的依赖注入。
- 涌现式设计架构决定了 Scripts 不是以业务作为划分的，而是以一种机制或是一种功能来进行划分。机制 + Singleton 进行结合，成为一个业务。

## 在Unity中异步（多线程）和协程

> - [Unity协程的原理与应用](https://zhuanlan.zhihu.com/p/279383752)



> Github Copilot：
>
> Liubasara: 在 unity 中，协程和异步有什么区别？分别是如何实现的，请给我一个具体的例子。
>
> GitHub Copilot: 在Unity中，协程和异步都可以用于处理耗时操作，但它们的实现方式和使用场景有所不同。
>
> 协程是一种轻量级的线程，可以在执行过程中暂停和恢复。协程通常用于需要在一段时间内分步执行的任务，例如动画、延迟等待和网络请求。在Unity中，协程使用C#的迭代器语法实现，可以使用yield return语句来暂停和恢复协程的执行。
>
> 异步是一种基于任务的编程模型，可以在执行过程中不阻塞主线程。异步通常用于需要等待I/O操作完成的任务，例如文件读写、网络请求和数据库查询。在Unity中，异步可以使用C#的async和await关键字实现。
>
> 下面是一个具体的例子，演示了如何使用协程和异步来加载网络图片：
>
> ```csharp
> using System.Collections;
> using System.Threading.Tasks;
> using UnityEngine;
> using UnityEngine.Networking;
> using UnityEngine.UI;
> 
> public class ImageLoader : MonoBehaviour
> {
>     public string url;
>     public RawImage image;
> 
>     private void Start()
>     {
>         StartCoroutine(LoadImageCoroutine());
>         LoadImageAsync();
>     }
> 
>     private IEnumerator LoadImageCoroutine()
>     {
>         using (UnityWebRequest request = UnityWebRequestTexture.GetTexture(url))
>         {
>             yield return request.SendWebRequest();
> 
>             if (request.result == UnityWebRequest.Result.Success)
>             {
>                 Texture2D texture = DownloadHandlerTexture.GetContent(request);
>                 image.texture = texture;
>             }
>         }
>     }
> 
>     private async void LoadImageAsync()
>     {
>         using (UnityWebRequest request = UnityWebRequestTexture.GetTexture(url))
>         {
>             await request.SendWebRequest();
> 
>             if (request.result == UnityWebRequest.Result.Success)
>             {
>                 Texture2D texture = DownloadHandlerTexture.GetContent(request);
>                 image.texture = texture;
>             }
>         }
>     }
> }
> ```
>
> 在这个例子中，我们定义了一个ImageLoader类，它有一个url字段和一个RawImage组件。在Start方法中，我们同时使用协程和异步来加载网络图片。LoadImageCoroutine方法使用协程来加载图片，LoadImageAsync方法使用异步来加载图片。在两种方法中，我们都使用UnityWebRequest来发送网络请求，并使用DownloadHandlerTexture来获取图片的Texture2D对象。最后，我们将Texture2D对象赋值给RawImage组件，以显示图片。

