*Rogalo* a simple programming language tokenize with flex, parsed with bison 
and compiled with LVMM

Author: Jakub Svatuška
Supervisor: Pavel Kryl
Github Repository: https://github.com/svatusak1/maturitni_prace

==============================================================================
## Introduction

Rogalo is a compiled procedural mostly structural language built for 
educational purposes.

==============================================================================
## Compile and run

To compile your code run script *compile.bat*
To run your code execute script *run.bat*
your file name needs to be inside the main function in *parser.y* as input-file


==============================================================================
## SYNTAX

One-line comments are marked with ## at the beginning of the line:

##this is a comment

Multi-line comments are marked as follows ##[[.....]]##:

##[[

this 
is 
a multi-line 
commment

##]]

------------------------------------------------------------------------------
## VARIBLES

type name = value

int counter = 10

they are by default signed

following types are available:

    byte - 8 bits -> −127, +127
    int - 16 bits -> −32767, +32767
    string - space allocated according to the length - immutable
        str car = "audi" 

{
    call len() is used to get the length of a string
    call print() is used to print someting
}

global variables can't be acceced in functions (strings can be acceced anywhere)

------------------------------------------------------------------------------
## OPERATORS

following arithmetic operators are available:
    
    + addition
    - subtraction
    * multiplication
    / division
    
    applicable only between variables of the same type

comparing operators available:

    < less then
    > greater then
    <= less then or equal
    >= greater then or equal
    == equals
    != does not equal

    applicable only between variables of the same type
------------------------------------------------------------------------------
## FLOW CONTROL

blocks are denoted with curly braces

if (1 < counter)
{
    animals ++ "bee"
}


loops are range like:

loop (variable_to_loop_on; range_min -> range_max(inclusive); optional_step)
{
    ## here happenes something
}

default step is +1

loops 6 times with i = 0, then 1, then 2, 3, 4, 5
loop (byte i; 0 -> 5) 
{
    counter = counter + i * 10
}

loop (int i; -2 -> 7)
{
    counter = counter + i * i
}

loop (int i; 10 -> 0; -1)
{
    counter = counter + i / 5
}


strings return a syntax error in boolean statements evaluation

------------------------------------------------------------------------------
## FUNCTIONS

function calls are done with brackets with arguments:

int a = add(3, 5)

byte bfoo(1, 4, "kozel")

function declarations are done with the func keyword 
followed by its return type, name and arguments

return value is returned by return keyword

func byte addition(byte a, byte b)
{
    return a + b
}

