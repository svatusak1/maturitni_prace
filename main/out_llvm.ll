source_filename = "Module" 
target triple = "x86_64-w64-mingw32"

@ubrousek = internal constant [4 x i8] c"city"

define i32 @print(i32 %o){
entry:
%l = alloca i32
store i32 10, ptr %l

%c10 = load i32, ptr %l
 %condition0 = icmp sgt i32 %c10, 20
br i1 %condition0, label %if0, label %continue0
if0:
%k = alloca i32
store i32 34, ptr %k
br i1 1, label %continue0, label %entry
continue0:
ret i32 %o
}

@hola = internal constant [5 x i8] c"kokos"
@kola = internal constant [5 x i8] c"kokos"

define i32 @main() {
entry:
%t0 = mul i32 9, 9
%i = alloca i32
store i32 %t0, ptr %i

%c11 = load i32, ptr %i
 %condition1 = icmp slt i32 %c11, 10
br i1 %condition1, label %if1, label %continue1
if1:
br i1 1, label %continue1, label %entry
continue1:

%c12 = load i32, ptr %i
 %condition2 = icmp slt i32 %c12, 10
br i1 %condition2, label %if2, label %continue2
if2:
br i1 1, label %continue2, label %entry
continue2:
%ahoj = alloca i32
store i32 10, ptr %ahoj
ret i32 0
}