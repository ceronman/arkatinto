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
    @missiles = []

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

    for missile in @missiles
      missile.update(dt)

  draw: ->
    super()
    for missile in @missiles
      missile.draw()

  shoot: ->
    if @missiles.length != 0
      return

    missile1 = new Missile(@map)
    missile2 = new Missile(@map)

    missile1.shoot(SIDE.left)
    missile2.shoot(SIDE.right)

    @missiles = [missile1, missile2]


class Missile extends Sprite

  @IMAGE: resource.image("graphics/missile.png")

  constructor: (@map) ->
    super
      image: Missile.IMAGE

    @speed = -400

  shoot: (side) ->
    if side == SIDE.left
      @x = @map.paddle.left() + 5
    else
      @x = @map.paddle.right() - 5

    @y = @map.paddle.top()

  update: (dt) ->
    @y += @speed * dt
    if @bottom() < 0
      @map.paddle.missiles = []
