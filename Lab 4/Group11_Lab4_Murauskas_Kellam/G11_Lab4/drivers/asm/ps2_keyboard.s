		.text
		.global read_PS2_data_ASM
		.equ PS2_DATAREG, 0xFF200100

/*read_PS2_data_ASM: Read data from the keyboard
	-> R0 - char* data_to_be_read
*/
read_PS2_data_ASM: //Parameters R0 is the character pointer

	PUSH {R4-R10}				// Store state
	LDR R2, =PS2_DATAREG		// Get PS2 data register address
	LDR R1, [R2]				// Load in PS2 data register contents
	MOV R3, #0x8000				// 16th bit (to get RVALID)
	MOV R4, #0xFF				// 8 bit mask (to get Data)
	AND R5, R1, R3				// R5 = R1 (PS2_Data) & R3 (0x8000) [Get the RVALID bit]
	CMP R5, #0					// if (RVALID == 0)
	MOVEQ R0, #0				// 	Return 0
	POPEQ {R4-R10}
	BXEQ LR

	AND R6, R1, R4				// R6 = R1 (PS2_Data) & R4 (0xFF) [Get Data]
	STRB R6, [R0] 				// Store R6 data byte into the memory pointed to by R0 (data_to_be_read)
	
	POP {R4-R10}				
	MOV R0, #1					// Return 1
	BX LR 


	.end