section .data
    sensor db 150              ; Simulated sensor value
    motor_status db 0          ; Motor status: 0 = OFF, 1 = ON
    alarm_status db 0          ; Alarm status: 0 = OFF, 1 = ON

    motor_on_msg db "Motor is ON", 0xA, 0  ; Message for motor ON
    motor_off_msg db "Motor is OFF", 0xA, 0 ; Message for motor OFF
    alarm_on_msg db "Alarm is ON", 0xA, 0   ; Message for alarm ON
    alarm_off_msg db "Alarm is OFF", 0xA, 0 ; Message for alarm OFF

section .text
    global _start

_start:
    ; Read the sensor value
    mov al, [sensor]           ; Load sensor value into AL
    cmp al, 100                ; Compare sensor value with 100
    jbe low_water_level        ; If <= 100, jump to low_water_level

    cmp al, 200                ; Compare sensor value with 200
    jbe moderate_water_level   ; If <= 200, jump to moderate_water_level

    ; If sensor > 200, trigger alarm
high_water_level:
    mov byte [motor_status], 0 ; Turn OFF motor
    mov byte [alarm_status], 1 ; Turn ON alarm
    jmp print_status           ; Jump to print status

moderate_water_level:
    mov byte [motor_status], 0 ; Turn OFF motor
    mov byte [alarm_status], 0 ; Turn OFF alarm
    jmp print_status           ; Jump to print status

low_water_level:
    mov byte [motor_status], 1 ; Turn ON motor
    mov byte [alarm_status], 0 ; Turn OFF alarm

print_status:
    ; Print motor status
    mov al, [motor_status]     ; Load motor status into AL
    cmp al, 1                  ; Check if motor is ON
    je print_motor_on          ; If ON, jump to print_motor_on
    jmp print_motor_off        ; Otherwise, jump to print_motor_off

print_motor_on:
    mov eax, 4                 ; sys_write
    mov ebx, 1                 ; stdout
    lea ecx, [motor_on_msg]    ; Address of "Motor is ON"
    mov edx, 13                ; Length of the message
    int 0x80                   ; Call kernel
    jmp check_alarm            ; Skip to check_alarm

print_motor_off:
    mov eax, 4                 ; sys_write
    mov ebx, 1                 ; stdout
    lea ecx, [motor_off_msg]   ; Address of "Motor is OFF"
    mov edx, 14                ; Length of the message
    int 0x80                   ; Call kernel

check_alarm:
    ; Print alarm status
    mov al, [alarm_status]     ; Load alarm status into AL
    cmp al, 1                  ; Check if alarm is ON
    je print_alarm_on          ; If ON, jump to print_alarm_on
    jmp print_alarm_off        ; Otherwise, jump to print_alarm_off

print_alarm_on:
    mov eax, 4                 ; sys_write
    mov ebx, 1                 ; stdout
    lea ecx, [alarm_on_msg]    ; Address of "Alarm is ON"
    mov edx, 12                ; Length of the message
    int 0x80                   ; Call kernel
    jmp end_program            ; Skip to end_program

print_alarm_off:
    mov eax, 4                 ; sys_write
    mov ebx, 1                 ; stdout
    lea ecx, [alarm_off_msg]   ; Address of "Alarm is OFF"
    mov edx, 13                ; Length of the message
    int 0x80                   ; Call kernel

end_program:
    ; Exit the program
    mov eax, 1                 ; sys_exit
    xor ebx, ebx               ; exit status 0
    int 0x80                   ; Call kernel
