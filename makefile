CC = g++
GLUTFLAGS = -lglut -lGL -lGLU
CFLAGS = -Wall -m64

all:	Source.o f.o
	$(CC) $(CFLAGS) -o prog Source.o f.o $(GLUTFLAGS)

f.o:	f.s
	nasm -f elf64 -o f.o f.s

f2.o:	f2.cpp
	$(CC) $(CFLAGS) -c -o f2.o f2.cpp

Source.o:	Source.cpp
	$(CC) $(CFLAGS) -c -o Source.o Source.cpp

clean:
	rm -f *.o
