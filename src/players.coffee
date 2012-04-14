# Imports
key = tinto.input.key
resource = tinto.resource
Sprite = tinto.sprite.Sprite

@tinto.players = do ->

  SIDE =
    top: 1
    left: 2
    bottom: 3
    right: 4

  speedAngle = (speedX, speedY) ->
    Math.atan2(speedY, speedX)

  collision = (sprite1, sprite2) ->
    collide = (sprite1.right() > sprite2.left() and
               sprite1.left() < sprite2.right() and
               sprite1.bottom() > sprite2.top() and
               sprite1.top() < sprite2.bottom())

    if not collide
      return false

    if sprite1.left() < sprite2.left()
      if sprite1.top() < sprite2.top()
        if speedAngle(sprite1.speedX, -sprite1.speedY) < -(Math.PI/4)
          return SIDE.left
        else
          return SIDE.top
      else if sprite1.bottom() > sprite2.bottom()
        if speedAngle(sprite1.speedX, -sprite1.speedY) < (Math.PI/4)
          return SIDE.left
        else
          return SIDE.bottom
      else
        return SIDE.left

    if sprite1.right() > sprite2.right()
      if sprite1.top() < sprite2.top()
        if speedAngle(sprite1.speedX, -sprite1.speedY) < -3*(Math.PI/4)
          return SIDE.right
        else
          return SIDE.top

      else if sprite1.bottom() > sprite2.bottom()
        if speedAngle(sprite1.speedX, -sprite1.speedY) > 3*(Math.PI/4)
          return SIDE.right
        else
          return SIDE.bottom

    if sprite1.bottom() > sprite2.bottom()
      return SIDE.bottom
    else
      return SIDE.top



  class Brick extends Sprite
    constructor: (@x, @y, @type)->
      super
        image: resource.image("graphics/brick#{type}.png")
        @lifes = 1

    touch: -> @lifes--
    dead: -> @lifes <= 0


  class LevelMap
    constructor: (content) ->
      @bricks = []

      lines = content.split("\n")
      @name = lines[0]
      lines = lines[1..]

      for row in [0..lines.length-1]
        line = lines[row]
        bricks = line.split(",")
        for col in [0..bricks.length-1]
          type = bricks[col]
          if type != "X"
            x = col * CONFIG.cellWidth
            y = row * CONFIG.cellHeight
            brick = new Brick(x, y, type)
            @bricks.push brick

    checkCollision: (ball) ->
      for brick in @bricks
        if collision(ball, brick)
          console.log collision(ball, brick)
          brick.touch()
          if brick.dead()
            @removeBrick(brick)
          return true
      return false

    removeBrick: (brick) ->
      index = @bricks.indexOf(brick)
      @bricks.splice(index, 1)

    draw: ->
      for brick in @bricks
        brick.draw()


  class Paddle extends Sprite

    constructor: ->
      super
        image: resource.image("graphics/paddle.png")

      @speed = 300

    center: ->
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


  class Ball extends Sprite

    constructor: ->
      super
        image: resource.image("graphics/ball.png")

      @MAX_SPEED = 4

      @speedX = 1
      @speedY = -20

    center: ->
      @x = CONFIG.mapWidth / 2 - @width() / 2
      # @y = CONFIG.mapHeight / 2 - @height() / 2
      # @x = 100
      @y = 800

      @limitRight = CONFIG.mapWidth - @width()
      @limitLeft = 0
      @limitTop = 0
      @limitBottom = CONFIG.mapHeight - @height()

    bounce: (paddle) ->
      @y = paddle.top()
      @speedY *= -1
      paddleDistance = @centerX() - paddle.centerX()
      speedMagnitude = paddleDistance / (paddle.width() / 2)
      @speedX = @MAX_SPEED * speedMagnitude

    update: (dt, paddle, map) ->
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

      if collision(this, paddle)
        @bounce(paddle)
      else if @y > @limitBottom
        @center()

      map.checkCollision(this)


  LevelMap: LevelMap
  Paddle: Paddle
  Ball: Ball
