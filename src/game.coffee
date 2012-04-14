# Imports
key = tinto.input.key
resource = tinto.resource
Sprite = tinto.sprite.Sprite
Label = tinto.text.Label

window.onload = ->
  canvas = new tinto.canvas.GameCanvas 'gamecanvas',
    width: CONFIG.mapWidth
    height: CONFIG.mapHeight + CONFIG.boardHeight
    background: 'black'

  levelMap = new LevelMap(LEVEL1)

  tinto.resource.loaded () ->
    levelMap.init()

  tinto.resource.loadAll()

  canvas.update (dt) ->
    levelMap.update dt

  canvas.draw () ->
    canvas.clear()
    levelMap.draw()
