# Imports
key = tinto.input.key
resource = tinto.resource
Sprite = tinto.sprite.Sprite

class Ball extends Sprite

  constructor: (@map) ->
    super
      image: resource.image("graphics/ball.png")

    @MAX_SPEED = 300
    @state = 'ready'
    @fireball = false

  init: ->
    @speedX = @MAX_SPEED / 2
    @speedY = -@MAX_SPEED / 2
    @limitRight = CONFIG.mapWidth - @width()
    @limitLeft = 0
    @limitTop = 0
    @limitBottom = CONFIG.mapHeight - @height()

  bouncePaddle: (paddle) ->
    @y = paddle.top() - @height()
    @speedY *= -1
    paddleDistance = @centerX() - paddle.centerX()
    speedMagnitude = paddleDistance / (paddle.width() / 2)
    @speedX = @MAX_SPEED * speedMagnitude

  bounceBrick: (brick, side) ->
    if side == SIDE.left
      @x = brick.left() - @width()
      @speedX *= -1
    else if side == SIDE.right
      @x = brick.right()
      @speedX *= -1
    else if side == SIDE.top
      @y = brick.top() - @height()
      @speedY *= -1
    else if side == SIDE.bottom
      @y = brick.bottom()
      @speedY *= -1

  update: (dt) ->
    switch @state
      when "playing" then @updatePlaying dt
      when "ready" then @updateReady dt
      when "lost" then @updateLost dt

  updateLost: (dt) ->
    paddle = @map.paddle
    @x = paddle.centerX() - @width() / 2
    @y = paddle.top() - @height()

  updateReady: (dt) ->
    paddle = @map.paddle
    @x = paddle.centerX() - @width() / 2
    @y = paddle.top() - @height()

    if key("space")
      if paddle.sticky
        # FIXME
        @map.activeAction.stop()
        @map.activeAction = null
      @state = "playing"

  updatePlaying: (dt) ->
    paddle = @map.paddle
    @x += @speedX * dt
    @y += @speedY * dt

    if @x > @limitRight
      @x = @limitRight
      @speedX *= -1


    if @x < @limitLeft
      @x = @limitLeft
      @speedX *= -1

    if @y < @limitTop
      @y = @limitTop
      @speedY *= -1

    if collision(this, paddle) == SIDE.top
      if paddle.sticky
        @init()
        @state = "ready"
      else
        @bouncePaddle(paddle)

    if @y > @limitBottom
      @init()
      @map.die()
      @state = "ready"

    [brick, side] = @map.checkCollision(this)
    if side and not @fireball
      @bounceBrick(brick, side)
