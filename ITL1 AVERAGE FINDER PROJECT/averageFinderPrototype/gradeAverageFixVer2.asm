
include EMU8086.inc 

.MODEL SMALL
.DATA
        VAL1         DB      ?
        SUBJ         DB      0AH,0DH,'NUMBER OF SUBJECTS : $'
        GRADE        DB      0AH,0DH,'ENTER GRADE: $'
        AVERAGE      DB      0AH,0DH,'AVERAGE: $'
        DESIGN1      DB      0AH,0DH,'*********************** $'
        BUFFER       DB      3,4 DUP(?)
        SEJ          DB      10,13,10,13,' $' 
        MSG          DB      0DH,0AH, '  ===WELCOME!=== $'
        MSG1         DB      10, 13, "ENTER NAME: $"
        MSG2         DB      10, 13, "ENTER SCHOOL ID: $"  
        MSG_1        DB      10, 13, 'NAME: $'
        MSG_2        DB      10, 13, 'ID: $'
        BUFFERSIZE   DB      21     ; 20 CHAR + RETURN 
        BUFFERSIZE1  DB     31     ; 20 CHAR + RETURN
        INPUTLENGTH  DB      0     ; NUMBER OF READ CHARACTERS
        DNAME        DB      21 DUP('$')
        DSCHLID      DB      31 DUP('$')
       
     
      ; declare the value of variables as 0, hexadecimal value because
      ; registers work with hexadecimal values 
      numberOfSubjects            dw 0h
      loopCounter                 dw 1h
      totalSumOfGradesOfAverage   dw 0h

      ; prompt for grade input
      gradeInputPromptPrefix    dw  10,13,'Enter grade for subject $'
      gradeInputPromptSuffix    dw  ' :$ '     

      
                     
.CODE 
               
MAIN    PROC  
    
        MOV AX, @DATA 
        MOV DS , AX  
        LEA DX,  DESIGN1
        MOV AH, 09H ;OUTPUT
        INT 21H
  
        ; INPUT NAME
        MOV AX, @DATA
        MOV DS, AX
        LEA DX, MSG1
        MOV AH, 09H ;OUTPUT
        INT 21H
        
        MOV DX, OFFSET BUFFERSIZE 
        MOV AH, 10 ; GETLINE FUNCTION
        INT 21H
        
        
        ; PRINT NAME          
        MOV AX, @DATA 
        MOV DS , AX  
        LEA DX,  MSG_1
        MOV AH, 09H ;OUTPUT
        INT 21H
                
        MOV AX, @DATA 
        MOV DS , AX  
        LEA DX,  DNAME
        MOV AH, 09H ;OUTPUT
        INT 21H   
        
        LEA DX,SEJ ;NEWLINE
        MOV AH,9
        INT 21H 
        
        
        ; INPUT SCHOOL ID
        MOV AX, @DATA
        MOV DS, AX
        LEA DX, MSG2
        MOV AH, 09H ;OUTPUT
        INT 21H
        
        MOV DX, OFFSET BUFFERSIZE1 ;
        MOV AH, 10 ; GETLINE FUNCTION
        INT 21H  
           
        
        ; PRINT SCHOOL ID          
        MOV AX, @DATA 
        MOV DS , AX  
        LEA DX,  MSG_2
        MOV AH, 09H ;OUTPUT
        INT 21H
                
        MOV AX, @DATA 
        MOV DS , AX  
        LEA DX,  DSCHLID 
        MOV AH, 09H ;OUTPUT
        INT 21H  
        
        MOV AX, @DATA 
        MOV DS , AX  
        LEA DX,  DESIGN1
        MOV AH, 09H ;OUTPUT
        INT 21H
  
        ;NEWLINE
        LEA DX,SEJ 
        MOV AH,9
        INT 21H  
               
        LEA DX,MSG, '$'
        MOV AH,9
        INT 21H   
        
    
        
        LEA DX,SEJ ;NEWLINE
        MOV AH,9
        INT 21H   
      

        caLL receiveGradesAndPresentAverage
        mov ah, 4ch
        int 21h
MAIN    ENDP

receiveGradesAndPresentAverage proc

    mov dx , offset SUBJ
    
    mov ah,09h
    int 21h
    
    call scan_num ; call keyword invokes the procedure scan_num which takes a 
                  ; a number(5 digits max) from the console. 
                  ; the value retrieved by the function is located in the CX register

    mov numberOfSubjects, cx
  
    takeGradeForSubject: 
      
      mov dx , offset gradeInputPromptPrefix ; prepare string variable to print 
      
      mov ah,09h    ; call the sub function for printing 
      int 21h       ; call the interrupt, which should print 
                    ; the variable in dx register  

      mov ax, loopcounter
      call print_num

      mov dx , offset gradeInputPromptSuffix; prepare string variable to print 
      
      mov ah,09h    ; call the sub function for printing 
      mov al, 0h
      int 21h       ; call the interrupt, which should print 
                    ; the variable in dx register  



      call scan_num
      
      mov ax, totalSumOfGradesOfAverage   ; holds all the accumulated values of the grades entered by user
      add ax, cx                          ; cx holds the value the user has recently entered, which is a subject grade
                                          ; add operation should compress all values to a single value, this is because 
                                          ; a sum of all values is needed for geting the average.

      mov totalsumofgradesofaverage, ax   ; the total sum should be in ax, and must be moved back to the memory address
                                          ; of all the totalsumofgradesofaverage for future operations.   


 

      ; cmp performs arithmetic operation, subtract both values.
      ; cmp value to be subtracted from, the value to subtract
      ; the result will be visible in the flags.

      mov bx,numberofsubjects
      cmp bx, loopcounter ; compare the values of the number of subjects
                          ; the number of times the takeGradeForSubject 
                          ; has looped  
      
      je presentAverage       ; je = JUMP IF EQUAL TO 
      

      mov bx, loopCounter   ; move the value of the loop counter to bx register for inc operation, any vacant register will work
      inc bx                ; increment loop counter value inside of the bx register
      mov loopcounter, bx   ; return the incremented value back to the memory address.
      
      mov bx,numberofsubjects
      cmp bx, loopcounter

      jge takeGradeForSubject   ; jge = JUMP IF GREATER THAN OR EQUAL TO


    presentAverage: 
    
      MOV DX, OFFSET SEJ
      mov ah,09
      INT 21h

      mov dx, 0
      mov ax, totalsumofgradesofaverage
      div numberofsubjects    ; the result should be at the 
                              ; ax register. 

      call print_num    ; prints number in ax register.

      ret   ; returns control to the procedure that called 
            ; the procedure where ret is used.
            ; to avoid loop bugs, ret must be at the end of a procedure 

receiveGradesAndPresentAverage endp



DEFINE_SCAN_NUM ; MUST BE DECLARED BEFORE THE 'END' , necessary because a library is used and the 
                ; the program produces an error without it. 

DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS ; don't remove, necessary for DEFINE_PRINT_NUM 

        END     MAIN