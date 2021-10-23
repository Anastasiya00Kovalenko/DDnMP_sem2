		GET stm32_EQU.s

MAX_SIZE EQU 0xA

		AREA CONSTANT_FLASH, DATA, READONLY

mas DCB 1, 6, 36, 19, 147, -94, -44, 85, -5, 48
		AREA VERIABLE_RAM, DATA, READWRITE
			
mas_out SPACE 0x40
	
			AREA MAIN, CODE, READONLY
			THUMB

main PROC
	
	LDR R0, =mas            ;исходный массив 
    LDR R1, =mas_out        ;выходной массив 
    MOV R2, #40             ;длина массива
    MOV R3, #0              ;смещение адреса массива 
    MOV R5, R3              ;регистр для временного хранения элемента масива

; КОПИРОВАНИЕ В RAM ИСХОДНОГО МАССИВА                
COPY
    LDR R4, [R0, R3]        ;чтение в R4 с паяти по адресу R0 + R3
    STR R4, [R1, R3]        ;запись R4 в RAM по адресу R1 + R3
    ADD R3, #4              ;сложение R3 = R3 + 4
    CMP R3, R2              ;сравнение R3 и R2  
    BEQ FOR                 ;если R3 = R2, то переход в FOR
    B   COPY                ;безусловный переход в COPY

; СРАВНЕНИЕ ЭЛЕМЕНТОВ МАССИВА
FOR
    SUB R2, #4              ;вычитание R2 = R2 - 4
    MOV R3, #0              ;копирование в R3 ноль
    CBZ R2, loop            ;если R2 = 0, то переход в loop

COMP                                  
    CMP R3, R2              ;сравнение R3 и R2
    BEQ FOR                 ;если R3 = R2, то переход в FOR
    LDR R0, [R1, R3]        ;чтение в R0 с паяти по адресу R1 + R3
    ADD R6, R3, #4          ;сложение R6 = R3 + 4
    LDR R4, [R1, R6]        ;чтение в R4 с паяти по адресу R1 + R3 (следующий элемент массива)
    CMP R0, R4              ;сравнение R0 и R4
    BGT REP                 ;если R0 > R4, то переход в REP
    ADD R3, #4              ;сложение R3 = R3 + 4
    B   COMP                ;безусловный переход в COMP

;МЕНЯЕМ МЕСТОМИ ЭЛЕМЕНТЫ МАССИВА                
REP                                   
    MOV R5, R0              ;копирование R0 в R5
    STR R4, [R1, R3]        ;запись R4 в память по адресу R1 + R3
    STR R5, [R1, R6]        ;запись R4 в память по адресу R1 + R6
    ADD R3, #4              ;сложение R3 = R3 + 4
    B   COMP                ;безусловный переход в COMP                ;
loop 

			B loop 

ENDP