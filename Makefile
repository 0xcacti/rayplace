SRC_DIR=src
BIN_DIR=bin
OBJ_DIR=obj
VENDOR_DIR=vendor

CFLAGS=-Iinclude -I$(VENDOR_DIR)/raylib/include -Wall -Wextra -O2
LDFLAGS=-L$(VENDOR_DIR)/raylib/lib -lraylib -framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo

TARGET=$(BIN_DIR)/rayplace

SRC_FILES = $(wildcard $(SRC_DIR)/*.c)
OBJ_FILES = $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRC_FILES))

all: $(TARGET)

$(TARGET): $(OBJ_FILES) | $(BIN_DIR)
	$(CC) -o $@ $^ $(LDFLAGS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c -o $@ $

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

cdb:
	@rm -f compile_commands.json
	@compiledb --output compile_commands.json make clean all
	@echo "✓ compile_commands.json regenerated"

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

.PHONY: all clean cdb
