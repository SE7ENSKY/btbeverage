import { TimelineMax, Power0, Power2 } from 'gsap'

$ ->
	productCoverJS = ->
		$block = $(".product-cover")
		return unless $block.length
		$catalog = $(".catalog")

		$block.each (index) ->
			if index % 2
				$(this).addClass 'right'

		isAnimation = false

		scrollToViewport = ($this) ->
			$('body').animate
				scrollTop: $this.offset().top

		animationFunc = ($this, isOpen, removeHover = false) ->
			isAnimation = true
			tl = new TimelineMax()
			$target = $catalog.find($this.attr("data-target"))
			$targetInner = $target.find('.product-params__inner')

			productCoverHeightClosed = 0.33 * window.innerWidth
			productCoverHeightOpen = Math.max(150 + $targetInner.outerHeight(), 0.33 * window.innerWidth)

			diff = 0.33 * window.innerWidth + $targetInner.outerHeight() - productCoverHeightOpen

			catalogIndex = $('.catalog__item').index($this.parent()) + 1
			selector = ".catalog__item:nth-child(2n+" + (catalogIndex + 2) + ")"

			$blockInners = $targetInner.find '.stagger'

			$paramsText = $targetInner.find '.product-params__text'
			$paramsVolume = $targetInner.find '.product-params__volume'
			$paramsPack = $targetInner.find '.product-params__packs'
			$paramsCart = $targetInner.find '.product-params__cart'

			volumeHeight = $paramsVolume.outerHeight()
			textHeight = $paramsText.outerHeight()

			isEvenProductCover = catalogIndex % 2
			coef = if isEvenProductCover then -1 else 1
			$sliderWrapper = $this.find '.product-cover__slider-wrapper'
			$slider = $this.find '.product-cover__slider'
			$sliderVerticalText = $this.find '.product-cover__text-vertical span'
			$sliderNormalText = $this.find '.product-cover__text'

			if !isOpen
				tl
					.fromTo $target.get(0), 0.5, { height: 0 }, { height: $targetInner.outerHeight(),ease: Power0.easeNone  }, 0
					.fromTo $this.get(0), 0.5, { paddingBottom: "#{productCoverHeightClosed}px" }, { paddingBottom: "#{productCoverHeightOpen}px", ease: Power0.easeNone }, 0
					.fromTo $sliderWrapper, 0.2, { autoAlpha: 0 }, { autoAlpha: 1 }, 0.2
					.staggerFromTo selector, 0.5, { y: 0 }, { y: -diff, ease: Power0.easeNone }, 0, 0
					.set $blockInners, { autoAlpha: 0 }, 0
					.fromTo $paramsCart.get(0), 0.5, { y: -(textHeight + volumeHeight + $paramsPack.outerHeight())}, { y: 0, ease: Power0.easeNone }, 0
					.fromTo $paramsPack.get(0), 0.4, { y: -(textHeight + volumeHeight) }, { y: 0, ease: Power0.easeNone }, 0.1
					.fromTo $paramsVolume.get(0), 0.3, { y: -textHeight }, { y: 0, ease: Power0.easeNone }, 0.2
					.staggerFromTo $blockInners, 0.1, { autoAlpha: 0 }, { autoAlpha: 1 }, 0, 0.4
					.fromTo $slider, 1, { x: 0.5 * window.innerWidth * coef}, { x: 0, ease: Power2.easeOut }, 0.3
					.fromTo $sliderNormalText, 0.4, { x: 0.25 * window.innerWidth * coef }, { x: 0, ease: Power2.easeOut }, 0.9
					.staggerFromTo $sliderVerticalText, 0.4, { autoAlpha: 0, rotationX: 90 * coef }, { autoAlpha: 1, rotationX: 0 }, 0.2, 0.4
					# after animation
					setTimeout ->
						isAnimation = false
						scrollToViewport $this
					, 1300
			else
				tl
					.to $target.get(0), 0.5, { height: 0, ease: Power0.easeNone }, 0
					.to $this.get(0), 0.5, { paddingBottom: "#{productCoverHeightClosed}px" , ease: Power0.easeNone  }, 0
					.set $this.get(0), { paddingBottom: "66%" }, 0.5
					.fromTo $sliderWrapper, 0.2, { autoAlpha: 1 }, { autoAlpha: 0 }, 0
					.staggerFromTo $blockInners, 0.1, { autoAlpha: 1 }, { autoAlpha: 0 }, 0, 0
					.staggerFromTo selector, 0.5, { y: -diff }, { y: 0, ease: Power0.easeNone }, 0, 0
					.fromTo $paramsCart.get(0), 0.5, { y: 0 }, { y: -(textHeight + volumeHeight + $paramsPack.outerHeight()), ease: Power0.easeNone }, 0
					.fromTo $paramsPack.get(0), 0.4, { y: 0 }, { y: -(textHeight + volumeHeight), ease: Power0.easeNone }, 0
					.fromTo $paramsVolume.get(0), 0.3, { y: 0 }, { y: -textHeight, ease: Power0.easeNone }, 0
					# after animation
					setTimeout ->
						isAnimation = false
						$this.removeClass 'hover' if removeHover
					, 500

		#
		# add Video
		#

		addVideo = (block) ->
			$video = block.find("video")
			return unless $video.length

			$target = $catalog.find(block.attr("data-target")).find('.product-params__inner')

			$video.attr "controls", "true" if touchDevice
			videoSrc = $video.data 'video'

			tempVideo = document.createElement('video')
			tempVideo.src = videoSrc
			videoDOM = document.body.appendChild tempVideo
			videoDOM.addEventListener 'canplay', ->
				$video.attr 'src', videoSrc
				$video.css 'height', $target.outerHeight() + 150
				$(videoDOM).remove()

		window.addEventListener 'load', ->
			$block.each ->
				addVideo $(@)

		#
		# hover
		#

		$block.hover ->
			$this = $(@)
			$video = $this.find('video')
			hasVideo = $video.length and $video.attr('src')
			if (hasVideo or $this.hasClass('hover')) and !$this.hasClass('active')
				if !$this.hasClass('hover')
					$video.get(0).play()
				else
					$video.get(0).pause()
				$this.toggleClass 'hover'

		#
		# Click handler
		#

		$block.on "click", (e) ->
			$this = $(@)
			isOpen = $this.hasClass('active')
			$openBlock = $('.product-cover.active')

			return if isAnimation

			if !isOpen and $openBlock.length
				# check if other block is not opened
				animationFunc $openBlock, true, true
				$openBlock.toggleClass 'active'

				setTimeout ->
					animationFunc $this, isOpen
					$this.toggleClass 'active'
				, 500

			else
				animationFunc $this, isOpen
				$this.toggleClass 'active'

	productCoverJS()

	$(document).on 'product-cover', productCoverJS
