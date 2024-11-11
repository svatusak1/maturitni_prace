exit loops*Rogalo* a simple programming language compiled with LVMM 

Author: Jakub Svatuška
Supervisor: Pavel Kryl

==============================================================================
Introduction

Rogalo is a compiled procedural mostly structural language built for 
educational purposes.

==============================================================================
SYNTAX

One-line comments are marked with ## at the beginning of the line:

## this is a comment

Multi-line comments are marked as follows ##[[ .... ]]##:

##[[

this 
is 
a multi-line 
commment

##]]

------------------------------------------------------------------------------
VARIBLES

type name = value

int counter = 10

they are by default signed

following types are available:

    byte - 8 bits -> −127, +127
    int - 16 bits -> −32767, +32767
    string - space allocated according to the length - immutable
    list - needs to be initialized with specific size and type of all the 
        elementl; they are of fixed size -> adding an ellement via plus operator
        creates a new list 
        they are index from 0

            list str[4] animals = ["bear", "cat", "frog", "elephant"]
            list byte[2] coordinates = [4, 8]
            list list[5] int[4] cars = []
        list are indexed as follows:
            str froggy = animals[2] 
        removal of elements from end with the -- operator:
            animals --
        remove element on index:
            animals --[3]
    0 is false and everything else is evaluated as true

    capacity() is used to determine the length of a list
    len() is used to get number of elements in list and the length of a string

------------------------------------------------------------------------------
OPERATORS

following arithmetic operators are available:
    
    + addition (also means addition for lists)
    - subtraction
    * multiplication
    : division

comparing operators available:

    < less then
    > greater then
    <= less then or equal
    >= greater then or equal
    == equals
    != does not equal

------------------------------------------------------------------------------
FLOW CONTROL

blocks are denoted with curly braces

if (1 < counter)
{
    animals = animals + "bee"
}


loops are range like:

loop (variable_to_loop_on; range_min -> range_max(exclusiv); optional_step)
{
}

## default step is +1

## loops 5 times with i = 0, then 1, then 2, 3, 4
loop (byte i; 0 -> 5) 
{
    counter = counter + i
}

loop (int i; -2 -> 7)
{
    counter = counter + i
}

loop (int i; 10 -> 0; -1)
{
    counter = counter + i
}


list and strings return a syntax error in boolean statements evaluation

------------------------------------------------------------------------------
FUNCTIONS

function calls are done with brackets with arguments:

add(3, 5)

foo(1, 4, "kozel")

function declarations are done with the func keyword 
followed by its return type, name and arguments

return value is returned by return keyword

func char foo(char a, str b, char c)
{
    char res = a + c
    return res
}
