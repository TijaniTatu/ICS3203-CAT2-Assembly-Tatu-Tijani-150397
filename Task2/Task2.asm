section .data
    prompt db "Enter 5 integers: ", 0  ; Prompt for user input
    newline db 0xA, 0   
    result_msg db "Reversed array: ", 0                   ; Message to print result                                 ; Newline character
    array db 0, 0, 0, 0, 0                                ; Array to store integers (5 slots)

section .bss
    buffer resb 20                                        ; Input buffer to hold user input

section .text
    global _start

_start:
    ; Print prompt message
    mov eax, 4                ; syscall: write
    mov ebx, 1                ; file descriptor: stdout
    mov ecx, prompt           ; address of the prompt message
    mov edx, 33               ; length of the prompt message
    int 0x80                  ; invoke syscall

    ; Read input from user
    mov eax, 3                ; syscall: read
    mov ebx, 0                ; file descriptor: stdin
    mov ecx, buffer           ; address to store input
    mov edx, 20               ; max bytes to read
    int 0x80                  ; invoke syscall

    ; Parse integers from the input buffer into the array
    mov esi, buffer           ; esi points to the input buffer
    mov edi, array            ; edi points to the array
    mov ecx, 5                ; number of integers to parse
parse_loop:
    xor eax, eax              ; Clear eax to accumulate the parsed number
parse_digit:
    lodsb                     ; Load byte at [esi] into al and advance esi
    cmp al, ' '               ; Check if the character is a space
    je store_number           ; If space, end of the number
    cmp al, 0xA               ; Check if the character is a newline
    je store_number           ; If newline, end of the number
    sub al, '0'               ; Convert ASCII digit to numeric value
    imul eax, 10              ; Multiply current value by 10
    add al, [edi]             ; Add the parsed digit to the number
    mov [edi], al             ; Store the result in the array slot
    jmp parse_digit           ; Continue parsing digits

store_number:
    add edi, 1                ; Move to the next slot in the array
    loop parse_loop           ; Repeat until all 5 integers are parsed

    ; Reverse the array in place
    mov esi, array            ; esi points to the start of the array
    mov edi, array + 4        ; edi points to the end of the array
reverse_loop:
    cmp esi, edi              ; Check if pointers have crossed
    jge reverse_done          ; If crossed or equal, reversing is complete
    mov al, [esi]             ; Load value from the start
    mov bl, [edi]             ; Load value from the end
    mov [esi], bl             ; Store end value at start
    mov [edi], al             ; Store start value at end
    add esi, 1                ; Move start pointer forward
    sub edi, 1                ; Move end pointer backward
    jmp reverse_loop          ; Repeat until the array is reversed

reverse_done:
    ; Print the result message
    mov eax, 4                ; syscall: write
    mov ebx, 1                ; file descriptor: stdout
    mov ecx, result_msg       ; address of the result message
    mov edx, 16               ; length of the result message
    int 0x80                  ; invoke syscall

    ; Output the reversed array
    mov esi, array            ; esi points to the start of the array
    mov ecx, 5                ; Number of integers to print
print_loop:
    mov al, [esi]             ; Load value from the array
    add al, '0'               ; Convert to ASCII
    mov [esp - 1], al         ; Store the ASCII character temporarily
    mov eax, 4                ; syscall: write
    mov ebx, 1                ; file descriptor: stdout
    lea ecx, [esp - 1]        ; Address of the ASCII character
    mov edx, 1                ; Length of the character
    int 0x80                  ; Invoke syscall

    ; Print space between numbers
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    add esi, 1                ; Move to the next array element
    loop print_loop           ; Repeat until all integers are printed

    ; Exit program
    mov eax, 1                ; syscall: exit
    xor ebx, ebx              ; exit code 0
    int 0x80
