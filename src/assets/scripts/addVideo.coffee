window.addVideo = ($block, playDelay = 0, cb) ->
	$video = $block.find("video")
	videoSrc = $video.data 'video'
	videoType = $video.data 'type'
	if !videoSrc
		cb() if cb
		return

	tempSource = document.createElement('source')
	tempSource.src = videoSrc
	tempSource.type = videoType
	$video.get(0).appendChild(tempSource)
	cb() if cb
	$video.get(0).addEventListener 'canplaythrough', ->
		$video.addClass 'is-loaded'
