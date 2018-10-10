#ifndef _REGEX_DATA_H_
#define _REGEX_DATA_H_

#include "global.h"

typedef struct S_regex REGEX;

struct S_regex{
    unsigned type;
    union{
	char *str;
	REGEX *group;
    }d;
    unsigned begintimes, endtimes;
    REGEX *next;
};

#define TYPE_NIL 0x0000
#define TYPE_STR 0x0001
#define TYPE_GROUP 0x0010
#define TYPE_HEAD 0xfffe
#define TYPE_EOG 0xffff

// procedure begin
REGEX *regexNew();
_Bool regexDelete(REGEX *reg);
void regexClean(REGEX *reg);

REGEX *regexSet_str(const char *str,
	unsigned *slen);
unsigned regexSet_times(REGEX *reg,
	const char *str);
// procedure end
#ifdef _DEBUG
void regexPrint(REGEX *reg);
#endif // _DEBUG

#endif // _REGEX_DATA_H_
