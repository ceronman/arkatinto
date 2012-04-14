# Imports
key = tinto.input.key
resource = tinto.resource
Sprite = tinto.sprite.Sprite


class Paddle extends Sprite

  constructor: (@map) ->
    super
      image: resource.image("graphics/paddle.png")

    @speed = 300

  init: ->
    @x = CONFIG.mapWidth / 2 - @width() / 2
    @y = CONFIG.cellHeight * 21

    @limitRight = CONFIG.mapWidth - @width()
    @limitLeft = 0

  update : (dt) ->
    if key "left"
      @x -= @speed * dt
    if key "right"
      @x += @speed * dt

    if @x < @limitLeft
      @x = @limitLeft

    if @x > @limitRight
      @x = @limitRight