---
name: 《JavaScript设计模式与开发实践》学习笔记（八）
title: 《JavaScript设计模式与开发实践》学习笔记（八）
tags: ["技术","学习笔记","JavaScript设计模式与开发实践"]
categories: 学习笔记
info: "第二部分、第 11 章 模板方法模式、第 12 章 享元模式"
time: 2019/9/28
desc: 'JavaScript设计模式与开发实践, 资料下载, 学习笔记'
keywords: ['JavaScript设计模式与开发实践资料下载', '前端', '学习笔记']
---

# 《JavaScript设计模式与开发实践》学习笔记（八）

## 第 11 章 模板方法模式

模板方法模式是一种基于继承的设计模式。

### 11.1 定义及组成

该模式由两部分结构组成：

- 抽象父类，封装了子类的算法框架，包括一些公共方法以及封装子类中所有方法的执行顺序
- 具体实现子类，子类通过继承父类可以继承整个算法结构，并且可以选择重写父类的方法

### 11.2 一个例子

我们定义一个抽象父类：Beverage（饮料），以及两种子类饮料：Tea 和 Coffee。

```javascript
class Beverage {
    init () {
        // 通用步骤
        this.boilWater()
        // 调用当前实例的制作饮料方法步骤
        this.step1()
        this.step2()
        this.step3()
    }
    boilWater () {
        console.log('把水煮沸')
    }
}

class Tea extends Beverage {
    step1 () {
        console.log('步骤一')
    }
    step2 () {
        console.log('步骤二')
    }
    step3 () {
        console.log('步骤三')
    }
}

class Coffee extends Beverage {
    step1 () {
        console.log('步骤一')
    }
    step2 () {
        console.log('步骤二')
    }
    step3 () {
        console.log('步骤三')
    }
}

let tea = new Tea()
tea.init() // 制作开始
```

在上面的例子中，Beverage.prototype.init 就是一个模板方法，因为该方法中封装了子类的算法框架，并指导子类以何种顺序去执行哪些方法。

### 11.3 抽象类

模板方法模式是一种严重依赖抽象类的设计模式，JavaScript 在语言层面上并没有提供对抽象类的支持（TypeScript 有）。这一小节我们来了解一下 Java 中抽象类的作用地位以及在 JavaScript 中的兼容和变通。

#### 11.3.1 抽象类的作用

抽象类不能被实体化，就像一瓶饮料不能被实体化一样，这个抽象类一定是用来被某些具体类（比如快乐水、雪碧）来继承的。

同样的，如果在抽象类中的抽象方法没有被子类正确的实现，那么该实现就是错误的，Java 这类需要编译的静态语言也会报错。

抽象类中一样可以存在具体方法，就像刚刚的 boildWater 方法一样，为所有子类所共享。

#### 11.3.4 JavaScript 没有抽象类的缺点和解决方案

由于 JavaScript 是一门“类型模糊”的语言，也并没有编译器来帮助我们进行任何形式的检查，所以我们没有办法保证子类一定会重写父类中的“抽象方法”。

完全依靠程序员的自觉和记忆力来确保代码健壮性无疑是很危险的，为了能够达到类似抽象类报错的能力，我们可以给父类 Bevereage 加入一些报错信息：

```javascript
class Beverage {
    init () {
        // 通用步骤
        this.boilWater()
        // 调用当前实例的制作饮料方法步骤
        this.step1()
        this.step2()
        this.step3()
    }
    boilWater () {
        console.log('把水煮沸')
    }
    step1 () {
        throw new Error('子类必须重写该方法')
    }
    step2 () {
        throw new Error('子类必须重写该方法')
    }
    step3 () {
        throw new Error('子类必须重写该方法')
    }
}
```

这样，当程序执行时，若没有找到子类的对应方法，JavaScript 就会顺着原型链找到父类的方法，并抛出错误。

这样做虽然依然不能完全替代编译器的作用，但至少聊胜于无。

### 11.6 好莱坞原则

> 莱坞无疑是演员的天堂，但好莱坞也有很多找不到工作的新人演员，许多新人演员在好莱
> 坞把简历递给演艺公司之后就只有回家等待电话。有时候该演员等得不耐烦了，给演艺公司打电话询问情况，演艺公司往往这样回答：“不要来找我，我会给你打电话。” 
>
> 在设计中，这样的规则就称为好莱坞原则 

好莱坞原则是指允许底层组件将自己挂载道高层组件中，由高层组件决定在什么时候以何种方式调用这些底层组件。

模板方法模式就是好莱坞原则的一个景点使用场景，当我们用模板方法编写一个程序时，就意味着子类放弃了对自己的控制权，改为由高层来调用。

除此以外，之前学习的发布-订阅模式，甚至是最基础的回调函数也都是这一原则的体现。

## 第 12 章 享元模式

> 享元（flyweight）模式是一种用于性能优化的模式，“fly”在这里是苍蝇的意思，意为蝇量级。

享元模式的核心是运用共享技术来有效支持大量细粒度的对象。可以有效节省内存。

### 12.2 内部状态和外部状态

享元模式要求将对象的属性划分为内部状态和外部状态，其目标是尽量减少共享对象的数量，关于如何划分内部状态和外部状态，可以参照以下几条：

- 内部状态存储于对象内部
- 内部状态可以被一些对象共享
- 内部状态独立于具体的场景，通常不会改变
- 外部状态取决于具体的场景，并且根据场景而变化，外部状态不能被共享

### 12.4 文件上传的例子

在文件上传模块的开发中，享元模式就是提升程序性能的关键。

常规的上传函数是这样的：

```javascript
class Upload {
    constructor (uploadType, fileName, fileSize, id) {
        this.uploadType = uploadType
        this.fileName = fileName
        this.fileSize = fileSize
        this.id = id // 该对象设置一个唯一的 id
    }
}

function startUpload = function (uploadType, files) { // uploadType 区分是控件还是 flash
    files.forEach((item, index) => {
        let uploadObj = new Upload(uploadType, file.fileName, file.fileSize, index++)
    })
}

startUpload('plugin', [
    {fileNmae: '1.txt', fileSize: 1000},
    {fileNmae: '2.txt', fileSize: 2000}
])
```

但当进行多个文件的并发上传，比如说 2000 个，如果我们同时 new 2000 个文件对象，那么大部分浏览器都会直接罢工，甚至导致死机。

接下来用享元模式进行重构。

1. 首先要区分外部状态和内部状态

   在该例子中，upload 对象必须依赖 uploadType 属性，因为这意味着两种不同的上传对象，所以 uploadType 是一个内部状态，而 fileName 和 fileSize 由于会随着环境变化而变化，且无法共享，所以是外部状态

2. 剥离外部状态，在确定内部状态和外部状态后，我们就可以把外部状态从构造函数中抽离出来了。

   ```javascript
   class Upload {
       constructor (uploadType) {
           this.uploadType = uploadType
       }
   }
   ```

3. 工厂进行对象实例化

   定义一个工厂用于创建 Upload 对象，如果某种内部状态对应的共享对象已经被创建过，则可以直接返回这个对象，某则就创建一个新的对象。

   ```javascript
   let UploadFactory = (function () {
       var createdFlyWeightObjs = {}
       return {
           create: function (uploadType) {
               if (createdFlyWeightObjs[uploadType]) {
                   return createdFlyWeightObjs[uploadType]
               }
               return createdFlyWeightObjs[uploadType] = new Upload(uploadType)
           }
       }
   })()
   ```

4. 管理器封装外部状态

   封装好了内部状态以后，就可以为不同内部状态的对象添加外部状态了：

   ```javascript
   let uploadManager = (function () {
       let uploadDatabase = {}
       return {
           add: function (uploadType, fileName, fileSize, id) {
               let flyWeightObj = UploadFactory.create(uploadType)
               uploadDatabase[id] = {
                   fileName: fileName,
                   fileSize: fileSize
               }
               return flyWeightObj
           }
       }
   })()
   ```

5. startUpload 函数可以修改如下：

   ```javascript
   function startUpload = function (uploadType, files) { // uploadType 区分是控件还是 flash
       files.forEach((item, index) => {
           let uploadObj = uploadManager.add(uploadType, file.fileName, file.fileSize, index++)
       })
   }
   ```

经过上面的重构以后，无论同时上传多少个文件，所创建的对象数量依然只有不同 uploadType 类型的数量。

### 12.8 小结

跟大部分模式的诞生原因不一样，享元模式是为了解决性能问题而生的模式，它可以很好地解决大量对象带来的性能问题。

