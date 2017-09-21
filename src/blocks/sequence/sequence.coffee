$ ->
	sequenceJS = ->
		$block = $('.sequence')
		return unless $block.length

		$children = $block.find('.sequence__image')
		$childrenCount = $children.length
		loadedCount = 0
		$children.each ->
			$this = $(@)
			self = @
			imgSrc = $this.data('image')
			tempImage = document.createElement 'img'
			tempImage.src = imgSrc
			tempImage.style.height = 0
			imageDOM = document.body.appendChild tempImage
			imageDOM.addEventListener 'load', ->
				self.style.backgroundImage = "url(#{imgSrc})"
				$(imageDOM).remove()
				$(document).trigger 'sequence-loaded' if ++loadedCount == $childrenCount

	$(document).on 'sequence-init', sequenceJS
