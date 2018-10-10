CC = clang -Wall -ggdb
CFLAGS = -std=c99

SOURCES = $(wildcard *.c)
HEADERS = $(wildcard *.h)
OBJS = $(patsubst %.c, %.o, $(SOURCES))

all: $(OBJS)

$(OBJS): %.o: %.c
	$(CC) $(CFLAGS) $(INCLUDE) $(LIBS) -c $^ -o $@

clean:
	-rm $(OBJS)
