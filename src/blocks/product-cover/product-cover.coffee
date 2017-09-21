import { Scene } from 'scrollmagic'

$ ->
	productCoverJS = ->
		$block = $(".product-cover")
		return unless $block.length
		$catalog = $(".catalog")

		$block.each (index) ->
			if index % 2
				$(this).addClass 'right'

		#
		# add Video
		#

		cntrl = controller.get()

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
				.addTo(cntrl)

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
				TweenMax.set $video.get(0), { autoAlpha: 1 }
		, ->
			$this = $(@)
			$video = $this.find('video')
			hasVideo = $video.length and $video.attr('src')
			if (hasVideo and $this.hasClass('hover'))
				$video.get(0).pause()
				$this.toggleClass 'hover'

	productCoverJS()

	$(document).on 'product-cover', productCoverJS
