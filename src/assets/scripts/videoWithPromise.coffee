$ ->
  window.videoWithPromise = (el) ->
    isPlayPromise = null

    delayedPause = ->
      return unless isPlayPromise

      isPlayPromise.then ->
        el.pause()

    return
      play: ->
        isPlayPromise = el.play()
      pause: delayedPause
