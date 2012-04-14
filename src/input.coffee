@tinto.input = do ->

  # Private.
  KEY_CODES =
    "mac_enter": 3
    "backspace": 8
    "tab": 9
    "enter": 13
    "shift": 16
    "ctrl": 17
    "alt": 18
    "pause": 19
    "caps_lock": 20
    "esc": 27
    "space": 32
    "page_up": 33
    "page_down": 34
    "end": 35
    "home": 36
    "left": 37
    "up": 38
    "right": 39
    "down": 40
    "insert": 45
    "delete": 46
    "0": 48
    "1": 49
    "2": 50
    "3": 51
    "4": 52
    "5": 53
    "6": 54
    "7": 55
    "8": 56
    "9": 57
    "a": 65
    "b": 66
    "c": 67
    "d": 68
    "e": 69
    "f": 70
    "g": 71
    "h": 72
    "i": 73
    "j": 74
    "k": 75
    "l": 76
    "m": 77
    "n": 78
    "o": 79
    "p": 80
    "q": 81
    "r": 82
    "s": 83
    "t": 84
    "u": 85
    "v": 86
    "w": 87
    "x": 88
    "y": 89
    "z": 90
    "win": 91
    "context_menu": 93
    "numpad_0": 96
    "numpad_1": 97
    "numpad_2": 98
    "numpad_3": 99
    "numpad_4": 100
    "numpad_5": 101
    "numpad_6": 102
    "numpad_7": 103
    "numpad_8": 104
    "numpad_9": 105
    "numpad_*": 106
    "numpad_+": 107
    "numpad_-": 109
    "numpad_.": 110
    "numpad_/": 111
    "f1": 112
    "f2": 113
    "f3": 114
    "f4": 115
    "f5": 116
    "f6": 117
    "f7": 118
    "f8": 119
    "f9": 120
    "f10": 121
    "f11": 122
    "f12": 123
    ";": 186
    ":": 186
    "-": 189
    "=": 187
    ",": 188
    "<": 188
    ".": 190
    ">": 190
    "/": 191
    "?": 191
    "~": 192
    "`": 192
    "[": 219
    "{": 219
    "\\": 220
    "|": 220
    "]": 221
    "}": 221
    "'": 222
    "\"": 222

  # Generate the key names map using the inverse of KEY_CODES
  KEY_NAMES = {}
  for name, code of KEY_CODES
     KEY_NAMES[code] = name

  MOZILLA = navigator.userAgent.indexOf 'Gecko' != -1
  OPERA = window.opera

  # Mozilla Firefox and Opera use different key codes for the following keys.
  # This codes have been taken from:
  # http://www.javascripter.net/faq/keycodes.htm
  MOZILLA_OPERA_MAP =
    59:  186  # ; :
    61:  187  # = +
    109: 189  # - _

  normalizeKeyCode = (keyCode) ->
    if MOZILLA or OPERA
      return MOZILLA_OPERA_MAP[keyCode] or keyCode
    else
      return keyCode

  # Internal map of down keys
  keysDown = {}
  keyPressedEvent = new tinto.EventEmitter()
  keyReleasedEvent = new tinto.EventEmitter()

  #Public interface.
  installKeyboardCallbacks: ->
    document.addEventListener "keydown", (event) ->
      code = event.which or event.keyCode
      code = normalizeKeyCode code
      keysDown[code] = true
      keyPressedEvent.call(code)

    document.addEventListener "keyup", (event) ->
      code = event.which or event.keyCode
      code = normalizeKeyCode code
      delete keysDown[code]
      keyReleasedEvent.call(code)

  key: (keyName) ->
    keyCode = KEY_CODES[keyName]
    if keyCode
      return keysDown[keyCode]
    else
      return false

  keypressed: (callback) -> keyPressedEvent.addCallback(callback)
  keyreleased: (callback) -> keyReleasedEvent.addCallback(callback)

  keyName: (keyCode) -> KEY_NAMES[keyCode] ? 'unknown'