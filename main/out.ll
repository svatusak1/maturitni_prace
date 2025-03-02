source_filename = "Module" 
target triple = "x86_64-w64-windows-gnu"


define i32 @add(i32 %a, i32 %b){
entry:
%a0 = alloca i32
store i32 %a, ptr %a0
%b0 = alloca i32
store i32 %b, ptr %b0
%a.0 = load i32, ptr %a0
%b.0 = load i32, ptr %b0
%t0 = add i32 %a.0, %b.0
%t1 = mul i32 %t0, 4
%t2 = udiv i32 %t1, 5
%res0 = alloca i32
store i32 %t2, ptr %res0
%res.0 = load i32, ptr %res0
ret i32 %res.0
}

@ubrousek = private constant [5 x i8] c"city\00"

define i32 @simon_says(i32 %r, i32 %t){
entry:
%r0 = alloca i32
store i32 %r, ptr %r0
%t0 = alloca i32
store i32 %t, ptr %t0
%r.0 = load i32, ptr %r0
ret i32 %r.0
}


define i32 @adition_function(i32 %dobrman){
entry:
%dobrman0 = alloca i32
store i32 %dobrman, ptr %dobrman0
%dobrman.0 = load i32, ptr %dobrman0
%t3 = add i32 %dobrman.0, 4
%alk0 = alloca i32
store i32 %t3, ptr %alk0
%alk.0 = load i32, ptr %alk0
%t4 = load i32, ptr %alk0
%t5 = call i32 @__mingw_printf(ptr @num_str__, i32 %t4)

%t6 = call i32 @__mingw_printf(ptr @ubrousek)
call i32 @__mingw_printf(ptr @newline__)

%zdravim0 = alloca i32
store i32 0, ptr %zdravim0
%balo0 = alloca i8
store i8 10, ptr %balo0

br label %entry_loop1
entry_loop1:
%alk.1 = load i32, ptr %alk0
%x0 = alloca i32
store i32 10, ptr %x0
%loop_var_comp__ = load i32, ptr %x0
%max1 = add i32 0, %alk.1
%condition = icmp sgt i32 %max1, %loop_var_comp__
br label %loop_start1
loop_start1:
%i.check1 = load i32, ptr %x0
%range_start1__ = add i32 0, 10
%range_end1__ = load i32, ptr %alk0
%done1 = icmp slt i32 %i.check1, %max1
br i1 %done1, label %continue_loop1, label %loop1
loop1:
%t7 = call i32 @__mingw_printf(ptr @1)


%loop_var1__ = load i32, ptr %x0
%new_loop_var1__ = add i32 -1, %loop_var1__
store i32 %new_loop_var1__, ptr %x0

br label %loop_start1
continue_loop1:

%zdravim.0 = load i32, ptr %zdravim0
%alk.2 = load i32, ptr %alk0
%t8 = add i32 %zdravim.0, %alk.2
ret i32 %t8
}

@pozdrav = private constant [10 x i8] c"no nazdar\00"
@1 = private constant [4 x i8] c"10\0A\00"
@newline__ = private constant [2 x i8] c"\0A\00"
@num_str__ = private constant [4 x i8] c"%d\0A\00"

define i32 @main() {
entry:
%adolf0 = alloca i32
store i32 55, ptr %adolf0
%t9 = call i32 @adition_function(i32 10)
%kamo_ale0 = alloca i32
store i32 %t9, ptr %kamo_ale0
ret i32 0
}

declare i32 @__mingw_printf(ptr noundef, ...)
