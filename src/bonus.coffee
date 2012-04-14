# Imports
key = tinto.input.key
resource = tinto.resource
Sprite = tinto.sprite.Sprite


randomChoice = (items) ->
  items[Math.floor(Math.random() * items.length)];


class ExtraLifeBonusAction
  execute: (map) ->
    map.lifes++

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
    @action.execute(@map)
    @map.removeBonus()
