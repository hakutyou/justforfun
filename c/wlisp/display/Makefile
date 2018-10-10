CC = clang -Wall -ggdb
CFLAGS = -std=c99

SOURCES = $(wildcard *.c)
OBJS = $(patsubst %.c, %.o, $(SOURCES))
HEADERS = $(wildcard *.h)

.PHONY: all clean

all: $(OBJS)

$(OBJS): %.o: %.c
	$(CC) $(CFLAGS) $(INCLUDE) $(LIBS) -c $^ -o $@

clean:
	-rm $(OBJS)
