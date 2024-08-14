## 数据类型与源程序结构
首先tinyc只有一种int的数据类型并且我们默认是32位。但是在函数的返回值里面可以有int和void两种类型，但是我们构建的编译器会自动为void函数返回一个int值。但不支持全局变量，只支持局部变量，并且变量必须先声明再使用，且变量声明必须放在函数体的最前面，在变量声明时不可以赋初值。同时对于函数的原型声明也不支持，函数的声明和定义必须放在一起，函数无需先定义再使用。同时整个程序要有一个不带参数的main函数作为入口。“//...”和“#...”为单行注释，并且不支持#include等预处理命令，不支持多行注释。
给出一个比较简单且典型的tinyc程序。
```c
int main() {
    int a, b;
    int c, d;   // 变量声明必须放在函数体的最前面
    a = 0;
    ...
}

void func1(int a, int b) {
    ...
}

...
```
同时tinyc只支持四种语句：赋值语句、函数调用语句、if语句和while语句。在赋值语句中=左边为变量名，右边为表达式，如果只含有一个表达式这是错误的当然函数调用语句除外。
## 运算
tinyc支持以下运算
+, -, *, /, %, ==, !=, >, <, >=, <=, &&, ||, !, -
最后一个 - 是取反与减号区别
tinyc不支持++和--。并且赋值语句也只能单独使用不可以在表达式内部使用。

## 输入和输出

tinyc可以使用两种io命令

```c
print("x = %d, y = %d", 2, 3);          // 输出： x = 2, y = 3
x = readint("Please input an integer");
```

但是print只能单独使用，而readint必须放在赋值语句的右端。

## 控制与循环

tinyc支持if和while语句并且在while中支持continue和break，但是整个tinyc不支持for、switch、goto等控制循环语句。并且在使用if和while中也要使用花括号将代码包括

## 函数调用

tinyc支持函数调用并且可以使用递归的方法

## 关键字

tinyc中的关键字有：

```c
void, int, while, if, else, return, break, continue, print, readint
```

## 示例代码

```c
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

以上代码中的第一行的 #include “for_gcc_build.hh” 是为了利用gcc来编译该文件的，TinyC 编译器会注释掉该行。`for_gcc_build.hh`文件源码如下：

```c
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

void print(char *format, ...) {
    va_list args;
    va_start(args, format);
    vprintf(format, args);
    va_end(args);
    puts("");
}

int readint(char *prompt) {
    int i;
    printf(prompt);
    scanf("%d", &i);
    return i;
}

#define auto
#define short
#define long
#define float
#define double
#define char
#define struct
#define union
#define enum
#define typedef
#define const
#define unsigned
#define signed
#define extern
#define register
#define static
#define volatile
#define switch
#define case
#define for
#define do
#define goto
#define default
#define sizeof
```

可以使用gcc编译器编译以上的源文件

```
$ gcc -o tinyc tinyc.c
$ ./tinyc
```