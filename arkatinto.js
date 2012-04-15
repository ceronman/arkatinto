(function() {
  var Ball, Board, Bonus, BonusAction, Brick, CONFIG, ExplosionBonusAction, ExtraLifeBonusAction, FastBallBonusAction, FireBallBonusAction, LEVEL1, LEVEL2, LEVEL3, LEVELS, Label, LargePadBonusAction, LevelMap, MirrorControlBonusAction, Missile, MissileBonusAction, Paddle, SIDE, ShortPadBonusAction, SlowBallBonusAction, Sprite, StickyPaddleBonusAction, collision, key, randomChoice, resource, ﻿LEVEL0,
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  CONFIG = {
    mapWidth: 455,
    mapHeight: 460,
    boardHeight: 20,
    cellWidth: 35,
    cellHeight: 20,
    initialLifes: 3,
    maxLevel: 3
  };

  this.tinto = (function() {
    var EventEmitter;
    EventEmitter = (function() {

      function EventEmitter() {
        this.callbacks = [];
      }

      EventEmitter.prototype.call = function() {
        var callback, _i, _len, _ref, _results;
        _ref = this.callbacks;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          callback = _ref[_i];
          _results.push(callback.apply(null, arguments));
        }
        return _results;
      };

      EventEmitter.prototype.addCallback = function(callback) {
        return this.callbacks.push(callback);
      };

      EventEmitter.prototype.removeCallback = function(callback) {
        var index;
        index = this.callbacks.indexOf(callback);
        if (index !== -1) return this.callbacks.splice(index, 1);
      };

      return EventEmitter;

    })();
    return {
      EventEmitter: EventEmitter
    };
  })();

  this.tinto.canvas = (function() {
    var GameCanvas;
    GameCanvas = (function() {

      function GameCanvas(canvasID, options) {
        var _ref, _ref2, _ref3;
        options = options != null ? options : {};
        this.canvas = document.getElementById(canvasID);
        this.canvas.width = (_ref = options.width) != null ? _ref : 640;
        this.canvas.height = (_ref2 = options.height) != null ? _ref2 : 480;
        this.canvas.style.backgroundColor = (_ref3 = options.background) != null ? _ref3 : 'black';
        this.context2D = this.canvas.getContext('2d');
        this.width = this.canvas.width;
        this.height = this.canvas.height;
        tinto.activeCanvas = this;
        this.drawEvent = new tinto.EventEmitter();
        this.updateEvent = new tinto.EventEmitter();
        tinto.input.installKeyboardCallbacks();
      }

      GameCanvas.prototype.draw = function(callback) {
        var oldTimestamp, update,
          _this = this;
        oldTimestamp = new Date().getTime();
        update = function() {
          var dt, newTimestamp;
          newTimestamp = new Date().getTime();
          dt = (newTimestamp - oldTimestamp) / 1000;
          oldTimestamp = newTimestamp;
          _this.updateEvent.call(dt);
          return _this.drawEvent.call();
        };
        tinto.resource.loaded(function() {
          console.log('loaded');
          return window.setInterval(update, 1000 / 60.0);
        });
        tinto.resource.check();
        return this.drawEvent.addCallback(callback);
      };

      GameCanvas.prototype.update = function(callback) {
        return this.updateEvent.addCallback(callback);
      };

      GameCanvas.prototype.clear = function() {
        return this.context2D.clearRect(0, 0, this.width, this.height);
      };

      GameCanvas.prototype.preserveContext = function(drawFunction) {
        this.context2D.save();
        drawFunction(this.context2D);
        return this.context2D.restore();
      };

      return GameCanvas;

    })();
    return {
      GameCanvas: GameCanvas
    };
  })();

  this.tinto.input = (function() {
    var KEY_CODES, KEY_NAMES, MOZILLA, MOZILLA_OPERA_MAP, OPERA, code, keyPressedEvent, keyReleasedEvent, keysDown, name, normalizeKeyCode;
    KEY_CODES = {
      "mac_enter": 3,
      "backspace": 8,
      "tab": 9,
      "enter": 13,
      "shift": 16,
      "ctrl": 17,
      "alt": 18,
      "pause": 19,
      "caps_lock": 20,
      "esc": 27,
      "space": 32,
      "page_up": 33,
      "page_down": 34,
      "end": 35,
      "home": 36,
      "left": 37,
      "up": 38,
      "right": 39,
      "down": 40,
      "insert": 45,
      "delete": 46,
      "0": 48,
      "1": 49,
      "2": 50,
      "3": 51,
      "4": 52,
      "5": 53,
      "6": 54,
      "7": 55,
      "8": 56,
      "9": 57,
      "a": 65,
      "b": 66,
      "c": 67,
      "d": 68,
      "e": 69,
      "f": 70,
      "g": 71,
      "h": 72,
      "i": 73,
      "j": 74,
      "k": 75,
      "l": 76,
      "m": 77,
      "n": 78,
      "o": 79,
      "p": 80,
      "q": 81,
      "r": 82,
      "s": 83,
      "t": 84,
      "u": 85,
      "v": 86,
      "w": 87,
      "x": 88,
      "y": 89,
      "z": 90,
      "win": 91,
      "context_menu": 93,
      "numpad_0": 96,
      "numpad_1": 97,
      "numpad_2": 98,
      "numpad_3": 99,
      "numpad_4": 100,
      "numpad_5": 101,
      "numpad_6": 102,
      "numpad_7": 103,
      "numpad_8": 104,
      "numpad_9": 105,
      "numpad_*": 106,
      "numpad_+": 107,
      "numpad_-": 109,
      "numpad_.": 110,
      "numpad_/": 111,
      "f1": 112,
      "f2": 113,
      "f3": 114,
      "f4": 115,
      "f5": 116,
      "f6": 117,
      "f7": 118,
      "f8": 119,
      "f9": 120,
      "f10": 121,
      "f11": 122,
      "f12": 123,
      ";": 186,
      ":": 186,
      "-": 189,
      "=": 187,
      ",": 188,
      "<": 188,
      ".": 190,
      ">": 190,
      "/": 191,
      "?": 191,
      "~": 192,
      "`": 192,
      "[": 219,
      "{": 219,
      "\\": 220,
      "|": 220,
      "]": 221,
      "}": 221,
      "'": 222,
      "\"": 222
    };
    KEY_NAMES = {};
    for (name in KEY_CODES) {
      code = KEY_CODES[name];
      KEY_NAMES[code] = name;
    }
    MOZILLA = navigator.userAgent.indexOf('Gecko' !== -1);
    OPERA = window.opera;
    MOZILLA_OPERA_MAP = {
      59: 186,
      61: 187,
      109: 189
    };
    normalizeKeyCode = function(keyCode) {
      if (MOZILLA || OPERA) {
        return MOZILLA_OPERA_MAP[keyCode] || keyCode;
      } else {
        return keyCode;
      }
    };
    keysDown = {};
    keyPressedEvent = new tinto.EventEmitter();
    keyReleasedEvent = new tinto.EventEmitter();
    return {
      installKeyboardCallbacks: function() {
        document.addEventListener("keydown", function(event) {
          code = event.which || event.keyCode;
          code = normalizeKeyCode(code);
          keysDown[code] = true;
          return keyPressedEvent.call(code);
        });
        return document.addEventListener("keyup", function(event) {
          code = event.which || event.keyCode;
          code = normalizeKeyCode(code);
          delete keysDown[code];
          return keyReleasedEvent.call(code);
        });
      },
      key: function(keyName) {
        var keyCode;
        keyCode = KEY_CODES[keyName];
        if (keyCode) {
          return keysDown[keyCode];
        } else {
          return false;
        }
      },
      clear: function() {
        return keysDown = {};
      },
      keypressed: function(callback) {
        return keyPressedEvent.addCallback(callback);
      },
      keyreleased: function(callback) {
        return keyReleasedEvent.addCallback(callback);
      },
      keyName: function(keyCode) {
        var _ref;
        return (_ref = KEY_NAMES[keyCode]) != null ? _ref : 'unknown';
      }
    };
  })();

  this.tinto.resource = (function() {
    var loadedEvent;
    loadedEvent = new tinto.EventEmitter();
    return {
      images: [],
      sounds: [],
      image: function(path) {
        var image,
          _this = this;
        image = document.createElement('img');
        image._loaded = false;
        image._path = path;
        image.addEventListener("load", function() {
          image._loaded = true;
          return _this.check();
        });
        this.images.push(image);
        return image;
      },
      sound: function(path) {
        var sound,
          _this = this;
        sound = document.createElement('audio');
        sound._loaded = false;
        sound._path = path;
        sound.addEventListener("canplaythrough", function() {
          sound._loaded = true;
          return _this.check();
        });
        this.sounds.push(sound);
        return sound;
      },
      loadAll: function() {
        this.loadImages();
        return this.loadSounds();
      },
      loadImages: function() {
        var image, _i, _len, _ref, _results;
        _ref = this.images;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          image = _ref[_i];
          _results.push(image.src = image._path);
        }
        return _results;
      },
      loadSounds: function() {
        var sound, _i, _len, _ref, _results;
        _ref = this.sounds;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          sound = _ref[_i];
          _results.push(sound.src = sound._path);
        }
        return _results;
      },
      check: function() {
        var image, sound, _i, _j, _len, _len2, _ref, _ref2;
        _ref = this.images;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          image = _ref[_i];
          if (!image._loaded) return;
        }
        _ref2 = this.sounds;
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          sound = _ref2[_j];
          if (!sound._loaded) return;
        }
        return loadedEvent.call();
      },
      loaded: function(callback) {
        return loadedEvent.addCallback(callback);
      }
    };
  })();

  this.tinto.sprite = (function() {
    var Sprite;
    Sprite = (function() {

      function Sprite(options) {
        var key, value;
        for (key in options) {
          value = options[key];
          this[key] = value;
        }
      }

      Sprite.prototype.draw = function() {
        var _this = this;
        return tinto.activeCanvas.preserveContext(function(context) {
          return context.drawImage(_this.image, _this.x, _this.y);
        });
      };

      Sprite.prototype.top = function() {
        return this.y;
      };

      Sprite.prototype.left = function() {
        return this.x;
      };

      Sprite.prototype.bottom = function() {
        return this.y + this.image.height;
      };

      Sprite.prototype.right = function() {
        return this.x + this.image.width;
      };

      Sprite.prototype.centerX = function() {
        return this.x + this.image.width / 2;
      };

      Sprite.prototype.centerY = function() {
        return this.y + this.image.height / 2;
      };

      Sprite.prototype.width = function() {
        var _ref;
        return (_ref = this.image.width) != null ? _ref : 0;
      };

      Sprite.prototype.height = function() {
        var _ref;
        return (_ref = this.image.height) != null ? _ref : 0;
      };

      return Sprite;

    })();
    return {
      Sprite: Sprite
    };
  })();

  this.tinto.text = (function() {
    var Label;
    Label = (function() {

      function Label(options) {
        var key, value;
        for (key in options) {
          value = options[key];
          this[key] = value;
        }
      }

      Label.prototype.draw = function() {
        var _this = this;
        return tinto.activeCanvas.preserveContext(function(context) {
          var _ref, _ref2, _ref3;
          context.font = (_ref = _this.font) != null ? _ref : '14pt Serif italic';
          context.fillStyle = (_ref2 = _this.color) != null ? _ref2 : 'white';
          context.textAlign = (_ref3 = _this.alignment) != null ? _ref3 : 'start';
          return context.fillText(_this.text, _this.x, _this.y);
        });
      };

      return Label;

    })();
    return {
      Label: Label
    };
  })();

  ﻿LEVEL0 = "mapa base\nX,X,X,X,X,X,X,X,X,X,X,X,X\nX,X,X,X,X,A,A,A,X,X,X,X,X\nX,X,X,X,X,X,A,X,X,X,X,X,X\nX,A,A,A,A,X,B,X,A,A,A,A,X\nX,A,A,A,A,X,A,X,A,A,A,A,X\nA,X,X,X,X,X,X,X,X,X,X,X,X\nA,X,A,A,X,A,A,A,X,A,A,X,A\nA,C,X,A,X,A,A,A,X,C,X,A,A\nA,A,X,X,X,X,X,X,X,X,X,A,A\nX,X,A,A,A,A,B,A,A,A,X,X,X\nX,X,A,A,A,A,A,A,A,A,A,X,X\nX,D,A,A,X,X,A,X,X,A,A,D,X\nX,X,A,A,X,A,A,A,X,A,A,X,X\nX,X,X,X,X,A,E,A,X,X,X,X,X\nX,X,X,X,X,X,X,X,X,X,X,X,X\nX,X,X,X,X,X,X,X,X,X,X,X,X\nX,X,X,X,X,X,X,X,X,X,X,X,X\nX,X,X,X,X,X,X,X,X,X,X,X,X";

  LEVEL1 = "mapa uno\nX,X,X,X,X,X,X,X,X,X,X,X,X\nX,A,X,X,X,B,B,B,X,X,X,A,X\nX,A,A,X,X,B,B,B,X,X,A,A,X\nX,A,A,A,A,B,B,B,A,A,A,A,X\nX,A,A,A,A,A,A,A,A,A,A,A,X\nX,A,X,X,X,B,B,B,X,X,X,A,X\nX,X,A,A,X,A,A,A,X,A,A,X,X\nD,X,X,A,X,A,A,A,X,A,X,X,D\nA,A,X,X,X,A,A,A,X,X,X,A,A\nX,X,A,A,A,A,A,A,A,A,A,X,X\nX,X,A,A,A,A,A,A,A,A,A,X,X\nX,X,A,A,X,A,A,A,X,A,A,X,X\nX,X,A,A,X,A,A,A,X,A,A,X,X\nX,X,X,X,X,A,A,A,X,X,X,X,X\nX,X,X,X,X,X,X,X,X,X,X,X,X\nX,X,X,X,X,X,X,X,X,X,X,X,X\nX,X,X,X,X,X,X,X,X,X,X,X,X\nX,X,X,X,X,X,X,X,X,X,X,X,X";

  LEVEL2 = "mapa dos\nX,X,X,X,X,X,X,X,X,X,X,X,X\nX,X,A,X,X,X,X,X,X,X,A,X,X\nA,A,A,A,A,X,X,X,A,A,A,A,A\nX,A,A,A,X,X,X,X,X,A,A,A,X\nX,X,A,X,X,X,X,X,X,X,A,X,X\nX,X,X,X,X,X,A,X,X,X,X,X,X\nX,X,X,X,A,A,B,A,A,X,X,X,X\nX,X,X,X,A,B,C,B,A,X,X,X,X\nX,X,X,A,B,C,C,C,B,A,X,X,X\nX,X,X,A,A,B,C,B,A,A,X,X,X\nX,X,X,X,A,A,B,A,A,X,X,X,X\nX,X,X,X,X,X,A,X,X,X,X,X,X\nX,X,X,X,X,X,X,X,X,X,X,X,X\nX,X,X,X,X,X,X,X,X,X,X,X,X\nX,X,X,X,X,X,X,X,X,X,X,X,X\nX,X,X,X,X,X,X,X,X,X,X,X,X\nX,X,X,X,X,X,X,X,X,X,X,X,X\nX,X,X,X,X,X,X,X,X,X,X,X,X";

  LEVEL3 = "mapa tres\nX,X,X,X,X,X,X,X,X,X,X,X,X\nX,X,A,A,A,A,A,A,A,A,A,X,X\nX,X,A,A,A,A,A,A,A,A,A,X,X\nX,X,A,A,A,A,A,A,A,A,A,X,X\nX,X,X,X,X,X,X,X,X,X,X,X,X\nX,X,A,A,A,A,A,A,A,A,A,X,X\nX,X,A,A,A,A,A,A,A,A,A,X,X\nX,X,A,A,A,A,A,A,A,A,A,X,X\nX,X,X,X,X,X,X,X,X,X,X,X,X\nX,X,X,X,X,B,B,B,X,X,X,X,X\nX,X,X,B,B,B,B,B,B,B,X,X,X\nX,X,A,A,A,A,A,A,A,A,A,X,X\nX,X,A,A,A,A,A,A,A,A,A,X,X\nX,X,A,A,A,A,A,A,A,A,A,X,X\nX,X,X,X,X,X,X,X,X,X,X,X,X\nX,X,X,X,X,X,X,X,X,X,X,X,X\nX,X,X,X,X,X,X,X,X,X,X,X,X\nX,X,X,X,X,X,X,X,X,X,X,X,X";

  LEVELS = [LEVEL0, LEVEL1, LEVEL2, LEVEL3];

  collision = function(sprite1, sprite2) {
    var angle, collide;
    collide = sprite1.right() > sprite2.left() && sprite1.left() < sprite2.right() && sprite1.bottom() > sprite2.top() && sprite1.top() < sprite2.bottom();
    if (!collide) return false;
    if (sprite1.left() < sprite2.left()) {
      if (sprite1.top() < sprite2.top()) {
        angle = Math.atan2(-sprite1.speedY, sprite1.speedX);
        if (angle > -(Math.PI / 4)) {
          return SIDE.left;
        } else {
          return SIDE.top;
        }
      } else if (sprite1.bottom() > sprite2.bottom()) {
        angle = Math.atan2(-sprite1.speedY, sprite1.speedX);
        if (angle < (Math.PI / 4)) {
          return SIDE.left;
        } else {
          return SIDE.bottom;
        }
      } else {
        return SIDE.left;
      }
    }
    if (sprite1.right() > sprite2.right()) {
      if (sprite1.top() < sprite2.top()) {
        angle = Math.atan2(-sprite1.speedY, sprite1.speedX);
        if (angle < -3 * (Math.PI / 4) || angle > (Math.PI / 2)) {
          return SIDE.right;
        } else {
          return SIDE.top;
        }
      } else if (sprite1.bottom() > sprite2.bottom()) {
        angle = Math.atan2(-sprite1.speedY, sprite1.speedX);
        if (angle > 3 * (Math.PI / 4) || angle < -Math.PI / 2) {
          return SIDE.right;
        } else {
          return SIDE.bottom;
        }
      } else {
        return SIDE.right;
      }
    }
    if (sprite1.bottom() > sprite2.bottom()) return SIDE.bottom;
    if (sprite1.top() < sprite2.top()) return SIDE.top;
    return console.log('unknown side');
  };

  key = tinto.input.key;

  resource = tinto.resource;

  Sprite = tinto.sprite.Sprite;

  Label = tinto.text.Label;

  SIDE = {
    top: 1,
    left: 2,
    bottom: 3,
    right: 4
  };

  Brick = (function(_super) {

    __extends(Brick, _super);

    Brick.IMAGES = {
      "A": resource.image("graphics/brickA.png"),
      "B": resource.image("graphics/brickB.png"),
      "C": resource.image("graphics/brickC.png"),
      "D": resource.image("graphics/brickD.png"),
      "E": resource.image("graphics/brickE.png")
    };

    function Brick(x, y, type) {
      this.x = x;
      this.y = y;
      this.type = type;
      switch (this.type) {
        case "A":
          this.lifes = 1;
          break;
        case "B":
          this.lifes = 2;
          break;
        case "C":
          this.lifes = 3;
          break;
        case "E":
          this.lifes = 1;
          break;
        default:
          this.lifes = Infinity;
      }
      this.updateImage();
      Brick.__super__.constructor.call(this, {
        image: this.image
      });
    }

    Brick.prototype.touch = function() {
      var points;
      points = this.lifes;
      this.lifes--;
      switch (this.lifes) {
        case 1:
          this.type = "A";
          break;
        case 2:
          this.type = "B";
          break;
        case 3:
          this.type = "C";
      }
      this.updateImage();
      return points;
    };

    Brick.prototype.dead = function() {
      return this.lifes <= 0;
    };

    Brick.prototype.updateImage = function() {
      return this.image = Brick.IMAGES[this.type];
    };

    return Brick;

  })(Sprite);

  LevelMap = (function() {

    function LevelMap() {
      this.paddle = new Paddle(this);
      this.board = new Board(this);
      this.ball = new Ball(this);
      this.music = resource.sound("sounds/ride-the-storm.ogg");
      this.bricks = [];
      this.bonus = null;
      this.currentLevel = 0;
      this.stateLabel = new Label({
        font: "20pt Arial",
        color: "yellow",
        x: CONFIG.mapWidth / 2,
        y: 3 * CONFIG.mapHeight / 4,
        alignment: "center",
        text: "Presione 'espacio' para lanzar"
      });
    }

    LevelMap.prototype.init = function(content) {
      var brick, bricks, col, line, lines, row, type, x, y, _ref, _ref2;
      this.music.play();
      this.bricks = [];
      this.lifes = 3;
      this.points = 0;
      lines = content.split("\n");
      this.name = lines[0];
      lines = lines.slice(1);
      for (row = 0, _ref = lines.length - 1; 0 <= _ref ? row <= _ref : row >= _ref; 0 <= _ref ? row++ : row--) {
        line = lines[row];
        bricks = line.split(",");
        for (col = 0, _ref2 = bricks.length - 1; 0 <= _ref2 ? col <= _ref2 : col >= _ref2; 0 <= _ref2 ? col++ : col--) {
          type = bricks[col];
          if (type !== "X") {
            x = col * CONFIG.cellWidth;
            y = row * CONFIG.cellHeight;
            brick = new Brick(x, y, type);
            this.bricks.push(brick);
          }
        }
      }
      this.paddle.init();
      return this.ball.init();
    };

    LevelMap.prototype.removeBrickAt = function(x, y) {
      var brick, _i, _len, _ref, _ref2, _results;
      _ref = this.bricks;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        brick = _ref[_i];
        if ((brick != null) && ((_ref2 = brick.type) === "A" || _ref2 === "E") && x > brick.left() && x < brick.right() && y > brick.top() && y < brick.bottom()) {
          _results.push(this.removeBrick(brick));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    LevelMap.prototype.explodeBrick = function(brick) {
      this.removeBrickAt(brick.centerX() - brick.width(), brick.centerY() - brick.height());
      this.removeBrickAt(brick.centerX() - brick.width(), brick.centerY());
      this.removeBrickAt(brick.centerX() - brick.width(), brick.centerY() + brick.height());
      this.removeBrickAt(brick.centerX() + brick.width(), brick.centerY() - brick.height());
      this.removeBrickAt(brick.centerX() + brick.width(), brick.centerY());
      this.removeBrickAt(brick.centerX() + brick.width(), brick.centerY() + brick.height());
      this.removeBrickAt(brick.centerX(), brick.centerY() - brick.height());
      return this.removeBrickAt(brick.centerX(), brick.centerY() + brick.height());
    };

    LevelMap.prototype.checkCollision = function(ball) {
      var brick, collisionSide, lifes, _i, _len, _ref;
      _ref = this.bricks;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        brick = _ref[_i];
        collisionSide = collision(ball, brick);
        if (collisionSide) {
          lifes = brick.touch();
          if (brick.type !== "D") this.points += 10 * lifes;
          if (brick.dead()) {
            if (brick.type === "E") this.explodeBrick(brick);
            this.removeBrick(brick);
            if (!(this.bonus != null) && !(this.activeAction != null)) {
              this.bonus = new Bonus(brick.centerX(), brick.centerY(), this);
            }
          }
          return [brick, collisionSide];
        }
      }
      return false;
    };

    LevelMap.prototype.removeBrick = function(brick) {
      var index;
      index = this.bricks.indexOf(brick);
      return this.bricks.splice(index, 1);
    };

    LevelMap.prototype.removeBonus = function() {
      return this.bonus = null;
    };

    LevelMap.prototype.die = function() {
      return this.lifes--;
    };

    LevelMap.prototype.checkState = function() {
      var brick, _i, _len, _ref;
      if (this.lifes < 0) {
        this.ball.state = "lost";
        this.stateLabel.text = "GAME OVER";
        this.stateLabel.color = "red";
      }
      _ref = this.bricks;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        brick = _ref[_i];
        if (brick.type !== "D") return;
      }
      this.ball.state = "win";
      this.ball.state = "win";
      this.stateLabel.text = "GANASTE!";
      return this.stateLabel.color = "green";
    };

    LevelMap.prototype.update = function(dt) {
      var brick, _i, _len, _ref, _ref2;
      if (key('w')) {
        _ref = this.bricks;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          brick = _ref[_i];
          this.removeBrick(brick);
        }
      }
      if (this.ball.state === "win") {
        if (key('space')) {
          this.currentLevel++;
          if (this.currentLevel <= CONFIG.maxLevel) {
            this.init(LEVELS[this.currentLevel]);
            this.ball.state = 'ready';
          }
        }
        return;
      }
      if (this.ball.state === "playing" && key("space") && (this.activeAction != null) && this.activeAction.powerAction) {
        this.activeAction.action();
      }
      this.ball.update(dt);
      if (this.ball.state !== 'playing') this.removeBonus();
      this.paddle.update(dt);
      if ((_ref2 = this.bonus) != null) _ref2.update(dt);
      return this.checkState();
    };

    LevelMap.prototype.draw = function() {
      var brick, _i, _len, _ref, _ref2;
      _ref = this.bricks;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        brick = _ref[_i];
        brick.draw();
      }
      this.board.draw();
      this.ball.draw();
      if ((_ref2 = this.bonus) != null) _ref2.draw();
      this.paddle.draw();
      if (this.ball.state !== "playing") return this.stateLabel.draw();
    };

    return LevelMap;

  })();

  Board = (function() {

    function Board(map) {
      this.map = map;
      this.lifesLabel = new Label({
        font: "12pt Arial",
        color: "white",
        x: 10,
        y: CONFIG.mapHeight + 3 * CONFIG.boardHeight / 4,
        text: "Vidas:"
      });
      this.pointsLabel = new Label({
        font: "12pt Arial",
        color: "white",
        x: 80,
        y: CONFIG.mapHeight + 3 * CONFIG.boardHeight / 4,
        text: "Puntos:"
      });
      this.nameLabel = new Label({
        font: "12pt Arial",
        color: "blue",
        x: CONFIG.mapWidth,
        y: CONFIG.mapHeight + 3 * CONFIG.boardHeight / 4,
        alignment: "right",
        text: "Level:"
      });
      this.bonusLabel = new Label({
        font: "12pt Arial",
        x: 180,
        y: CONFIG.mapHeight + 3 * CONFIG.boardHeight / 4,
        text: ""
      });
    }

    Board.prototype.draw = function() {
      var _this = this;
      this.lifesLabel.text = "Vidas: " + this.map.lifes;
      this.pointsLabel.text = "Puntos: " + this.map.points;
      this.nameLabel.text = "<" + this.map.name + ">";
      if (this.map.activeAction != null) {
        this.bonusLabel.text = this.map.activeAction.text;
        this.bonusLabel.color = this.map.activeAction.color;
      } else {
        this.bonusLabel.text = "";
      }
      tinto.activeCanvas.preserveContext(function(context) {
        context.fillStyle = "gray";
        return context.fillRect(0, CONFIG.mapHeight, CONFIG.mapWidth, CONFIG.boardHeight);
      });
      this.lifesLabel.draw();
      this.pointsLabel.draw();
      this.nameLabel.draw();
      return this.bonusLabel.draw();
    };

    return Board;

  })();

  key = tinto.input.key;

  resource = tinto.resource;

  Sprite = tinto.sprite.Sprite;

  Paddle = (function(_super) {

    __extends(Paddle, _super);

    function Paddle(map) {
      this.map = map;
      Paddle.__super__.constructor.call(this, {
        image: resource.image("graphics/paddle.png")
      });
      this.speed = 300;
      this.mirror = false;
      this.sticky = false;
      this.missiles = [];
    }

    Paddle.prototype.init = function() {
      this.x = CONFIG.mapWidth / 2 - this.width() / 2;
      this.y = CONFIG.cellHeight * 21;
      this.limitRight = CONFIG.mapWidth - this.width();
      return this.limitLeft = 0;
    };

    Paddle.prototype.update = function(dt) {
      var leftKey, missile, rightKey, _i, _len, _ref, _results;
      leftKey = this.mirror ? "right" : "left";
      rightKey = this.mirror ? "left" : "right";
      if (key(leftKey)) this.x -= this.speed * dt;
      if (key(rightKey)) this.x += this.speed * dt;
      if (this.x < this.limitLeft) this.x = this.limitLeft;
      if (this.x > this.limitRight) this.x = this.limitRight;
      if ((this.map.bonus != null) && collision(this.map.bonus, this)) {
        this.map.bonus.executeAction();
      }
      _ref = this.missiles;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        missile = _ref[_i];
        _results.push(missile.update(dt));
      }
      return _results;
    };

    Paddle.prototype.draw = function() {
      var missile, _i, _len, _ref, _results;
      Paddle.__super__.draw.call(this);
      _ref = this.missiles;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        missile = _ref[_i];
        _results.push(missile.draw());
      }
      return _results;
    };

    Paddle.prototype.shoot = function() {
      var missile1, missile2;
      if (this.missiles.length !== 0) return;
      missile1 = new Missile(this.map);
      missile2 = new Missile(this.map);
      missile1.shoot(SIDE.left);
      missile2.shoot(SIDE.right);
      return this.missiles = [missile1, missile2];
    };

    return Paddle;

  })(Sprite);

  Missile = (function(_super) {

    __extends(Missile, _super);

    Missile.IMAGE = resource.image("graphics/missile.png");

    function Missile(map) {
      this.map = map;
      Missile.__super__.constructor.call(this, {
        image: Missile.IMAGE
      });
      this.speed = -400;
    }

    Missile.prototype.shoot = function(side) {
      if (side === SIDE.left) {
        this.x = this.map.paddle.left() + 5;
      } else {
        this.x = this.map.paddle.right() - 5;
      }
      return this.y = this.map.paddle.top();
    };

    Missile.prototype.update = function(dt) {
      this.y += this.speed * dt;
      if (this.bottom() < 0) return this.map.paddle.missiles = [];
    };

    return Missile;

  })(Sprite);

  key = tinto.input.key;

  resource = tinto.resource;

  Sprite = tinto.sprite.Sprite;

  Ball = (function(_super) {

    __extends(Ball, _super);

    function Ball(map) {
      this.map = map;
      Ball.__super__.constructor.call(this, {
        image: resource.image("graphics/ball.png")
      });
      this.MAX_SPEED = 300;
      this.state = 'ready';
      this.fireball = false;
    }

    Ball.prototype.init = function() {
      this.state = 'ready';
      this.speedX = this.MAX_SPEED / 2;
      this.speedY = -this.MAX_SPEED / 2;
      this.limitRight = CONFIG.mapWidth - this.width();
      this.limitLeft = 0;
      this.limitTop = 0;
      return this.limitBottom = CONFIG.mapHeight - this.height();
    };

    Ball.prototype.bouncePaddle = function(paddle) {
      var paddleDistance, speedMagnitude;
      this.y = paddle.top() - this.height();
      this.speedY *= -1;
      paddleDistance = this.centerX() - paddle.centerX();
      speedMagnitude = paddleDistance / (paddle.width() / 2);
      return this.speedX = this.MAX_SPEED * speedMagnitude;
    };

    Ball.prototype.bounceBrick = function(brick, side) {
      if (side === SIDE.left) {
        this.x = brick.left() - this.width();
        return this.speedX *= -1;
      } else if (side === SIDE.right) {
        this.x = brick.right();
        return this.speedX *= -1;
      } else if (side === SIDE.top) {
        this.y = brick.top() - this.height();
        return this.speedY *= -1;
      } else if (side === SIDE.bottom) {
        this.y = brick.bottom();
        return this.speedY *= -1;
      }
    };

    Ball.prototype.update = function(dt) {
      switch (this.state) {
        case "playing":
          return this.updatePlaying(dt);
        case "ready":
          return this.updateReady(dt);
        case "lost":
          return this.updateLost(dt);
        case "win":
          return this.updateLost(dt);
      }
    };

    Ball.prototype.updateLost = function(dt) {
      var paddle;
      paddle = this.map.paddle;
      this.x = paddle.centerX() - this.width() / 2;
      return this.y = paddle.top() - this.height();
    };

    Ball.prototype.updateReady = function(dt) {
      var paddle;
      paddle = this.map.paddle;
      this.x = paddle.centerX() - this.width() / 2;
      this.y = paddle.top() - this.height();
      if (key("space")) {
        this.state = "playing";
        if (paddle.sticky) {
          this.map.activeAction.stop();
          return this.map.activeAction = null;
        }
      }
    };

    Ball.prototype.updatePlaying = function(dt) {
      var brick, paddle, side, _ref;
      paddle = this.map.paddle;
      this.x += this.speedX * dt;
      this.y += this.speedY * dt;
      if (this.x > this.limitRight) {
        this.x = this.limitRight;
        this.speedX *= -1;
      }
      if (this.x < this.limitLeft) {
        this.x = this.limitLeft;
        this.speedX *= -1;
      }
      if (this.y < this.limitTop) {
        this.y = this.limitTop;
        this.speedY *= -1;
      }
      if (collision(this, paddle) === SIDE.top) {
        if (paddle.sticky) {
          this.init();
        } else {
          this.bouncePaddle(paddle);
        }
      }
      if (this.y > this.limitBottom) {
        this.init();
        this.map.die();
      }
      _ref = this.map.checkCollision(this), brick = _ref[0], side = _ref[1];
      if (side && !this.fireball) return this.bounceBrick(brick, side);
    };

    return Ball;

  })(Sprite);

  key = tinto.input.key;

  resource = tinto.resource;

  Sprite = tinto.sprite.Sprite;

  randomChoice = function(items) {
    return items[Math.floor(Math.random() * items.length)];
  };

  BonusAction = (function() {

    function BonusAction() {}

    BonusAction.prototype.execute = function(map) {
      var _this = this;
      this.map = map;
      this.start();
      if (this.duration != null) {
        return setTimeout((function() {
          _this.end();
          return _this.map.activeAction = null;
        }), this.duration * 1000);
      }
    };

    BonusAction.prototype.remove = function() {
      this.end();
      return this.map.activeAction = null;
    };

    return BonusAction;

  })();

  ExtraLifeBonusAction = (function(_super) {

    __extends(ExtraLifeBonusAction, _super);

    function ExtraLifeBonusAction() {
      ExtraLifeBonusAction.__super__.constructor.apply(this, arguments);
    }

    ExtraLifeBonusAction.prototype.color = 'lightgreen';

    ExtraLifeBonusAction.prototype.text = 'Vida Extra!';

    ExtraLifeBonusAction.prototype.duration = 2;

    ExtraLifeBonusAction.prototype.start = function() {
      return this.map.lifes++;
    };

    ExtraLifeBonusAction.prototype.end = function() {};

    return ExtraLifeBonusAction;

  })(BonusAction);

  LargePadBonusAction = (function(_super) {

    __extends(LargePadBonusAction, _super);

    function LargePadBonusAction() {
      LargePadBonusAction.__super__.constructor.apply(this, arguments);
    }

    LargePadBonusAction.IMAGE = resource.image("graphics/paddle_large.png");

    LargePadBonusAction.prototype.color = 'lightgreen';

    LargePadBonusAction.prototype.text = 'Agrandar!';

    LargePadBonusAction.prototype.duration = 12;

    LargePadBonusAction.prototype.start = function() {
      var center, paddle;
      this.oldImage = this.map.paddle.image;
      paddle = this.map.paddle;
      center = paddle.centerX();
      paddle.image = LargePadBonusAction.IMAGE;
      return paddle.x = center - paddle.width() / 2;
    };

    LargePadBonusAction.prototype.end = function() {
      var center, paddle;
      paddle = this.map.paddle;
      center = paddle.centerX();
      paddle.image = this.oldImage;
      return paddle.x = center - paddle.width() / 2;
    };

    return LargePadBonusAction;

  })(BonusAction);

  ShortPadBonusAction = (function(_super) {

    __extends(ShortPadBonusAction, _super);

    function ShortPadBonusAction() {
      ShortPadBonusAction.__super__.constructor.apply(this, arguments);
    }

    ShortPadBonusAction.IMAGE = resource.image("graphics/paddle_short.png");

    ShortPadBonusAction.prototype.color = 'red';

    ShortPadBonusAction.prototype.text = 'Encoger!';

    ShortPadBonusAction.prototype.duration = 12;

    ShortPadBonusAction.prototype.start = function() {
      var center, paddle;
      this.oldImage = this.map.paddle.image;
      paddle = this.map.paddle;
      center = paddle.centerX();
      paddle.image = ShortPadBonusAction.IMAGE;
      return paddle.x = center - paddle.width() / 2;
    };

    ShortPadBonusAction.prototype.end = function() {
      var center, paddle;
      paddle = this.map.paddle;
      center = paddle.centerX();
      paddle.image = this.oldImage;
      return paddle.x = center - paddle.width() / 2;
    };

    return ShortPadBonusAction;

  })(BonusAction);

  ExplosionBonusAction = (function(_super) {

    __extends(ExplosionBonusAction, _super);

    function ExplosionBonusAction() {
      ExplosionBonusAction.__super__.constructor.apply(this, arguments);
    }

    ExplosionBonusAction.prototype.color = 'lightgreen';

    ExplosionBonusAction.prototype.text = 'Bloques explosivos!';

    ExplosionBonusAction.prototype.duration = 10;

    ExplosionBonusAction.prototype.start = function() {
      var brick, _i, _len, _ref, _results;
      _ref = this.map.bricks;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        brick = _ref[_i];
        if ((brick != null) && brick.type === "A") {
          brick.type = "E";
          _results.push(brick.updateImage());
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    ExplosionBonusAction.prototype.end = function() {
      var brick, _i, _len, _ref, _results;
      _ref = this.map.bricks;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        brick = _ref[_i];
        if ((brick != null) && brick.type === "E") {
          brick.type = "A";
          _results.push(brick.updateImage());
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    return ExplosionBonusAction;

  })(BonusAction);

  FastBallBonusAction = (function(_super) {

    __extends(FastBallBonusAction, _super);

    function FastBallBonusAction() {
      FastBallBonusAction.__super__.constructor.apply(this, arguments);
    }

    FastBallBonusAction.prototype.color = 'red';

    FastBallBonusAction.prototype.text = 'Bola rapida!';

    FastBallBonusAction.prototype.duration = 12;

    FastBallBonusAction.prototype.start = function() {
      this.map.ball.speedX *= 2;
      this.map.ball.speedY *= 2;
      return this.map.ball.MAX_SPEED *= 2;
    };

    FastBallBonusAction.prototype.end = function() {
      this.map.ball.speedX /= 2;
      this.map.ball.speedY /= 2;
      return this.map.ball.MAX_SPEED /= 2;
    };

    return FastBallBonusAction;

  })(BonusAction);

  SlowBallBonusAction = (function(_super) {

    __extends(SlowBallBonusAction, _super);

    function SlowBallBonusAction() {
      SlowBallBonusAction.__super__.constructor.apply(this, arguments);
    }

    SlowBallBonusAction.prototype.color = 'lightgreen';

    SlowBallBonusAction.prototype.text = 'Bola lenta!';

    SlowBallBonusAction.prototype.duration = 10;

    SlowBallBonusAction.prototype.start = function() {
      this.map.ball.speedX /= 2;
      this.map.ball.speedY /= 2;
      return this.map.ball.MAX_SPEED /= 2;
    };

    SlowBallBonusAction.prototype.end = function() {
      this.map.ball.speedX *= 2;
      this.map.ball.speedY *= 2;
      return this.map.ball.MAX_SPEED *= 2;
    };

    return SlowBallBonusAction;

  })(BonusAction);

  FireBallBonusAction = (function(_super) {

    __extends(FireBallBonusAction, _super);

    function FireBallBonusAction() {
      FireBallBonusAction.__super__.constructor.apply(this, arguments);
    }

    FireBallBonusAction.IMAGE = resource.image("graphics/fireball.png");

    FireBallBonusAction.prototype.color = 'lightgreen';

    FireBallBonusAction.prototype.text = 'Bola de fuego!';

    FireBallBonusAction.prototype.duration = 10;

    FireBallBonusAction.prototype.start = function() {
      this.oldImage = this.map.ball.image;
      this.map.ball.image = FireBallBonusAction.IMAGE;
      return this.map.ball.fireball = true;
    };

    FireBallBonusAction.prototype.end = function() {
      this.map.ball.image = this.oldImage;
      return this.map.ball.fireball = false;
    };

    return FireBallBonusAction;

  })(BonusAction);

  MirrorControlBonusAction = (function(_super) {

    __extends(MirrorControlBonusAction, _super);

    function MirrorControlBonusAction() {
      MirrorControlBonusAction.__super__.constructor.apply(this, arguments);
    }

    MirrorControlBonusAction.IMAGE = resource.image("graphics/mirror_paddle.png");

    MirrorControlBonusAction.prototype.color = 'red';

    MirrorControlBonusAction.prototype.text = 'Control espejo!';

    MirrorControlBonusAction.prototype.duration = 10;

    MirrorControlBonusAction.prototype.start = function() {
      this.oldImage = this.map.paddle.image;
      this.map.paddle.image = MirrorControlBonusAction.IMAGE;
      return this.map.paddle.mirror = true;
    };

    MirrorControlBonusAction.prototype.end = function() {
      this.map.paddle.image = this.oldImage;
      return this.map.paddle.mirror = false;
    };

    return MirrorControlBonusAction;

  })(BonusAction);

  StickyPaddleBonusAction = (function(_super) {

    __extends(StickyPaddleBonusAction, _super);

    function StickyPaddleBonusAction() {
      StickyPaddleBonusAction.__super__.constructor.apply(this, arguments);
    }

    StickyPaddleBonusAction.IMAGE = resource.image("graphics/sticky_paddle.png");

    StickyPaddleBonusAction.prototype.powerAction = true;

    StickyPaddleBonusAction.prototype.duration = null;

    StickyPaddleBonusAction.prototype.color = 'purple';

    StickyPaddleBonusAction.prototype.text = 'Atrapar: <espacio>';

    StickyPaddleBonusAction.prototype.start = function() {
      return this.oldImage = this.map.paddle.image;
    };

    StickyPaddleBonusAction.prototype.end = function() {};

    StickyPaddleBonusAction.prototype.action = function() {
      this.map.paddle.image = StickyPaddleBonusAction.IMAGE;
      return this.map.paddle.sticky = true;
    };

    StickyPaddleBonusAction.prototype.stop = function() {
      this.map.paddle.image = this.oldImage;
      return this.map.paddle.sticky = false;
    };

    return StickyPaddleBonusAction;

  })(BonusAction);

  MissileBonusAction = (function(_super) {

    __extends(MissileBonusAction, _super);

    function MissileBonusAction() {
      MissileBonusAction.__super__.constructor.apply(this, arguments);
    }

    MissileBonusAction.IMAGE = resource.image("graphics/battle_paddle.png");

    MissileBonusAction.prototype.color = 'purple';

    MissileBonusAction.prototype.text = 'Disparar: <espacio>!';

    MissileBonusAction.prototype.duration = 12;

    MissileBonusAction.prototype.powerAction = true;

    MissileBonusAction.prototype.start = function() {
      this.oldImage = this.map.paddle.image;
      return this.map.paddle.image = MissileBonusAction.IMAGE;
    };

    MissileBonusAction.prototype.end = function() {
      return this.map.paddle.image = this.oldImage;
    };

    MissileBonusAction.prototype.action = function() {
      return this.map.paddle.shoot();
    };

    return MissileBonusAction;

  })(BonusAction);

  Bonus = (function(_super) {

    __extends(Bonus, _super);

    Bonus.IMAGE = resource.image("graphics/bonus.png");

    Bonus.ACTIONS = [ExtraLifeBonusAction, LargePadBonusAction, ShortPadBonusAction, ExplosionBonusAction, FastBallBonusAction, SlowBallBonusAction, FireBallBonusAction, MirrorControlBonusAction, StickyPaddleBonusAction, MissileBonusAction];

    function Bonus(x, y, map) {
      this.x = x;
      this.y = y;
      this.map = map;
      Bonus.__super__.constructor.call(this, {
        image: Bonus.IMAGE
      });
      this.speed = 50;
      BonusAction = randomChoice(Bonus.ACTIONS);
      this.action = new BonusAction();
    }

    Bonus.prototype.update = function(dt) {
      this.y += this.speed * dt;
      if (this.bottom() > CONFIG.mapWidth) return this.map.removeBonus();
    };

    Bonus.prototype.executeAction = function() {
      this.map.activeAction = this.action;
      this.action.execute(this.map);
      return this.map.removeBonus();
    };

    return Bonus;

  })(Sprite);

  key = tinto.input.key;

  resource = tinto.resource;

  Sprite = tinto.sprite.Sprite;

  Label = tinto.text.Label;

  window.onload = function() {
    var canvas, levelMap, loading, ready;
    canvas = new tinto.canvas.GameCanvas('gamecanvas', {
      width: CONFIG.mapWidth,
      height: CONFIG.mapHeight + CONFIG.boardHeight,
      background: 'black'
    });
    loading = new Label({
      font: "28pt Arial",
      color: "red",
      x: CONFIG.mapWidth / 2,
      y: CONFIG.mapHeight / 2,
      alignment: "center",
      text: "Cargando..."
    });
    loading.draw();
    levelMap = new LevelMap();
    ready = false;
    tinto.resource.loaded(function() {
      ready = true;
      return levelMap.init(LEVELS[0]);
    });
    window.loadMap = function(level) {
      if (ready) {
        levelMap.init(LEVELS[level]);
        return tinto.input.clear();
      } else {
        return alert("Estoy cargando, por favor espere un momento.");
      }
    };
    tinto.resource.loadAll();
    canvas.update(function(dt) {
      return levelMap.update(dt);
    });
    return canvas.draw(function() {
      canvas.clear();
      return levelMap.draw();
    });
  };

}).call(this);
