# Imports
key = tinto.input.key
resource = tinto.resource
Sprite = tinto.sprite.Sprite

@tinto.players = do ->

  class Brick extends Sprite
    constructor: (@x, @y, @type)->
      super
        image: resource.image("graphics/brick#{type}.png")


  class LevelMap
    constructor: (content) ->
      @bricks = []

      lines = content.split("\n")
      @name = lines[0]
      lines = lines[1..]

      for row in [0..lines.length-1]
        line = lines[row]
        console.log "line", line
        bricks = line.split(",")
        for col in [0..bricks.length-1]
          type = bricks[col]
          console.log "brick", type
          if type != "X"
            x = col * CONFIG.cellWidth
            y = row * CONFIG.cellHeight
            brick = new Brick(x, y, type)
            @bricks.push brick

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

      @MAX_SPEED = 400

      @speedX = 200
      @speedY = 300

    center: ->
      @x = CONFIG.mapWidth / 2 - @width() / 2
      @y = CONFIG.mapHeight / 2 - @height() / 2

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

    collision: (paddle) ->
      (@bottom() > paddle.top() and @bottom() < paddle.bottom() and
       @right() > paddle.left() and @right() < paddle.right())

    update: (dt, paddle) ->
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

      if @collision(paddle)
        @bounce(paddle)
      else if @y > @limitBottom
        @center()


  LevelMap: LevelMap
  Paddle: Paddle
  Ball: Ball
