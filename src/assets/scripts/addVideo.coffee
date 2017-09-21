window.addVideo = ($block, playDelay = 0, cb) ->
  $video = $block.find("video")
  $video.attr "controls", "true" if touchDevice
  videoSrc = $video.data 'video'
  return unless videoSrc

  tempVideo = document.createElement('video')
  tempVideo.src = videoSrc
  tempVideo.style.height = 0
  videoDOM = document.body.appendChild tempVideo
  videoDOM.addEventListener 'canplay', ->
    $video.get(0).src = videoSrc
    setTimeout ->
      $video.get(0).play()
    , playDelay
    $(videoDOM).remove()
    cb() if cb
