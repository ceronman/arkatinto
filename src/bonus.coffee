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
  text: 'Extra life!'
  duration: 2

  start: ->
    @map.lifes++

  end: ->


class Bonus extends Sprite

  @IMAGE: resource.image("graphics/bonus.png")
  @ACTIONS: [
    ExtraLifeBonusAction,
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
