TOKEN-TYPE          TOKEN-VALUE
-------------------------------------------------
T_Int               int
T_Identifier        main
(                   (
)                   )
{                   {
T_Int               int
T_Identifier        n
;                   ;
T_Identifier        n
=                   =
T_IntConstant       1
;                   ;
T_Print             print
(                   (
T_StringConstant    "The first 10 number of the fibonacci sequence:"
)                   )
;                   ;
T_While             while
(                   (
T_Identifier        n
T_Le                <=
T_IntConstant       10
)                   )
{                   {
T_Print             print
(                   (
T_StringConstant    "fib(%d)=%d"
,                   ,
T_Identifier        n
,                   ,
T_Identifier        fib
(                   (
T_Identifier        n
)                   )
)                   )
;                   ;
T_Identifier        n
=                   =
T_Identifier        n
+                   +
T_IntConstant       1
;                   ;
}                   }
T_Return            return
T_IntConstant       0
;                   ;
}                   }
T_Int               int
T_Identifier        fib
(                   (
T_Int               int
T_Identifier        n
)                   )
{                   {
T_If                if
(                   (
T_Identifier        n
T_Le                <=
T_IntConstant       2
)                   )
{                   {
T_Return            return
T_IntConstant       1
;                   ;
}                   }
T_Return            return
T_Identifier        fib
(                   (
T_Identifier        n
-                   -
T_IntConstant       1
)                   )
+                   +
T_Identifier        fib
(                   (
T_Identifier        n
-                   -
T_IntConstant       2
)                   )
;                   ;
}                   }