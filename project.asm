;============================================================================
;                   COAL LAB PROJECT                                        |
;                   TIC TIAC TOE GAME                                       |
;   GROUP MEMBERS:                                                          |
;          "       M SIBTAIN ASAD     (BITF19M008)  "                       |
;          "       M UMAIR            (BITF19M029)  "                       |
;          "       FATIMA MEHMOOD     (BITF19M019)  "                       | 
;          "       AYESHA ZAFAR DAR   (BITF19M043)  "                       |
;          "       FATIMA FARUKH      (BITF19M051)  "                       |
;============================================================================



;============================================================================
;      declaration of model and stack                                       |                               
;============================================================================
.MODEL SMALL
.STACK 100H


;============================================================================
;      data area                                                            |        
;============================================================================
.data

table db 9 dup("*")                      ; array for table of game

count dw 0                               ; counter

current db ?                             ; to store current plyer data

screen db "   *****************************", 0Ah, 0Dh,
          "   *                           *", 0Ah, 0Dh,
          "   *      TIC TAC TOE GAME     *", 0Ah, 0Dh,
          "   *                           *", 0Ah, 0Dh,
          "   *****************************", 0Ah, 0Dh, 0Ah, 0Dh,"$"   

disScn db "   *************************************", 0Ah, 0Dh,
          "   *                                   *", 0Ah, 0Dh,
          "   **    WELCOME TO TIC TAC TOE GAME  **", 0Ah, 0Dh,
          "   *                                   *", 0Ah, 0Dh,
          "   *************************************", 0Ah, 0Dh, 0Ah, 0Dh, "$"

membrs db "   GROUP MEMBERS:                       ", 0Ah, 0Dh, 0Ah, 0Dh,
          "       M SIBTAIN ASAD     (BITF19M008)  ", 0Ah, 0Dh,
          "       M UMAIR            (BITF19M029)  ", 0Ah, 0Dh,
          "       FATIMA MEHMOOD     (BITF19M019)  ", 0Ah, 0Dh,
          "       AYESHA ZAFAR DAR   (BITF19M043)  ", 0Ah, 0Dh,
          "       FATIMA FARUKH      (BITF19M051)  ", 0Ah, 0Dh, 0Ah, 0Dh,
          "Press any key to continue...  $" 

space  db "        $"             ; to print some spaces 
linef  db 0AH, 0DH ,"$"           ; to move to next line

inputLine1 db "Player 1's turn <0> ", 0Ah, 0Dh, "$"   
inputLine2 db "Player 2's turn <X> ", 0Ah, 0Dh, "$"

row db 0Ah, 0Dh, "      Enter row (1-3)  $"
col db 0Ah, 0Dh, "      Enter col (1-3)  $"


tieScr db "   *****************************", 0Ah, 0Dh,       
          "   *                           *", 0Ah, 0Dh,
          "   *         MATCH TIE         *", 0Ah, 0Dh,
          "   *                           *", 0Ah, 0Dh,
          "   *****************************", 0Ah, 0Dh, 0Ah, 0Dh,"$"

winner1 db"   *********************************", 0Ah, 0Dh,
          "   *                               *", 0Ah, 0Dh,
          "   *   CONGRATULATIONS !!!         *", 0Ah, 0Dh,
          "   *   PLAYER 01 <0> WON THE GAME  *", 0Ah, 0Dh,
          "   *                               *", 0Ah, 0Dh,
          "   *********************************", 0Ah, 0Dh, 0Ah, 0Dh,"$"

winner2 db"   *********************************", 0Ah, 0Dh,
          "   *                               *", 0Ah, 0Dh,
          "   *   CONGRATULATIONS !!!         *", 0Ah, 0Dh,
          "   *   PLAYER 02 <X> WON THE GAME  *", 0Ah, 0Dh,
          "   *                               *", 0Ah, 0Dh,
          "   *********************************", 0Ah, 0Dh, 0Ah, 0Dh,"$"          

invalid db  0Ah, 0Dh, "OOPS!!! INVALID INPUT" , 0Ah, 0Dh, "Try again ... " , 0Ah, 0Dh, "$"




;============================================================================
;        CODE AREA STARTS                                                   |                  
;============================================================================
.code

main proc
mov ax, @data
mov ds, ax          ; storing memory area to DS register

call displayScreen  ; calling function to display home screen interface
call print          ; calling function to print the table 

mov current, "0"    ; starting game with player 1 <0>
mov cx, 9           ; as game contains 9 loops so set CX 9

input:              ; loop to take 9 inputs max
  cmp current,"0"   ; comparing for player 1 <0>
  JE input1         ; jump to input for player 1 <0>
  JMP input2        ; otherwise player 2 <X>
return:             ; returning progression after taking input
  call print        ; again print

loop input         
call tie            ; if 9 loops done without any result, game will tie
jmp terminate_      ; terminate program 



;============================================================================
;        INPUT PLAYER ONE <0>                                               |                  
;============================================================================
input1:             ; first player 1 <0> input 
  
  mov ah, 9         ; input prompt 
  lea dx, inputLine1
  int 21H

  mov ah, 9         ; row input 
  lea dx, row
  int 21H

  mov ah, 1
  int 21h


mov count, 0        ; initialize counter 0 
increment1:         ; As for 2D array Algo, we need to multiply row with 3 and 
                    ; then add column to reach to the desired place
                    ; for this purpose we use count variable which will have the index
  cmp al, "1"      
  JE okay1          ; if al contains '1' then terminate the loop
  add count, 3
  dec al
  jmp increment1

okay1:

  mov ah, 9         ; input prompt for column
  lea dx, col     
  int 21H

  mov ah, 1
  int 21h

increase1:          ; loop for adding count (having row * 3) with column
  cmp al, "1"    
  JE put1           ; terminate loop in case of '1'
  inc count 
  dec al
jmp increase1

put1:
mov bx, count       ; store index in BX register as only BX can treat as array index
cmp table[bx],"*"   ; input validation (only have to put data if there was an *)
JE adding1          ; if valid index then move next

mov ah, 9           ; prompt in case of invalid input
lea dx, invalid
int 21H
JMP input1          ; again taking input 

adding1:            
mov table [bx], "0" ; store 0 at given index

call check_result   ; calling function to see if there is any winning condition

mov current, "X"    ; changing variable for player 2 turn

jmp return          ; return to start


;============================================================================
;        INPUT PLAYER TWO X0>                                               |                  
;============================================================================
input2:             ; first player 2 <X> input
  
  mov ah, 9         ; input prompt
  lea dx, inputLine2
  int 21H

  mov ah, 9
  lea dx, row       ; input row
  int 21H

  mov ah, 1
  int 21h


mov count, 0
increment2:         ; As for 2D array Algo, we need to multiply row with 3 and 
                    ; then add column to reach to the desired place
                    ; for this purpose we use count variable which will have the index
  cmp al, "1"       ; if al contains '1' then terminate the loop
  JE okay2
  add count, 3
  dec al
  jmp increment2

okay2:

  mov ah, 9         ; input prompt for column
  lea dx, col
  int 21H

  mov ah, 1
  int 21h

increase2:         ; loop for adding count (having row * 3) with column
  cmp al, "1"      ; input validation (only have to put data if there was an *)
  JE put2          ; if valid index then move next
  inc count 
  dec al
jmp increase2

put2:
mov bx, count       ; store index in BX register as only BX can treat as array index

cmp table[bx], "*"  
JE adding2

mov ah, 9           ; prompt in case of invalid input
lea dx, invalid
int 21H
JMP input2

adding2:

mov table [bx], "X" ; store X at given index

call check_result   ; calling function to see if there is any winning condition

mov current, "0"    ; changing variable for player 1 turn

jmp return


terminate_:         ; program termination 

MOV AH, 4CH
INT 21H

MAIN ENDP



;============================================================================
;        FUNCTION TO PRINT THE TABLE IN CORRECT FORMATE                     |                  
;============================================================================
print proc

  mov ah, 00  
  mov al, 02
  int 10h           ; clearing screen

  mov ah, 9
  lea dx, screen
  int 21h

  mov ah, 9
  lea dx, space
  int 21h

  mov ah, 2
  mov dl, table
  int 21h


  mov ah, 9
  lea dx, space
  int 21h

  mov ah, 2
  mov dl, table+1
  int 21h

  mov ah, 9
  lea dx, space
  int 21h

  mov ah, 2
  mov dl, table+2
  int 21h

  mov ah, 9
  lea dx, linef
  int 21h

  mov ah, 9
  lea dx, linef
  int 21h

  mov ah, 9
  lea dx, space
  int 21h

  mov ah, 2
  mov dl, table+3
  int 21h

  mov ah, 9
  lea dx, space
  int 21h

  mov ah, 2
  mov dl, table+4
  int 21h

  mov ah, 9
  lea dx, space
  int 21h

  mov ah, 2
  mov dl, table+5
  int 21h

  mov ah, 9
  lea dx, linef
  int 21h

  mov ah, 9
  lea dx, linef
  int 21h

  mov ah, 9
  lea dx, space
  int 21h

  mov ah, 2
  mov dl, table+6
  int 21h

  mov ah, 9
  lea dx, space
  int 21h

  mov ah, 2
  mov dl, table+7
  int 21h

  mov ah, 9
  lea dx, space
  int 21h

  mov ah, 2
  mov dl, table+8
  int 21h

  mov ah, 9
  lea dx, linef
  int 21h

  mov ah, 9
  lea dx, linef
  int 21h

ret
print endp

;============================================================================
;        FUNCTION TO PRINT DISPLAY SCREEN                                   |                  
;============================================================================
displayScreen proc

  mov ah, 00
  mov al, 02
  int 10h

  mov ah, 9
  lea dx, disScn
  int 21h

  mov ah, 9
  lea dx, membrs
  int 21h

  mov ah, 1
  int 21h
ret
displayScreen endp


;============================================================================
;        FUNCTION TO PRINT TIE GAME SCREEN                                  |                  
;============================================================================
tie proc

  call print

  mov ah, 9
  lea dx, tieScr
  int 21h

ret
tie endp


;============================================================================
;        FUNCTION TO CHECK WINNIG STATE                                     |      
; This function checks each row, column and diagonal of the table           |            
;============================================================================
check_result proc

  mov bl, current
  
first:
  cmp table[0], bl
  JNE second
  cmp table[1], bl 
  JNE second
  cmp table[2], bl  
  JE win
second:
  cmp table[3], bl 
  JNE third
  cmp table[4], bl 
  JNE third
  cmp table[5], bl 
  JE win

third:
  cmp table[6], bl
  JNE forth
  cmp table[7], bl
  JNE forth
  cmp table[8], bl
  JE win

forth:
  cmp table[0],bl 
  JNE fifth
  cmp table[3],bl 
  JNE fifth
  cmp table[6],bl
  JE win

fifth:
  cmp table[1],bl 
  JNE sixth
  cmp table[4],bl 
  JNE sixth
  cmp table[7],bl 
  JE win

sixth:
  cmp table[2],bl 
  JNE seventh
  cmp table[5],bl 
  JNE seventh
  cmp table[8],bl 
  JE win

seventh:
  cmp table[0],bl 
  JNE eigth
  cmp table[4],bl 
  JNE eigth
  cmp table[8],bl 
  JE win

eigth:
  cmp table[2],bl 
  JNE NotWin
  cmp table[4],bl 
  JNE NotWin
  cmp table[6],bl
  JE win
  jmp NotWin

win:
call printResult    ; calling result displaying function in case of player win

NotWin:
ret
check_result endp



;============================================================================
;        FUNCTION TO PRINT RESULT BY SHOWING CURRENT PLAYER AS WINNER       |                  
;============================================================================
printResult proc

  call print

  cmp current, "0"  ; if current is 0 then player 1 is winner 
                    ; otherwise player 2 is winner 
  JNE winneris2

winneris1:
  mov ah, 9
  lea dx, winner1
  int 21h
jmp terminate_2

winneris2:
  mov ah, 9
  lea dx, winner2
  int 21h

terminate_2:        ; using terminating intterupt as exit (0) 
mov ah, 4ch
int 21h
ret
printResult endp


END MAIN





;============================================================================
;        END                                                                |                  
;============================================================================
