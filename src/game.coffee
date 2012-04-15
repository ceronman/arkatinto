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
    text: "Cargando..."

  loading.draw()

  levelMap = new LevelMap()

  ready = false
  tinto.resource.loaded () ->
    ready = true
    levelMap.init(LEVELS[0])

  window.loadMap = (level) ->
    if ready
      levelMap.init(LEVELS[level])
    else
      alert "Estoy cargando, por favor espere un momento."

  tinto.resource.loadAll()

  canvas.update (dt) ->
    levelMap.update dt

  canvas.draw () ->
    canvas.clear()
    levelMap.draw()
