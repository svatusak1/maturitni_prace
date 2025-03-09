source_filename = "Module" 
target triple = "x86_64-w64-windows-gnu"

@newline__ = private constant [2 x i8] c"\0A\00"
@num_str__ = private constant [4 x i8] c"%d\0A\00"

define [100 x i32] @bubble_sort([100 x i32] %seznam, i32 %len_seznam){
entry:
%seznam0 = alloca [100 x i32]
store [100 x i32] %seznam, ptr %seznam0
%len_seznam0 = alloca i32
store i32 %len_seznam, ptr %len_seznam0
%len_seznam.0 = load i32, ptr %len_seznam0
%to_max0 = alloca i32
store i32 %len_seznam.0, ptr %to_max0
br label %entry_loop1

entry_loop1:
%len_seznam.1 = load i32, ptr %len_seznam0
%t0 = sub i32 %len_seznam.1, 1
%k0 = alloca i32
store i32 0, ptr %k0
%loop_var_comp1__ = load i32, ptr %k0
%max1 = add i32 0, %t0
%condition_for1 = icmp sgt i32 %max1, %loop_var_comp1__
br label %loop_start1

loop_start1:
%i.check1 = load i32, ptr %k0
br i1 %condition_for1, label %sgt11__, label %slt11__

sgt11__:
%done_sgt1 = icmp sgt i32 %i.check1, %max1
br i1 %done_sgt1, label %continue_loop1, label %loop1
slt11__:
%done_slt1 = icmp slt i32 %i.check1, %max1
br i1 %done_slt1, label %continue_loop1, label %loop1

loop1:
br label %entry_loop2

entry_loop2:
%to_max.0 = load i32, ptr %to_max0
%t1 = sub i32 %to_max.0, 2
%i0 = alloca i32
store i32 0, ptr %i0
%loop_var_comp2__ = load i32, ptr %i0
%max2 = add i32 0, %t1
%condition_for2 = icmp sgt i32 %max2, %loop_var_comp2__
br label %loop_start2

loop_start2:
%i.check2 = load i32, ptr %i0
br i1 %condition_for2, label %sgt12__, label %slt12__

sgt12__:
%done_sgt2 = icmp sgt i32 %i.check2, %max2
br i1 %done_sgt2, label %continue_loop2, label %loop2
slt12__:
%done_slt2 = icmp slt i32 %i.check2, %max2
br i1 %done_slt2, label %continue_loop2, label %loop2

loop2:
%i.0 = load i32, ptr %i0
%idx_seznam_.0 = getelementptr [100 x i32], ptr %seznam0, i32 0, i32 %i.0
%t2 = load i32, ptr %idx_seznam_.0
%i.1 = load i32, ptr %i0
%t3 = add i32 %i.1, 1
%idx_seznam_.1 = getelementptr [100 x i32], ptr %seznam0, i32 0, i32 %t3
%t4 = load i32, ptr %idx_seznam_.1
%condition_if0 = icmp sgt i32 %t2, %t4
br i1 %condition_if0, label %if0, label %continue_if0
if0:
%i.2 = load i32, ptr %i0
%idx_seznam_.2 = getelementptr [100 x i32], ptr %seznam0, i32 0, i32 %i.2
%t5 = load i32, ptr %idx_seznam_.2
%temp0 = alloca i32
store i32 %t5, ptr %temp0
%i.3 = load i32, ptr %i0
%idx_seznam_.3 = getelementptr [100 x i32], ptr %seznam0, i32 0, i32 %i.3
%i.4 = load i32, ptr %i0
%t6 = add i32 %i.4, 1
%idx_seznam_.4 = getelementptr [100 x i32], ptr %seznam0, i32 0, i32 %t6
%t7 = load i32, ptr %idx_seznam_.4
store i32 %t7, ptr %idx_seznam_.3
%i.5 = load i32, ptr %i0
%t8 = add i32 %i.5, 1
%idx_seznam_.5 = getelementptr [100 x i32], ptr %seznam0, i32 0, i32 %t8
%temp.0 = load i32, ptr %temp0
store i32 %temp.0, ptr %idx_seznam_.5
br label %continue_if0
continue_if0:


%loop_var2__ = load i32, ptr %i0
br i1 %condition_for2, label %sgt22__, label %slt22__

sgt22__:
%new_loop_var_sgt2__ = add i32 1, %loop_var2__
store i32 %new_loop_var_sgt2__, ptr %i0
br label %loop_start2
slt22__:
%new_loop_var_slt2__ = add i32 -1, %loop_var2__
store i32 %new_loop_var_slt2__, ptr %i0
br label %loop_start2

continue_loop2:

%to_max.1 = load i32, ptr %to_max0
%t9 = sub i32 %to_max.1, 1
store i32 %t9, ptr %to_max0

%loop_var1__ = load i32, ptr %k0
br i1 %condition_for1, label %sgt21__, label %slt21__

sgt21__:
%new_loop_var_sgt1__ = add i32 1, %loop_var1__
store i32 %new_loop_var_sgt1__, ptr %k0
br label %loop_start1
slt21__:
%new_loop_var_slt1__ = add i32 -1, %loop_var1__
store i32 %new_loop_var_slt1__, ptr %k0
br label %loop_start1

continue_loop1:

%seznam.6 = load [100 x i32], ptr %seznam0
ret [100 x i32] %seznam.6
}


define i32 @main() {
entry:
%mysi0 = alloca [100 x i32]
br label %entry_loop3

entry_loop3:
%p0 = alloca i32
store i32 100, ptr %p0
%loop_var_comp3__ = load i32, ptr %p0
%max3 = add i32 0, 1
%condition_for3 = icmp sgt i32 %max3, %loop_var_comp3__
br label %loop_start3

loop_start3:
%i.check3 = load i32, ptr %p0
br i1 %condition_for3, label %sgt13__, label %slt13__

sgt13__:
%done_sgt3 = icmp sgt i32 %i.check3, %max3
br i1 %done_sgt3, label %continue_loop3, label %loop3
slt13__:
%done_slt3 = icmp slt i32 %i.check3, %max3
br i1 %done_slt3, label %continue_loop3, label %loop3

loop3:
%p.0 = load i32, ptr %p0
%t10 = sub i32 100, %p.0
%idx_mysi_.0 = getelementptr [100 x i32], ptr %mysi0, i32 0, i32 %t10
%p.1 = load i32, ptr %p0
store i32 %p.1, ptr %idx_mysi_.0

%loop_var3__ = load i32, ptr %p0
br i1 %condition_for3, label %sgt23__, label %slt23__

sgt23__:
%new_loop_var_sgt3__ = add i32 1, %loop_var3__
store i32 %new_loop_var_sgt3__, ptr %p0
br label %loop_start3
slt23__:
%new_loop_var_slt3__ = add i32 -1, %loop_var3__
store i32 %new_loop_var_slt3__, ptr %p0
br label %loop_start3

continue_loop3:

br label %entry_loop4

entry_loop4:
%q0 = alloca i32
store i32 0, ptr %q0
%loop_var_comp4__ = load i32, ptr %q0
%max4 = add i32 0, 99
%condition_for4 = icmp sgt i32 %max4, %loop_var_comp4__
br label %loop_start4

loop_start4:
%i.check4 = load i32, ptr %q0
br i1 %condition_for4, label %sgt14__, label %slt14__

sgt14__:
%done_sgt4 = icmp sgt i32 %i.check4, %max4
br i1 %done_sgt4, label %continue_loop4, label %loop4
slt14__:
%done_slt4 = icmp slt i32 %i.check4, %max4
br i1 %done_slt4, label %continue_loop4, label %loop4

loop4:
%q.0 = load i32, ptr %q0
%idx_mysi_.1 = getelementptr [100 x i32], ptr %mysi0, i32 0, i32 %q.0
%t11 = load i32, ptr %idx_mysi_.1
%t12 = call i32 @__mingw_printf(ptr @num_str__, i32 %t11)


%loop_var4__ = load i32, ptr %q0
br i1 %condition_for4, label %sgt24__, label %slt24__

sgt24__:
%new_loop_var_sgt4__ = add i32 1, %loop_var4__
store i32 %new_loop_var_sgt4__, ptr %q0
br label %loop_start4
slt24__:
%new_loop_var_slt4__ = add i32 -1, %loop_var4__
store i32 %new_loop_var_slt4__, ptr %q0
br label %loop_start4

continue_loop4:

%mysi.2 = load [100 x i32], ptr %mysi0
%t13 = call [100 x i32] @bubble_sort([100 x i32] %mysi.2,i32 100)
store [100 x i32] %t13, ptr %mysi0
br label %entry_loop5

entry_loop5:
%t0 = alloca i32
store i32 0, ptr %t0
%loop_var_comp5__ = load i32, ptr %t0
%max5 = add i32 0, 99
%condition_for5 = icmp sgt i32 %max5, %loop_var_comp5__
br label %loop_start5

loop_start5:
%i.check5 = load i32, ptr %t0
br i1 %condition_for5, label %sgt15__, label %slt15__

sgt15__:
%done_sgt5 = icmp sgt i32 %i.check5, %max5
br i1 %done_sgt5, label %continue_loop5, label %loop5
slt15__:
%done_slt5 = icmp slt i32 %i.check5, %max5
br i1 %done_slt5, label %continue_loop5, label %loop5

loop5:
%t.0 = load i32, ptr %t0
%idx_mysi_.3 = getelementptr [100 x i32], ptr %mysi0, i32 0, i32 %t.0
%t14 = load i32, ptr %idx_mysi_.3
%t15 = call i32 @__mingw_printf(ptr @num_str__, i32 %t14)


%loop_var5__ = load i32, ptr %t0
br i1 %condition_for5, label %sgt25__, label %slt25__

sgt25__:
%new_loop_var_sgt5__ = add i32 1, %loop_var5__
store i32 %new_loop_var_sgt5__, ptr %t0
br label %loop_start5
slt25__:
%new_loop_var_slt5__ = add i32 -1, %loop_var5__
store i32 %new_loop_var_slt5__, ptr %t0
br label %loop_start5

continue_loop5:

ret i32 0
}

declare i32 @__mingw_printf(ptr noundef, ...)
