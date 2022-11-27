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

run-tests:
	./main 0.0005 100000 -f tests/1.in tests/output/1.out
	./main 0.0005 100000 -f tests/2.in tests/output/2.out
	./main 0.0005 100000 -f tests/3.in tests/output/3.out
	./main 0.0005 100000 -f tests/4.in tests/output/4.out
	./main 0.0005 100000 -f tests/5.in tests/output/5.out
	./main 0.0005 100000 -f tests/6.in tests/output/6.out
	./main 0.0005 100000 -f tests/7.in tests/output/7.out
