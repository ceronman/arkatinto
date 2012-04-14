window.onload = ->
  canvas = new tinto.canvas.GameCanvas 'gamecanvas',
    width: CONFIG.mapWidth
    height: CONFIG.mapHeight
    background: 'gray'

  paddle = new tinto.players.Paddle()

  tinto.resource.loaded () ->
    paddle.center()

  tinto.resource.loadAll()

  canvas.update (dt) ->
    paddle.update(dt)

  canvas.draw () ->
    canvas.clear()
    paddle.draw()
