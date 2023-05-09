

INCLUDE EMU8086.INC     ;Including Library

org 100h

.data       ;Data Segment
                 
  numberOfLoop      dw 0h
  totalSumOfInput   dw 0h 
  latestInput       dw ?
  totalAverage      dw 0h
 
  resultOfCalculationMessage   dw   10,13, 'the average of the input is :$'
  continuationChoice           dw   10,13, 'enter more numbers for average (1)    show average and end program (0)',10,13,'$'                                                
  enterInput                   dw   10,13, 'enter input for average: ',10,13 ,'$'
  
  wrongChoiceForProgramContinuation db 10,13, '         PLEASE ENTER A VALID VALUE', 10,13, '         ENTER A NEW CHOICE AGAIN','$'
  
  ;message for evaluating average of grades
  unsatisfactoryMessage       db 10,13, 'Your grades did not reach the minimum passing marks, Try again next semester!$'
  fairlySatisfactoryMessage   db 10,13, 'Your grades met the passing marks, Congratulations you Passed!$'
  satisfactoryMessage         db 10,13, 'Your grades are great and exceeded the passing marks, Congratulations you Passed!$'
  verySatisfactoryMessage     db 10,13, 'Your grades have exceeded expectations, Congratulations for your Hard Work!$'

  ;message for showing subjects needing grades.
  allSubjectsBlank dw  10,13,'1: MATH : ',10,13,'2: ENGLISH : ',10,13,'3: SCIENCE : ',10,13,'4: PHYSICAL EDUCATION : ',10,13,'5: ARALING PANLIPUNAN : ','$'

  ;variables holding the grades 
  mathGrade              db ?
  scienceGrade           db ?
  englishGrade           db ?
  aralPanGrade           db ?
  physicalEducationGrade db ?


.code       ;Code Segment

  MAIN PROC
      
    MOV AX, @data
    MOV DS, AX

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
      
      ;END THE PROGRAM 
      mov ah, 4ch
      int 21h
  MAIN ENDP    

    
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