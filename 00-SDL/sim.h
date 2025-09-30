#ifndef SIM_H
#define SIM_H

#define SIM_X_SIZE 800
#define SIM_Y_SIZE 600

#ifndef __sim__
void simInit();
void app();
void simExit();
void simFlush();
void simPutPixel(int x, int y, int argb);
int simRand(void);
void simDelay(int ms);
#endif // __sim__

#endif // SIM_H
