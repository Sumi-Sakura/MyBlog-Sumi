---
title: ES5 中的声明提升
categories: [JavaScript]
tags: [ES5, JS基础]
copyright: true
date: 2017-06-28
permalink: hoisting
---
聊到声明提升就必须聊一下浏览器对于 JavaScript 代码的解析步骤

三个参与者：编译器、作用域、引擎

编译器会对源代码进行解析，生成可供浏览器执行的代码

在解析完成之后，引擎会执行解析后的代码

作用域参与了这两个环节，编译过程中对于需要进行变量提升的变量，会先将这些变量存储在作用域中，然后在引擎执行的过程中对其进行赋值操作

# 概念
在进入 **全局作用域** 或者 **函数作用域** 之前，会对作用域的代码先执行编译，然后再执行。在编译过程中，遇到了 `var`关键字，则将变量名保存在作用域中；遇到了函数声明，则将整个函数块 `function (arguments) {...}` 提升到代码顶部，而在执行阶段，每次执行函数前，都会对于函数内的代码进行编译，然后再执行

# 详解
## 全局作用域中的声明提升
只有用 **`var` 关键字声明的变量** 和 **函数声明** 会有声明提升现象

遇到了 `var`，则将变量名保存在作用域中，遇到了函数声明，则将整个函数块 `function (arguments) {...}` 提升到代码顶部

### 实例 1：利用 var 声明的变量
```javascript
console.log(a);     // undefined
var a = 1;
```
这里代码的执行步骤可以用下面来表示
```javascript
var a;
console.log(a);
a = 1;
```
由于碰到了 `var` 关键字，这里会对其进行声明提升，所以这里会打印出 undefined

### 实例 2：利用 var 声明的函数
```javascript
console.log(fn);    // undefined
var fn = function () {
    return 1;
};
```
可以将编译和执行过程表示成如下
```javascript
var fn;
console.log(fn);
fn = function () {
    return 1;
};
```

### 实例 3：函数声明
```javascript
console.log(fn;      // function fn () { return 1; };
function fn () {
    return 1;
};
```
这里同样也是，会对函数声明进行变量提升
```javascript
function fn () {...};
console.log(fn);
```
这里会先将整个函数块提升至代码顶部，并不会去管函数内有啥，然后执行代码，遇到 `console.log(fn())` 直接执行函数并打印出结果

这里一定要弄清楚函数表达式和函数声明的区别，不然会很容易犯错

## 函数作用域中的声明提升
在全局作用域代码编译完后，代码执行的过程中，遇到函数执行语句，都会对其内的代码先进行编译，再执行

函数内部编译的过程也是有顺序的，在有参数的情况下，**先声明参数然后赋值**，接下来才会对函数内代码进行编译，进行变量提升等操作
### 不含参数
```javascript
var a = 1;
function fn () {
    console.log(a);     // undefined
    var a = 2;
};
```
这是一段误导性很强的代码，根据作用域链的规则，都是在当前作用域去查找所需要的变量，如果未找到，则会沿着作用域链按顺序向上查找。按理说，不管是在函数内部还是在外部都声明了变量 a，并且进行了赋值，而在函数内部的打印结果却是 undefined，这就是声明提升导致的结果

我们可以根据声明提升的规则来分析上述代码编译和执行步骤：

全局会进行一次编译，将 var 声明的变量和函数声明提升到代码顶部
```javascript
var a;
function fn () {...};
```
然后开始执行，遇到了变量 a 的赋值操作
```javascript
a = 1;
```
接着开始执行函数，这时要先对函数内部的代码进行编译，函数内部有一个变量 a 通过 `var` 关键字声明，此时就要进行声明提升
```javascript
function fn () {
    var a;
    ...
};
```
然后执行
```javascript
function fn () {
    var a;
    console.log(a);
    a = 2;
};
```
所以这里最后会输出 2

### 含有参数
含有参数，且参数名和函数内部利用 `var` 关键字或者函数声明的名字重复的情况下，会导致一些预想不到的情况
#### 与变量声明重复
```javascript
function fn (a) {
    console.log(a);	// 1
    var a = 2;
	console.log(a);	// 2
}
fn(1);
```
对这段代码进行解析（函数内部情况）
```javascript
// 声明参数并赋值
var a = 1;		// 我对于函数内参数声明机制也不了解，故这里用 var 代替
// 进行声明提升，由于作用域已存在变量 a，并不会重新赋值为 undefined，下面会讲到
// var a;
console.log(a);		// 1
a = 2;
console.log(a);		// 2
```
这里先声明参数然后进行赋值，然后进行声明提升


#### 与函数声明重复
```javascript
function fn (a) {
    console.log(a);
    function a () {
    	return 1;
    };
}
fn(1);
```
对这段代码进行解析（函数内部情况）
```javascript
// 函数参数赋值
a = 1;
// 声明提升
function a () {
    return 1;
}
// 开始执行
console.log(a);		// function a () { return 1 }
```
这里也可以看到，在函数编译时，会首先对函数内的参数进行赋值，然后才会进行变量提升

>	所以这里一定要注意，为了避免意想不到的情况，避免函数内声明的变量名或者函数声明的名称与参数名相同！


# 规则
聊完了概念，来聊聊提升的规则
-   函数声明的声明提升优先于 `var` 关键字带来的声明提升
-   编译过程中，编译器碰到了 `var` 关键字，会先问作用域中是否含有该变量，如果有，则会忽略这个 `var` 然后继续执行编译；如果没有，则会为其分配内存并保存在作用域中

其实这两条规则是息息相关的，在代码进行编译时，首先对函数声明进行提升，然后将函数声明的名称存于作用域中，再来对 `var` 关键字声明的变量进行提升。此时碰到了 `var` 关键字，会先询问作用域，存不存在与该变量同名的函数声明，如果存在，则忽略 `var`，继续编译代码；如果不存在，则为其分配内存并保存在作用域中

```javascript
console.log(fn);        // function fn () { return 1; };
function fn () {
    return 1;
};
var fn = function () {
    return 2;
};
console.log(fn);		// function fn () { return 2; };
```
我们来对上述代码进行分析
```javascript
function fn () {
    return 1;
};
// var fn;
console.log(fn);
fn = function () {
    return 2;
};
console.log(fn);
```

# 多个 script 标签中的声明提升
上面只描述了一个 script 标签内的情况，如果是多个 script 标签呢？

标签共享作用域，但是它们却是编译并执行完一个 script 标签内的代码，然后才会对下一个 script 标签内的代码进行编译和执行

-   先来测试一下，多个 script 标签是否公用一个作用域：
    ```
    <script>
        var a = 1;
    </script>
    <script>
        console.log(a);     // 1
    </script>
    ```
    可以看到这里输出了 a 的值，说明多个 script 标签公用一个作用域

-   再来测试一下多个 script 标签的编译和执行顺序：

    -	同一个 script 标签内：
		```javascript
		function fn () {
			console.log(1);
		}
		function fn () {
			console.log(2);
		};
		fn();       // 2
		```
		可以看到浏览器只打印了 2

	-	多个 script 标签内：
		```
		<script>
		    function fn () {
		        console.log(1);
		    };
		    fn();       // 1
		</script>
		<script>
		    function fn () {
		        console.log(2);
		    };
		    fn();       // 2
		</script>
		```

    这里会先打印出 1，然后再打印出 2，如果是先编译第一个 script 标签内的代码，然后再编译下一个 script 标签内的代码，则会和上面的代码结果相同，但是这里有两个结果，说明虽然多个 script 标签是公用一个作用域，但是它们却是先执行完一个标签内的再执行下一个

下面这段代码也可以证实这个结论：
```javascript
<script>
    console.log(a);		// ReferenceError: a is not defined
</script>
<script>
    var a = 1;
</script>
```
故多个 script 标签，会先编译并执行完一个以后，再对下一个编译、执行，但是它们会共享同一作用域

# ES5 的规范以及 ES6 中的块级作用域
## 函数声明的规范和块级作用域
>	在 ES5 中，规范规定函数声明只能在 **全局作用域** 和 **函数作用域** 之中使用

只是因为各种原因，各大浏览器并没有遵循这个规定，所以即使在 **全局作用域** 和 **函数作用域** 外的作用域使用函数声明并不会报错

```javascript
// 情况一
if (true) {
  function fn() {}
}

// 情况二
try {
  function fn() {}
} catch(e) {
  // ...
}
```
上面两种情况其实都是不符合规范的，不过这些代码在浏览器中都能正常运行

>	ES6 引入了块级作用域，明确允许在块级作用域之中声明函数。ES6 规定，块级作用域之中，函数声明语句的行为类似于let，在块级作用域之外不可引用。如果改变了块级作用域内声明的函数的处理规则，显然会对老代码产生很大影响。为了减轻因此产生的不兼容问题，ES6在 [附录B](http://www.ecma-international.org/ecma-262/6.0/index.html#sec-block-level-function-declarations-web-legacy-compatibility-semantics) 里面规定，浏览器的实现可以不遵守上面的规定，有自己的行为方式 —— [阮一峰.《ECMAScript 6 入门》](http://es6.ruanyifeng.com/#docs/let)

来看两段代码就可以知道函数声明在支持 `ES6` 的浏览器中的变量提升机制了
```javascript
console.log(a);     // undefined
if (false) {
    function a () {
        return 1;
    };
};
console.log(a);     // undefined
```
```javascript
console.log(a);     // undefined
if (true) {
    function a () {
        return 1;
    };
};
console.log(a);     // function a () { return 1 };
```
在支持 `ES6` 的浏览器中，函数声明遵循以下的规则
-	允许块级作用域中定义函数
-	函数声明实际上将会类似于利用 `var` 关键字声明的函数表达式，会将变量名提升至顶部，而函数语句则会在执行中被指向变量

纠结于浏览器的表现形式不如注重自己的代码规范，不要在块级作用域内使用函数声明，如果实在需要使用，那么也要使用函数表达式

## var 关键字和块级作用域
`var` 关键字产生的声明提升是不受块级作用域的影响的
```javascript
if('a' in window) {
    var a = 10;
}
console.log(a);		// 10
```
```javascript
if (!('a' in window)) {
    var a = function () {
        return 1;
    };
}
console.log(a);		// undefined
```
这两段代码都会发生声明提升，所以 `'a' in window` 在这两个代码里结果都为 `true`

如果为了避免声明提升，则要使用 `let`

# 总结
-   **声明提升** 发生在 **`var` 关键字** 和 **函数声明** 身上
-   函数声明的提升优先级高于 **`var` 关键字**
-	函数内代码编译时，会先对函数参数赋值然后进行声明提升
-	对于 `{}` 形成的块级作用域内的函数声明，不同浏览器解析方式不同
-	`var` 关键字声明的变量不受 `{}` 形成的块级作用域影响，仍然会产生变量提升

# 遵守规范
可以说 JavaScript 声明提升这个特性在编写代码时很容易带来意想不到的错误，写出这篇文章也是为了加深自己对它的了解，在这里提醒大家：在编写代码时一定要遵守代码规范
-	函数内函数声明的名称或者利用 `var` 关键字声明的变量名不要和函数参数名相同
-	不要在 **全局作用域** 以及 **函数作用域** 外声明函数，如果要在 `{}` 形成块级作用域内声明函数，使用函数表达式是最佳方案