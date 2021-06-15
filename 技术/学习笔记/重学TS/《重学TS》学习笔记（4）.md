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

TypeScript 2.7 带来了对数据分隔符的支持。对于一个数字字面量，在 TypeScript 中可以通过一个下划线作为它们之间的分隔符来分组数字：

```typescript
const inhabitantsOfMunich = 1_464_301;
const distanceEarthSunInKm = 149_600_000;
const fileSystemPermission = 0b111_111_000;
const bytes = 0b1111_10101011_11110000_00001101;
```

分隔符不会改变数值字面量的值，只是让人们能够容易一眼看懂数字。上面的 TS 代码会生成以下的 ES5 代码：

```javascript
"use strict";
const inhabitantsOfMunich = 1464301;
const distanceEarthSunInKm = 149600000;
const fileSystemPermission = 504;
const bytes = 262926349;
```

#### 7.1 使用限制

虽然数字分隔符看起来很简单，且只能在数字之间添加`_`分隔符，但以下的使用方式还是非法的：

```typescript
 // Numeric separators are not allowed here.(6188)
3_.141592 // Error
3._141592 // Error
// Numeric separators are not allowed here.(6188)
1_e10 // Error
1e_10 // Error
// Cannot find name '_126301'.(2304)
_126301 // Error
// Numeric separators are not allowed here.(6188)
126301_ // Error
// Cannot find name 'b111111000'.(2304)
// An identifier or keyword cannot immediately follow a numeric literal.(1351)
0_b111111000 // Error
// Numeric separators are not allowed here.(6188)
0b_111111000 // Error
// Multiple consecutive numeric separators are not permitted.(6189) 
123__456 // Error
```

#### 7.2 解析分隔符

此外要注意，分隔符只能用于数字字面量，也就是说对于字符串不适用，对于将字符串转换为数字的函数也是如此，比如说这些函数：

- Number()
- parseInt()
- parseFloat()

### 八、@XXX 装饰器

#### 8.1 装饰器语法

装饰器的本质是一个函数，通过装饰器可以方便地定义与对象相关的元数据。

```typescript
function Plugin(obj: object): Function {
  return function (target: Function) {
    target.prototype.greet = function (): void {
      console.log(obj)
    }
  }
}

function Injectable(obj?: object): Function {
  return function (target: Function) {
    target.prototype.greet = function (): void {
      console.log(obj)
    }
  }
}

class IonicNativePlugin {}

@Plugin({
  pluginName: 'Device',
  plugin: 'cordova-plugin-device',
  pluginRef: 'device',
  repo: 'https://github.com/apache/cordova-plugin-device', platforms: ['Android', 'Browser', 'iOS', 'macOS', 'Windows'],
})
@Injectable()
export class Device extends IonicNativePlugin { }
```

为什么说是语法糖，可以通过编译生成的 JavaScript 代码得知：

```javascript
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
function Plugin(obj) {
    return function (target) {
        target.prototype.greet = function () {
            console.log(obj);
        };
    };
}
function Injectable(obj) {
    return function (target) {
        target.prototype.greet = function () {
            console.log(obj);
        };
    };
}
class IonicNativePlugin {
}
let Device = class Device extends IonicNativePlugin {
};
Device = __decorate([
    Plugin({
        pluginName: 'Device',
        plugin: 'cordova-plugin-device',
        pluginRef: 'device',
        repo: 'https://github.com/apache/cordova-plugin-device', platforms: ['Android', 'Browser', 'iOS', 'macOS', 'Windows'],
    }),
    Injectable()
], Device);
export { Device };
```

可以看到，`@Plugin({...})`和`@Injectable()`最终会被转换成普通的方法调用，它们的调用结果最终会以数组的形式作为参数传递给`__decorate`函数。而在`__decorate`函数内部会以 Device 类作为参数调用各自的类型装饰器，从而扩展对应的功能。

#### 8.2 装饰器的分类

在 TypeScript 中分为类装饰器、属性装饰器和参数装饰器四大类。

> PS：又是重复自己，详情见第一章....略

### 九、#XXX 私有字段

私有字段要牢记以下规则：

- 私有字段以`#`字符开头，有时又称为私有名称
- 每个私有字段名称都唯一地限定于其包含的类
- 不能在私有字段使用 TypeScript 可访问性修饰符（如 public 或 private）
- 私有字段不能在包含的类之外访问，甚至不能被检测到

#### 9.1 私有字段与 private 的区别

```typescript
class Person {
  constructor(private name: string) {}
}

const person = new Person('Semlinker')
/*
Errors in code
Property 'name' is private and only accessible within class 'Person'.
*/
console.log(person.name)
```

上面的 TS 代码创建了一个 Person 类，该类中使用`private`修饰符定义了一个私有属性`name`，接着使用该类创建一个`person`对象，然后通过`person.name`来访问`person`对象的私有属性，此时 TS 编译器会报错。

但是虽然 TS 编译器会报错，但是运行编译后的代码会发现，Person 内部的私有属性依然被打印出来了，原因是编译生成的 ES5 代码并不会对 private 做任何特殊处理：

```javascript
"use strict";
class Person {
    constructor(name) {
        this.name = name;
    }
}
const person = new Person('Semlinker');
console.log(person.name);
```

那通过`#`号定义的私有字段编译后会生成什么代码呢？

```typescript
class Person {
  #name: string;
  constructor(name: string) {
    this.#name = name;
  }
	greet () {
    console.log(`Hello, my name is ${this.#name}`);
  }
}

const person = new Person('Semlinker')
// Property 'name' does not exist on type 'Person'.
console.log(person.name)
```

编译出来的代码如下：

```javascript
"use strict";
var __classPrivateFieldSet = (this && this.__classPrivateFieldSet) || function (receiver, state, value, kind, f) {
    if (kind === "m") throw new TypeError("Private method is not writable");
    if (kind === "a" && !f) throw new TypeError("Private accessor was defined without a setter");
    if (typeof state === "function" ? receiver !== state || !f : !state.has(receiver)) throw new TypeError("Cannot write private member to an object whose class did not declare it");
    return (kind === "a" ? f.call(receiver, value) : f ? f.value = value : state.set(receiver, value)), value;
};
var __classPrivateFieldGet = (this && this.__classPrivateFieldGet) || function (receiver, state, kind, f) {
    if (kind === "a" && !f) throw new TypeError("Private accessor was defined without a getter");
    if (typeof state === "function" ? receiver !== state || !f : !state.has(receiver)) throw new TypeError("Cannot read private member from an object whose class did not declare it");
    return kind === "m" ? f : kind === "a" ? f.call(receiver) : f ? f.value : state.get(receiver);
};
var _Person_name;
class Person {
    constructor(name) {
        _Person_name.set(this, void 0);
        __classPrivateFieldSet(this, _Person_name, name, "f");
    }
    greet() {
        console.log(`Hello, my name is ${__classPrivateFieldGet(this, _Person_name, "f")}`);
    }
}
_Person_name = new WeakMap();
const person = new Person('Semlinker');
console.log(person.name);
```

可以看到，对于使用`#`号定义的私有字段，ES 代码会通过`WeakMap`对象来存储，同时编译器会生成`__classPrivateFieldSet`和`__classPrivateFieldGet`这两个方法用于设置值和获取值。