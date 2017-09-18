window.addVideo = ($block, playDelay = 0) ->
  $video = $block.find("video")
  $video.attr "controls", "true" if touchDevice
  videoSrc = $video.data 'video'

  tempVideo = document.createElement('video')
  tempVideo.src = videoSrc
  videoDOM = document.body.appendChild tempVideo
  videoDOM.addEventListener 'canplay', ->
    $video.attr 'src', videoSrc
    setTimeout ->
      $video.get(0).play()
    , playDelay
    $(videoDOM).remove()
