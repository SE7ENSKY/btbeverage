$ ->
  window.videoWithPromise = (el) ->
    isPlayPromise = null

    delayedPause = ->
      if isPlayPromise
        isPlayPromise.then ->
          el.pause()
      else
        setTimeout ->
          el.pause()
        , 100

    return
      play: ->
        isPlayPromise = el.play()
      pause: delayedPause
