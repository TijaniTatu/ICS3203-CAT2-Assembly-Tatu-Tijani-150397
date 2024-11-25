# ICS3203-CAT2-Assembly-Tatu-Tijani-150397
![Static Badge](https://img.shields.io/badge/AssemblyLanguage-red?style=flat&logo=assemblyscript&logoColor=black)




### How to Compile and Run
### Prerequisites
1. Ensure you have the **NASM assembler** installed:
   ```bash
   sudo apt install nasm
   ```
   or 
   ```bash
   sudo apt-get install nasm libc6-dev-i386
   ```
2. Install the GCC multiarch libraries to enable 32-bit code execution
   ```bash
   sudo apt install gcc-multilib
   ```


### Steps to Compile and Run
1. **Assemble the code**:
    ```bash
    nasm -f elf32 <filename>.asm -o <filename>.o
    ```

2. **Link the object file**:
    ```bash
    ld -m elf_i386 -o <output filename> <filename>.o
    ```

3. **Run the program**:
    ```bash
    ./<output filename>
    ```


---
## Task 1: Control Flow and Conditional Logic

### <span style="color: blue;">Brief Overview</span>

The goal of Task 1 is to write an assembly program that:
- Prompts the user for an input number.
- Classifies the number as **POSITIVE**, **NEGATIVE**, or **ZERO** using both conditional and unconditional jumps.

   #### Program Logic

   1. **User Input**: The program prompts the user to enter a number. It then reads this number as a string.
   2. **Classification**: 
      - The program checks if the number is **positive**, **negative**, or **zero**.
      - It uses **conditional jumps** (`jne`, `je`) to check the number's value and an **unconditional jump** (`jmp`) to exit after displaying the result.


### <span style="color: green;">Conditional and Unconditional Jumps</span>

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

<mark>Purpose:</mark>The first je ensures the program knows when the input string ends, so it can proceed with classification. The second je ensures that if the number is zero, it goes directly to the section that outputs "ZERO".


#### 3. **`jmp` (Unconditional Jump)** - **Conditional Jump**

**Code snippet**:  
```asm
jmp end_program
```
<u><b>Explanation:</b></u>
After printing the corresponding message ("POSITIVE", "NEGATIVE", or "ZERO"), the program unconditionally jumps to the end_program section. This jump prevents the program from executing any additional code in other branches, ensuring that only one output is printed.

<mark>Purpose:</mark> The unconditional jump is used to skip over the other sections once a result has been displayed. It ensures the program terminates properly without printing multiple messages.

# Task 2: Array Manipulation with Looping and Reversal

### <span style="color: blue;">Brief Overview</span>

This task involves creating an assembly program that:
1. Accepts an array of integers (e.g., five values) from the user.
2. Reverses the array **in place**, without using additional memory.
3. Outputs the reversed array.

The program demonstrates the ability to handle array manipulation, memory indexing, and loop control in assembly language.



#### Program Logic

1. **Input Collection**:
   - The user is prompted to enter an array of integers.
   - The integers are stored sequentially in memory.

2. **In-Place Reversal**:
   - The program uses two pointers: one starting at the beginning of the array and the other at the end.
   - These pointers are used to swap the corresponding elements until the pointers meet in the middle.

3. **Output the Reversed Array**:
   - After reversal, the program iterates through the array and prints each element.

---

### Challenges and Solutions

#### 1. **In-Place Reversal**
   - The main challenge was reversing the array without using additional memory. This was solved by using a temporary register to swap values at two indices.

#### 2. **Handling User Input**
   - Converting user input (ASCII characters) into integers and ensuring correct storage in memory required careful string parsing and arithmetic operations.

#### 3. **Loop Control**
   - Ensuring the reversal loop stopped at the middle of the array was critical. This was handled using pointer comparison logic.

---



### Example Runs

#### Input:  
```plaintext
Enter 5 integers: 1 2 3 4 5
```
#### output:
```plaintext
Reversed Array: 5 4 3 2 1
```

# Task 3:Modular Program with Subroutines for Factorial Calculation 
### <span style="color: blue;">Brief Overview</span>

The factorial program calculates the factorial of a number using recursion, with the stack and registers playing key roles in managing values. The eax register holds the current factorial value and the result, while ebx temporarily stores intermediate values. The program pushes the current value of eax onto the stack before making a recursive call and pops it back to continue the calculation after the call. This ensures that intermediate results are preserved. The stack also helps manage the recursive flow, allowing the program to multiply the current number with the result of smaller factorials until the base case is reached.
## Register Management and Stack Operations
In this factorial program, registers and the stack are managed carefully to preserve intermediate values and maintain the modularity of the code. Here's how it is done:

### Register Usage
#### 1.General Purpose Registers:

- eax: This is the primary register used to store the current value of the factorial during computation. It also holds the final result of the factorial calculation.
- ebx: This is used as a temporary register to store intermediate values (e.g., popped values from the stack during multiplication).
- ecx: Used during the division operation in the convert subroutine for converting the factorial result into a string (base 10).
- edx: Used to store the remainder of the division during the string conversion process.
- edi: Points to the current location in the buffer while constructing the result string.
#### 2.Special Purpose Registers:

- esp: Stack pointer, automatically adjusted by push and pop instructions.
### Stack Management
The stack is used to save and restore values during recursive calls in the factorial subroutine. Here’s how it is managed:

#### Preserving Values
In the factorial subroutine, the current value of eax (representing the number being processed) is saved onto the stack using the push instruction before making the recursive call.
```asm
push eax
```
#### Restoring Values
After the recursive call returns, the saved value of eax is restored from the stack using the pop instruction. This allows the program to continue multiplying the current number with the result from the recursive call.
```asm
pop ebx
```
The multiplication is then performed:
```asm
imul eax, ebx
```
This ensures that intermediate values are preserved across recursive calls, and no data is lost during the computation.

# Task 4: Data Monitoring and Control Using Port-Based Simulation
### <span style="color: blue;">Brief Overview</span>
This program simulates a water level monitoring system using a sensor value to control a motor and alarm. It compares the sensor value to thresholds: below 100 triggers the motor to turn on, while above 200 turns on the alarm. Between 100 and 200, both the motor and alarm are off. The program then prints the status of both the motor and the alarm based on the water level, using conditional jumps to determine actions. After printing the statuses, the program exits.
### Explanation
1. Sensor Input Reading:

   - The program reads the sensor value from a predefined memory location (sensor).
   - The value is loaded into the AL register for processing:
`mov al, [sensor]`.

2. Decision Logic:

The program compares the sensor value against thresholds using `cmp`:
   - If `sensor ≤ 100`: Motor is ON, Alarm is OFF.
   - If `101 ≤ sensor ≤ 200`: Motor is OFF, Alarm is OFF.
   - If `sensor > 200`: Motor is OFF, Alarm is ON.
Conditional jumps (`jbe, jg`) determine which block of code executes.
3. Action Execution:

- Motor Status:
`motor_status` memory location is updated:
   - 1 for ON: mov byte [motor_status], 1.
   - 0 for OFF: mov byte [motor_status], 0.
- Alarm Status:
`alarm_status` memory location is updated:
   - 1 for ON: mov byte [alarm_status], 1.
   - 0 for OFF: mov byte [alarm_status], 0.
Output Text:

Messages reflecting the motor and alarm statuses are printed using `sys_write`.

#### Memory Locations/Ports Manipulated:
1. `sensor` - Holds the input sensor value.
2. `motor_status` - Reflects the motor state (1 = ON, 0 = OFF).
3. `alarm_status` - Reflects the alarm state (1 = ON, 0 = OFF).

---
## Challenges faced:
1. <u>Printing Messages with System Calls:</u> Using the int 0x80 syscall to print messages was effective, but I encountered issues with the correct placement of memory addresses and ensuring the messages were printed without interference. 

2. <u>Debugging Segmentation Errors:</u> During early testing, I faced segmentation faults where the program would crash unexpectedly. These errors were often due to incorrect memory addresses being accessed (for instance, when loading or comparing values from the wrong register or address). Tracking down these issues involved carefully checking the data sections and ensuring the correct register values were being passed.