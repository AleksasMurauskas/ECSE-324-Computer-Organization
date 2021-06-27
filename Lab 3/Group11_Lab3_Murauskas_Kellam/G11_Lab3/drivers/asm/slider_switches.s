		.text
		.equ SW_BASE, 0xFF200040			// Note: .equ is like #define in C
											// . word is like unsigned int int C
											// See: https://stackoverflow.com/questions/21624155/difference-between-equ-and-word-in-arm-assembly
		.global read_slider_switches_ASM

read_slider_switches_ASM:
		LDR R1, =SW_BASE
		LDR R0, [R1]
		BX LR
		.end
