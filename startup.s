		GET main.s



		PRESERVE8

		THUMB

		AREA RESET, CODE, READONLY

		DCD STACK_TOP 
		DCD startup 

		ENTRY

startup PROC 


		B main
		
		ENDP 
		END 