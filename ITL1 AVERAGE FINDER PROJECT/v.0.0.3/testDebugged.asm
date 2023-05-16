                             INCLUDE EMU8086.INC 
.MODEL SMALL
.DATA   


        VAL1         DB      ?
        SUBJ         DB      0AH,0DH,'NUMBER OF SUBJECTS : $'
        GRADE        DB      0AH,0DH,'ENTER GRADE: $'
        AVERAGE      DW      0AH,0DH,'AVERAGE: $'
        DESIGN1      DB      0AH,0DH,'************************** $'
        DESIGN2      DB      0AH,0DH,'============================ $'
        BUFFER       DB      3,4 DUP(?)
        NEWLINE      DB      10,13,10,13,' $' 
        WELCOME      DB      0DH,0AH, '==========WELCOME!========== $'
        THANKU       DB      0DH,0AH, ' ========THANK YOU!======== $'
        MSG1         DB      10, 13, "ENTER NAME: $"
        MSG2         DB      10, 13, "ENTER SCHOOL ID: $"  
        BUFFERSIZE   DB      21     ; 20 CHAR + RETURN 
        INPUTLENGTH  DB      0     ; NUMBER OF READ CHARACTERS
        DNAME        DB      21 DUP('$')
      
       
     
      ; DECLARE THE VALUE OF VARIABLES AS 0, HEXADECIMAL VALUE BECAUSE
      ; REGISTERS WORK WITH HEXADECIMAL VALUES 
      NUMBEROFSUBJECTS            DW 0H
      LOOPCOUNTER                 DW 1H
      TOTALSUMOFGRADESOFAVERAGE   DW 0H

      totalAverage                DW 0h ; this variable will hold the final average.

      ; PROMPT FOR GRADE INPUT
      GRADEINPUTPROMPTPREFIX    DW  10,13,'GRADE FOR SUBJECT $'
      GRADEINPUTPROMPTSUFFIX    DW  ': $ '
      
      
      ;message for evaluating average of grades
      failMsg db 10,13, 'you fail$' 
      passMsg db 10,13, 'you pass$'  

      
                     
.CODE

               
MAIN    PROC  

       ; PRINT THE LINE DESIGN2   
        MOV AX, @DATA 
        MOV DS , AX  
        LEA DX,  DESIGN2
        MOV AH, 09H ;OUTPUT
        INT 21H  
    
        ;PRINT WELCOME
        MOV AX, @DATA 
        MOV DS , AX    
        LEA DX,WELCOME
        MOV AH,9
        INT 21H  
        
        ; PRINT THE LINE DESIGN2    
        LEA DX,  DESIGN2
        MOV AH, 09H ;OUTPUT
        INT 21H 
        
        ;NEWLINE
        LEA DX,NEWLINE 
        MOV AH,9
        INT 21H 
        
        ; PRINT THE LINE DESIGN1    
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
        
        
        ; INPUT SCHOOL ID
        MOV AX, @DATA
        MOV DS, AX
        LEA DX, MSG2
        MOV AH, 09H ;OUTPUT
        INT 21H
        
        MOV DX, OFFSET BUFFERSIZE ;
        MOV AH, 10 ; GETLINE FUNCTION
        INT 21H   
         
        
        ; PRINT THE LINE DESIGN1    
        MOV AX, @DATA 
        MOV DS , AX  
        LEA DX,  DESIGN1
        MOV AH, 09H ;OUTPUT
        INT 21H 
  
        ;NEWLINE
        LEA DX,NEWLINE 
        MOV AH,9
        INT 21H 
        
        CALL RECEIVEGRADESANDPRESENTAVERAGE 

        
        MOV BX, totalAverage ; GET THE TOTAL AVERAGE AND PUT IT INSIDE OF A REGISTER
        
        CMP BX, 75 ;if greater than 75 then average is passing 
                    ; if less than 75 then average is failed 
                    ; cmp command takes the first parameter and diminishes it
                    ; with the second command. 
                    
                    ; the CMP command sets the flags according to the value of the result,
                    ;then whenever a conditional jump is executed, the program will analyze
                    ; value of the flags.
                    
                    ; the flags will be set according to the value of the latest arithmetic operation
                    ; which should be the CMP command.

                    ; if the result is 0 then the first parameter and the second parameter is equal
                    ; if the result is a lower than 0 or negative then the second parameter is greater
                    ; if the result is positive or greater than 0 then the first parameter is greater 
        
                    ; the use of conditional jumps like JLE and JGE rely upon the 

        JGE passLabel

        jle faillabel

                
                  
        passLabel:                       
            
            ; code here when user average is passing 
            mov dx, offset passMsg
            mov ah,09 
            int 21h
                  
            jmp closetheprogram
        
        
        failLabel:
            ; code here when user average is failing
            mov dx, offset failMsg
            mov ah,09 
            int 21h

            jmp closetheprogram
          

        closetheprogram:
        
        CALL ENDINGMESSAGE ; PRINT MESSAGE FOR ENDING PROGRAM.
        
        ; this block of code will terminate the program
        ; make sure this is at the end of the main
        MOV AH, 4CH 
        INT 21H
MAIN    ENDP  

ENDINGMESSAGE PROC

      ;NEWLINE
      LEA DX,NEWLINE 
      MOV AH,9
      INT 21H 
             
      ; PRINT THE LINE DESIGN1    
      LEA DX,  DESIGN1
      MOV AH, 09H ;OUTPUT
      INT 21H  
      
      ; PRINT THANK YOU    
      LEA DX,  THANKU
      MOV AH, 09H ;OUTPUT
      INT 21H

      RET
ENDINGMESSAGE ENDP

RECEIVEGRADESANDPRESENTAVERAGE PROC
    
    ; ASK HOW MANY SUBJECTS
    MOV DX , OFFSET SUBJ
    MOV AH,09H
    INT 21H  
    CALL SCAN_NUM ; CALL KEYWORD INVOKES THE PROCEDURE SCAN_NUM WHICH TAKES A 
                  ; A NUMBER(5 DIGITS MAX) FROM THE CONSOLE. 
                  ; THE VALUE RETRIEVED BY THE FUNCTION IS LOCATED IN THE CX REGISTER

    MOV NUMBEROFSUBJECTS, CX  
   
    ;NEWLINE
    LEA DX,NEWLINE 
    MOV AH,9
    INT 21H 
  
    TAKEGRADEFORSUBJECT: 
      
      MOV DX , OFFSET GRADEINPUTPROMPTPREFIX ; PREPARE STRING VARIABLE TO PRINT 
      MOV AH,09H    ; CALL THE SUB FUNCTION FOR PRINTING 
      INT 21H       ; CALL THE INTERRUPT, WHICH SHOULD PRINT 
                    ; THE VARIABLE IN DX REGISTER  

      MOV AX, LOOPCOUNTER
      CALL PRINT_NUM
      MOV DX , OFFSET GRADEINPUTPROMPTSUFFIX; PREPARE STRING VARIABLE TO PRINT 
      MOV AH,09H    ; CALL THE SUB FUNCTION FOR PRINTING 
      MOV AL, 0H
      INT 21H       ; CALL THE INTERRUPT, WHICH SHOULD PRINT 
                    ; THE VARIABLE IN DX REGISTER  



      CALL SCAN_NUM
      MOV AX, TOTALSUMOFGRADESOFAVERAGE   ; HOLDS ALL THE ACCUMULATED VALUES OF THE GRADES ENTERED BY USER
      ADD AX, CX                          ; CX HOLDS THE VALUE THE USER HAS RECENTLY ENTERED, WHICH IS A SUBJECT GRADE
                                          ; ADD OPERATION SHOULD COMPRESS ALL VALUES TO A SINGLE VALUE, THIS IS BECAUSE 
                                          ; A SUM OF ALL VALUES IS NEEDED FOR GETING THE AVERAGE.

      MOV TOTALSUMOFGRADESOFAVERAGE, AX   ; THE TOTAL SUM SHOULD BE IN AX, AND MUST BE MOVED BACK TO THE MEMORY ADDRESS
                                          ; OF ALL THE TOTALSUMOFGRADESOFAVERAGE FOR FUTURE OPERATIONS.   
                                          ; CMP PERFORMS ARITHMETIC OPERATION, SUBTRACT BOTH VALUES.
                                          ; CMP VALUE TO BE SUBTRACTED FROM, THE VALUE TO SUBTRACT
                                          ; THE RESULT WILL BE VISIBLE IN THE FLAGS.

      MOV BX,NUMBEROFSUBJECTS
      CMP BX, LOOPCOUNTER   ; COMPARE THE VALUES OF THE NUMBER OF SUBJECTS THE NUMBER OF TIMES THE TAKEGRADEFORSUBJECT HAS LOOPED  
      JE PRESENTAVERAGE     ; JE = JUMP IF EQUAL TO 
      MOV BX, LOOPCOUNTER   ; MOVE THE VALUE OF THE LOOP COUNTER TO BX REGISTER FOR INC OPERATION, ANY VACANT REGISTER WILL WORK
      INC BX                ; INCREMENT LOOP COUNTER VALUE INSIDE OF THE BX REGISTER
      MOV LOOPCOUNTER, BX   ; RETURN THE INCREMENTED VALUE BACK TO THE MEMORY ADDRESS.     
      MOV BX,NUMBEROFSUBJECTS
      CMP BX, LOOPCOUNTER
      JGE TAKEGRADEFORSUBJECT   ; JGE = JUMP IF GREATER THAN OR EQUAL TO


    PRESENTAVERAGE: 
    
      MOV DX, OFFSET NEWLINE
      MOV AH,09
      INT 21H 
       
      LEA DX, AVERAGE 
      MOV AH, 09H ;OUTPUT
      INT 21H
      
      
      MOV AX, TOTALSUMOFGRADESOFAVERAGE 
      MOV BX, TOTALSUMOFGRADESOFAVERAGE ; Load the low word of TOTALSUMOFGRADESOFAVERAGE into BX
      MOV CX, 2                         ; Set the number of decimal places to print
      
      MOV DX, 0               ;avoid overflow error, set dx to 0h
      DIV NUMBEROFSUBJECTS    ; THE RESULT SHOULD BE AT THE AX REGISTER.  

      MOV totalAverage,ax    ; transfer the average towards the averageVariable
      CALL PRINT_NUM         ; PRINTS NUMBER IN AX REGISTER.

      RET   ; RETURNS CONTROL TO THE PROCEDURE THAT CALLED 
            ; THE PROCEDURE WHERE RET IS USED.      

RECEIVEGRADESANDPRESENTAVERAGE ENDP



  

DEFINE_SCAN_NUM  
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS 


  

        END     MAIN