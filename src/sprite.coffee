# tinto.sprite module.

@tinto.sprite = do ->

  class Sprite

    constructor: (options) ->
      for key, value of options
        this[key] = value

    draw: () ->
      tinto.activeCanvas.preserveContext (context) =>
        context.drawImage @image, @x, @y

  # Public interface.
  Sprite: Sprite
