---
name: 《重学TS》学习笔记（9）
title: 《重学TS》学习笔记（9）
tags: ["技术","学习笔记","重学TS"]
categories: 学习笔记
info: "第11章 TypeScript 进阶之装饰 Web 服务器 第 12 章 编写高效 TS 代码的一些建议"
time: 2021/6/26
desc: '重学TS，第11章 TypeScript 进阶之装饰 Web 服务器，第 12 章 编写高效 TS 代码的一些建议'
keywords: ['前端', '重学 TS', '学习笔记', 'typeScript']
---

# 《重学TS》学习笔记（9）

## 第11章 TypeScript 进阶之装饰 Web 服务器

本章重心围绕装饰器的应用展示，以 OvernightJS 库为例，介绍如何使用 TypeScript 装饰器来装饰 Express。

### 一、OvernightJS 简介

OvernightJS 用于为调用 Express 路由的方法添加 TypeScript 装饰器，还包含了用于管理 json-web-token 和打印日志的包。

该库为开发者提供了以下特性：

- 使用`@Controller`装饰器定义基础路由
- 提供把类方法转化为 Express 路由的装饰器（比如 @Get，@Put，@Post，@Delete）
- 提供用于处理中间件的`@Middleware`和`@ClassMiddleware`装饰器
- 提供用于处理异常的`@ErrorMiddleware`装饰器
- 提供`@Wrapper`和`@ClassWrapper`装饰器用于包装函数
- 通过`@ChildControllers`装饰器支持子控制器

#### 初始化项目

```shell
# 在项目中安装 express 和 overnightJS
npm i @overnightjs/core express -S

# 项目中集成 typeScript 和直接在 node 环境下运行 TS 命令的包
npm i typescript ts-node -D

# 为 Node.js 和 Express 安装声明文件
npm i @types/node @types/express -D
```

安装完以上依赖后，package.json 中就会新增如下的依赖：

```json
{
    "devDependencies": {
        "@types/express": "^4.17.8",
      	"@types/node": "^14.11.2",
      	"ts-node": "^9.0.0",
      	"typescript": "^4.0.3"
    }
}
```

#### 初始化 TypeScript 配置文件

为了能够灵活配置 TypeScript 项目，需要为本项目生成 TypeScript 配置文件。

```shell
# 在项目中输入如下命令就会自动创建一个 tsconfig.json 文件
tsc --init
```

在本项目中，使用如下配置项：

```json
{
    "compilerOptions": {
        "target": "es6",
        "module": "commonjs",
      	"rootDir": "./src",
        "outDir": "./build",
      	"esModuleInterop": true,
      	"experimentalDecorators": true,
      	"strict": true
    }
}
```

#### 添加 index.ts 和第一个 Controller 文件

**index.ts**

```typescript
import { Server } from "@overnightjs/core";
import { UserController } from "./controllers/UserController";
const PORT = 3000;
export class SampleServer extends Server {
    constructor() {
        super(process.env.NODE_ENV === "development");
        this.setupControllers();
    }
    private setupControllers(): void {
        const userController = new UserController(); super.addControllers([userController]);
    }
    public start(port: number): void {
        this.app.listen(port, () => {
            console.log(` [server]:Serverisrunningathttp://localhost:${PORT}`);
        });
    }
}
const sampleServer = new SampleServer(); sampleServer.start(PORT);
```

**UserController.ts**

```typescript
import { Controller, Get } from "@overnightjs/core";
import { Request, Response } from "express";

@Controller("api/users") export class UserController {
    @Get("")
    private getAll(req: Request, res: Response) {
        return res.status(200).json({
            message: "成功获取所有用户",
        });
    }
}
```

#### 添加启动命令

在 package.json 中添加 start 命令来启动项目：

```json
{
  "script": {
    "start": "ts-node ./src/index.ts"
  }
}
```

#### 安装 nodemon

使用 nodemon 库可以自动检测目录中文件的更改，当发现文件异动时，会自动重启 Node.js 应用程序。

```shell
# 安装 nodemon
npm i nodemon -D
```

package.json:

```json
{
  "script": {
    "start": "nodemon ./src/index.ts"
  }
}
```

### 二、OvernightJS 原理分析

![11-2-1.png](./images/11-2-1.png)

利用 OvernightJS 提供的装饰器，可以让开发显得更加便捷。但其实 OvernightJS 底层还是基于 Express，内部最终还是通过 Express 提供的 API 来处理路由。

> PS：要使用装饰器，必须要将 tsconfig 中的 compilerOptions.experimentalDecorators 选项设置为 true，或者在执行 tsc 命令时使用
>
> `tsc --target ES5 --experimentalDecorators`



> PS：接下来的源码分析看得头大，而且作者也只写了一部分...有兴趣再回顾吧

## 第 12 章 编写高效 TS 代码的一些建议













> 本次阅读至 208 第 12 章 编写高效 TS 代码的一些建议