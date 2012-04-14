OUTPUT = arkatinto.js

SOURCES = src/config.coffee \
          src/tinto.coffee \
          src/canvas.coffee \
          src/input.coffee \
          src/resource.coffee \
          src/sprite.coffee \
          src/text.coffee \
          src/players.coffee \
          src/game.coffee

build:
	coffee --join $(OUTPUT) --compile $(SOURCES)

watch:
	coffee --watch --join $(OUTPUT) --compile $(SOURCES)

clean:
	find . -name *.js -delete

all: build