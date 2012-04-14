# Imports
Paddle = tinto.players.Paddle
Ball = tinto.players.Ball
LevelMap = tinto.players.LevelMap
maps = tinto.maps

window.onload = ->
  canvas = new tinto.canvas.GameCanvas 'gamecanvas',
    width: CONFIG.mapWidth
    height: CONFIG.mapHeight
    background: 'gray'

  levelMap = new LevelMap(maps.LEVEL1)
  paddle = new Paddle()
  ball = new Ball()

  tinto.resource.loaded () ->
    paddle.center()
    ball.center()

  tinto.resource.loadAll()

  canvas.update (dt) ->
    paddle.update dt
    ball.update dt, paddle, levelMap

  canvas.draw () ->
    canvas.clear()
    levelMap.draw()
    paddle.draw()
    ball.draw()
