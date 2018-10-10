#ifndef _STACK_H_
#define _STACK_H_

typedef struct S_sstack SSTACK;
typedef struct S_stack STACK;

struct S_sstack{
    STACK *head, *tail;
};

struct S_stack{
    void *p;
    STACK *prev, *next;
};

SSTACK *stackNew();
void stackPush(SSTACK *sstk, void *p);
void *stackPop(SSTACK *sstk);
void stackPopd(SSTACK *sstk);


#endif // _STACK_H_
