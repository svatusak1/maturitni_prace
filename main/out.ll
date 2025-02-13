source_filename = "Module" 
target triple = "x86_64-w64-mingw32"

define i32 @add(ptr %a0, ptr %b0){
entry:
%a = load i32, ptr %a0
%b = load i32, ptr %b0
%t0 = add i32 %a, %b
%t1 = mul i32 %t0, 4
%t2 = udiv i32 %t1, 5
%res0 = alloca i32
store i32 %t2, ptr %res0
%res = load i32, ptr %res0
ret i32 %res
}


define i32 @simon_says(ptr %r0, ptr %t0){
entry:
%r = load i32, ptr %r0
ret i32 %r
}


define i32 @adition_function(ptr %dobrman0){
entry:
%dobrman = load i32, ptr %dobrman0
%adolf = load i32, ptr %adolf0
%t3 = add i32 %dobrman, %adolf
%alk0 = alloca i32
store i32 %t3, ptr %alk0
%t4 = add i32 3, 44
%pozdrav = alloca [9 x i8]
store [9 x i8] c"no nazdar", ptr %pozdrav
%pozdrav = load [9 x i8], ptr %pozdrav0
var_type %pozdrav)
%pozdrav = load [9 x i8], ptr %pozdrav0
ret i32 %pozdrav
%zdravim0 = alloca i32
store i32 0, ptr %zdravim0
%balo0 = alloca i8
store i8 10, ptr %balo0
%zdravim = load i32, ptr %zdravim0
var_type %zdravim%balo = load i8, ptr %balo0
, var_type %balocall i32 @simon_says()
var_type 1, var_type 2, var_type 3call i32 @add()
%kokos0 = alloca i8
store i8 kokos, ptr %kokos0

br label %entry_loop0
entry_loop0:
%i0 = alloca i8
store i8 0, ptr %i0
%max = add i32 0, 0
br label %loop_start0
loop_start0:
%i.check = load i8, ptr %i0
%done0 = icmp eq i32 %i.check, %max
br i1 %done0, label %continue_loop0, label %loop0
loop0:
%i = load i8, ptr %i0
%ahoj0 = alloca i32
store i32 %i, ptr %ahoj0
br label %loop_start0
continue_loop0:

br label %entry_loop1
entry_loop1:
%k0 = alloca i8
store i8 0, ptr %k0
%max = add i32 0, 10
br label %loop_start1
loop_start1:
%i.check = load i8, ptr %k0
%done1 = icmp eq i32 %i.check, %max
br i1 %done1, label %continue_loop1, label %loop1
loop1:
%i = load i8, ptr %i0
%t5 = add (null) %i, 1
store (null) %t5, ptr %krakonos0
%k = load i8, ptr %k0
var_type %k)
br label %loop_start1
continue_loop1:

%c10 = load i32, ptr 10
 %condition0 = icmp sgt i32 %c10, 10
br i1 %condition0, label %if0, label %continue_if0
if0:
)
%doh = load (null), ptr %doh0
%total = load (null), ptr %total0
%t6 = mul i32 9, %total
%t7 = add i32 %doh, %t6
store i32 %t7, ptr %ahoj0
br label %continue_if0
continue_if0:

%adolf = load i32, ptr %adolf0
%k = load i8, ptr %k0
%t8 = add i32 %adolf, %k
ret i32 %t8
}


define i32 @main() {
entry:
%ubrousek = alloca [4 x i8]
store [4 x i8] c"city", ptr %ubrousek
%adolf0 = alloca i32
store i32 55, ptr %adolf0
var_type 10, var_type 20%vcelky = load (null), ptr %vcelky0
, var_type %vcelkycall i32 @adition_function()
ret i32 0
}
