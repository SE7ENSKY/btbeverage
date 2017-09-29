$ ->
  window.videoWithPromise = (el) ->
    isPlayPromise = null

    delayedPause = ->
      if isPlayPromise != undefined
        isPlayPromise.then ->
          el.pause()
      else
        setTimeout ->
          el.pause()
        , 100

    return
      play: ->
        isPlayPromise = el.play()
        if isPlayPromise != undefined
          isPlayPromise.catch (e) ->
            console.log 'error', e
      pause: delayedPause
