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
	tempVideo.addEventListener 'canplaythrough', ->
		source = document.createElement('source')
		source.src = videoSrc
		source.type = videoType
		$video.get(0).appendChild(source)
		setTimeout ->
			$video.addClass 'is-loaded'
			cb() if cb
		, 300

	tempVideo.addEventListener 'error', ->
		cb() if cb
