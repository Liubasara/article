---
name: 《RustCourse》学习笔记（1）
title: 《RustCourse》学习笔记（1）
tags: ["技术","学习笔记","RustCourse"]
categories: 学习笔记
info: "第1章 Rust语言基础学习"
time: 2024/1/27
desc: 'RustCourse, 学习笔记'
keywords: ['RustCourse', '学习笔记', 'rust']
---

# 《RustCourse》学习笔记（1）

> 资料地址:
>
> https://github.com/sunface/rust-course
>
> **本资料仅用于自学记录，请到官方网站查看最新更新章节!**

## 第1章 Rust语言基础学习

### 1.1 安装环境

使用 rustup 教程：https://course.rs/first-try/installation.html

> 个人更建议在学习阶段不要往自己的电脑乱装环境浪费时间，可以用 Docker 镜像配合 VsCode 进行开发，下面是个人的一点经验：
>
> 1. 安装 docker，并且拉取 rust 镜像。（默认镜像是基于 Debian 12 的）
>
>    ```shell
>    docker pull rust
>    ```
>
> 2. 启动容器并挂载。
>
>    ```shell
>    docker run -dit --name rust-study -v d:/dockerInfo/rust-study/volume:/app/data rust
>    docker exec -it rust-study bash
>    root@3aa4eb51aa66: cd /app/data/ && touch hello-world
>    ```
>
>    查看硬盘目录是否挂载成功。
>
> 3. 使用 Vscode 安装 Docker 插件以及 Dev Container 插件以后连接到现有容器中
>
>    ![1-1.png](./images/1-1.png)
>
>    ![1-2.png](./images/1-2.png)
>
>    ![1-3.png](./images/1-3.png)