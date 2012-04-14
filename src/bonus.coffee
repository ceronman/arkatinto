# Imports
key = tinto.input.key
resource = tinto.resource
Sprite = tinto.sprite.Sprite


class Bonus extends Sprite

  @IMAGE = resource.image("graphics/bonus.png")

  constructor: (@x, @y, @map) ->
    console.log @x, @y
    super
      image: Bonus.IMAGE

    @speed = 50

  update: (dt) ->
    @y += @speed * dt

    if @y > CONFIG.mapWidth
      @map.removeBonus()