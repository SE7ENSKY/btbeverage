import { Scene } from 'scrollmagic'
import { TimelineMax, TweenMax, Power0, Power1 } from 'gsap'

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
			self = @
			scene = new Scene({
				triggerElement: self,
				triggerHook: 1,
				offset: -200
				})
				.on 'start', ->
					addVideo $(self)
					scene.destroy()
				.addTo(cntrl)

			scene.enabled false if isMobile() && scene

			controller.resizeSceneActions.push ->
				return unless scene
				if isMobile()
					scene.enabled false
				else
					scene.enabled true

		#
		# catalog animation
		#

		isAnimation = false

		scrollToViewport = ($this) ->
			$('html, body').animate
				scrollTop: $this.offset().top

		animationFunc = ($this, isOpen, removeHover = false) ->
			isAnimation = true
			tl = new TimelineMax()
			$target = $catalog.find($this.attr("data-target"))
			$targetInner = $target.find('.product-params__wrap')

			productCoverHeightClosed = 0.3333 * window.innerWidth
			productCoverHeightOpen = Math.max(150 + $targetInner.outerHeight(), 0.3333 * window.innerWidth)

			catalogIndex = $('.catalog__item').index($this.parent()) + 1
			isOddProductCover = catalogIndex % 2
			if isOddProductCover
				oddShift = 150 - productCoverHeightClosed
				evenShift = -120
				coef = -1
				selectorOdd = ".catalog__item:nth-child(2n+" + (catalogIndex + 2) + ")"
				selectorEven = ".catalog__item:nth-child(2n+2)"
			else
				oddShift = 120
				evenShift = switch getWidthVariable()
					when "tablet" then -38
					when "sm" then -110
					when "md" then -210
					else 0
				coef = 1
				selectorOdd = ".catalog__item:nth-child(2n+1)"
				selectorEven = ".catalog__item:nth-child(2n+" + (catalogIndex + 2) + ")"

			$blockInners = $targetInner.find '.stagger'

			$paramsText = $targetInner.find '.product-params__text'
			$paramsVolume = $targetInner.find '.product-params__volume'
			$paramsPack = $targetInner.find '.product-params__packs'
			$paramsCart = $targetInner.find '.product-params__cart'

			volumeHeight = $paramsVolume.outerHeight()
			textHeight = $paramsText.outerHeight()
			packHeight = $paramsPack.outerHeight()

			$sliderWrapper = $this.find '.product-cover__slider-wrapper'
			$slider = $this.find '.product-cover__slider'
			$sliderVerticalText = $this.find '.product-cover__text-vertical span'
			$sliderNormalText = $this.find '.product-cover__text'

			if !isOpen
				if isMobile()
					tl
						.fromTo $target.get(0), 0.5, { height: 0 }, { height: $targetInner.outerHeight(),ease: Power0.easeNone  }, 0
						.fromTo $sliderWrapper, 0.2, { autoAlpha: 0 }, { autoAlpha: 1 }, 0.2
						.fromTo $paramsText.get(0), 0.5, { y: -(packHeight + volumeHeight + $paramsCart.outerHeight())}, { y: 0, ease: Power0.easeNone }, 0
						.fromTo $paramsCart.get(0), 0.4, { y: -(packHeight + volumeHeight) }, { y: 0, ease: Power0.easeNone }, 0.1
						.fromTo $paramsPack.get(0), 0.3, { y: -volumeHeight }, { y: 0, ease: Power0.easeNone }, 0.2
						.staggerFromTo $blockInners, 0.1, { autoAlpha: 0 }, { autoAlpha: 1 }, 0, 0.4
						.fromTo $slider, 0.5, { x: -window.innerWidth }, { x: 0, ease: Power1.easeOut }, 0.5
						.fromTo $sliderNormalText, 0.3, { x: -0.5 * window.innerWidth }, { x: 0, ease: Power1.easeOut }, 0.5
				else
					tl
						.fromTo $target.get(0), 0.5, { height: 0 }, { height: $targetInner.outerHeight(),ease: Power0.easeNone  }, 0
						.fromTo $this.get(0), 0.5, { paddingBottom: "#{productCoverHeightClosed}px" }, { paddingBottom: "#{productCoverHeightOpen}px", ease: Power0.easeNone }, 0
						.fromTo $sliderWrapper, 0.2, { autoAlpha: 0 }, { autoAlpha: 1 }, 0.2
						.staggerFromTo selectorOdd, 0.5, { y: 0 }, { y: oddShift, ease: Power0.easeNone }, 0, 0
						.staggerFromTo selectorEven, 0.5, { y: 0 }, { y: evenShift, ease: Power0.easeNone }, 0, 0
						.set $blockInners, { autoAlpha: 0 }, 0
						.fromTo $paramsCart.get(0), 0.5, { y: -(textHeight + volumeHeight + packHeight)}, { y: 0, ease: Power0.easeNone }, 0
						.fromTo $paramsPack.get(0), 0.4, { y: -(textHeight + volumeHeight) }, { y: 0, ease: Power0.easeNone }, 0.1
						.fromTo $paramsVolume.get(0), 0.3, { y: -textHeight }, { y: 0, ease: Power0.easeNone }, 0.2
						.staggerFromTo $blockInners, 0.1, { autoAlpha: 0 }, { autoAlpha: 1 }, 0, 0.4
						.fromTo $slider, 1, { x: - 0.5 * window.innerWidth * coef}, { x: 0, ease: Power1.easeOut }, 0.3
						.fromTo $sliderNormalText, 0.4, { x: -0.25 * window.innerWidth * coef }, { x: 0, ease: Power1.easeOut }, 0.9
						.staggerFromTo $sliderVerticalText, 0.4, { autoAlpha: 0, rotationX: 90 * coef }, { autoAlpha: 1, rotationX: 0 }, 0.2, 0.4
						# after animation
				setTimeout ->
					isAnimation = false
					scrollToViewport $this
				, 1300
			else
				if isMobile()
					tl
						.to $target.get(0), 0.5, { height: 0, ease: Power0.easeNone }, 0
						.staggerFromTo $blockInners, 0.1, { autoAlpha: 1 }, { autoAlpha: 0 }, 0, 0
						.fromTo $sliderWrapper, 0.2, { autoAlpha: 1 }, { autoAlpha: 0 }, 0
						.set $slider, { x: -window.innerWidth }, 0.2
						.set $sliderNormalText, { x: -0.5 * window.innerWidth }, 0.2
						.fromTo $paramsText.get(0), 0.5, { y: 0 }, { y: -(packHeight + volumeHeight + $paramsCart.outerHeight()), ease: Power0.easeNone }, 0
						.fromTo $paramsCart.get(0), 0.4, { y: 0 }, { y: -(textHeight + volumeHeight), ease: Power0.easeNone }, 0
						.fromTo $paramsPack.get(0), 0.3, { y: 0 }, { y: -textHeight, ease: Power0.easeNone }, 0
				else
					tl
						.to $target.get(0), 0.5, { height: 0, ease: Power0.easeNone }, 0
						.to $this.get(0), 0.5, { paddingBottom: "#{productCoverHeightClosed}px" , ease: Power0.easeNone  }, 0
						.set $this.get(0), { paddingBottom: "33.33vw" }, 0.5
						.fromTo $sliderWrapper, 0.2, { autoAlpha: 1 }, { autoAlpha: 0 }, 0
						.staggerFromTo $blockInners, 0.1, { autoAlpha: 1 }, { autoAlpha: 0 }, 0, 0
						.staggerFromTo selectorOdd, 0.5, { y: oddShift }, { y: 0, ease: Power0.easeNone }, 0, 0
						.staggerFromTo selectorEven, 0.5, { y: evenShift }, { y: 0, ease: Power0.easeNone }, 0, 0
						.fromTo $paramsCart.get(0), 0.5, { y: 0 }, { y: -(textHeight + volumeHeight + $paramsPack.outerHeight()), ease: Power0.easeNone }, 0
						.fromTo $paramsPack.get(0), 0.4, { y: 0 }, { y: -(packHeight + volumeHeight), ease: Power0.easeNone }, 0
						.fromTo $paramsVolume.get(0), 0.3, { y: 0 }, { y: -volumeHeight, ease: Power0.easeNone }, 0
						# after animation
				setTimeout ->
					isAnimation = false
					$this.removeClass 'hover' if removeHover
				, 500

		#
		# hover
		#

		$block.hover ->
			$this = $(@)
			$video = $this.find('video')
			hasVideo = $video.length and $video.hasClass('is-loaded')
			if (hasVideo and !$this.hasClass('hover')) and !$this.hasClass('active')
				$video.show(0)
				$this.toggleClass 'hover'
				setTimeout ->
					$video.get(0).play() if $this.hasClass('hover')
				, 300
		, ->
			$this = $(@)
			$video = $this.find('video')
			hasVideo = $video.length and $video.hasClass('is-loaded')
			if (hasVideo and $this.hasClass('hover')) and !$this.hasClass('active')
				$video.get(0).pause()
				$this.toggleClass 'hover'
				setTimeout ->
					$video.hide(0) if !$this.hasClass('hover')
				, 300

		#
		# Click handler
		#

		$block.on "click", (e) ->
			e.preventDefault()
			$this = $(@)
			isOpen = $this.hasClass('active')
			$openBlock = $('.product-cover.active')

			return if isAnimation

			if !isOpen and $openBlock.length
				# check if other block is not opened
				animationFunc $openBlock, true, true
				$openBlock.removeClass 'active'

				setTimeout ->
					animationFunc $this, isOpen
					$openBlock.trigger 'mouseleave'
					$this.addClass 'active'
				, 500
			else if !isOpen
				$this.addClass 'active'
				animationFunc $this, isOpen

		$block.find('.product-cover__close').on 'click', (e) ->
			e.preventDefault()
			$this = $(@)
			$parent = $this.parents('.product-cover.active')
			animationFunc $parent, true
			$parent.removeClass 'active'

		controller.resizeSceneActions.push ->
			# close all open blocks on resize
			$openBlock = $('.product-cover.active')
			return unless $openBlock.length
			animationFunc $openBlock, true, true
			$openBlock.removeClass 'active'

	productCoverJS()

	$(document).on 'product-cover', productCoverJS
