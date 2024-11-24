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
    mov rax, 1                              ; syscall: write
    mov rdi, 1                              ; file descriptor: stdout
    mov rsi, prompt                         ; address of the prompt
    mov rdx, 15                             ; length of the prompt
    syscall

    ; Read input
    mov rax, 0                              ; syscall: read
    mov rdi, 0                              ; file descriptor: stdin
    mov rsi, num                            ; address to store input
    mov rdx, 5                              ; max bytes to read
    syscall

    ; Convert ASCII input to integer
    xor rax, rax                            ; Clear RAX (result register)
    mov rcx, 0                              ; Sign flag: 0 = positive, 1 = negative
    mov rdi, num                            ; Point to input buffer

check_sign:
    cmp byte [rdi], '-'                     ; Check if the first character is '-'
    jne convert_digits                      ; If not, go to conversion
    inc rdi                                 ; Move pointer to the next character
    mov rcx, 1                              ; Mark the number as negative

convert_digits:
    movzx rbx, byte [rdi]                   ; Load current character
    cmp rbx, 0xA                            ; Check for newline character
    je classification                       ; If newline, go to classification
    sub rbx, 48                             ; Convert ASCII to digit
    imul rax, 10                            ; Multiply result by 10
    add rax, rbx                            ; Add the digit to result
    inc rdi                                 ; Move to the next character
    jmp convert_digits                      ; Repeat for next digit

classification:
    cmp rcx, 1                              ; Check if the number is negative
    je is_negative                          ; If negative, jump to is_negative
    cmp rax, 0                              ; Check if the number is zero
    je is_zero                              ; If zero, jump to is_zero
    jmp is_positive                         ; Otherwise, it's positive

is_positive:
    ; Print "POSITIVE"
    mov rax, 1
    mov rdi, 1
    mov rsi, positive_msg
    mov rdx, 9
    syscall
    jmp end_program                         ; Unconditional jump to end

is_negative:
    ; Print "NEGATIVE"
    mov rax, 1
    mov rdi, 1
    mov rsi, negative_msg
    mov rdx, 9
    syscall
    jmp end_program                         ; Unconditional jump to end

is_zero:
    ; Print "ZERO"
    mov rax, 1
    mov rdi, 1
    mov rsi, zero_msg
    mov rdx, 5
    syscall

end_program:
    ; Exit
    mov rax, 60                             ; syscall: exit
    xor rdi, rdi                            ; exit code 0
    syscall
