

INCLUDE EMU8086.INC     ;Including Library

org 100h

.data       ;Data Segment
                 
  numberOfLoop      dw 0h
  totalSumOfInput   dw 0h 
  latestInput       dw ?
  totalAverage      dw 0h
  newLine           dw 10,13,'$'

  valueToCheck      dw 0h
  
  isGradeInputValid dw 0h

  resultOfCalculationMessage   dw   10,13, '     AVERAGE: $'
  continuationChoice           dw   10,13, 'enter more numbers for average (1)    show average and end program (0)',10,13,'$'                                                
  enterInput                   dw   10,13, 'enter input for average: ',10,13 ,'$'
  
  askUserIfTheyWantToContinueUsingProgram db 10,13,10,13,'DO YOU WANT TO CALCULATE A NEW AVERAGE?   ',10,13,'         (1) YES         (2) NO',10,13,'$'
  
  wrongChoiceForProgramContinuation db 10,13, '         PLEASE ENTER A VALID VALUE', 10,13, '         ENTER A NEW CHOICE AGAIN','$'
  
  ;message for evaluating average of grades
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


  ;message for program events 
  invalidInputMessage       db      10,13,10,13,'       A grade CANNOT be greater than 100. ',10,13,'       PLEASE ENTER NUMERIC VALUES RANGING FROM 1 TO 100.',10,13,10,13,'$'

  ;variables holding the grades 
  mathGrade              dw 0h
  scienceGrade           dw 0h
  englishGrade           dw 0h
  aralPanGrade           dw 0h
  physicalEducationGrade dw 0h


.code       ;Code Segment

  MAIN PROC
      
    MOV AX, @data
    MOV DS, AX

    startOfProgram: 
    call gradesInput
    

    decideWhetherOrNotToContinueProgram:
    
    mov dx, offset askUserIfTheyWantToContinueUsingProgram
    mov ah,09
    int 21h
    
    call scan_num 

    cmp cx, 1
    je startOfProgram

    
    cmp cx, 0
    je closeProgram 

    jmp decideWhetherOrNotToContinueProgram
    
    closeProgram:
    ;end code
    mov ah, 4ch
    int 21h
    
    ret
  MAIN ENDP 

  average PROC


    jmp entryOfInput 
        
    entryOfInput: 
      mov dx, offset enterInput
      mov ah, 09
      int 21h
      
      call scan_num
      mov bx, totalSumOfInput
      add bx, cx
      
      mov totalSumOfInput, bx  
      mov bx, 0h
      
      mov latestInput, cx


      mov bx, numberOfLoop
      add bx, 1
      
      mov numberOfLoop, bx
      mov bx, 0h

      jmp decisionChoose 


    decisionChoose:           

      mov dx, offset continuationChoice         
      mov ah,09
      int 21h
      
      call scan_num 
      cmp cx, 0
      je displayResultFromComputation  
      
      cmp cx, 1
      je entryOfInput

      mov dx, offset wrongChoiceForProgramContinuation
      mov ah,09
      int 21h

      jmp decisionChoose
     

 
    displayResultFromComputation: 
        
      mov ax, totalSumOfInput
      mov bx, numberOfLoop

      MOV DX, 0 ; avoid overflow           
      div bx
      
      mov totalAverage,ax    
              
      mov dx, offset resultOfCalculationMessage
      mov ah,09
      int 21h
                        
      mov ax, totalAverage                     
      call print_num
      
      call gradeEvaluation
      
      ret
  average ENDP    
  
  averageFinderForGrades proc 
    
    mov ax, mathgrade
    add ax, scienceGrade
    add ax, englishGrade
    add ax, aralPanGrade
    add ax, physicalEducationGrade
    
    mov dx,0
    mov bx, 05h
    div bx
    
    mov totalaverage, ax


    mov dx, offset resultOfCalculationMessage
    mov ah,09h
    int 21h

    mov ax, totalaverage
    call print_num 

    ret 
  averageFinderForGrades endp 

  gradesInput proc 

   
    mov dx, offset programStartPrompt
    mov ah,9h
    int 21h
    
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

    call averageFinderForGrades
    call gradeEvaluation
    ret
  gradesInput endp 
  
  valueInputCheck proc

    mov bx, valuetocheck
    cmp bx,101
    jge inputIsNotValid

    jmp inputisvalid 
    
    inputIsNotValid: 
    
    mov dx, offset invalidInputMessage
    mov ah,09h
    int 21h
    
    mov bx, 1h
    mov isgradeinputvalid, bx

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

    ;grade is unsatisfactory 75 and below
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
      cmp bx, 75
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