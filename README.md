*Rogalo* a simple programming language tokenize with flex, parsed with bison 
and compiled with LVMM

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
        str car = "audi"
    list - needs to be initialized with specific size and type of all the 
        elements; they are of fixed size -> adding an ellement via plus operator
        creates a new list if size is overfilled
        they are index from 0

            list[4] str animals = ["bear", "cat", "frog", "elephant"]
            list[2] byte coordinates = [4, 8]
            list[5] list[4] int cars = []
        list are indexed as follows:
            str froggy = animals[2] 
    0 is false and everything else is evaluated as true

    capacity() is used to determine the length of a list
    len() is used to get number of elements in list and the length of a string

------------------------------------------------------------------------------
OPERATORS

following arithmetic operators are available:
    
    + addition
    - subtraction
    * multiplication
    / division

comparing operators available:

    < less then
    > greater then
    <= less then or equal
    >= greater then or equal
    == equals
    != does not equal

list operators:
    -- list subtraction
        animals --
        ## removes element at the end of the list
        animals --[3]
        ## removes element on index 3
    ++ list addition
        animals ++ "ahoj"
        ## adds "ahoj" to the end of the list
        animals ++[2] "kosa"
        ## inserts "kosa" on the index 2 and moves the rest to the right

------------------------------------------------------------------------------
FLOW CONTROL

blocks are denoted with curly braces

if (1 < counter)
{
    animals ++ "bee"
}


loops are range like:

loop (variable_to_loop_on; range_min -> range_max(exclusiv); optional_step)
{
    ## here happenes something
}

## default step is +1

## loops 5 times with i = 0, then 1, then 2, 3, 4
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


list and strings return a syntax error in boolean statements evaluation

------------------------------------------------------------------------------
FUNCTIONS

function calls are done with brackets with arguments:

add(3, 5)

foo(1, 4, "kozel")

function declarations are done with the func keyword 
followed by its return type, name and arguments

return value is returned by return keyword

func byte addition(byte a, byte b)
{
    return a + b
}

