import { Scene } from 'scrollmagic'

$ ->
	productCoverJS = ->
		$block = $(".product-cover")
		return unless $block.length
		$catalog = $(".catalog")

		$block.each (index) ->
			if index % 2 == 0
				$(this).addClass 'right'

		#
		# add Video
		#

		cntrl = controller.get()

		$block.each ->
			isCalled = false
			self = @
			scene = new Scene({
				triggerElement: self,
				offset: -200
				})
				.on 'enter', ->
					if !isCalled
						addVideo $(self)
						isCalled = true
				.addTo(cntrl)
			scene.enabled false if isMobile()

			controller.resizeSceneActions.push ->
				if isMobile()
					scene.enabled false
				else
					scene.enabled true

		#
		# hover
		#

		$block.hover ->
			$this = $(@)
			$video = $this.find('video')
			hasVideo = $video.length and $video.hasClass('is-loaded')
			if (hasVideo and !$this.hasClass('hover')) and !isMobile()
				$video.show(0)
				$video.get(0).play()
				$this.toggleClass 'hover'
		, ->
			$this = $(@)
			$video = $this.find('video')
			hasVideo = $video.length and $video.hasClass('is-loaded')
			if (hasVideo and $this.hasClass('hover'))
				$video.get(0).pause()
				$this.toggleClass 'hover'
				setTimeout ->
					$video.hide(0) if !$this.hasClass('hover')
				, 500

	productCoverJS()

	$(document).on 'product-cover', productCoverJS
