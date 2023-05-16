

      INCLUDE EMU8086.INC     ;Including Library

      org 100h

      .data       ;Data Segment
                      
        numberOfLoop      dw 0h
        totalSumOfInput   dw 0h 
        latestInput       dw ?
        totalAverage      dw 0h
        newLine           dw 10,13,'$'

        valueToCheck      dw -1d
        
        isGradeInputValid dw 0h

        resultOfCalculationMessage   dw   10,13, '     AVERAGE: $'
        continuationChoice           dw   10,13, 'enter more numbers for average (1)    show average and end program (0)',10,13,'$'                                                
        enterInput                   dw   10,13, 'enter input for average: ',10,13 ,'$'
        
        askUserIfTheyWantToContinueUsingProgram db 10,13,10,13,'DO YOU WANT TO CALCULATE A NEW AVERAGE?   ',10,13,'         (PRESS 1) YES         ( PRESS 0 ) NO',10,13,'$'
        
        wrongChoiceForProgramContinuation db 10,13, '         PLEASE ENTER A VALID VALUE', 10,13, '         ENTER A NEW CHOICE AGAIN','$'
        
        ;message for evaluating average of gr ades
        unsatisfactoryMessage       db 10,13, '     Your grades did not reach the minimum passing marks.',10,13,'     Try again next semester!$'
        fairlySatisfactoryMessage   db 10,13, '     Your grades met the passing marks.',10,13,'     Congratulations you Passed!$'
        satisfactoryMessage         db 10,13, '     Your grades are great and exceeded the passing marks.',10,13,'      Congratulations you Passed!$'
        verySatisfactoryMessage     db 10,13, '     Your grades have exceeded expectations.',10,13,'     Congratulations for your Hard Work!$'

        ;message for showing subjects needing grades.
        programStartPrompt         dw     10,13,'             ----ELEMENTARY GRADING SYSTEM----',10,13, 'Please enter values for the SUBJECTS in order to calculate the average. ',10,13, 'THE AVERAGE WILL BE PRESENTED WHEN ALL SUBJECTS ARE FILLED WITH VALUE',10,13, '$'
        promptForMathInput         db     10,13,' 1: MATH : $'
        promptForEnglishInput      db     '2: ENGLISH : $'
        promptForScienceInput      db     '3: SCIENCE : $'
        promptForPhycicalEducInput db     '4: PHYSICAL EDUCATION : $'
        promptForAralPanInput      db     '5: ARALING PANLIPUNAN : $'

        ;message for program exceptions 
        invalidInputMessage       dw      10,13,10,13,'       A grade CANNOT be greater than 100. ',10,13,'       PLEASE ENTER NUMERIC VALUES RANGING FROM 1 TO 100.',10,13,10,13,'$'
        negativeValueMessage      db      10,13,10,13,'       A grade CANNOT be 0 and Lower.',10,13,10,13,'$'
        userDidNotEnterAnything   db      10,13,10,13,'       PLEASE ENTER A VALUE FOR THE GRADE OF THE SUBJECT',10,13,10,13,'$'
        noValidChoiceProvided     db      10,13,10,13,'       PLEASE PROVIDE A VALID ANSWER!',10,13,10,13,'  PRESS 1 FOR YES    OR   PRESS 2 FOR NO ',10,13,10,13,'$'
        
        ;variables holding the grades , THE INITIAL VALUES WILL BE REPLACED WITH USER INPUT
        mathGrade              dw 0h
        scienceGrade           dw 0h
        englishGrade           dw 0h
        aralPanGrade           dw 0h
        physicalEducationGrade dw 0h



        
      ;----------------RETRIEVING NUMERICAL INPUT---------------------
      
      ; scan_num is a procedure from the EMU8086 library for retrieving numerical input
      ; the numerical input retrieved by the scan_num procedure is located on the cx register
      
      ; in order to invoke scan_num procedure, the CALL command is used
      ; the command executes a procedure, and accepts a single parameter
      ; the parameter accepts the name of the procedure to execute 

      ; SYNTAX: call scan_num 
      
      ;----------------RETRIEVING NUMERICAL INPUT---------------------

      ;----------------PRINTING OUT A STRING TO THE CONSOLE---------------------
      
      ; To print out a message to the console. The program utilizes the BIOS interrupt,
      ; because it is faster than invoking the PRINT procedure. 
      
      ; To print a message with interrupt
      ; 1. AH register needs 09h value, the ah register acts as a signature for 
      ; identifying the interrupt to be interrupted. 
      ; SYNTAX: MOV AH, 09 

      ; 2. The value 21h needs to be passed to the interrupt command.
      ; SYNTAX: INT 21H       

      ; THEN PREPARING THE MESSAGE . 
      ; 1. the message variable must be defined in the data segment.
      ;             NAME        MEMORY ALLOCATION         CONTENT         NECESSARY SUFFIX
      ; SYNTAX:  Variable_name        db             'MESSAGE CONTENT'  ,     '$'
      ;           

      ; 2. the ADDRESS of the DATA segment must be inside the DS register
      ;            |any register that       |
      ;            |can hold 16 bit address |   |'@' (necessary) + DATA|
      ;SYNTAX: mov     ax                     ,       @DATA
      ;
      ;             |transfer content of ax to ds |
      ;        mov     ds , ax

      ; 3. then the ADDRESS of the message must be inside of the DX register
      ;   METHOD 1: use MOV and OFFSET 
      ;   METHOD 2: use LEA 
      ;
      ; SYNTAX FOR METHOD 1: MOV DX, OFFSET STRING_VARIABLE 
      ;
      ; SYNTAX FOR METHOD 2: LEA DX, STRING_VARIABLE 

      ; printing a message looks like this.
      ; SYNTAX: MOV DX, offset STRING_VARIABLE 
      ;         MOV ah, 09H
      ;         int 21h
      
      ;----------------PRINTING OUT A STRING TO THE CONSOLE---------------------



      .code       ;Code Segment

        MAIN PROC
            
          MOV AX, @data ;retrieve address of DATA SEGMENT
          MOV DS, AX    ;move address of DATA SEGMENT to DS register


          startOfProgram: 
            call gradesInput          ;ACCEPT GRADES
              
            call averageFinderForGrades   ;CALCULATE AVERAGE OF GRADES

            call gradeEvaluation    ;PROVIDE FEEDBACK FOR AVERAGE OF GRADES

          decideWhetherOrNotToContinueProgram:
          
          
          ;print message to ask user whether or not to terminate program
          ; or continue using program 

          mov dx, offset askUserIfTheyWantToContinueUsingProgram
          mov ah,09
          int 21h
          
          call scan_num 

          cmp cx, 1 ; if user wants to use the program again, they should press 1
          je startOfProgram
          
          cmp cx, 2 ; if user wants to quit, they should press 0
                    ; don't use 0 because if user presses enter without
                    ;pressing any key, 0 is the default value that will 
                    ;be retrieved, any number other than 0 is safe

          je closeProgram 

          ; an unconditional jump is placed after all the conditional jumps because
          ; the program should ask the user again if they want to continue or not
          ; this is necessary because the user must choose whether or not to terminate
          ; the program or continue using the program.
          
          mov dx, offset noValidChoiceProvided
          mov ah,09
          int 21h

          jmp decideWhetherOrNotToContinueProgram
          

          closeProgram:
          
          ;end code
          mov ah, 4ch 
          int 21h
          
          ret
        MAIN ENDP 

        averageFinderForGrades proc 
          
          ;----- COMBINE ALL GRADES INTO A SINGLE VALUE ---------
          mov ax, mathgrade
          add ax, scienceGrade
          add ax, englishGrade
          add ax, aralPanGrade
          add ax, physicalEducationGrade
          ;----- COMBINE ALL GRADES INTO A SINGLE VALUE ---------
          
          mov dx,0 ; AVOID OVERFLOW BY PUTTING 0 inside of dx register
          mov bx, 05h ;there are 5 subjects available, so 5 is the divisor.
          div bx
          
          mov totalaverage, ax ; pass the average to the container variable 

          ;----- print out average ----------------- 
          mov dx, offset resultOfCalculationMessage
          mov ah,09h
          int 21h

          mov ax, totalaverage
          call print_num 
          ;----- print out average -----------------
          
          ret ; must return control back to line of execution in main proc. 
        averageFinderForGrades endp 

        gradesInput proc 

          ;print out starting message. 
          mov dx, offset programStartPrompt
          mov ah,9h
          int 21h
          
          ;---------------MATH-----------------------
          retrieveGradeForMath:
          mov dx, offset promptForMathInput
          mov ah,9h
          int 21h

          call scan_num 
          
          mov valuetocheck,cx
          call valueInputCheck

          cmp isgradeinputvalid, 1h
          je retrieveGradeForMath

          mov mathgrade,cx

          mov dx, offset newLine
          mov ah,9h
          int 21h
          ;---------------MATH-----------------------

          ;---------------ENGLISH-----------------------
          retrieveGradeForEnglish:
          mov dx, offset promptForEnglishInput
          mov ah,9h
          int 21h

          call scan_num
          
          mov valuetocheck,cx
          call valueInputCheck

          cmp isgradeinputvalid, 1h
          je retrievegradeforenglish

          mov englishgrade,cx

          mov dx, offset newLine
          mov ah,9h
          int 21h
          ;---------------ENGLISH-----------------------


          ;---------------SCIENCE-----------------------
          retrieveGradeForScience:

          mov dx, offset promptForScienceInput
          mov ah,9h
          int 21h

          call scan_num

          mov valuetocheck,cx
          call valueInputCheck

          cmp isgradeinputvalid, 1h
          je retrieveGradeForScience

          mov scienceGrade,cx

          mov dx, offset newLine
          mov ah,9h
          int 21h

          ;---------------SCIENCE-----------------------


          ;---------------PHYSICAL EDUCATION------------
          retrieveGradeForPhysicalEducation:
          mov dx, offset promptforphycicaleducinput
          mov ah,9h
          int 21h

          call scan_num

          mov valuetocheck,cx
          call valueInputCheck

          mov dx, isgradeinputvalid
          
          cmp dx, 1h
          je retrieveGradeForPhysicalEducation

          mov physicaleducationgrade,cx

          mov dx, offset newLine
          mov ah,9h
          int 21h

          ;---------------PHYSICAL EDUCATION-----------------------
          

          ;---------------ARAL PAN-----------------------
          retriveGradeForAralPan: 
          mov dx, offset promptForAralPanInput
          mov ah,9h
          int 21h

          call scan_num
          
          mov valuetocheck,cx
          call valueInputCheck

          mov dx, isgradeinputvalid
          cmp dx, 1h
          je retriveGradeForAralPan
          
          mov aralpangrade,cx

          mov dx, offset newLine
          mov ah,9h
          int 21h
          ;---------------ARAL PAN---------------------
          ret
        gradesInput endp 
        
        ; input validator procedure. 
        ; this procedure checks the value of a variable
        ; called valuetocheck.
        ; a variable is used as a way to pass values 
        ; because using the register would increase the
        ; chances of changing the behaviour of the built-in
        ;commands and library procedures.
        valueInputCheck proc

          mov bx, valuetocheck

          cmp bx,101    ; greater than 100 is invalid 
          jge inputIsGreaterThanExpected


          cmp bx, -1
          je noInputFromUser

          cmp bx,0      ; 0 is invalid 
          jle inputnegativeIsNotValid

          jmp inputisvalid  ; if all check conditions are not
                            ; triggered then input is valid  
          
          noInputFromUser: 
            mov dx, offset userDidNotEnterAnything
            mov ah,09h
            int 21h
            jmp inputIsNotValid

          inputnegativeIsNotValid:    
            mov dx, offset negativeValueMessage
            mov ah,09h
            int 21h
            jmp inputIsNotValid

          inputIsGreaterThanExpected:

            mov dx, offset invalidInputMessage
            mov ah,09h
            int 21h
            jmp inputIsNotValid

          inputIsNotValid: 
            mov bx, 1h      ; 1 is a value that represents there is an error 
                            ; error with the user input. 

            mov isgradeinputvalid, bx ; transfer the value to isgradeinputvalid

            jmp endOfProcedure

          inputIsValid:
            mov bx, 0h
            mov isgradeinputvalid, bx
            jmp endOfProcedure

          endOfProcedure:
          ret

        valueInputCheck endp   
        
        gradeEvaluation proc
        
          mov bx, totalaverage

          cmp bx, 74
          jle gradeUnSatisfactory
          
          cmp bx, 75 
          jge gradePassed 

          ;grade is unsatisfactory 74  and below
          gradeUnSatisfactory:

            mov dx, offset unsatisfactoryMessage  
            mov ah,09h
            int 21h
            jmp closetheprogram 
          

          gradePassed:

            ;grade is very satisfactory 85 - 100
            cmp bx, 85
            jge gradeVerySatisfactory 

            ;grade is satisfactory 80 - 84
            cmp bx, 80
            jge gradeSatisfactory
          
            ;grade is fairly satisfactory, 75 - 79 
            cmp bx, 74
            jge gradeSatisfactory

          gradeVerySatisfactory:

            mov dx, offset verySatisfactoryMessage  
            mov ah,09h
            int 21h
            jmp closetheprogram 
          
          gradeSatisfactory:    

            mov dx, offset satisfactoryMessage  
            mov ah,09h
            int 21h
            jmp closetheprogram 

          gradeFairlySatisfactory:
          
            mov dx, offset fairlySatisfactoryMessage  
            mov ah,09h
            int 21h 
            jmp closetheprogram

          closeTheProgram:
            ret ; RETURN CONTROL TO THE CALLER OF THE PROCEDURE, 
                ; WARNING: THE EXIT OF THE PROGRAM CANNOT BE PLACED ON 
                ; ANOTHER PROCEDURE, IT MUST BE WITHIN THE MAIN PROCEDURE
                ; OR ELSE THERE WILL BE LOOPING BUGS. 
        gradeEvaluation endp
        
      DEFINE_SCAN_NUM
      DEFINE_PRINT_NUM
      DEFINE_PRINT_NUM_UNS    ;this is necessary even if it is not called or used in the program.

      END main

      HLT         ;Halting                                            
      ret         ;Return