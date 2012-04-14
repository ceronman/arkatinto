# Imports
Paddle = tinto.players.Paddle
Ball = tinto.players.Ball

window.onload = ->
  canvas = new tinto.canvas.GameCanvas 'gamecanvas',
    width: CONFIG.mapWidth
    height: CONFIG.mapHeight
    background: 'gray'

  paddle = new Paddle()
  ball = new Ball()

  tinto.resource.loaded () ->
    paddle.center()
    ball.center()

  tinto.resource.loadAll()

  canvas.update (dt) ->
    paddle.update dt
    ball.update dt, paddle

  canvas.draw () ->
    canvas.clear()
    paddle.draw()
    ball.draw()
