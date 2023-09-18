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

