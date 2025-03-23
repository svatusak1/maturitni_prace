source_filename = "Module" 
target triple = "x86_64-w64-windows-gnu"

@newline__ = private constant [2 x i8] c"\0A\00"
@num_str__ = private constant [4 x i8] c"%d\0A\00"
@zvire = private constant [11 x i8] c"dinosaurus\00"
@0 = private constant [4 x i8] c"-9\0A\00"
@1 = private constant [13 x i8] c"pterodaktyl\0A\00"
@2 = private constant [36 x i8] c"array \22pole\22 with type: [10 x i32]\0A\00"

define i32 @main() {
entry:
%x0 = alloca i32
store i32 10, ptr %x0
%t0 = call i32 @__mingw_printf(ptr @0)

%x.0 = load i32, ptr %x0
%t1 = call i32 @__mingw_printf(ptr @num_str__, i32 %x.0)

%t2 = call i32 @__mingw_printf(ptr @1)

%x.1 = load i32, ptr %x0
%t3 = add i32 %x.1, 10
%t4 = add i32 %t3, 10
%t5 = call i32 @__mingw_printf(ptr @num_str__, i32 %t4)

%pole0 = alloca [10 x i32]
br label %entry_loop1

entry_loop1:
%a0 = alloca i32
store i32 0, ptr %a0
%loop_var_comp1__ = load i32, ptr %a0
%max1 = add i32 0, 9
%condition_for1 = icmp sgt i32 %max1, %loop_var_comp1__
br label %loop_start1

loop_start1:
%i.check1 = load i32, ptr %a0
br i1 %condition_for1, label %sgt11__, label %slt11__

sgt11__:
%done_sgt1 = icmp sgt i32 %i.check1, %max1
br i1 %done_sgt1, label %continue_loop1, label %loop1
slt11__:
%done_slt1 = icmp slt i32 %i.check1, %max1
br i1 %done_slt1, label %continue_loop1, label %loop1

loop1:
%a.0 = load i32, ptr %a0
%idx_pole_.0 = getelementptr [10 x i32], ptr %pole0, i32 0, i32 %a.0
%a.1 = load i32, ptr %a0
store i32 %a.1, ptr %idx_pole_.0

%loop_var1__ = load i32, ptr %a0
br i1 %condition_for1, label %sgt21__, label %slt21__

sgt21__:
%new_loop_var_sgt1__ = add i32 %loop_var1__, 1
store i32 %new_loop_var_sgt1__, ptr %a0
br label %loop_start1
slt21__:
%new_loop_var_slt1__ = sub i32 %loop_var1__, 1
store i32 %new_loop_var_slt1__, ptr %a0
br label %loop_start1

continue_loop1:

%pole.1 = load [10 x i32], ptr %pole0
%t6 = call i32 @__mingw_printf(ptr @2)

br label %entry_loop2

entry_loop2:
%k0 = alloca i32
store i32 0, ptr %k0
%loop_var_comp2__ = load i32, ptr %k0
%max2 = add i32 0, 9
%condition_for2 = icmp sgt i32 %max2, %loop_var_comp2__
br label %loop_start2

loop_start2:
%i.check2 = load i32, ptr %k0
br i1 %condition_for2, label %sgt12__, label %slt12__

sgt12__:
%done_sgt2 = icmp sgt i32 %i.check2, %max2
br i1 %done_sgt2, label %continue_loop2, label %loop2
slt12__:
%done_slt2 = icmp slt i32 %i.check2, %max2
br i1 %done_slt2, label %continue_loop2, label %loop2

loop2:
%k.0 = load i32, ptr %k0
%idx_pole_.2 = getelementptr [10 x i32], ptr %pole0, i32 0, i32 %k.0
%t7 = load i32, ptr %idx_pole_.2
%t8 = call i32 @__mingw_printf(ptr @num_str__, i32 %t7)


%loop_var2__ = load i32, ptr %k0
br i1 %condition_for2, label %sgt22__, label %slt22__

sgt22__:
%new_loop_var_sgt2__ = add i32 %loop_var2__, 1
store i32 %new_loop_var_sgt2__, ptr %k0
br label %loop_start2
slt22__:
%new_loop_var_slt2__ = sub i32 %loop_var2__, 1
store i32 %new_loop_var_slt2__, ptr %k0
br label %loop_start2

continue_loop2:

ret i32 0
}

declare i32 @__mingw_printf(ptr noundef, ...)
