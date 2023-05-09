
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

INCLUDE EMU8086.INC     ;Including Library

org 100h

.data       ;Data Segment

  ;0dh,0ah stands for a newline character.
  operationChoices db '  1. Addition', 0dh,0ah,'  2. Subtration', 0dh,0ah, '  3. Multiplication', 0dh,0ah, '  4. Division', 0dh,0ah,'Select any Options: ','$'

  ;line breaks are really important, a line break means
  ; a new line of instruction so breaking the long code
  ; of the operationChoices would change it's functionality  

  programHeader        db '             **** CALCULATOR ****$'  
  additionHeader       db '             **** ADDITION ****$' 
  subtractionHeader    db '             **** SUBTRACTION ****$'
  multiplicationHeader db '             **** MULTIPLICATION ****$'
  divisionHeader       db '             **** DIVISION ****$'

  additionResultMsg db 'The SUM of two Numbers = $', 0dh,0ah       ;Printing Strings
  subtractionResultMsg db 'The SUBTRACTION of two Numbers = $', 0dh,0ah
  multiplicationResultMsg db 'The MULTIPLICATION of two Numbers = $', 0dh,0ah
  divisionResultMsg db 'The DIVISION of two Numbers = $', 0dh,0ah 

  newLine db 10,13, '$'

  firstNumberEntryMsg db 'enter first number: $'
  secondNumberEntryMsg db 10,13,'enter second number: $'
 

  cont db 10,13,'Do you want to Use Again ? $'
  continuationChoice db 10,13,'(Yes = 1 / No = 0) : $'
  bye db '            **** Thank You !!!  :) **** $'

  divisionErrorMessage db 10,13,'Cannot be divided by 0. ', 10,13, 'Undefined Math Error', '$'

  val1 dw ?       ;Uninitialize
  val2 dw ?       ;Uninitialize  
  res dw ?
  agn dw ?


.code       ;Code Segment

  programStart proc 
    
    mov ah,09h
    mov dx, offset programheader
    int 21h

    call printNewLine

    MOV AH,9
    MOV DX, OFFSET operationChoices
    INT 21h                                          

    CALL scan_num

    call printNewLine


    CMP CX, 0
    JE programCanExit                 ;Jumps to Exit Func if input is equal to 0             


    CMP CX, 1
    JE additionoperation    ;Jumps to Addition Func if input is equal to 1


    CMP CX, 2
    JE subtractionOperation ;Jumps to Substraction Func if input is equal to 2
      
      
    CMP CX, 3
    je multiplyoperation    ;Jumps to Multiplication Func if input is equal to 3


    CMP CX, 4
    JE divideoperation      ;Jumps to Division Func if input is equal to 4

    call programContinuationDecision

    programCanExit:
      call programEnding

    additionOperation:
      call addition
    
    subtractionOperation:
      call subtraction
    
    divideOperation:
      call division
    
    multiplyOperation:
      call multiplication
  
  programStart endp
 
  printNewLine proc 

    MOV AH,9
    MOV DX, OFFSET newLine
    INT 21h

    ret
  printNewLine endp 

  retrieveValues proc 
    mov ah, 09h
    mov dx, offset firstNumberEntryMsg
    int 21h

    CALL scan_num       ;First no. input
    MOV val1, CX        ;Moving first no. to val1   

    call printNewLine


    mov ah, 09h
    mov dx, offset secondNumberEntryMsg
    int 21h
    
    CALL scan_num       ;Second no. input
    
    MOV val2, CX        ;Moving second no. to val2
    
    call printNewLine
    ret
  retrieveValues endp 

  addition proc

    mov ah, 09h
    mov dx, offset additionHeader
    int 21h

    call printNewLine
    call printNewLine

    call retrieveValues

    MOV AX, val1        ;Moving val1 to AX reg
    ADD AX, val2        ;Adding AX to val2
    MOV res, AX         ;Storing AX in res

    call printNewLine

    MOV AH,9
    MOV DX, OFFSET additionResultMsg    ;Displaying Message
    INT 21h                             ;Calling Interrupt

    MOV AX, res             ;Moving res to AX
    CALL print_num          ;Printing AX reg
                            
    CALL programContinuationDecision  ;Goes to Con Func                 

  addition endp
  

  subtraction proc
    
    MOV AH,09H
    MOV DX, OFFSET subtractionheader
    INT 21H

    CALL printNewLine
    CALL printNewLine
    
    call retrieveValues

    MOV AX, val1        ;Moving val1 to AX reg
    SUB AX, val2        ;Subtracting AX with val2
    MOV res, AX         ;Storing AX in res

    call printNewLine

    MOV AH,9
    MOV DX, OFFSET subtractionResultMsg   ;Displaying Message
    INT 21h                               ;Calling Interrupt


    MOV AX, res             ;Moving res to AX
    CALL print_num          ;Printing AX reg

    CALL programContinuationDecision             ;Goes to Con Func             


  subtraction endp

    
  multiplication proc

    mov ah,09h
    mov dx, offset multiplicationheader
    int 21h

    call printNewLine
    call printNewLine
    
    call retrieveValues



    MOV AX, val1        ;Moving val1 to AX reg
    MUL val2            ;Multiplying AX with val2
    MOV res, AX         ;Storing AX in res

    call printNewLine

    MOV AH,9
    MOV DX, OFFSET multiplicationResultMsg   ;Displaying Message
    INT 21h                 ;Calling Interrupt

    MOV AX, res             ;Moving res to AX
    CALL print_num          ;Printing AX reg

    call programContinuationDecision  ;Goes to Con Func
    ret 
  multiplication endp
  
  division proc

    
    print '     ****--Division--****' 
    printn
    printn
    
    call retrieveValues

    ;prepare values for division operation
    MOV AX, val1        ;Moving val1 to AX reg  
    MOV BX, val2


    CMP BX, 0      ;if divisor = 2 
    JE Error        ;overflow

    MOV DX, 0           ;Moving 0 in DX to avoid overflow

    DIV BX            ;Dividing AX with val2
    MOV res, AX         ;Storing AX in res

    call printNewLine

    MOV AH,9
    MOV DX, OFFSET divisionresultmsg    ;Displaying Message
    INT 21h                           ;Calling Interrupt

    MOV AX, res             ;Moving res to AX
    CALL print_num          ;Printing AX reg

    call programContinuationDecision ;Goes to Con Func
    ret
    error: 
      call divisionError
      ret
  division endp




  divisionError proc   
    

    call printNewLine

    mov ah,09
    mov dx, offset divisionErrorMessage
    int 21h 

    call printNewLine
    call printNewLine
    ret

  divisionError endp



  programContinuationDecision proc ;Continue Func

    call printNewLine

    MOV AH,9
    MOV DX, OFFSET cont    ;Displaying Message
    INT 21h                 ;Calling Interrupt
    
    MOV AH,9
    MOV DX, OFFSET continuationChoice    ;Displaying Message
    INT 21h                 ;Calling Interrupt
    

    CALL scan_num           ;Enter 1 for Yes and 0 for No
    MOV agn, CX

    call printNewLine
    call printNewLine

    CMP agn, 1
    JE backToStart    ;Jumps to Start Func if input is equal to 1                    

    CMP agn, 0
    JE finishProgram              ;Jumps to Bye Func if input is equal to 0

    call programContinuationDecision ; beware this is a recursion in the case where
                                    ; user does not enter a valid input and prevent
                                    ; the label from auto execution.

    backToStart: 
      call programStart
      ret
    
    finishProgram:
      call programEnding

  programContinuationDecision endp

  programEnding proc ;EXIT Func

    call printNewLine
    call printNewLine

    MOV AH,9
    MOV DX, OFFSET bye    ;Displaying Message
    INT 21h                        

    MOV AH, 0
    INT 21H

  programEnding endp

  MAIN PROC
      
    MOV AX, @data
    MOV DS, AX

    call programStart  

  MAIN ENDP     
DEFINE_SCAN_NUM
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS

END main

HLT         ;Halting                                            
ret         ;Return


