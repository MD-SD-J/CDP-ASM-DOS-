section .data
    ; Constants for text colors
    WHITE equ 7
    CYAN equ 3
    ; Message strings
    welcome_msg db 'Welcome to x86 DOS Test', 0
    about_msg db 'ABOUT', 0
    exit_msg db 'EXIT', 0
    minimize_msg db 'MINIMIZE', 0
    maximize_msg db 'MAXIMIZE', 0
    ; Button coordinates
    about_x dw 2
    about_y dw 1
    exit_x dw 15
    exit_y dw 1
    minimize_x dw 30
    minimize_y dw 1
    maximize_x dw 45
    maximize_y dw 1

section .bss
    ; No BSS section needed for this example

section .text
    global _start

_start:
    ; Display window
    call drawWindow
    
    ; Display buttons
    call drawButtonAbout
    call drawButtonExit
    call drawButtonMinimize
    call drawButtonMaximize
    
    ; Wait for any key press
    mov eax, 0
    int 0x16

    ; Terminate program
    mov eax, 1
    xor ebx, ebx
    int 0x80

drawWindow:
    mov ax, 0xB800  ; Video memory segment
    mov es, ax      ; Set ES to video memory
    xor di, di      ; Start at beginning of video memory
    mov cx, 160     ; Number of characters (80 columns * 2 bytes per character)
    mov ax, 20h * 256 + WHITE ; Background color and text color
    rep stosw       ; Fill video memory with spaces and color
    mov di, 1 * 160 + 2         ; Move to next row for window border
    mov ax, CYAN * 256 + 219    ; Border character and color
    stosw           ; Draw top border
    mov di, 1 * 160 + 4         ; Move to starting position for text
    mov esi, welcome_msg        ; Load address of message string
    call printString            ; Call function to print string
    ret

drawButtonAbout:
    mov di, [about_y] * 160 + [about_x] * 2
    mov ax, WHITE * 256 + CYAN
    mov cx, 6
    rep stosw
    mov di, [about_y] * 160 + [about_x] * 2 + 1
    mov esi, about_msg
    call printString
    ret

drawButtonExit:
    mov di, [exit_y] * 160 + [exit_x] * 2
    mov ax, WHITE * 256 + CYAN
    mov cx, 4
    rep stosw
    mov di, [exit_y] * 160 + [exit_x] * 2 + 1
    mov esi, exit_msg
    call printString
    ret

drawButtonMinimize:
    mov di, [minimize_y] * 160 + [minimize_x] * 2
    mov ax, WHITE * 256 + CYAN
    mov cx, 8
    rep stosw
    mov di, [minimize_y] * 160 + [minimize_x] * 2 + 1
    mov esi, minimize_msg
    call printString
    ret

drawButtonMaximize:
    mov di, [maximize_y] * 160 + [maximize_x] * 2
    mov ax, WHITE * 256 + CYAN
    mov cx, 9
    rep stosw
    mov di, [maximize_y] * 160 + [maximize_x] * 2 + 1
    mov esi, maximize_msg
    call printString
    ret

printString:
    mov ah, 0x0E  ; BIOS teletype function
    mov bh, 0     ; Page number
.repeat:
    lodsb         ; Load byte from SI into AL
    cmp al, 0     ; Check for null terminator
    je .done      ; If null terminator found, exit loop
    int 0x10      ; Otherwise, print character
    jmp .repeat   ; Repeat until null terminator found
.done:
    ret           ; Return from function
