#include "regex-string.h"

#include <stdio.h>

#include "escape.h"

unsigned rStrlen(const char *str, char eof,
	unsigned *escapelen, unsigned fmttype){
    if(!str) return 0;
    if(!str[0]) return 0;

    _Bool prevescape = 0, escape = 0, backread = 0;
    // backread 应对 a? 的情况
    // prevescape 应对 \\ 的情况
    int rcount, count;
    // rcount 整个字符串长度, count 转义后长度
    for(rcount=count=0; str[rcount]!=0; rcount++, count++){
	if(escape){
	    count--;
	    escape = 0;
	    prevescape = 1;
	    continue;
	}
	if(str[rcount] == eof) break;
	switch(str[rcount]){
	    case '\\':
		escape = 1;
		break;
	    case '*': case '+': case '?':
	    case '{': case '(':
		//if(fmttype != FMT_GROUP){
		    backread = 1;
		//}
		// backread test begin
		switch(count){
		    case 0:
			printf("Warning: unexcept char '%c'\n"
				, str[rcount]);
		    case 1:
			*escapelen = 1;
			return (rcount==0)?1+prevescape:rcount;
		    default:
			*escapelen = count-backread;
			return rcount-prevescape-backread;
		}
		// backread test end
	}
	prevescape = 0;
    }
    *escapelen = count;
    return rcount;
}

void rStrncpy(char *dest, const char *source, int len){
    _Bool escape = 0;
    unsigned si, di;
    for(si=di=0; source[si]!=0 && si<len; si++, di++){
	if(escape){
	    dest[di] = rEscape(source[si], 1);
	    if(!dest[di]){
		printf("Warning: \\%c not supported.\n", source[si]);
		dest[di] = source[si];
	    }
	    escape = 0;
	    continue;
	}
	switch(source[si]){
	    case '\\':
		escape = 1;
		di--;
		break;
	    default:
		dest[di] = source[si];
		break;
	}
    }
    dest[di] = 0;
}

