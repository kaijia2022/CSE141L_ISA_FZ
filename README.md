## CSE141L_ISA_FZ

RISC 9 bit special purpose ISA for CSE 141L


## Features
 - 9-bit intruction length

 - 8-bit data path

 - Supports relative jumpss

 - Supports function calls

 - Five stage machine

 - 4 cycles per instruction

 - Assembler(vs2022)

 - contains assembly and machine codes for the following programs (passes all 3 testbenches 100%):

    - Closest and farthest Hamming pairs -- Write a program to find the least and greatest Hamming
        distances among all pairs of values in an array of 32 two-byte half-words. Assume all values are
        signed 16-bit (“half-word”) integers. The array of integers runs from data memory location 0 to 63.
        Even-numbered addresses are MSBs, following odd addresses are LSBs, e.g. a concatenation of
        addresses 0 and 1 forms a 16-bit two’s complement half-word. Write the minimum distance in
        location 64 and the maximum in 65.

    - Closest and farthest arithmetic pairs -- Write a program to find the absolute values of the least and
        greatest arithmetic difference among all pairs of incoming values from Program 2. Assume again that
        all values are two’s complement (“signed”) 16-bit integers. The array of integers starts at location 0.
        Write the absolute value of the minimum difference in locations 66-67 and the maximum in 68-69.
        Format: mem[66] = MSB of smallest absolute value difference among pairs; mem[67] = LSB.
        mem[68] = MSB of largest absolute value difference among pairs, mem[69] = LSB.

    - Double-precision (16x16 bits = 32-bit product) two’s complement multiplication using shift-
        and-add (a direct c=a*b – multiplication operation is not allowed, although this can be a
        programming macro that breaks down into a subroutine).
        Operands are stored in memory locations 0-3, 4-7, ..., 60-63, where the format is:
        mem[4N+0]: most significant (signed) byte of operand AN
        mem[4N+1]: least significant (unsigned) byte of operand AN
        mem[4N+2]: most significant (signed) byte of operand BN
        mem[4N+3]: least significant (unsigned) byte of operand BN
        All of these independent variable values will be injected directly into your data memory to start
        the program.
        You will then return your results to data_mem 64-127, where the format is:
        mem[64+4N+0]: most significant (signed) byte of product of AN * BN
        mem[64+4N+1]: second (unsigned) byte of same product
        mem[64+4N+2]: thrid (unsigned) byte

## ISA Design

    See /images/ISA.PNG.

## Top_level view (Quartus)

    See /images/top_level.PNG

## Instruction format

![Instruction Format](/images/Instruction_Format.PNG)

## Operations

![op1](/images/opcode1.PNG)
![op2](/images/opcode2.PNG)
![op3](/images/opcode3.PNG)
![op4](/images/opcode4.PNG)
![op5](/images/opcode5.PNG)
![op6](/images/opcode6.PNG)


## Known Issues

- Assembler is case sensitive

- `LEA` currently Hardcodes the program entrypoint address to be 0. 

- `COMP` operation is not taking 2's comp, but flipping the bits.

- Multiplication uses boot's algorithm but edge cases are hardcoded based on testfiles
    - TODO: Handle overflow edge cases

- ISA sketch is slightly out of date, stages are now controlled by a counter in top_level
    - TODO: Update ISA sketch image

## Build

 - ISA: Create a new project in Modelsim 2020.1, add all testfiles, machinecodes, jump instructions and offsets to the project directory in modelsim.

 - Assembler: VS2022.
 
## Contributors
- [Bran Zhang](https://github.com/kaijia2022)

- [Henry Feng](https://github.com/Henryfzh)
