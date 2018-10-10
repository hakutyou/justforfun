#include "regex-data.h"

#include <stdio.h>
#include <stdlib.h>

#include "regex-string.h"

REGEX *regexNew(){
    REGEX *reg = malloc(sizeof(REGEX));
    if(!reg){
	printf("Error: Memory not enough.\n");
	return 0;
    }
    reg->type = TYPE_NIL;
    reg->begintimes = reg->endtimes = 1;
    reg->next = 0;
    return reg;
}

REGEX *regexSet_str(const char *str, unsigned *slen){
    if(!str) return 0;
    unsigned regexfmt = FMT_CHARS;
    switch(str[0]){
	case 0:
	    return 0;
    }

    unsigned escapelen = 0;
    unsigned len = rStrlen(str, 0, &escapelen, regexfmt);
    if(!len) return 0;
// new REGEX begin
    REGEX *reg = regexNew();
    if(!reg) return 0;
    reg->type = TYPE_STR;
// new REGEX end
    reg->d.str = malloc(sizeof(char)*(escapelen+1));
    rStrncpy(reg->d.str, str, len);
    //printf("len=%d, escapelen=%d", len, escapelen);
    *slen = len;
    return reg;
}

static unsigned regexSpecialtime(REGEX *reg, const char *fmt);
static unsigned str2uint(const char *fmt, unsigned len);

unsigned regexSet_times(REGEX *reg, const char *str){
    if(!reg) return 0;
    if(!str) return 0;
    if(!str[0]) return 0;
    unsigned *begintimes, *endtimes;
    _Bool lazy = 0;
    if(str[1] == '?'){
	begintimes = &(reg->endtimes);
	endtimes = &(reg->begintimes);
	lazy = 1;
    }
    else{
	begintimes = &(reg->begintimes);
	endtimes = &(reg->endtimes);
    }
    switch(str[0]){
	case '*':
	    *begintimes = (unsigned)-1;
	    *endtimes = 0;
	    return 1+lazy;
	case '+':
	    *begintimes = (unsigned)-1;
	    *endtimes = 1;
	    return 1+lazy;
	case '?':
	    *begintimes = 1;
	    *endtimes = 0;
	    return 1+lazy;
	case '{':
	    return regexSpecialtime(reg, str);
	default:
	    return 0;
    }
}

unsigned regexSpecialtime(REGEX *reg, const char *fmt){
    // fmt[0] must be '{'
    unsigned count, midpos, begintimes, endtimes;
    _Bool lazy = 0;
    midpos = 0;
    for(count=1; fmt[count]!='}'; count++){
	if(fmt[count] == 0){
	    printf("Warning: Not found pattern with '{'\n");
	    return 0;
	}
	if(!midpos && fmt[count] == ',')
	    midpos = count;
    }
    if(midpos){
	begintimes = str2uint(fmt+1, midpos-1);
	endtimes = str2uint(fmt+midpos+1, count-midpos-1);
    }
    else{
	begintimes = endtimes = str2uint(fmt+1, count-1);
    }

    if(count+1 == '?'){ // lazy
	reg->begintimes = endtimes;
	reg->endtimes = begintimes;
	lazy = 1;
    }
    else{
	reg->begintimes = begintimes;
	reg->endtimes = endtimes;
    }
    return count+lazy+1;
}

unsigned str2uint(const char *fmt, unsigned len){
    unsigned count, result;
    count = result = 0;
    short carry = 10, bitnum;

    // prefix begin
    int again;
    do{
	again = 0;
	switch(fmt[count]){
	    case ' ':
		count++;
		again = 1;
	    case '0':
		if((fmt[count+1] == 'x') || (fmt[count+1] == 'X')){
		    count +=2;
		    carry = 16;
		}
		if((fmt[count+1] == 'b') || (fmt[count+1] == 'B')){
		    count +=2;
		    carry = 2;
		}
		break;
	    default:
		break;
	}
    }while(again);
    // prefix end

    for(; count<len; count++){
	switch(fmt[count]){
	    case '0': case '1': case '2': case '3': case '4':
	    case '5': case '6': case '7': case '8': case '9':
		bitnum = fmt[count] - '0';
		break;
	    case 'a': case 'b': case 'c': case 'd': case 'e':
	    case 'f':
		bitnum = fmt[count] - 'a' + 10;
		break;
	    case 'A': case 'B': case 'C': case 'D': case 'E':
	    case 'F':
		bitnum = fmt[count] - 'A' + 10;
		break;
	    case ' ': case '_': continue;
	    default:
		return result;
	}
	if(bitnum < carry){
	    result *= carry;
	    result += bitnum;
	}
    }
    return result;
}

_Bool regexDelete(REGEX *reg){
    if(!reg) return 0;
    switch(reg->type){
	case TYPE_STR: free(reg->d.str);
    }
    free(reg); return 1;
}

void regexClean(REGEX *reg){
    if(!reg) return;
    REGEX *p = reg, *next;
    while(p){
	switch(p->type){
	    case TYPE_NIL:
		break;
	    case TYPE_STR:
		free(p->d.str);
		break;
	    default:
		printf("unknow type: 0x%x\n", p->type);
		break;
	}
	next = p->next;
	free(p);
	p = next;
    }
    return;
}


#ifdef _DEBUG
#include "escape.h"

#define NONE          "\033[m"
#define RED           "\033[0;32;31m"
#define LIGHT_RED     "\033[1;31m"
#define GREEN         "\033[0;32;32m"
#define LIGHT_GREEN   "\033[1;32m"
#define BLUE          "\033[0;32;34m"
#define LIGHT_BLUE    "\033[1;34m"
#define DARY_GRAY     "\033[1;30m"
#define CYAN          "\033[0;36m"
#define LIGHT_CYAN    "\033[1;36m"
#define PURPLE        "\033[0;35m"
#define LIGHT_PURPLE  "\033[1;35m"
#define BROWN         "\033[0;33m"
#define YELLOW        "\033[1;33m"
#define LIGHT_GRAY    "\033[0;37m"
#define WHITE         "\033[1;37m"

static void Rprintf(char *s);
static void _regexPrint(REGEX *reg);

void _regexPrint(REGEX *reg){
    for(; reg!=0; reg=reg->next){
	switch(reg->type){
	    case TYPE_NIL:
	    case TYPE_EOG:
		printf(WHITE"group end\n"NONE);
		return;
	    case TYPE_STR:
		Rprintf(reg->d.str);
		break;
	    case TYPE_GROUP:
		_regexPrint(reg->d.group);
		break;
	    case TYPE_HEAD:
		printf(WHITE"group begin\n"NONE);
		continue;
	    default:
		printf("unknow type: 0x%x\n", reg->type);
		return;
	}
	printf("{%u, %u}\n", reg->begintimes, reg->endtimes);
    }
}

void regexPrint(REGEX *reg){
    if(!reg) return;
    _regexPrint(reg);
    return;
}

static void Rprintf(char *s){
    char ch;
    if(!s) return;
    for(int i=0; s[i]!=0; i++){
	if(ch = rEscape(s[i], 0)){
	    printf(RED"%c"NONE, ch);
	}
	else{
	    printf("%c", s[i]);
	}
    }
}
#endif // _DEBUG

