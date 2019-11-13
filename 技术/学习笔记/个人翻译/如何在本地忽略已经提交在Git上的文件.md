---
name: 如何在本地忽略已经提交在Git上的文件
title: 如何在本地忽略已经提交在Git上的文件
tags: ["技术","学习笔记","个人翻译"]
categories: 学习笔记
info: "有时候两个命令就能体现出程序员的矫情"
time: 2019/11/12
desc: '个人翻译, How to ignore files already managed with Git locally, Git'
keywords: ['Git', '个人翻译', '学习笔记', 'How to ignore files already managed with Git locally']
---

# 如何在本地忽略已经提交在Git上的文件

> 原文链接：
>
> [How to ignore files already managed with Git locally](https://dev.to/nishina555/how-to-ignore-files-already-managed-with-git-locally-19oo)

通过将文件写入`.gitignore`或者`.git/info/exclude`，我们可以很轻松的将一些还未被 Git 管理的文件排除掉，不让 Git 进行跟踪。

但是，当你在本地改动了一些已经被 Git 列入了管理的文件，却又不想将这些提交上去的时候，`.gitignore`和`.git/info/exclude`就帮不了你了 ——  举个例子，比如通过 Git 的配置来除外一些只会在本地用到的应用程序配置文件信息的时候。

在这篇博客里，我会解释一些 Git 命令，这些命令用于哪怕文件已经被 Git 接收管理，也能帮你在提交时自动忽略掉它。

有两条命令可以做到这件事：

- ```shell
  git update-index --skip-worktree path/to/file
  ```

- ```shell
  git update-index --assume-unchanged path/to/file
  ```

## git update-index --skip-worktree

### 什么时候用？

`--skip-worktree`是一条象征着**这些文件的改动只应该在本地**的命令。

当你使用这条命令的大多数情况下，意味着你想要在本地修改一些文件但完全不想让 Git 来追踪这些变化。

### 如何确认

```shell
git ls-files -v | grep ^S
```

- `git ls-files`用于展示所有被 git 管理的文件
- `-v`用于检查被忽略的文件
- `--skip-worktree`会被`^S`给过滤出来

### 回滚设置

```shell
git update-index --no-skip-worktree path/to/file
```

## git update-index --assume-unchanged

### 什么时候用

`--assume-unchanged`是一条象征着**这些文件不应该被本地修改**的命令。

换句话说，当你想忽略一些不能在本地被修改的文件的时候，你可以使用这条命令。

同样，即便这条命令可以忽略本地修改，那么当使用`git reset --hard`命令时，还是会删掉你所有的已忽略的本地修改(PS：而`git update-index --skip-worktree`命令则不会，甚至当发现冲突时还会阻止命令执行)。

### 如何确认

```shell
git ls-files -v | grep ^h
```

- `--assume-unchanged`会被`^h`给过滤出来

### 回滚设置

```shell
git update-index --no-assume-unchanged path/to/file
```

