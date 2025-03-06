source_filename = "Module" 
target triple = "x86_64-w64-windows-gnu"


define ptr @bubble_sort(ptr %seznam, i32 %len_seznam, i32 %jak){
entry:
%jak0 = alloca i32
store i32 %jak, ptr %jak0
%len_seznam0 = alloca i32
store i32 %len_seznam, ptr %len_seznam0
%seznam0 = alloca i32
store i32 %seznam, ptr %seznam0
%len_seznam.0 = load i32, ptr %len_seznam0
%to_max0 = alloca i32
store i32 %len_seznam.0, ptr %to_max0
}

@newline__ = private constant [2 x i8] c"\0A\00"
@num_str__ = private constant [4 x i8] c"%d\0A\00"

define i32 @main() {
entry:
ret i32 0
}

declare i32 @__mingw_printf(ptr noundef, ...)
