window.addVideo = ($block, playDelay = 0, cb) ->
	$video = $block.find("video")
	$video.attr "controls", "true" if touchDevice
	videoSrc = $video.data 'video'
	if !videoSrc
		cb() if cb
		return

	tempVideo = document.createElement('video')
	tempVideo.src = videoSrc
	tempVideo.addEventListener 'loadeddata', ->
		$video.attr 'src', videoSrc
		cb() if cb
	tempVideo.addEventListener 'error', ->
		cb() if cb
