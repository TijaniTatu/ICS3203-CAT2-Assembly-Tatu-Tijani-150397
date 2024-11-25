section .data
    prompt db "Enter a number: ", 0          ; Prompt for user input
    positive_msg db "POSITIVE", 0xA, 0       ; Positive message
    negative_msg db "NEGATIVE", 0xA, 0       ; Negative message
    zero_msg db "ZERO", 0xA, 0               ; Zero message

section .bss
    num resb 5                              ; Space to store the input string

section .text
    global _start

_start:
    ; Print prompt
    mov eax, 4                              ; syscall: write
    mov ebx, 1                              ; file descriptor: stdout
    mov ecx, prompt                         ; address of the prompt
    mov edx, 15                             ; length of the prompt
    int 0x80                                 ; invoke syscall

    ; Read input
    mov eax, 3                              ; syscall: read
    mov ebx, 0                              ; file descriptor: stdin
    mov ecx, num                            ; address to store input
    mov edx, 5                              ; max bytes to read
    int 0x80                                 ; invoke syscall

    ; Convert ASCII input to integer
    xor eax, eax                            ; Clear EAX (result register)
    mov ecx, 0                              ; Sign flag: 0 = positive, 1 = negative
    mov edi, num                            ; Point to input buffer

check_sign:
    cmp byte [edi], '-'                     ; Check if the first character is '-'
    jne convert_digits                      ; If not, go to conversion (conditional jump: determine if input number is negative by ensuring that no negative sign, the number will be processed as a positive value)
    inc edi                                 ; Move pointer to the next character
    mov ecx, 1                              ; Mark the number as negative

convert_digits:
    movzx ebx, byte [edi]                   ; Load current character
    cmp ebx, 0xA                            ; Check for newline character
    je classification                       ; If newline, go to classification (conditional jump if a newline is detected, the program jumps to the classification section)
    sub ebx, 48                             ; Convert ASCII to digit
    imul eax, 10                            ; Multiply result by 10
    add eax, ebx                            ; Add the digit to result
    inc edi                                 ; Move to the next character
    jmp convert_digits                      ; Repeat for next digit

classification:
    cmp ecx, 1                              ; Check if the number is negative
    je is_negative                          ; If negative, jump to is_negative (conditional jump if ecx is equal to 1, indicating a negative number, the program jumps to the is_negative section)
    cmp eax, 0                              ; Check if the number is zero
    je is_zero                              ; If zero, jump to is_zero (conditional jump if the value is zero, the program will jump to the is_zero section)
    jmp is_positive                         ; Otherwise, it's positive

is_positive:
    ; Print "POSITIVE"
    mov eax, 4
    mov ebx, 1
    mov ecx, positive_msg
    mov edx, 9
    int 0x80                                 ; invoke syscall
    jmp end_program                         ; Unconditional jump to end the program

is_negative:
    ; Print "NEGATIVE"
    mov eax, 4
    mov ebx, 1
    mov ecx, negative_msg
    mov edx, 9
    int 0x80                                 ; invoke syscall
    jmp end_program                         ; Unconditional jump to end

is_zero:
    ; Print "ZERO"
    mov eax, 4
    mov ebx, 1
    mov ecx, zero_msg
    mov edx, 5
    int 0x80                                 ; invoke syscall

end_program:
    ; Exit
    mov eax, 1                              ; syscall: exit
    xor ebx, ebx                            ; exit code 0
    int 0x80                                 ; invoke syscall
