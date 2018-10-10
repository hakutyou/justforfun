#include <stdio.h>
#include <stdlib.h>

#include <display/alio.h>

#include <regex/stack.h>
#include <regex/regex-data.h>
#include <regex/regex-string.h>

unsigned res_regex(const char *fmt, unsigned spos, REGEX *head){
    REGEX *tail = head;
    while(1){
	unsigned slen;
	display("%s\n", fmt+spos);
	REGEX *ghead = 0;
	switch(fmt[spos]){
	    case '(':
		ghead = regexNew();
		tail->type = TYPE_GROUP;
		ghead->type = TYPE_HEAD;
		tail->d.group = ghead;
		ghead->d.group = tail;
		spos = res_regex(fmt, spos+1, ghead);
		break;
	    case ')':
		spos++;
	    case 0:
		tail->next = regexNew();
		tail = tail->next;
		tail->type = TYPE_EOG;
		tail->d.group = head->d.group;
		return spos;
	    default:
		tail->next = regexSet_str(fmt+spos, &slen);
		tail = tail->next;
		if(!tail){
		    display("Error: Memory Full.\n");
		    return spos;
		}
		spos += slen;
		break;
	}
	display("%s\n", fmt+spos);
	unsigned tlen = regexSet_times(tail, fmt+spos);
	spos += tlen;
	display("%s\n", fmt+spos);
    }
}

int main(){
    const char *fmt = "d\\*a{}b(cd)??";
    unsigned spos = 0;
    REGEX *head = regexNew();
    head->type = TYPE_HEAD;
    spos = res_regex(fmt, spos, head);
    switch(fmt[spos]){
	case 0:
	    break;
	default:
	    display("unexcept \'%c\' appeared.\n", fmt[spos]);
    }
    regexPrint(head);
    //regexClean(head);
    return 0;
}
