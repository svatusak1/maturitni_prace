source_filename = "Module" 
target triple = "x86_64-w64-mingw32"

define i32 @print(ptr %o0){
entry:
%o.0 = load i8, ptr %o0
%l0 = alloca i8
store i8 %o.0, ptr %l0
%l.0 = load i8, ptr %l0
%t0 = add i8 %l.0, 5
store i8 %t0, ptr %l0

%c0 = load i32, ptr %l0
%condition0 = icmp sgt i32 %c0, 20
br i1 %condition0, label %if0, label %continue_if0
if0:
%p0 = alloca i32
store i32 34, ptr %p0
br label %continue_if0
continue_if0:

%t1 = call i32 @print(i32 12)
ret i32 %t1
}


define i32 @main() {
entry:
%ubrousek = alloca [4 x i8]
store [4 x i8] c"city", ptr %ubrousek
%t2 = mul i32 9, 9
%i0 = alloca i32
store i32 %t2, ptr %i0

%c1 = load i32, ptr %i0
%condition1 = icmp slt i32 %c1, 10
br i1 %condition1, label %if1, label %continue_if1
if1:
%hola = alloca [5 x i8]
store [5 x i8] c"kokos", ptr %hola
br label %continue_if1
continue_if1:


%c2 = load i32, ptr %i0
%condition2 = icmp slt i32 %c2, 10
br i1 %condition2, label %if2, label %continue_if2
if2:
%kola = alloca [5 x i8]
store [5 x i8] c"kokos", ptr %kola
br label %continue_if2
continue_if2:

%ahoj0 = alloca i32
store i32 10, ptr %ahoj0
%a0 = alloca i32
store i32 0, ptr %a0
%t3 = call i32 @print(i32 45)

br label %entry_loop0
entry_loop0:
%k0 = alloca i32
store i32 0, ptr %k0
%max = add i32 0, 5
br label %loop_start0
loop_start0:
%i.check = load i32, ptr %k0
%done0 = icmp eq i32 %i.check, %max
br i1 %done0, label %continue_loop0, label %loop0
loop0:
%a.0 = load i32, ptr %a0
%k.0 = load i32, ptr %k0
%t4 = add i32 %a.0, %k.0
store i32 %t4, ptr %a0
br label %loop_start0
continue_loop0:
%t5 = call i32 @print(i32 9)
%valeim0 = alloca i32
store i32 %t5, ptr %valeim0
ret i32 0
}
