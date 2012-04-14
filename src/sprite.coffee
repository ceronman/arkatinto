# tinto.sprite module.

@tinto.sprite = do ->

  class Sprite

    constructor: (options) ->
      for key, value of options
        this[key] = value

    draw: () ->
      tinto.activeCanvas.preserveContext (context) =>
        context.drawImage @image, @x, @y

    top: -> @y - @image.height
    bottom: -> @y
    left: -> @x
    right: -> @x + @image.width
    centerX: -> @x + @image.width / 2
    centerY: -> @y + @image.height / 2
    width: -> @image.width ? 0
    height: -> @image.height ? 0


  # Public interface.
  Sprite: Sprite
