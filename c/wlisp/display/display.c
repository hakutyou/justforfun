#include "display.h"

#include <stdio.h>
#include <stdarg.h>
#include <unistd.h>
#include <string.h>


static char printbuf[100];

int colorPrint(const char *color, const char *fmt, va_list args){
    int i;
    write(1, color, strlen(color));
    write(1, printbuf, i=vsprintf(printbuf, fmt, args));
    write(1, NO_COLOR, strlen(NO_COLOR));
    return i;
}

