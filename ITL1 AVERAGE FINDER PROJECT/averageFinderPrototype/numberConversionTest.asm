.model small
.stack 100h

.data
    msg db "Enter a number: $"
    input db 10, ?, 10, '$'
    output db 10, "The number is: $"
    
.code
main proc
    mov ax, @data
    mov ds, ax
    
    lea dx, msg
    mov ah, 9
    int 21h        ; display message to enter a number
    
    lea dx, input
    mov ah, 0Ah
    int 21h        ; read input from user
    
    lea dx, output
    mov ah, 9
    int 21h        ; display message "The number is:"
    
    lea si, input+2   ; point SI to the beginning of the input string
    mov cx, 0         ; initialize CX to 0
    
    ; loop to convert ASCII digits to binary
    convert_loop:
        mov al, [si]     ; move ASCII digit to AL
        cmp al, 0Ah      ; check if digit is 10 (end of string)
        je done          ; if end of string, exit loop
        
        sub al, 30h      ; convert ASCII digit to binary
        mov bx, 10       ; move 10 to BX
        mul bx           ; multiply CX by 10
        add cx, ax       ; add AL to CX
        inc si           ; move to next digit
        jmp convert_loop ; repeat for all digits
        
    done:
        mov ax, 4C00h    ; exit program with return code 0
        int 21h
    
main endp
end main