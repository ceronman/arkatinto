# Imports
resource = tinto.resource
Sprite = tinto.sprite.Sprite
Label = tinto.text.Label

SIDE =
  top: 1
  left: 2
  bottom: 3
  right: 4


class Brick extends Sprite
  @IMAGES:
    1: resource.image("graphics/brickA.png")
    2: resource.image("graphics/brickB.png")
    3: resource.image("graphics/brickC.png")
    Infinity: resource.image("graphics/brickD.png")

  constructor: (@x, @y, @type)->
    switch @type
      when "A" then @lifes = 1
      when "B" then @lifes = 2
      when "C" then @lifes = 3
      else @lifes = Infinity

    @image = Brick.IMAGES[@lifes]
    super image: @image

  touch: -> @lifes--
  dead: -> @lifes <= 0
  draw: ->
    @image = Brick.IMAGES[@lifes]
    super()


class LevelMap
  constructor: (content) ->
    @lifes = 3
    @points = 0
    @bricks = []

    @paddle = new Paddle(this)
    @board = new Board(this)
    @ball = new Ball(this)

    @stateLabel  = new Label
      font: "20pt Arial"
      color: "yellow"
      x: CONFIG.mapWidth / 2
      y: 3* CONFIG.mapHeight / 4
      alignment: "center"
      text: "Presione 'espacio' para lanzar"

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

  init: ->
    @paddle.init()
    @ball.init()

  checkCollision: (ball) ->
    for brick in @bricks
      collisionSide = collision(ball, brick)
      if collisionSide
        lifes = brick.touch()
        if brick.type != "D"
          @points += 10 * lifes
        if brick.dead()
          @removeBrick(brick)
        return [brick, collisionSide]
    return false

  removeBrick: (brick) ->
    index = @bricks.indexOf(brick)
    @bricks.splice(index, 1)

  die: -> @lifes--

  checkState: ->
    if @lifes < 0
      console.log 'perdio'

  update: (dt) ->
    @ball.update dt
    @paddle.update dt

  draw: ->
    for brick in @bricks
      brick.draw()
    @board.draw()
    @ball.draw()
    @paddle.draw()

    if @ball.state == "ready"
      @stateLabel.draw()


class Board
  constructor: (@map) ->
    @lifesLabel = new Label
      font: "12pt Arial"
      color: "white"
      x: 10
      y: CONFIG.mapHeight + 3 * CONFIG.boardHeight / 4
      text: "Vidas:"

    @pointsLabel = new Label
      font: "12pt Arial"
      color: "white"
      x: 80
      y: CONFIG.mapHeight + 3 * CONFIG.boardHeight / 4
      text: "Puntos:"

    @nameLabel = new Label
      font: "12pt Arial"
      color: "blue"
      x: CONFIG.mapWidth
      y: CONFIG.mapHeight + 3 * CONFIG.boardHeight / 4
      alignment: "right"
      text: "Level:"

  draw: () ->
    @lifesLabel.text = "Vidas: #{@map.lifes}"
    @pointsLabel.text = "Puntos: #{@map.points}"
    @nameLabel.text = "<#{@map.name}>"
    tinto.activeCanvas.preserveContext (context) =>
      context.fillStyle = "gray"
      context.fillRect(0, CONFIG.mapHeight,
                       CONFIG.mapWidth, CONFIG.boardHeight)
    @lifesLabel.draw()
    @pointsLabel.draw()
    @nameLabel.draw()