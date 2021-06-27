#include <stdio.h>

#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/HEX_displays.h"

int main() {	

	// Flood 4 & 5 (These displays are not being used)
	HEX_flood_ASM(HEX4|HEX5);

	
	while(1){
		
		int switches_On = read_slider_switches_ASM(); 
		write_LEDs_ASM(switches_On);
		
		// Check furthest left switch to clear
		if(0x200 & switches_On){ 
			HEX_clear_ASM(HEX0|HEX1|HEX2|HEX3);
		}
		else{
			// Grab lowest 4 switches
			char switcher = 0xF & switches_On;
			
			// Get bottom 4 bits of push button data register & 0xFF2000050
			int push = 0xF & read_PB_data_ASM();
			
			// Write to single display
			HEX_write_ASM(push, switcher);
		}
	}
	return 0;
}
