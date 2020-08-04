---
name: 从RAF聊到EventLoop
title: 从RAF聊到EventLoop
tags: ["技术"]
categories: 学习笔记
info: "哦～循深深环蒙蒙，事件只在你眼中～"
time: 2020/8/3
desc: '学习笔记, 前端面试, event loop, requestAnimationFrame, setTimeout'
keywords: ['前端面试', '学习笔记', 'event loop', 'requestAnimationFrame', 'setTimeout']
---

# 从RAF聊到EventLoop

> 参考资料：
>
> - [HTML Standard系列：Event loop、requestIdleCallback 和 requestAnimationFrame](https://juejin.im/post/6844904056457003015)

参考资料中的文章已经将 RAF 和 EventLoop 的关系聊得十分透彻，以下记录一些个人认为重要的点以及补充一个例证 demo：

- 多次调用 requestAnimationFrame，将会在下一次渲染前的一次任务内按顺序全部执行。其原因是是因为对于浏览器的的事件循环线程 event loop 来说，事件循环不止 timer 一种，也就是说宏任务的种类也不止定时器一种。event loop 存在期间，将会一直从 task queue 里面取出一个最老的，优先级最高的任务进行执行，并且在每次执行之后都会尝试触发渲染，直至 task queue 置空为止。
- 关于任务的优先级，每个任务都有一个 task source 选项，决定了 task 归属到哪个 task queque，而 task queque 拥有不同的执行优先级，像 RAF 所属的`animation frame request callback list `的优先级就比`timer`的优先级要高。所以 event loop 会优先执行该任务。
- 此外，RAF 还会像微任务一样，将同步调用的多次任务在下一次宏任务中一次性全部执行完。

demo 代码：

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>display: none 性能测试</title>
  <style>
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }
    html, body {
      height: 100%;
    }
    .animation, .animation-2, .animation-settimeout {
      height: 100px;
      width: 0px;
      background: lightblue;
    }
  </style>
</head>
<body>
  <div class="animation"></div>
  <div class="animation-2" style="margin-top: 20px;"></div>
  <div class="animation-settimeout" style="margin-top: 20px;"></div>
  <script>
    /**
     * animation frame request callback list 中所有的回调函数，将会在一次任务内全部执行（相当于微任务执行形式的宏任务）
     * 意味着同步的多次调用 requestAnimationFrame，将会在下一次渲染前的一次任务内按顺序全部执行。
     * 
     * event loop 中在多个 task queue 之间优先级不一致中，每个 task 拥有一个 task source 属性，决定了 task 归属到哪个 task queque
     * 而 task queque 拥有不同的执行优先级，显然由 animation frame request callback list 非空而创建的任务优先级是要高于 timer 的。
     * **/
    window.onload = function () {
      let div1 = document.querySelector('.animation')
      let div2 = document.querySelector('.animation-2')
      let div3 = document.querySelector('.animation-settimeout')
      function updateDiv1 () {
        let width = div1.style.width
        if (!width) {
          div1.style.width = '1%'
        } else {
          width = (div1.style.width = +width.split('%')[0] + 1 + '%')
        }
        if (width !== '100%') {
          requestAnimationFrame(updateDiv1)
        } else {
          console.log('动画一完成：', new Date().getTime())
        }
      }
      function updateDiv2 () {
        let width = div2.style.width
        if (!width) {
          div2.style.width = '1%'
        } else {
          width = (div2.style.width = +width.split('%')[0] + 1 + '%')
        }
        if (width !== '100%') {
          requestAnimationFrame(updateDiv2)
        } else {
          console.log('动画二完成：', new Date().getTime())
        }
      }
      setTimeout(function paintDivAnimate () {
        let width = div3.style.width
        if (!width) {
          div3.style.width = '1%'
        } else {
          width = (div3.style.width = +width.split('%')[0] + 1 + '%')
        }
        if (width !== '100%') {
          setTimeout(paintDivAnimate, 16)
        } else {
          console.log('动画 setTimeout 完成：', new Date().getTime())
        }
      }, 16) // 浏览器以每秒 60HZ 运行动画，所以至少要 1000ms/60 = 16 ms执行一次刷新任务才能达到 60 帧的效果
      requestAnimationFrame(updateDiv1)
      requestAnimationFrame(updateDiv2)
      // 耗时操作，添加耗时操作之前，动画完成的速度为 3-1-2(且 1 与 2 同时启动，证明会同时执行所有的 RAF)
      // 添加耗时操作后，动画完成速度为 1-2-3(且 RAF 的任务没有阻塞，3 的任务在执行了一次以后就阻塞了很久)
      // 足以证明同为宏任务，RAF 的执行优先度比 timer 更高
      var testDOM = document.createElement('div')
      var wrapperDOM = document.createElement('div')
      testDOM.appendChild(wrapperDOM)
      for (let i = 0; i < 2000; i++) {
        // 不停塞入宏任务
        setTimeout(() => {
          wrapperDOM.innerHTML += `<div style="background: lightblue; height: 100px;">test</div>`
        }, 16)
      }
    }
  </script>
</body>
</html>
```

