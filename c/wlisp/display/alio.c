#include <display/display.h>

#include <stdlib.h>
#include <stdarg.h>

int error(const char *fmt, ...){
    va_list args;
    va_start(args, fmt);
    colorPrint(LIGHT_RED, fmt, args);
    va_end(args);
    exit(-1);
}

int warning(const char *fmt, ...){
    va_list args;
    va_start(args, fmt);
    int i = colorPrint(YELLOW, fmt, args);
    va_end(args);
    return i;
}

int tips(const char *fmt, ...){
    va_list args;
    va_start(args, fmt);
    int i = colorPrint(LIGHT_PURPLE, fmt, args);
    va_end(args);
    return i;
}

int display(const char *fmt, ...){
    va_list args;
    va_start(args, fmt);
    int i = colorPrint(NO_COLOR, fmt, args);
    va_end(args);
    return i;
}
