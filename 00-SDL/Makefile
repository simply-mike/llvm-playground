CC = clang
CFLAGS = -Wall -Wextra -O2 -std=c11	
LIBS = -lSDL2

TARGET = game_of_life

SOURCES = start.c sim.c app.c

OBJECTS = $(SOURCES:.c=.o)

.PHONY: all build run clean

all: build

build: $(TARGET)

$(TARGET): $(SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) -o $(TARGET) $(LIBS)

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(OBJECTS) $(TARGET)
