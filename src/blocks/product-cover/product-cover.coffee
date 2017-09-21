import { Controller, Scene } from 'scrollmagic'

$ ->
	controller = null
	productCoverJS = ->
		controller = null
		$block = $(".product-cover")
		return unless $block.length
		$catalog = $(".catalog")

		$block.each (index) ->
			if index % 2
				$(this).addClass 'right'

		#
		# add Video
		#

		controller = new Controller()

		$block.each ->
			isCalled = false
			self = @
			new Scene({
				triggerElement: self,
				offset: -200
				})
				.on 'enter', ->
					if !isCalled
						addVideo $(self)
						isCalled = true
				.addTo(controller)

		#
		# hover
		#

		$block.hover ->
			$this = $(@)
			$video = $this.find('video')
			hasVideo = $video.length and $video.attr('src')
			if (hasVideo and !$this.hasClass('hover'))
				$video.get(0).play()
				$this.toggleClass 'hover'
		, ->
			$this = $(@)
			$video = $this.find('video')
			hasVideo = $video.length and $video.attr('src')
			if (hasVideo and $this.hasClass('hover'))
				$video.get(0).pause()
				$this.toggleClass 'hover'

	productCoverJS()

	removeScene = ->
		controller.destroy() if controller

	$(document).on 'product-cover', productCoverJS
	$(document).on 'product-cover-remove', removeScene
