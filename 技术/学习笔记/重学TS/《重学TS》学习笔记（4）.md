---
name: 《重学TS》学习笔记（4）
title: 《重学TS》学习笔记（4）
tags: ["技术","学习笔记","重学TS"]
categories: 学习笔记
info: "第3章 细数TS中那些奇怪的符号"
time: 2021/6/13
desc: '重学 TS, 第2章 一文读懂 TypeScript 泛型及应用'
keywords: ['前端', '重学 TS', '学习笔记', 'typeScript']
---

# 《重学TS》学习笔记（4）

## 第3章 细数TS中那些奇怪的符号

### 一、! 非空断言操作符

操作符`!`可以用于断言操作对象是非 null 和非 undefined 类型。

#### 1.1 忽略 undefined 和 null 类型

```typescript
function myFunc(maybeString: string | undefined | null) {
  /*
  Type 'string | null | undefined' is not assignable to type 'string'.
  Type 'undefined' is not assignable to type 'string'.
  */
  const onlyString: string = maybeString; // Error
  const ignoreUndefinedAndNull: string = maybeString!; // Ok
}
```

#### 1.2 调用函数时忽略 undefined 类型

```typescript
type NumGenerator = () => number;

function myFunc(numGenerator: NumGenerator | undefined) {
  /*
  Object is possibly 'undefined'.
	Cannot invoke an object which is possibly 'undefined'.
  */
  const num1 = numGenerator(); // Error
  const num2 = numGenerator!() // OK
}
```

因为`!`非空断言操作符会从编译生成的 JavaScript 代码中移除，所以在实际使用的过程中，要特别注意。

```typescript
const a: number | undefined = undefined;
const b: number = a!;
```

以上代码中，虽然使用了非空断言，使得语句可以通过 TypeScript 类型检查器的检查，但是实际生成的 ES5 代码中，b 的值依然是 undefined。

```javascript
"use strict";
const a = undefined;
const b = a;
```

#### 1.3 确定赋值断言

```typescript
let x: number;
initialize()
// Variable 'x' is used before being assigned.(2454)
console.log(2 * x) // Error

function initialize() {
  x = 10
}
```

正常情况下这段代码会报错，因为编译器并不知道 x 在与 2 相乘时已经被 initialize 函数初始化过了。

在 TypeScript 2.7 版本中引入了赋值断言，从而告诉编译器该属性会被明确的赋值。

```typescript
let x!: nubmer;
initialize()

console.log(2 * x); // Ok

function initialize() {
  x = 10
}
```

### 二、?.运算符

TypeScript 3.7 实现了呼声最高的 ECMAScript 功能之一：可选链（Optional Chainint），它支持以下语法：

```typescript
obj?.prop
obj?.[expr]
arr?.[index]
func?.(args)
```

使用可选链，可以替代很多使用`&&`执行空检查的代码。但要注意的是`?.`运算符只会验证`null`或`undefined`的情况，对于 0 或空字符串这些会被`&&`操作符认为是 falsy 的值，并不会出现“短路”。

#### 2.1 可选元素访问

可选链除了支持可选属性的访问之外，还支持可选元素的访问，这里的元素可以是任意字符串、数字索引和 Symbol。

```typescript
function tryGetArray<T>(arr?: T[], index: number = 0) {
  return arr?.[index]
}
```

该方法会自动检测输入参数 arr 的值是否为 null 或 undefined，从而保证我们代码的健壮性。

#### 2.2 可选链与函数调用

当尝试调用一个不存在的方法时也可以使用可选链，比如：

```typescript
let result = obj.customMethod?.();
```

但是在使用可选调用的时候，要注意两个注意事项：

- 如果存在一个属性名且该属性名对应的值不是函数类型，使用`?.`仍然会产生一个编译异常。
- 可选链的运算行为被局限在属性的访问、调用以及元素的访问——它不会延伸到后续的表达式中，也就是说可选调用不会阻止`a?.b/someMethod()`表达式中的除法运算或`someMethod`的方法调用

### 三、?? 空值合并运算符

TypeScript 3.7 版本引入了新的逻辑运算符 —— 空值合并运算符`??`。

**当左侧操作数为 null 或 undefined 时，其返回右侧的操作数，否则返回左侧的操作数**。

这跟逻辑或`||`运算符不同，`??`只会判断 null 或 undefined，而`||`会默认判断 falsy 值。

```typescript
const foo = null ?? 'default string'; // default string
const foo1 = null || 'default string'; // default string

const baz = 0 ?? 42; // 0
const baz1 = 0 || 42; // 42
```

#### 3.1 短路

当`??`的左表达式不为 null 或 undefined 时，不会对右表达式进行求值。

```typescript
function A () {
  console.log('A was called')
  return undefined
}

function B () {
  console.log('B was called')
  return false
}

function C () {
  console.log('C was called')
  return 'foo'
}

console.log(A() ?? C())
console.log(B() ?? C())

/*
[LOG]: "A was called" 
[LOG]: "C was called" 
[LOG]: "foo" 
[LOG]: "B was called" 
[LOG]: false 
*/
```

#### 3.2 不能与 && 或 || 操作符共用

`??`操作符不能直接与`&&`或`||`进行组合使用，如果一定要使用，可以先使用括号来显式表明优先级。

```typescript
// '||' and '??' operations cannot be mixed without parentheses.(5076) 
null || undefined ?? "foo"; // raises a SyntaxError
// '&&' and '??' operations cannot be mixed without parentheses.(5076) 
true && undefined ?? "foo"; // raises a SyntaxError

(null || undefined ) ?? "foo"; // 返回 "foo"
```

#### 3.3 与可选链操作符?.的关系

```typescript
interface Customer {
  name: string;
  city?: string;
}

let customer: Customer = {
  name: 'Semlinker'
}

let customerCity = customer?.city ?? 'Unknown city' // Unknown city
```

> 无论是`?.`操作符还是`??`操作符，不仅可以在 TypeScript 3.7 以上版本使用，还可以借助 Babel 7.8.0 及以上的版本对语法进行转译，直接在 JavaScript 环境中进行使用。

### 四、?: 可选属性

TypeScript 中的接口是一个非常灵活的概念，而使用`?.`操作符，可以把其中的某个属性声明为可选的。

```typescript
interface Person {
  age?: number;
  name: string;
}

let lolo: Person = {
  name: 'lolo'
}
```

#### 4.1 工具类型

- `Partial<T>`：将某个接口类型中定义的属性全部变成可选的

- `Required<T>`：快速地把接口类型中所有的可选属性变成必选的

  ```typescript
  type Required<T> = {
    [P in keyof T]-?: T[P];
  }
  ```

  在`Required<T>`工具类型内部，通过`-?`移除了可选属性中的`?`，使得属性从可选变为必选的。

### 五、& 运算符

`&`运算符可以将现有的多种类型叠加到一起成为一种类型。

> PS：在第一章已经介绍过，此处不详细介绍。（这书为啥老喜欢重复自己....）

### 六、| 分隔符

联合类型表示取值可以分为多种类型中的一种，联合类型使用`|`分隔每个类型。

> 同样已经介绍过

### 七、`_`数字分隔符











> 本次阅读至 84 七、`_`数字分隔符