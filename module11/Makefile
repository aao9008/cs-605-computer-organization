All: main
LIB=libModule11.o
CC=gcc

main: main.o $(LIB)
	$(CC) $@.o $(LIB) -g -o $@

.s.o:
	$(CC) $(@:.o=.s) -g -c -o $@

clean:
	rm -f *.o main