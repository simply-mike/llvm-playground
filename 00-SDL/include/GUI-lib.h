#pragma once

#define GUI_WIDTH 512
#define GUI_HEIGHT 512
  
#ifdef __cplusplus
extern "C" {
#endif

extern void gui_init();

extern void gui_exit();

extern void gui_flush();

extern int gui_quit_event();

extern void gui_set_pixel(int x, int y, int color);

extern int gui_rand();

extern void app();

#ifdef __cplusplus
}
#endif

#define GUI_BLACK 0x000000FF
#define GUI_WHITE 0xFFFFFFFF
#define GUI_RED 0xFF0000FF
#define GUI_GREEN 0x00FF00FF
#define GUI_BLUE 0x0000FFFF
#define GUI_AQUA 0x00FFFFFF
#define GUI_YELLOW 0xFFFF00FF
#define GUI_PURPLE 0xFF00FFFF
