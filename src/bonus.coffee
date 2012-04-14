# Imports
key = tinto.input.key
resource = tinto.resource
Sprite = tinto.sprite.Sprite


randomChoice = (items) ->
  items[Math.floor(Math.random() * items.length)];

class BonusAction
  execute: (map) ->
    @map = map
    @start()
    setTimeout((=>
      @end()
      @map.activeAction = null
      ), @duration * 1000)

  remove: ->
    @end()
    @map.activeAction = null


class ExtraLifeBonusAction extends BonusAction

  color: 'green'
  text: 'Vida Extra!'
  duration: 2

  start: ->
    @map.lifes++

  end: ->


class LargePadBonusAction extends BonusAction

  @IMAGE = resource.image("graphics/paddle_large.png")

  color: 'green'
  text: 'Agrandar!'
  duration: 12

  start: ->
    @oldImage = @map.paddle.image
    paddle = @map.paddle
    center = paddle.centerX()
    paddle.image = LargePadBonusAction.IMAGE
    paddle.x = center - paddle.width() / 2

  end: ->
    paddle = @map.paddle
    center = paddle.centerX()
    paddle.image = @oldImage
    paddle.x = center - paddle.width() / 2


class ShortPadBonusAction extends BonusAction

  @IMAGE = resource.image("graphics/paddle_short.png")

  color: 'red'
  text: 'Encoger!'
  duration: 12

  start: ->
    @oldImage = @map.paddle.image
    paddle = @map.paddle
    center = paddle.centerX()
    paddle.image = ShortPadBonusAction.IMAGE
    paddle.x = center - paddle.width() / 2

  end: ->
    paddle = @map.paddle
    center = paddle.centerX()
    paddle.image = @oldImage
    paddle.x = center - paddle.width() / 2


class ExplosionBonusAction extends BonusAction

  color: 'Green'
  text: 'Bloques explosivos!'
  duration: 10

  start: ->
    for brick in @map.bricks
      if brick? and brick.type == "A"
        brick.type = "E"
        brick.updateImage()

  end: ->
    for brick in @map.bricks
      if brick? and brick.type == "E"
        brick.type = "A"
        brick.updateImage()


class Bonus extends Sprite

  @IMAGE: resource.image("graphics/bonus.png")
  @ACTIONS: [
    # ExtraLifeBonusAction,
    # LargePadBonusAction,
    # ShortPadBonusAction,
    ExplosionBonusAction,
  ]

  constructor: (@x, @y, @map) ->
    super
      image: Bonus.IMAGE

    @speed = 50
    BonusAction = randomChoice(Bonus.ACTIONS)
    @action = new BonusAction()

  update: (dt) ->
    @y += @speed * dt

    if @y > CONFIG.mapWidth
      @map.removeBonus()

  executeAction: ->
    @map.activeAction = @action
    @action.execute(@map)
    @map.removeBonus()