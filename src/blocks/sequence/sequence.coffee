$ ->
	sequenceJS = ->
		$block = $('.sequence')
		if !$block.length
			$(document).trigger 'sequence-loaded'
			return

		$children = $block.find('.sequence__image')
		$childrenCount = $children.length
		loadedCount = 0
		$children.each ->
			$this = $(@)
			self = @
			imgSrc = $this.data('image')
			tempImage = new Image()
			tempImage.src = imgSrc
			tempImage.addEventListener 'load', ->
				self.style.backgroundImage = "url(#{imgSrc})"
				$(document).trigger 'sequence-loaded' if ++loadedCount == $childrenCount

	$(document).on 'sequence-init', sequenceJS
