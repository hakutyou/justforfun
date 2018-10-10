#include "escape.h"

const static char unEscch[] = {'n', 't', '\\',
    '*', '+', '?', '{', '}', 0};
const static char Escch[] = {'\n', '\t', '\\',
    '*', '+', '?', '{', '}', 0};

char rEscape(const char ch, int escape){
    const char *pch, *pEscch;
    if(escape)
	pch = unEscch, pEscch = Escch;
    else
	pch = Escch, pEscch = unEscch;

    for(int i=0; pch[i]!=0; i++){
	if(ch == pch[i]) return pEscch[i];
    }
    return 0;
}

