		.text
		.equ HEX_0_to_3, 0xFF200020
		.equ HEX_4_to_5, 0xFF200030			
		.global HEX_clear_ASM
		.global HEX_flood_ASM
		.global HEX_write_ASM

// R0 -> hex
HEX_clear_ASM:
	push {LR}
	MOV R1, #0x000000
	BL WRITE_TO_HEX
	pop {LR}
	BX LR

HEX_flood_ASM:
	push {LR}
	MOV R1, #0x000006
	BL WRITE_TO_HEX
	pop {LR}
	BX LR

HEX_write_ASM:
	push {LR}
	//BL HEX_clear_ASM			// Clear displays
	LDR R3, =LOOKUP
	LDR R1, [R3, R1, LSL #2]
	BL WRITE_TO_HEX
	pop {LR}
	BX LR


// WRITE_TO_HEX: Writes a value to a subset of the DE1-SOC 7-segment displays
// ARGS: 
//			R0 - Flag register for selecting which display to write to.
//					Ex: 100101 writes to the 1st, 3rd and 5th hexidecimal displays
//			R1 - Value to write to each display
WRITE_TO_HEX:
		PUSH {R4-R8,LR} 		// Save state by pushing non-arg registers onto the stack
		MOV R7, R1				// Copy R1 into R7 (Read-only of val)
		LDR R1, =HEX_0_to_3
		LDR R2, =HEX_4_to_5
		MOV R3, #0				// R3 = count
		MOV R4, #1				// R4 is used as a bitmask to get each flag from R0

LOOP: 	TST R0, R4				// R0 & R4 - Apply bitmask
		BEQ SHIFT				// Continue. Bit is not set
		
		MOV R5, R7
		MOV R8, #0x00007F

		SUB R6, R3, #32

		CMP R3, #32			// R3 - 32
		LSLLT R5, R5, R3	// Shift the value into place
		LSLLT R8, R8, R3

		LSLGE R5, R5, R6
		LSLGE R8, R8, R6	

		NEG R8, R8			// Negate R8

		LDRGE R6, [R2]
		LDRLT R6, [R1]
		
		AND R6, R6, R8		// Apply mask
		ORR R5, R5, R6		// OR value
		STRGE R5, [R2]		// if (R3 >= 32) *R2 = R5		STRBGE
		STRLT R5, [R1]		// if (R3 < 32) *R1 = R5			STRBLT

SHIFT:  ADDS R3, R3, #8		// R3 += 8
		CMP R3, #48			// While (R3 < 7);
		POPEQ {R4-R8,LR}	// Restore state by popping R4 - LR from stack
		BXEQ LR				// Branch link out of routine
		LSL R4, R4, #1		// R4 << 1
		B LOOP				// GOTO  LOOP

LOOKUP:	.word 0x00003f	// 0
		.word 0x000006	// 1
		.word 0x00005b	// 2
		.word 0x00004f	// 3
		.word 0x000066	// 4
		.word 0x00006d	// 5
		.word 0x00007d	// 6
		.word 0x000007	// 7
		.word 0x00007f	// 8
		.word 0x000067	// 9
		.word 0x000077	// A
		.word 0x00007c	// B
		.word 0x000039	// C
		.word 0x00005e	// D
		.word 0x000079	// E
		.word 0x000071	// F

		.end
