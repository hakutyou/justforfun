#include "stack.h"

#include <stdio.h>
#include <stdlib.h>

static STACK *_stackNew();

SSTACK *stackNew(){
    SSTACK *sstk = malloc(sizeof(SSTACK));
    if(!sstk){
	printf("Error: Memory Full!\n");
	return 0;
    }
    sstk->head = sstk->tail = _stackNew();
    return sstk;
}

_Bool stackEmpty(SSTACK *sstk){
    if(!sstk) return 0;
    if(sstk->head == sstk->tail)
	return 1;
    return 0;
}

void stackPush(SSTACK *sstk, void *p){
    STACK *push = _stackNew();
    push->p = p;
    sstk->tail->next = push;
    push->prev = sstk->tail;
    sstk->tail = push;
}

void *stackPop(SSTACK *sstk){
    if(!sstk) return 0;
    if(stackEmpty(sstk)){
	printf("Warning: stack empty");
	return 0;
    }
    return sstk->tail->p;
}

void stackPopd(SSTACK *sstk){
    if(!sstk) return;
    if(stackEmpty(sstk)){
	printf("Warning: stack empty");
	return;
    }

    sstk->tail = sstk->tail->prev;
    free(sstk->tail->next->p);
    free(sstk->tail->next);
    sstk->tail->next = 0;
}

STACK *_stackNew(){
    STACK *stk = malloc(sizeof(STACK));
    stk->prev = stk->next = 0;
    stk->p = 0;
    return stk;
}
