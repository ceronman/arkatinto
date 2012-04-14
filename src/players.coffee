# Imports
key = tinto.input.key
resource = tinto.resource
Sprite = tinto.sprite.Sprite
Label = tinto.text.Label

@tinto.players = do ->

  SIDE =
    top: 1
    left: 2
    bottom: 3
    right: 4

  speedAngle = (speedX, speedY) ->


  collision = (sprite1, sprite2) ->
    collide = (sprite1.right() > sprite2.left() and
               sprite1.left() < sprite2.right() and
               sprite1.bottom() > sprite2.top() and
               sprite1.top() < sprite2.bottom())

    if not collide
      return false

    if sprite1.left() < sprite2.left()
      if sprite1.top() < sprite2.top()
        angle = Math.atan2(-sprite1.speedY, sprite1.speedX)
        if angle > -(Math.PI/4)
          return SIDE.left
        else
          return SIDE.top
      else if sprite1.bottom() > sprite2.bottom()
        angle = Math.atan2(-sprite1.speedY, sprite1.speedX)
        if  angle < (Math.PI/4)
          return SIDE.left
        else
          return SIDE.bottom
      else
        return SIDE.left

    if sprite1.right() > sprite2.right()
      if sprite1.top() < sprite2.top()
        angle = Math.atan2(-sprite1.speedY, sprite1.speedX)
        if angle < -3*(Math.PI/4) or angle > (Math.PI/2)
          return SIDE.right
        else
          return SIDE.top

      else if sprite1.bottom() > sprite2.bottom()
        angle = Math.atan2(-sprite1.speedY, sprite1.speedX)
        if angle > 3*(Math.PI/4) or angle < -Math.PI/2
          return SIDE.right
        else
          return SIDE.bottom
      else
        return SIDE.right

    if sprite1.bottom() > sprite2.bottom()
      return SIDE.bottom
    if sprite1.top() < sprite2.top()
      return SIDE.top
    console.log('unknown side')


  class Brick extends Sprite
    constructor: (@x, @y, @type)->
      super
        image: resource.image("graphics/brick#{type}.png")
        switch @type
          when "A" then @lifes = 1
          when "B" then @lifes = 2
          when "C" then @lifes = 3
          else @lifes = Infinity

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
        collisionSide = collision(ball, brick)
        if collisionSide
          brick.touch()
          if brick.dead()
            @removeBrick(brick)
          return [brick, collisionSide]
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

      @MAX_SPEED = 300

      @speedX = 200
      @speedY = -200

      @state = 'ready'

    center: ->
      @x = CONFIG.mapWidth / 2 - @width() / 2
      # @y = CONFIG.mapHeight / 2 - @height() / 2
      # @x = 100
      @y = 360

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

    update: (dt, paddle, map) ->
      switch @state
        when "playing" then @updatePlaying dt, paddle, map
        when "ready" then @updateReady dt, paddle, map

    updateReady: (dt, paddle, map) ->
      @x = paddle.centerX() - @width() / 2
      @y = paddle.top() - @height()

      if key("space")
        @state = "playing"

    updatePlaying: (dt, paddle, map) ->
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
        @bouncePaddle(paddle)

      if @y > @limitBottom
        @center()
        @state = "ready"

      [brick, side] = map.checkCollision(this)
      if side
        @bounceBrick(brick, side)


  class Board

    constructor: () ->
      @lifes = CONFIG.initialLifes
      @points = 0

      @lifesLabel = new Label
        font: "12pt Arial"
        color: "white"
        x: 10
        y: CONFIG.mapHeight + 3 * CONFIG.boardHeight / 4
        text: "Vidas: #{@lifes}"

      @pointsLabel = new Label
        font: "12pt Arial"
        color: "white"
        x: 100
        y: CONFIG.mapHeight + 3 * CONFIG.boardHeight / 4
        text: "Puntos: #{@points}"

    update: (dt) ->
      @lifesLabel.text = "Vidas: #{@lifes}"
      @pointsLabel.text = "Puntos: #{@points}"

    draw: () ->
      tinto.activeCanvas.preserveContext (context) =>
        context.fillStyle = "gray"
        context.fillRect(0, CONFIG.mapHeight,
                         CONFIG.mapWidth, CONFIG.boardHeight)
      @lifesLabel.draw()
      @pointsLabel.draw()


  LevelMap: LevelMap
  Paddle: Paddle
  Ball: Ball
  Board: Board
