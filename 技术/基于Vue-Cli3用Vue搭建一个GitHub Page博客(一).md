---
name: 基于Vue-Cli3用Vue搭建一个GitHub Page博客（一）
title: 基于Vue-Cli3用Vue搭建一个GitHub Page博客（一）
info: "从零开始的博客搭建~"
categories: 博客搭建
tags: ['技术', 'Vue']
time: 2018/11/29 12:00
---

# 基于Vue-Cli3用Vue搭建一个GitHub Page博客（一）

> 引用资料：
>
> - [Build your own site](http://www.dendoink.com/#/post/2018-11-14-Life)
> - [使用 github pages, 快速部署你的静态网页](https://blog.csdn.net/baidu_25464429/article/details/80805237)
> - [ Vue CLI 3](https://cli.vuejs.org/zh/)
> - [ 手把手教你用vue搭建个人站](https://segmentfault.com/a/1190000015721550)
> - [gray-matter](https://github.com/jonschlinkert/gray-matter)
> - [深入浅出 VuePress（一）：如何做到在 Markdown 中使用 Vue 语法](https://www.jianshu.com/p/c7b2966f9d3c)

## 写在开头

通读本文，您将获得以下技能点：

1. 使用vue-cli3搭建一个新项目
2. 对vue-cli3进行简单的设置，使其支持github page页面
3. 将打包的项目部署到github page上(项目方式， 个人主页方式)

若您对以上内容已经了然，那么可以跳过本章节继续阅读本系列的其他内容。

## 前言

vue在不久前发布了其最新的脚手架Vue-cli3，该脚手架基于webpack4，对项目目录进行了极大的优化和简化，并且在迭代了几个版本以后也逐渐趋于稳定，可以说是当下新建Vue项目的不二之选。

正好之前一直想要自己开发一个博客系统，又正好看到了这个十分优秀的[开源项目](https://github.com/DendiSe7enGitHub/Align)，在看了一遍代码之后心潮澎湃，干脆说做就做，开发一个博客系统出来。虽然说现在开源社区已经提供了很多优秀的开源博客系统供我们选择，但是程序员的天性就是把复杂的东西简单化，把简单的东西复杂化，自己手撸轮子的爽快感是无论用任何框架都难以代替的。

那么既然要开发一个博客系统，我们需要哪几项功能呢？

## 需求分析

一个博客系统应该具备的最基础的两项功能：

- 支持markdown样式
- 自动识别markdown文件，并生成对应页面的路由

没有以上这两个功能，博客系统也就无从谈起，而市面上几乎所有的博客生成器，也都具备以上两点功能，但是对于我们来说，上面的功能还是显得略微有些单薄，所以稍加升级，我们将上面的需求改为：

- 支持完全自定义的markdown样式
- 自动**递归**识别特定文件夹下的所有文件夹，找出所有的markdown文件并生成路由。

第一点的改进意义自然不必多说，实现方法大概也就是添加css，让整个页面显得更加美观。

而第二点的改进会让博客文章管理起来更加的方便，避免出现博客文章一多，posts文件夹里的markdown文件显得杂乱无章的情况。

那么说干就干，开始我们的博客搭建的第一步：生成项目。

