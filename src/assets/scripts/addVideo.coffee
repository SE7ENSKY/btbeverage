window.addVideo = ($block, playDelay = 0, cb) ->
	$video = $block.find("video")
	$video.attr "controls", "true" if touchDevice
	videoSrc = $video.data 'video'
	videoType = $video.data 'type'
	if !videoSrc
		cb() if cb
		return

	tempVideo = document.createElement('video')
	tempVideo.src = videoSrc
	tempVideo.addEventListener 'loadeddata', ->
		source = document.createElement('source')
		source.src = videoSrc
		source.type = videoType
		$video.addClass 'is-loaded'
		$video.get(0).appendChild(source)
		cb() if cb

	tempVideo.addEventListener 'error', ->
		cb() if cb
