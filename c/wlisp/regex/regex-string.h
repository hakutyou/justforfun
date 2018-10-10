#ifndef _REGEX_STRING_H_
#define _REGEX_STRING_H_

#define FMT_CHARS 0x0000

unsigned rStrlen(const char *str, char eof,
	unsigned *escapelen, unsigned fmttype);
void rStrncpy(char *dest, const char *source,
	int len);


#endif // _REGEX_STRING_H_
