#ifndef __HEX_DISPLAY  
#define __HEX_DISPLAY

typedef enum {
	HEX0 = 0x00000001,
	HEX1 = 0x00000002,
	HEX2 = 0x00000004,
	HEX3 = 0x00000008,		
	HEX4 = 0x00000010,
	HEX5 = 0x00000020
} HEX_t;

// Function definitions
extern HEX_clear_ASM(HEX_t hex);
extern HEX_flood_ASM(HEX_t hex);
extern HEX_write_ASM(HEX_t hex, char val);

#endif /* __HEX_DISPLAY */