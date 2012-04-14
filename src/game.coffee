window.onload = ->
  canvas = new tinto.canvas.GameCanvas 'gamecanvas',
    width: CONFIG.mapWidth
    height: CONFIG.mapHeight
    background: 'gray'

  canvas.context2D.globalAlpha = 0.5

  paddle = new tinto.players.Paddle()

  tinto.resource.loaded () ->
    paddle.center()

  tinto.resource.loadAll()

  canvas.draw () ->
    paddle.draw()
