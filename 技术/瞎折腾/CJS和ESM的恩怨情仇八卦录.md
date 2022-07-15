---
name: CJS和ESM的恩怨情仇八卦录
title: CJS和ESM的恩怨情仇八卦录
tags: ["技术", "瞎折腾"]
categories: 瞎折腾
info: "你有本事抢default，你有本事开门呐！"
time: 2022/7/15
desc: cjs和esm引入导出差异
keywords: ['javascript', 'commonJS', 'nodejs', 'ECMAScript']
---

# CJS和ESM的恩怨情仇八卦录

> 参考资料：
>
> - [CJS 转 ESM，这个坑得注意](https://mp.weixin.qq.com/s/q2EuMN7r3WzMPVVlEgZQMA)
> - [JavaScript 模块化的历史进程](https://mp.weixin.qq.com/s/W4pbh5ivGu-RGkz1fdDqwQ)
> - [ESM和CJS模块杂谈](https://juejin.cn/post/7048276970768957477)

先说结论：

1. 在 nodeJS 没有支持 ESM 语法以前，nodejs 中的 esm 支持一直是通过 babel 来做的，开发者使用 esm 的 import 和 export 语法编写代码，最后通过 babel 编译回 nodejs 的 require 模式。而涉及到 export default 这一语法时，babel 使用的编译策略是将它编译成 module.exports.default，并设置一个隐藏属性`module.exports._esModule = true`。然后再对使用`import xx from xxx`的语法进行动态判断，如果判断到了 _esModule 属性，则说明需要将该 import 语法转换为`const xx = require('xxx').default`（同理可得，如果没有该属性，则说明这本身就是一个 commonJS 写成的模块，直接转换成`const xx = require('xxx')`即可）

2. 在这个运行时的帮助下，nodeJS 社区诞生了无数带着 _esModule 属性的库，然后，nodeJS 这个老渣男带着他的新老婆（实现）来了，一把将沿用了多年的 babel 踹到了一边。

3. 在 nodeJS 的实现中，**当你在一个 mjs 文件中进行 import xx from xxx 的时候**，如果目标库 cjs 规范的文件，它会直接读取其 module.exports 的输出，将其作为 default 返回。

4. 到这里可能会有同学跟笔者一样困惑，如果说在 nodeJS 的实现中，module.exports 就等于 export default 的话，那 export const 这种用法呢？**在 cjs 里面需要怎么样才能拿到 mjs 中，export const 所定义的导出值呢**？

   答案是，在 nodeJS 的实现中，**是不允许在 cjs 文件中通过 require 来加载一个 esm 文件的**，就问你服不服，从根上就杜绝了这种事发生的可能。

   当然，也不是完全不能引入，根据 ES2020 规范，笔者所使用的 node 已经可以通过动态的`import()`语法，在 cjs 文件中引入 esm 文件的内容了。但是，该 promise 解析出来的结果是这样的......

   ```javascript
   [Module: null prototype] { bbb: { dd: 12335 }, default: { bb: 123 } }
   ```

   吐槽：大哥啊！这不还是跟 babel 的一样有 default 在里面吗！那你这是图啥啊！

以下展示四位主演，分别为：

- cjs.js

  ```javascript
  module.exports = {
    bb: 234,
  }
  module.exports.bbb = { bbb: 234 }
  ```

- esm.mjs

  ```javascript
  export default {
    bb: 234
  }
  export const bbb = { bbb: 234 }
  ```

- esmImportCjs.mjs

  ```javascript
  import bb, { bbb } from './cjs.js'
  
  console.log(bb, bbb)
  // 输出：{ bb: 234, bbb: { bbb: 234 } } { bbb: 234 }
  ```

  从这里可以直观的看到，esm 引入 cjs 的时候，nodeJS 是直接去读整个 module.exports 的输出并把它当成 default 的...而解构语法，其实就是解构这个 default 的值。

- cjsImportEsm.js

  ```javascript
  const bb = require('./esm.mjs')
  
  console.log(bb)
  ```

  而企图通过在 cjs 中引入的 mjs 就这样华丽丽地报错了：

  ```txt
  node cjsImportEsm.js 
  node:internal/modules/cjs/loader:979
      throw new ERR_REQUIRE_ESM(filename, true);
      ^
  
  Error [ERR_REQUIRE_ESM]: require() of ES Module D:\esm.mjs not supported.      
  Instead change the require of D:\esm.mjs to a dynamic import() which is availab
  le in all CommonJS modules.
  ```

  修改为：

  ```javascript
  // 修改为
  !(async () => {
    const bb = await import('./esm.mjs')
    console.log(bb)
  })()
  // 输出：[Module: null prototype] { bbb: { bbb: 234 }, default: { bb: 234 } }
  ```

  看着这输出也不知道为啥有种无言以对的感觉。



PS：本次的所有测试运行在 node 环境 16.14.2 下。



