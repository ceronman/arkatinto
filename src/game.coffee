window.onload = () ->
  canvas = new tinto.canvas.GameCanvas('gamecanvas')

  label = new tinto.text.Label
    text: 'Hello World!'
    x: canvas.width /2
    y: canvas.height/2
    alignment: 'center'
    color: '#FFAAAA'
    font: 'Bold 40pt Arial'

  canvas.draw () ->
    label.draw()
