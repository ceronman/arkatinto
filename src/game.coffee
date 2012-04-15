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

  loading = new Label
    font: "28pt Arial"
    color: "red"
    x: CONFIG.mapWidth / 2
    y: CONFIG.mapHeight / 2
    alignment: "center"
    text: "Loading..."

  loading.draw()

  levelMap = new LevelMap(LEVEL1)

  tinto.resource.loaded () ->
    levelMap.init()

  tinto.resource.loadAll()

  canvas.update (dt) ->
    levelMap.update dt

  canvas.draw () ->
    canvas.clear()
    levelMap.draw()
