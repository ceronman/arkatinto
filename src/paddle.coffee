# Imports
key = tinto.input.key
resource = tinto.resource
Sprite = tinto.sprite.Sprite


class Paddle extends Sprite

  constructor: (@map) ->
    super
      image: resource.image("graphics/paddle.png")

    @speed = 300
    @mirror = false
    @sticky = false

  init: ->
    @x = CONFIG.mapWidth / 2 - @width() / 2
    @y = CONFIG.cellHeight * 21

    @limitRight = CONFIG.mapWidth - @width()
    @limitLeft = 0

  update : (dt) ->
    leftKey = if @mirror then "right" else "left"
    rightKey = if @mirror then "left" else "right"

    if key leftKey
      @x -= @speed * dt
    if key rightKey
      @x += @speed * dt

    if @x < @limitLeft
      @x = @limitLeft

    if @x > @limitRight
      @x = @limitRight

    if @map.bonus? and collision(@map.bonus, this)
      @map.bonus.executeAction()