如何将tinyc语言手动编译成pcode代码是非常有助于理解整个编译过程的，因此这一部分就是完成手动编译。

## 函数定义

函数定义的翻译，其实就是将函数的开头和结尾换成FUNC 和 ENDFUNC，FUNC后面接@+func_name + ”:”，如果函数中有参数，那么就在函数体的第一行加上arg + 参数列表

**tinyc：**

```
int foo(int a, int b) {
    ...
}
```

**pcode：**

```
FUNC @foo:
    arg a, b

    ...
ENDFUNC
```

## 变量声明、赋值语句、函数调用语句

变量声明就是将tinyc中的int改成var

赋值语句左侧为变量名，右侧为表达式，首先将表达式转化为后缀表达式然后按顺序翻译成pcode即可，在最后加上一句

pop var_name：

**赋值语句：**

```
a = 1 + 2 * b / sum (5, 8);
```

**逆波兰表达式：**

```
1 2 b * 5 8 sum / +
```

**Pcode：**

```
push 1
push 2
push b
mul
push 5
push 8
$sum
div
add
pop a
```

注意对于自定义的函数，需在函数名前面加 $ 。

可以看出对于复杂一点的表达式，人工将其转化成正确的后缀表达式是很困难的，必须借助计算机程序来做这件事了，这个就留给我们的 TinyC 编译器

函数调用语句其实在上面的表达式转换中就有了，先从左向右将参数入栈，再调用函数，若参数是一个表达式，则先将这个表达式翻译成 Pcode 。

**tinyc:**

```
foo(1, a, sum(b, 5));
```

**pcode：**

```
push 1
push a
push b
push 5
$sum
$foo
pop
```

注意最后的 pop 是为了将 foo 函数的返回值出栈的，因为这个值以后都不会再被使用到。如果函数调用是在表达式的内部，则不需要使用 pop 。

## 控制和循环语句

if 和 while 语句利用 jz 和 jmp 命令就可以实现，首先看 if 语句：

**tinyc：**

```c++
if (a > 0) {
    print("a is a positive number");
} else {
    print("a is a negative number");
}
```

**pcode：**

```
_beg_if:

    ; test expression
    push a
    push 0
    cmpgt

jz _else

    ; statements when test is true
    print "a is a positive number"

jmp _end_if
_else:

    ; statements when test is false
    print "a is a negative number"

_end_if:
```

可以看出上述 Pcode 有固定的结构型式，将测试语句和两个执行体翻译成 Pcode 放到相对应的地方即可。

再来看 while 语句：

**tinyc：**

```
while (a > 0) {
    a = a - 1;
}
```

**pcode：**

```
_beg_while:
	push a
	push 0
	cmpgt
jz _end_while
	push a
	push 0
	sub
	pop a
jmp _beg_while
_end_while:
   
```

结构也很简单，将测试语句和执行体翻译成 Pcode 放到相对应的地方即可。

continue 和 break 呢？将 continue 换成 jmp _beg_while，break 换成 jmp _end_while 就可以啦。

对于有多个 if / while ，以及有嵌套 if / while 语句，就要注意对同一个 if / while 语句块使用同一个Label，不同的语句块的 Label 不能冲突，continue 和 break 要 jmp 到正确的 Label ，这些工作人工来做显然很困难也容易出错，留给我们的 TinyC 编译器

## 实例

**tinyc：**

```c++
#include "for_gcc_build.hh" // only for gcc, TinyC will ignore it.

int main() {
    int i;
    i = 0;
    while (i < 10) {
        i = i + 1;
        if (i == 3 || i == 5) {
            continue;
        }
        if (i == 8) {
            break;
        }
        print("%d! = %d", i, factor(i));
    }
    return 0;
}

int factor(int n) {
    if (n < 2) {
        return 1;
    }
    return n * factor(n - 1);
}
```

**pcode:**

```
;int main() 
FUNC @main:
	var i
	push 0
	pop i
	_beg_while:
		push i
		push 10
		cmplt
		jz _end_while
		push i
		push 1
		add
		pop i
		_beg_if1:
			push i
			push 3
			cmpeq
			push i
			push 5
			cmpeq
			or
		jz _end_if1
			jmp _beg_while
		_end_if1:
		_beg_if2:
			push i
			push 8
			cmpeq
			jz _end_if2
			jmp _end_while
		_end_if2:
		push i
		push i
		$factor
		print "%d! = %d"
	jmp _beg_while
	_end_while:
	ret 0
ENDFUNC

FUNC @factor:
	var n
	_beg_if:
		push n
		push 2
		cmplt
		jz _end_if
		ret 1
	_end_if:
	; return n * factor(n - 1);
	push n
	push n
	push 1
	sub
	$factor
	mul
	ret ~
ENDFUNC
			
```

