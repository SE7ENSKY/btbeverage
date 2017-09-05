$ ->
	$block = $(".intro")
	return unless $block.length

	_video = $block.find("video").get(0)
	$(_video).attr "controls", "true" if touchDevice
	# setTimeout ->
	# 	_video.play()
	# , 20
