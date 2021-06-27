	.text 

	.equ PIXEL_BUFF, 0xC8000000	// Pixel buffer address
	.equ CHAR_BUFF, 0xC9000000	// Character buffer address

	.global VGA_clear_charbuff_ASM //No parameters
	.global VGA_clear_pixelbuff_ASM // No parameters  
	.global VGA_write_char_ASM //parameters x[R0], y[R1], char c[R2]
	.global VGA_write_byte_ASM //parameters x[R0], y[R1], char byte[R2]

	.global VGA_draw_point_ASM //parameters x[R0], y[R1], short colour[R2]

	.equ H_PIXEL_RES, 320
	.equ V_PIXEL_RES, 240
	
	.equ H_CHAR_RES, 80
	.equ V_CHAR_RES, 60
	
	BASE .req R5
	OFST .req R6

/* VGA_clear_charbuff_ASM: Clears the entire char buffer to 0
*/
VGA_clear_charbuff_ASM:
						PUSH {R0-R10,LR} 		// PUSH the state for the function call
						LDR R2, =CHAR_BUFF 		// Holds  the location of the CHAR BUFFER
						MOV R3, #0  			// R3 = X counter
						MOV R4, #-1   			// R4 = Y counter 
					    MOV R7, #0 				// R7 = 0 (Final Character address)
						MOV R8, #0 				// Holds an empty value
						LDR R9,  =H_CHAR_RES	// Horizontal resolution
						LDR R10, =V_CHAR_RES	// Verticle resolution		
CLEAR_CHARY_LOOP:
						ADD R4,R4, #1 			//Increment the Y value
						CMP R4, R10 			// if (y == V_CHAR_RES)
						BEQ COMPLETE_CHAR_LOOP  //		GOTO: COMPLETE_CHAR_LOOP
						MOV R3, #0 				// X = 0

CLEAR_CHARX_LOOP:
						CMP R3, R9  			// if (x == H_CHAR_RES)
						BEQ CLEAR_CHARY_LOOP	//		GOTO: CLEAR_CHARY_LOOP
						LSL R6, R4, #7			// R6 = y << 7
						ORR R6, R6, R3			// R6 |= x (R6 is the offset)
						ADD R7, R2, R6			// R7 = R2 (CHAR_BUFF) + R6 (OFFSET)
						STRB R8, [R7]    		// Store 0 at the char address
						ADD R3,R3,#1			// x++
						B CLEAR_CHARX_LOOP		// GOTO: CLEAR_CHARX_LOOP
COMPLETE_CHAR_LOOP:
						POP {R0-R10,LR}			// Restore state
						BX LR


/* VGA_clear_pixelbuff_ASM: Clears the entire pixel buffer to 0
*/
VGA_clear_pixelbuff_ASM:
					PUSH {R0-R10,LR} 		// PUSH the state for the function call
					LDR R2, =PIXEL_BUFF 	// Holds  the location of the PIXEL_BUFFER
					MOV R3, #0  			// R3 = X counter
					MOV R4, #-1   			// R4 = Y counter 
					MOV R7, #0 				// R7 = 0 (Final Character address)
					MOV R8, #0 				// Holds empty value
					LDR R9,  =H_PIXEL_RES	// Horizontal resolution
					LDR R10, =V_PIXEL_RES	// Verticle resolution
CLEAR_PIXELY_LOOP:  
					ADD R4, R4, #1 			// y++
					CMP R4, R10 			// if (y == V_PIXEL_RES)
					BEQ COMPLETE_PIXEL_LOOP // 		GOTO: COMPLETE_PIXEL_LOOP
					MOV R3, #0 				// New Y row, reset the value

CLEAR_PIXELX_LOOP:
					CMP R3, R9  			// if (x == H_PIXEX_RES)
					BEQ CLEAR_PIXELY_LOOP	// 		GOTO: CLEAR_PIXELY_LOOP
					LSL R6, R4, #10			//	R6 = y << 10;	 
					LSL R7, R3, #1			//	R7 = x << 1;
					ORR R6, R6, R7			//  R6 |= R7 (Add shifted x and y). R6 is the offset
					ADD R7, R2, R6			//  R7 = R0 (PIXEL_BUFF) + R6 (Offset). R7 is the address for a given x,y
					STRH R8, [R7]    		//	*R7 = 0 
					ADD R3, R3, #1			// x++
					B CLEAR_PIXELX_LOOP		// GOTO: CLEAR+_PIXELX_LOOP

COMPLETE_PIXEL_LOOP:
					POP {R0-R10,LR}		    // Pop state of stack
					BX LR					// Branch to link register


/* VGA_write_char_ASM: Writes a character to the at a given (x,y) coordinate
	R0 -> int x
	R1 -> int y
	R2 -> char c
*/
VGA_write_char_ASM:
					PUSH {R0-R10,LR}		// Store state
					LDR R3, =H_CHAR_RES		// R3 = H_CHAR_RES
					LDR R4, =V_CHAR_RES		// R4 = H_CHAR_RES
					LDR R5, =CHAR_BUFF		// R5 = CHAR_BUFF

					// Defensive checks:
					CMP R0, R3 				// if (x >= H_CHAR_RES)
					BGE COMPLETE_WRITE_CHAR //		GOTO: COMPLETE_WRITE_CHAR
					CMP R0, #0				// if (x < 0)
					BLT COMPLETE_WRITE_CHAR //		GOTO: COMPLETE_WRITE_CHAR
					CMP R1, R4 				// if (y >= V_CHAR_RES)
					BGE COMPLETE_WRITE_CHAR //		GOTO: COMPLETE_WRITE_CHAR
					CMP R1, #0				// if (y < 0)
					BLT COMPLETE_WRITE_CHAR //		GOTO: COMPLETE_WRITE_CHAR

					MOV R3, #0 //Y offset
					MOV R4, #7 //X offset

					LSL R6, R1, #7			// R6 = y << 7 
					ORR R6, R6, R0			// R6 |= x (R6 is the offset)
					ADD R7, R5, R6			// R7 = R5 (CHAR_BUFF) + R6 (OFFSET) 
					STRB R2, [R7] 			// Store charachter at address

COMPLETE_WRITE_CHAR:
					POP {R0-R10,LR}
					BX LR


/* VGA_write_byte_ASM: Writes the hexadecimal representation of the value passed in the third
					   arg to the screen.
	R0 -> int x
	R1 -> int y
	R2 -> char byte
*/
VGA_write_byte_ASM:
					PUSH {R4-R10,LR}	 	// Store the state
					LDR R5, =CHAR_IN_HEX	// Points to the first character 
					MOV R3, R2				// R3 = R2 (read-only copy)  
					LSR R2, R3, #4			// R2 = R3 >> 4 (Remove the first 4 bits)
					AND R2, R2, #15			// R2 &= (1111) (Get last 4 bits of byte). R3 will range from
											// 0 (0000) to 15 (1111 or F)
					LDRB R2, [R5, R2]		// R2 = *(R5 + R2) (Get ascii character code)
					BL VGA_write_char_ASM	// Write the character
					AND R2, R3, #15			// Get first 4 bits of byte
					LDRB R2, [R5, R2]		// R2 = *(R5 + R2) (Get ascii character code)
					ADD R0, R0, #1 			// x = x + 1 
					BL VGA_write_char_ASM	// Write the character

					POP {R4-R10,LR}
					BX LR

/* VGA_draw_point_ASM: Draws a point on the screen with the colour (in the third argument )
	R0 -> int x
	R1 -> int y
	R2 -> short colour
*/
VGA_draw_point_ASM:
					PUSH {R4-R10,LR}		// Store the state
					LDR R5, =PIXEL_BUFF 	// Holds  the location of the PIXEL_BUFFER

					LSL R6, R1, #10			//	R6 = y << 10;	 
					LSL R9, R0, #1			//	R9 = x << 1;
					ORR R6, R6, R9			//  R6 |= R9 (Add shifted x and y). R6 is the offset
					ADD R7, R5, R6			//  R7 = R5 (PIXEL_BUFF) + R6 (Offset). R7 is the address for a given x,y 
					STRH R2, [R7]			//  *R7 = R2

					POP {R4-R10,LR}
					BX LR


// Memory for converting between hex and ascii
CHAR_IN_HEX: 	.ascii "0123456789ABCDEF"


.end
