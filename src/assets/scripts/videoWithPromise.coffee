$ ->
  window.videoWithPromise = (el) ->
    isPlayPromise = undefined

    return
      play: ->
        isPlayPromise = Promise.resolve().then -> el.play()
      pause: ->
        if isPlayPromise != undefined
          isPlayPromise.then ->
            el.pause()
        else
          el.pause()
