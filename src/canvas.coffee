# tinto.canvas module.

@tinto.canvas = do ->

  class GameCanvas

    constructor: (canvasID, options) ->
      options = options ? {}
      @canvas = document.getElementById canvasID
      @canvas.width = options.width ? 640
      @canvas.height = options.height ? 480
      @canvas.style.backgroundColor = options.background ? 'black'
      @context2D = @canvas.getContext '2d'

      @width = @canvas.width
      @height = @canvas.height

      tinto.activeCanvas = this

      @drawEvent = new tinto.EventEmitter()
      @updateEvent = new tinto.EventEmitter()

      tinto.input.installKeyboardCallbacks()

    draw: (callback) ->
      oldTimestamp = new Date().getTime()
      update = =>
        newTimestamp = new Date().getTime()
        dt = (newTimestamp - oldTimestamp) / 1000
        oldTimestamp = newTimestamp
        @updateEvent.call dt
        @drawEvent.call()

      tinto.resource.loaded ->
        console.log 'loaded'
        window.setInterval update, 1000/60.0

      tinto.resource.check()
      @drawEvent.addCallback callback

    update: (callback) -> @updateEvent.addCallback callback

    clear: -> @context2D.clearRect 0, 0, @width, @height

    preserveContext: (drawFunction) ->
      @context2D.save()
      drawFunction @context2D
      @context2D.restore()

  # Public interface.
  GameCanvas: GameCanvas
