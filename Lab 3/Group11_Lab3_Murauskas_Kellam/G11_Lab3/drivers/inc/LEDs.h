#ifndef __LEDS
#define __LEDS

// Reads a integer "val" from the DE1-SoC 10-bit LED data register
extern int read_LEDs_ASM();

// Writes a integer "val" to the DE1-SoC 10-bit LED data register
extern int write_LEDs_ASM(int val);

#endif /* __LEDS */
