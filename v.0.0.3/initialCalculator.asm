                  
.model small
.stack 100h

.data
    message1 db 10,13, 'Enter first number: $'
    message2 db 10,13, 'Enter second number: $'
    message3 db 10,13, '1. Add$'
    message4 db 10,13, '2. Subtract$'
    message5 db 10,13, '3. Multiply$'
    message6 db 10,13, '4. Divide$'
    message7 db 10,13, 'Enter your choice: $'
    result db 10,13, 'Result: $'
    randomBullshit db "Fucking assembly is weirder than java" 

.code
    main proc
    mov ax, @data
    mov ds, ax

    ; Input first number
    mov ah, 9
    lea dx, message1
    int 21h

    mov ah, 1
    int 21h
    sub al, '0'
    mov bl, al

    ; Input second number
    mov ah, 9
    lea dx, message2
    int 21h

    mov ah, 1
    int 21h
    sub al, '0'
    mov bh, al

    ; Display menu
    mov ah, 9
    lea dx, message3
    int 21h
    lea dx, message4
    int 21h
    lea dx, message5
    int 21h
    lea dx, message6
    int 21h
    
    lea dx, randomBullshit
    int 21h
    

    ; Input choice
    mov ah, 9
    lea dx, message7
    int 21h

    mov ah, 1
    int 21h
    sub al, '0'

    ; Perform arithmetic operation based on choice
    cmp al, 1
    je add_numbers
    
    cmp al, 2
    je subtract_numbers
    
    cmp al, 3
    je multiply_numbers
    
    cmp al, 4
    je divide_numbers
    
    jmp exit_program


add_numbers:
    mov ax, bx
    add ax, dx
    jmp display_result

subtract_numbers:
    mov ax, bx
    sub ax, dx
    jmp display_result

multiply_numbers:
    mov ax, bx
    mul dx
    jmp display_result

divide_numbers:
    mov ax, bx
    cwd
    div dx
    jmp display_result

display_result:
    ; Display result
    mov ah, 9
    lea dx, result
    int 21h

    mov al, ah
    add al, '0'
    mov ah, 2
    mov dl, al
    int 21h

    mov al, bl
    add al, '0'
    mov ah, 2
    mov dl, al
    int 21h

    jmp exit_program

exit_program:
    mov ah, 4ch
    int 21h
    main endp
    end main