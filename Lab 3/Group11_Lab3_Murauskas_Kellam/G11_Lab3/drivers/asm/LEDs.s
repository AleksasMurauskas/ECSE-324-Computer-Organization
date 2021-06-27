		.text
		.equ LED_BASE, 0xFF200000			
		.global read_LEDs_ASM
		.global write_LEDs_ASM

// Load the value at the LEDs memory location into R0 and then branch to LR
read_LEDs_ASM:
		LDR R1, =LED_BASE
		LDR R0, [R1]
		BX LR

// Store the value in R0 at the LEDs memorgy location and then branch to LR
write_LEDs_ASM:
		LDR R1, =LED_BASE
		STR R0, [R1]		
		BX LR
		.end
