ROOTDIR = `pwd`
SUBDIRS = display regex
INCLUDE = -I$(ROOTDIR)

TARGET  = alice

CC = clang -Wall -ggdb
CFLAGS = -std=c99

SUBSOURCES = $(foreach dir, $(SUBDIRS), $(wildcard $(dir)/*.c))
OBJS = $(patsubst %.c, %.o, $(SUBSOURCES))

.PHONY: all objs run clean

all: objs $(TARGET) run

run: $(TARGET)
	./$(TARGET)

check: $(TARGET)
	valgrind ./$^ --track-origins=yes

objs: $(SUBDIRS)
	@for subdir in $(SUBDIRS); \
	do \
		$(MAKE) -C $$subdir INCLUDE+=$(INCLUDE) LIBS+=$(LIBS)|| exit 1; \
	done

$(TARGET): regex.c $(OBJS)
	$(CC) $(CFLAGS) $(INCLUDE) -o $@ $(OBJS) $<

clean:
	@for subdir in $(SUBDIRS); \
	do \
		$(MAKE) -C $$subdir clean; \
	done
	-rm $(TARGET)
