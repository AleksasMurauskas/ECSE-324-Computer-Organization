#include <stdio.h> 


void test_char() {
	int x, y;
	char c = 0;

	for (y = 0; y < 59; y++)
		for (x = 0; x <= 79; x++)
			VGA_write_char_ASM(x, y, c++);
	
}

void test_byte() {
	int x, y;
	char c = 0;

	for (y = 0; y < 59; y++)
		for (x = 0; x <= 79; x+=3)
			VGA_write_byte_ASM(x, y, c++);

}

void test_pixel() {
	int x, y;
	unsigned short colour = 0;

	for (y = 0; y < 239; y++)
		for (x = 0; x <= 319; x++)
			VGA_draw_point_ASM(x,y,colour++);

}

void VGA_Test(){
	while(1){
		if(read_PB_data_ASM() == 1){
			if(read_slider_switches_ASM() == 0) {
				test_char();
			}
			else {
				test_byte();
			}
		}
		else if (read_PB_data_ASM() == 2) {
			test_pixel();
		}
		else if (read_PB_data_ASM() == 4) {
			VGA_clear_charbuff_ASM();
		}
		else if (read_PB_data_ASM() == 8) {
			VGA_clear_pixelbuff_ASM();
		}
	}
}

void ps2_Test(){
	VGA_clear_charbuff_ASM();
	VGA_clear_pixelbuff_ASM();

	char val;
	int x=0;
	int y=0;
	int xSpace = 3;
	int maximum[] = {80, 60};

	while(1){
		if(read_PS2_data_ASM(&val)!=0){
			VGA_write_byte_ASM(x,y,val);
			x+=xSpace;
			if(x >= maximum[0]){ // Checks if row is completed
				x=0; 
				y++;
				if(y >= maximum[1]){
					y=0;
					VGA_clear_charbuff_ASM();
				}
			}
		}
	}

}

void audio_Test(){
	int i = 0;
	while(1){

		// 48K samples/s / 100samples/s = 480 samples per period
		// 480 samples per period / 2 = 240 

		for(i=0;i<240;i++){
		
			if(write_audio_FIFO_ASM(0x00FFFFFF) !=1){
				i--;
			}
		}
		for(i=0;i<240;i++){
			
			if(write_audio_FIFO_ASM(0x00000000) !=1){
				i--;
			}
		}
		
	}
}

int main(){
	VGA_clear_charbuff_ASM();
	VGA_clear_pixelbuff_ASM();

	//VGA_Test();
	//ps2_Test();
	audio_Test();

	return 0;
}
