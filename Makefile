SRC_DIR=src
BIN_DIR=bin
OBJ_DIR=obj
VENDOR_DIR=vendor

MACOS_MIN=15.0

CFLAGS=-mmacosx-version-min=$(MACOS_MIN) -Iinclude -I$(VENDOR_DIR)/raylib/include -Wall -Wextra -O2
LDFLAGS=-mmacosx-version-min=$(MACOS_MIN) -L$(VENDOR_DIR)/raylib/lib -lraylib \
	-framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo -framework AppKit -framework Carbon

TARGET=$(BIN_DIR)/rayplace

SRC_C = $(SRC_DIR)/picker.c
SRC_M = $(SRC_DIR)/main.m $(SRC_DIR)/setwall.m

OBJ_C = $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRC_C))
OBJ_M = $(patsubst $(SRC_DIR)/%.m,$(OBJ_DIR)/%.o,$(SRC_M))

OBJ_FILES = $(OBJ_C) $(OBJ_M)

all: $(TARGET)

$(TARGET): $(OBJ_FILES) | $(BIN_DIR)
	$(CC) -o $@ $^ $(LDFLAGS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c -o $@ $<

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.m | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c -o $@ $<

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

.PHONY: all clean

