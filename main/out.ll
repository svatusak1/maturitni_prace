source_filename = "Module" 
target triple = "x86_64-w64-windows-gnu"

@zvire = private constant [11 x i8] c"dinosaurus\00"

define i32 @add(i32 %a, i32 %b){
entry:
%a0 = alloca i32
store i32 %a, ptr %a0
%b0 = alloca i32
store i32 %b, ptr %b0
%a.0 = load i32, ptr %a0
%b.0 = load i32, ptr %b0
%t0 = add i32 %a.0, %b.0
ret i32 %t0
}

@0 = private constant [4 x i8] c"%d\0A\00"
@1 = private constant [3 x i8] c"9\0A\00"
@newline = private constant [2 x i8] c"\0A\00"

define i32 @main() {
entry:
%x0 = alloca i32
store i32 2, ptr %x0
%x.0 = load i32, ptr %x0
%t1 = add i32 %x.0, 4
store i32 %t1, ptr %x0
%t2 = call i32 @add(i32 4, i32 5)
%t3 = call i32 @add(i32 2, i32 2)
%t4 = mul i32 %t2, %t3
store i32 %t4, ptr %x0
%t6 = call i32 @__mingw_printf(ptr @0, i32 %t5)

%t7 = call i32 @__mingw_printf(ptr @1)

%t8 = call i32 @__mingw_printf(ptr @zvire)
call i32 @__mingw_printf(ptr @newline)

ret i32 0
}

declare i32 @__mingw_printf(ptr noundef, ...)
