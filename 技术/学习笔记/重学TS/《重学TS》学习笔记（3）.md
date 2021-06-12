---
name: 《重学TS》学习笔记（3）
title: 《重学TS》学习笔记（3）
tags: ["技术","学习笔记","重学TS"]
categories: 学习笔记
info: "第2章 一文读懂 TypeScript 泛型及应用"
time: 2021/6/11
desc: '重学 TS, 第2章 一文读懂 TypeScript 泛型及应用'
keywords: ['前端', '重学 TS', '学习笔记', 'typeScript']
---

# 《重学TS》学习笔记（3）

## 第2章 一文读懂 TypeScript 泛型及应用

本章将全方位一步步学习 TypeScript 中的泛型。

![2-0-1.png](./images/2-0-1.png)

### 一、泛型是什么

设计泛型的关键目的是在成员之间提供有意义的约束，这些成员可以是：类的实例成员、类的方法、函数参数和函数返回值。

比如下面定义了一个通用的`identity`函数：

```javascript
function identity(value) {
  return value
}

console.log(identity(1)) // 1
```

然后将`identity`函数作适当调整，以支持 Number 类型的参数：

```typescript
function identity(value: Number): Number {
  return value
}
```

上面的函数仅可用于 Number 类型，并不是可扩展或通用的函数，而如果把 Number 换成 any，就会失去定义应该返回哪种类型的能力，并且让编译器失去了类型保护的作用。

所以这种情况下就可以使用泛型了。

```typescript
function identity <T>(value: T) : T {
  return value;
}

console.log(identity<Number>(1))
// 也可以省略掉上面的 Number，让编译器自行推断参数的类型
console.log(identity(1))
```

那如果想要返回两种类型的对象怎么办呢？一种方案是使用元组，即为元组设置通用的类型：

```typescript
function identity<T, U>(value: T, message: U) : [T, U] {
  return [value, message]
}
```

虽然使用了元组解决了这个问题，但更好的方案是使用**泛型接口**。

### 二、泛型接口

为了解决上面提到的问题，首先可以创建一个`Identities`接口，用于定义`identity`函数的返回类型：

```typescript
interface Identities<V, M> {
  value: V,
  message: M
}
```

在上述的`Identities`接口中引入了类型变量`V`和`M`，来进一步说明有效的字母都可以用于表示类型变量，之后就可以将该接口作为 identity 函数的返回类型：

```typescript
function identity<T, U> (value: T, message: U): Identities<T, U> {
  console.log(`value: ${typeof value}`);
  console.log(`message: ${typeof message}`)
  let identities: Identities<T, U> = {
    value,
    message
  }
  return identities;
}

console.log(identity(68, 'Semlinker'))

/*
[LOG]: "value: number" 
[LOG]: "message: string" 
[LOG]: {
  "value": 68,
  "message": "Semlinker"
} 
*/
```

### 三、泛型类

泛型除了可以应用在函数和接口之外，也可以应用在类中。

```typescript
interface GenericInterface<U> {
  value: U
  getIdentity: () => U
}

class IdentityClass<T> implements GenericInterface<T> {
  value: T
  constructor(value: T) {
    this.value = value
  }
  getIdentity(): T {
    return this.value
  }
}

const myNumberClass = new IdentityClass<Number>(68);
console.log(myNumberClass.getIdentity()); // 68

const myStringClass = new IdentityClass<string>("Semlinker!");
console.log(myStringClass.getIdentity()); // Semlinker!
```

泛型类可以确保在整个类中一致性地使用指定的数据类型，以确保类中的属性是类型安全的。

通常在决定是否使用泛型时，会有以下两个参考标准：

- 当你的函数、接口或者类将处理多种数据类型时
- 当函数、接口或类在多个地方使用该数据类型时

### 四、泛型约束

泛型的作用在于限制每个类型变量接受的类型数量，下面将介绍如何使用泛型约束。

#### 4.1 确保属性存在

举一个见简单的例子，当开发者处理通常的字符串或数组时，会假设`length`属性是可用的，但是当使用泛型时，编译器不会确切的知道泛型`T`确实包含`length`属性。

```typescript
function identity<T>(arg: T): T {
  console.log(arg.length); // Error return arg;
}
```

这时候就需要让类型变量`T`进行`extends`一个含有所需属性的接口，比如这样：

```typescript
interface Length {
  length: number;
}
function identity<T extends Length>(arg: T): T {
  console.log(arg.length); // 可以获取length属性
  return arg;
}
```

此外，还可以使用`,`来分割多种约束类型，就像`<T extends Length, Type2, Type3>`，而对于上述问题，显式地将变量设置为数组类型，也可以设置该问题，比如这样：

```typescript
function identity<T>(arg: T[]): T[] {
  console.log(arg.length);
  return arg;
}
// or
function identity<T>(arg: Array<T>): Array<T> {
  console.log(arg.length);
  return arg;
}
```

#### 4.2 检查对象上的键是否存在

泛型约束的另一个常见的使用场景就是检查对象上的键是否存在。而通过`keyof`操作符，开发者可以获取制定类型的所有键，并返回一个联合类型。然后使用`extends`进行配合，即可达成约束的目的，具体的例子比如：

```typescript
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key]
}
```

在上面的函数中，就可以通过`K extends keyof T`的约束确保参数 key 一定是对象中含有的键，这样就能确保不会发生运行时的错误，而是在编译阶段就能提前发现。**这是一个类型安全的解决方案，与简单调用`let value = obj[key];`不同**。

### 五、泛型参数的默认类型

在 TypeScript2.3 以后，可以为泛型中的类型参数指定默认类型。**当没有在代码中直接指定类型参数，也无法从实际值的参数中推断出类型时，这个默认类型就会起作用**。

```typescript
interface A<T=string> {
  name: T;
}

const strA: A = { name: 'Semlinker' }
const numB: A<number> = { name: 101 }
```

泛型参数的默认类型遵循以下规则：

- 有默认类型的类型参数被认为是可选的
- 必选的类型参数不能再可选的类型参数后
- 如果类型参数有约束，类型参数的默认类型必须满足这个约束
- 当指定类型实参时，只需要指定必选类型参数的类型实参。未指定的类型参数会被解析为它们的默认类型。
- 如果指定了默认类型，且类型推断无法选择一个候选类型，那么将使用默认类型作为推断结果。
- 一个被现有的类或接口合并的类或接口的声明，可以为现有类型参数引为默认类型
- 一个被现有类或接口合并的类或者接口的声明可以引入新的类型参数，只要它指定了默认类型。

### 六、泛型条件类型









> 本次阅读至 63 六、泛型条件类型

