CFLAGS += -fno-asynchronous-unwind-tables \
		-fno-jump-tables \
		-fno-stack-protector \
		-fno-exceptions

CFLAGS += -Wall

all: main

%.s: %.c
	gcc -S -masm=intel $(CFLAGS) -o $@ $^

main: main.s function.s
	gcc -o main $^

clean-all:
	rm *.s main
