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


define i32 @multiply(i32 %c, i32 %d){
entry:
%c0 = alloca i32
store i32 %c, ptr %c0
%d0 = alloca i32
store i32 %d, ptr %d0
%c.0 = load i32, ptr %c0
%d.0 = load i32, ptr %d0
%t1 = mul i32 %c.0, %d.0
ret i32 %t1
}

@newline__ = private constant [2 x i8] c"\0A\00"
@num_str__ = private constant [4 x i8] c"%d\0A\00"

define i32 @main() {
entry:
%x0 = alloca i32
store i32 2, ptr %x0
%x.0 = load i32, ptr %x0
%t2 = add i32 %x.0, 4
store i32 %t2, ptr %x0

br label %entry_loop1
entry_loop1:
%x.1 = load i32, ptr %x0
%loop_var0 = alloca i32
store i32 %x.1, ptr %loop_var0
%loop_var_comp__ = load i32, ptr %loop_var0
%max1 = add i32 -1, 0
%condition_for1 = icmp sgt i32 %max1, %loop_var_comp__
br label %loop_start1
loop_start1:
%i.check1 = load i32, ptr %loop_var0
br i1 %condition_for1, label %sgt11__, label %slt11__
sgt11__:
%done_sgt1 = icmp sgt i32 %i.check1, %max1
br i1 %done_sgt1, label %continue_loop1, label %loop1
slt11__:
%done_slt1 = icmp slt i32 %i.check1, %max1
br i1 %done_slt1, label %continue_loop1, label %loop1
loop1:
%loop_var.0 = load i32, ptr %loop_var0
%t3 = load i32, ptr %loop_var0
%t4 = call i32 @__mingw_printf(ptr @num_str__, i32 %t3)


%loop_var1__ = load i32, ptr %loop_var0
br i1 %condition_for1, label %sgt21__, label %slt21__
sgt21__:
%new_loop_var_sgt1__ = add i32 1, %loop_var1__
store i32 %new_loop_var_sgt1__, ptr %loop_var0

br label %loop_start1
slt21__:
%new_loop_var_slt1__ = add i32 -1, %loop_var1__
store i32 %new_loop_var_slt1__, ptr %loop_var0

br label %loop_start1
continue_loop1:

ret i32 0
}

declare i32 @__mingw_printf(ptr noundef, ...)
