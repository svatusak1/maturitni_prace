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

@1 = private constant [3 x i8] c"9\0A\00"
@newline__ = private constant [2 x i8] c"\0A\00"
@num_str__ = private constant [4 x i8] c"%d\0A\00"

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
%t5 = load i32, ptr %x0
%t6 = call i32 @__mingw_printf(ptr @num_str__, i32 %t5)

%t7 = call i32 @__mingw_printf(ptr @1)

%t8 = call i32 @__mingw_printf(ptr @zvire)
call i32 @__mingw_printf(ptr @newline__)


br label %entry_loop0
entry_loop0:
%loop_var0 = alloca i32
store i32 0, ptr %loop_var0
%max = add i32 0, 10
br label %loop_start0
loop_start0:
%i.check = load i32, ptr %loop_var0
%done0 = icmp sgt i32 %i.check, %max
br i1 %done0, label %continue_loop0, label %loop0
loop0:

%c0 = load i32, ptr %loop_var0
%condition0 = icmp sgt i32 %c0, 5
br i1 %condition0, label %if0, label %continue_if0
if0:
%t9 = call i32 @add(i32 2, i32 3)
%t10 = call i32 @add(i32 %t9, i32 8)
%res0 = alloca i32
store i32 %t10, ptr %res0
%t11 = load i32, ptr %res0
%t12 = call i32 @__mingw_printf(ptr @num_str__, i32 %t11)

br label %continue_if0
continue_if0:

%loop_var__ = load i32, ptr %loop_var0
%new_loop_Var__ = add i32 1, %loop_var__
store i32 %new_loop_Var__, ptr %loop_var0

br label %loop_start0
continue_loop0:

ret i32 0
}

declare i32 @__mingw_printf(ptr noundef, ...)
