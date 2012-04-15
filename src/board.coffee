# Imports
key = tinto.input.key
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
    "A": resource.image("graphics/brickA.png")
    "B": resource.image("graphics/brickB.png")
    "C": resource.image("graphics/brickC.png")
    "D": resource.image("graphics/brickD.png")
    "E": resource.image("graphics/brickE.png")

  constructor: (@x, @y, @type)->
    switch @type
      when "A" then @lifes = 1
      when "B" then @lifes = 2
      when "C" then @lifes = 3
      when "E" then @lifes = 1
      else @lifes = Infinity
    @updateImage()
    super image: @image

  touch: ->
    points = @lifes
    @lifes--
    switch @lifes
      when 1 then @type = "A"
      when 2 then @type = "B"
      when 3 then @type = "C"
    @updateImage()
    points

  dead: -> @lifes <= 0
  updateImage: ->
    @image = Brick.IMAGES[@type]


class LevelMap
  constructor: (content) ->
    @lifes = 3
    @points = 0
    @bricks = []

    @paddle = new Paddle(this)
    @board = new Board(this)
    @ball = new Ball(this)
    @bonus = null
    @music = resource.sound("sounds/ride-the-storm.ogg")
    @music.play()

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

  removeBrickAt: (x, y) ->
    # This is really inefficient.
    for brick in @bricks
      if (brick? and brick.type in ["A", "E"] and
          x > brick.left() and x < brick.right() and
          y > brick.top() and y < brick.bottom())
        @removeBrick(brick)

  explodeBrick: (brick) ->
    # Top left
    @removeBrickAt(brick.centerX() - brick.width(), brick.centerY() - brick.height())

    # Left
    @removeBrickAt(brick.centerX() - brick.width(), brick.centerY())

    # Bottom left
    @removeBrickAt(brick.centerX() - brick.width(), brick.centerY() + brick.height())

    # Top right
    @removeBrickAt(brick.centerX() + brick.width(), brick.centerY() - brick.height())

    # Right
    @removeBrickAt(brick.centerX() + brick.width(), brick.centerY())

    # Bottom right
    @removeBrickAt(brick.centerX() + brick.width(), brick.centerY() + brick.height())

    # Top
    @removeBrickAt(brick.centerX(), brick.centerY() - brick.height())

    # Botttom
    @removeBrickAt(brick.centerX(), brick.centerY() + brick.height())


  checkCollision: (ball) ->
    for brick in @bricks
      collisionSide = collision(ball, brick)
      if collisionSide
        lifes = brick.touch()
        if brick.type != "D"
          @points += 10 * lifes
        if brick.dead()
          if brick.type == "E"
            @explodeBrick(brick)
          @removeBrick(brick)
          if not @bonus? and not @activeAction?
            @bonus = new Bonus(brick.centerX(), brick.centerY(), this)
        return [brick, collisionSide]
    return false

  removeBrick: (brick) ->
    index = @bricks.indexOf(brick)
    @bricks.splice(index, 1)

  removeBonus: ->
    @bonus = null

  die: -> @lifes--

  checkState: ->
    if @lifes < 0
      @ball.state = "lost"
      @stateLabel.text = "GAME OVER. <F5> para reiniciar."
      @stateLabel.color = "red"

  update: (dt) ->
    if (@ball.state == "playing" and key("space") and
        @activeAction? and @activeAction.powerAction)
      @activeAction.action()

    @ball.update dt
    if @ball.state != 'playing'
      @removeBonus()

    @paddle.update dt
    @bonus?.update dt


    @checkState()

  draw: ->
    for brick in @bricks
      brick.draw()
    @board.draw()
    @ball.draw()
    @bonus?.draw()
    @paddle.draw()

    if @ball.state != "playing"
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

    @bonusLabel = new Label
      font: "12pt Arial"
      x: 180
      y: CONFIG.mapHeight + 3 * CONFIG.boardHeight / 4
      text: ""

  draw: () ->
    @lifesLabel.text = "Vidas: #{@map.lifes}"
    @pointsLabel.text = "Puntos: #{@map.points}"
    @nameLabel.text = "<#{@map.name}>"
    if @map.activeAction?
      @bonusLabel.text = @map.activeAction.text
      @bonusLabel.color = @map.activeAction.color
    else
      @bonusLabel.text = ""
    tinto.activeCanvas.preserveContext (context) =>
      context.fillStyle = "gray"
      context.fillRect(0, CONFIG.mapHeight,
                       CONFIG.mapWidth, CONFIG.boardHeight)
    @lifesLabel.draw()
    @pointsLabel.draw()
    @nameLabel.draw()
    @bonusLabel.draw()