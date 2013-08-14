
#include <SDL/SDL.h>

typedef struct{
	int buttons;			/* buttons bitfield */

}inputState;

#define INPUTBUTTONL     (1<<4)
#define INPUTBUTTONR     (1<<5)
#define INPUTBUTTONX     (1<<6)
#define INPUTBUTTONP     (1<<7)
#define INPUTBUTTONC     (1<<8)
#define INPUTBUTTONB     (1<<9)
#define INPUTBUTTONA     (1<<10)
#define INPUTBUTTONLEFT  (1<<11)
#define INPUTBUTTONRIGHT (1<<12)
#define INPUTBUTTONUP    (1<<13)
#define INPUTBUTTONDOWN  (1<<14)


unsigned char *inputRead();
int inputLength();
int inputEnum();
int inputInit();
SDL_Joystick *inputOpen(int joyid);
void inputPoll(SDL_Joystick *joy);
int inputQuit();
int inputFullscreen();
