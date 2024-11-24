# ICS3203-CAT2-Assembly-Tatu-Tijani-150397


## Task 1: Control Flow and Conditional Logic

### Task Description

The goal of Task 1 is to write an assembly program that:
- Prompts the user for an input number.
- Classifies the number as **POSITIVE**, **NEGATIVE**, or **ZERO** using both conditional and unconditional jumps.

### Program Logic

1. **User Input**: The program prompts the user to enter a number. It then reads this number as a string.
2. **Classification**: 
   - The program checks if the number is **positive**, **negative**, or **zero**.
   - It uses **conditional jumps** (`jg`, `jl`) to check the number's value and an **unconditional jump** (`jmp`) to exit after displaying the result.


### Conditional and Unconditional Jumps

The jumps control the program flow based on the user’s input. Below are the key jump instructions used, with explanations why I used them:


#### 1. **`jne` (Jump if Not Equal)** - **Conditional Jump**

**Code snippet**:  
```asm
jne convert_digits
```
The jne instruction is used right after checking if the user input starts with a negative sign ('-'). If the first character is not a '-', the program will jump to the convert_digits section and begin processing the number without considering it negative. If the character is '-', the program will skip this jump and proceed to mark the number as negative.
Why this jump is used:

<mark>Purpose: </mark>To determine whether the input number is negative. It ensures that if there's no negative sign, the number will be processed as a positive value, bypassing the negative sign processing.


#### 2. **`je` (Jump if Equal)** - **Conditional Jump**

**Code snippet**:  
```asm
je classification
```
```asm
je is_zero
```
<u><b>Explanation:</b></u>
The first je checks if the current character in the input is a newline (0xA), which marks the end of the user input. If a newline is detected, the program jumps to the classification section, where it will classify the number based on the value it has accumulated.

The second je is used in the classification section to check if the value in rax is zero. If the value is zero, the program will jump to the is_zero section, which outputs "ZERO".

<mark>Why this jump is used:</mark>

Purpose: The first je ensures the program knows when the input string ends, so it can proceed with classification. The second je ensures that if the number is zero, it goes directly to the section that outputs "ZERO".


#### 3. **`jmp` (Unconditional Jump)** - **Conditional Jump**

**Code snippet**:  
```asm
jmp end_program
```
<u><b>Explanation:</b></u>
After printing the corresponding message ("POSITIVE", "NEGATIVE", or "ZERO"), the program unconditionally jumps to the end_program section. This jump prevents the program from executing any additional code in other branches, ensuring that only one output is printed.

<mark>Why this jump is used:</mark>

Purpose: The unconditional jump is used to skip over the other sections once a result has been displayed. It ensures the program terminates properly without printing multiple messages.