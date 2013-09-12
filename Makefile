# NOTE: this needs to be executed as root

CC = cc
CFLAGS = -std=c99 -pedantic

all: write_to_kb

write_to_kb: write_to_kb.c
	$(CC) $(CFLAGS) -o $@ $^
	chmod u+s $@

clean: write_to_kb
	rm $^

