	.text

	.global write_audio_FIFO_ASM
	.equ FIFO_LOCATION, 0xFF203044
	.equ LEFT_LOCATION,0xFF203048
	.equ RIGHT_LOCATION,0xFF20304C
	.equ MASK,0xFFFF0000


/*write_audio_FIFO_ASM: Writes data to the left and right channels
	R0 -> int data
*/
write_audio_FIFO_ASM:
	
	PUSH {R4-R7, LR}
	LDR R1, =FIFO_LOCATION			// Pointer to fifospace 
	
	LDR R4, [R1]					// Load fifiospace
	LDR R6, =MASK					// Load mask
	ANDS R4, R6						// Get top 16 bits of fifospace
	MOVEQ R0, #0					// if (no capacity left) {
	POPEQ {R4-R7, LR}				// Branch out. Unable to write to buffer.
	BXEQ LR 

	LDR R2, =LEFT_LOCATION			// Pointer to leftdata
	LDR R3, =RIGHT_LOCATION			// Pointer to rightdata		
	STR R0, [R3]					// Store data in right data
	STR R0, [R2]					// Store data in left data
	
	
	MOV R0, #1 						// Return 1 for a success state 
	POP {R4-R7, LR}
	BX LR
