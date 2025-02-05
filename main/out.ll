source_filename = "Module" 
target triple = "x86_64-w64-mingw32"

@ubrousek = internal constant [4 x i8] c"city"

define i32 @print(i32 %o){
entry:
%l0 = alloca i8
store i8 10, ptr %l0
%l = load i8, ptr %l0
%t0 = add i8 %l, 5
store i8 %t0, ptr %l0

%c10 = load i32, ptr %l0
 %condition0 = icmp sgt i32 %c10, 20
br i1 %condition0, label %if0, label %continue0
if0:
%k0 = alloca i32
store i32 34, ptr %k0
br i1 1, label %continue0, label %entry
continue0:
ret i32 %o
}

@hola = internal constant [5 x i8] c"kokos"
@kola = internal constant [5 x i8] c"kokos"

define i32 @main() {
entry:
%t1 = mul i32 9, 9
%i0 = alloca i32
store i32 %t1, ptr %i0

%c11 = load i32, ptr %i0
 %condition1 = icmp slt i32 %c11, 10
br i1 %condition1, label %if1, label %continue1
if1:
br i1 1, label %continue1, label %entry
continue1:

%c12 = load i32, ptr %i0
 %condition2 = icmp slt i32 %c12, 10
br i1 %condition2, label %if2, label %continue2
if2:
br i1 1, label %continue2, label %entry
continue2:
%ahoj0 = alloca i32
store i32 10, ptr %ahoj0
ret i32 0
}
