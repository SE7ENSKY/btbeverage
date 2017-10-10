import { Scene } from 'scrollmagic'
import { TimelineMax, TweenMax, Power0, Power1 } from 'gsap'

$ ->
	productCoverJS = ->
		$block = $(".product-cover")
		return unless $block.length
		$catalog = $(".catalog")

		$col = $catalog.find('.catalog__col')
		if $col.length
			$col.filter(':eq(1)').find($block).addClass 'right'

		#
		# add Video
		#

		cntrl = controller.get()

		$block.each ->

			#
			# Handle ingredients click
			#
			$this = $(@)
			$params = $catalog.find($this.attr("data-target"))
			$ingredients = $this.find('.ingredients')
			$paramsIngredient = $params.find('.product-params__ingredients')
			$paramsIngredientInner = $params.find('.product-params__ingredients-inner')
			productCoverHeightClosed = 0.6666 * $this.parent().outerWidth()

			$ingredients.on 'click', ->
				ingredientsOrigin = $paramsIngredientInner.outerHeight()
				isOpen = $params.hasClass 'ingredients-open'
				ingredientsHeight = if !isOpen then ingredientsOrigin else 0
				paramsHeightDiff = if !isOpen then ingredientsOrigin else - ingredientsOrigin
				tl = new TimelineMax()

				tl
					.to $params.get(0), 0.2, { height: $params.outerHeight() + paramsHeightDiff, ease: Power0.easeNone }, 0
				
				if isOpen
					tl.to $paramsIngredient.get(0), 0.2, { height: 0, autoAlpha: 0, ease: Power0.easeNone }, 0
				else
					tl.fromTo $paramsIngredient.get(0), 0.2, { height: 0 }, { height: ingredientsHeight, autoAlpha: 1, ease: Power0.easeNone }, 0

				$params.toggleClass 'ingredients-open', !isOpen



		#
		# catalog animation
		#

		isAnimation = false

		scrollToViewport = ($this) ->
			$('html, body').animate
				scrollTop: $this.offset().top - $('.header').outerHeight()

		animationFunc = ($this, isOpen, removeHover = false) ->
			isAnimation = true
			tl = new TimelineMax()
			$target = $catalog.find($this.attr("data-target"))
			$targetInner = $target.find('.product-params__wrap')

			productCoverHeightClosed = (0.6666 * $this.outerWidth())
			productCoverHeightOpen = productCoverHeightClosed * 1.6

			catalogIndex = $('.catalog__item').index($this.parent()) + 1
			isOddProductCover = catalogIndex % 2
			if isOddProductCover
				coef = -1
			else
				coef = 1

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
						.to $target.get(0), 0.5, { height: $targetInner.outerHeight(), ease: Power0.easeNone  }, 0
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
						.set $blockInners, { autoAlpha: 0 }, 0
						.fromTo $paramsCart.get(0), 0.5, { y: -(textHeight + volumeHeight + packHeight)}, { y: 0, ease: Power0.easeNone }, 0
						.fromTo $paramsPack.get(0), 0.4, { y: -(textHeight + volumeHeight) }, { y: 0, ease: Power0.easeNone }, 0.1
						.fromTo $paramsVolume.get(0), 0.3, { y: -textHeight }, { y: 0, ease: Power0.easeNone }, 0.2
						.staggerFromTo $blockInners, 0.1, { autoAlpha: 0 }, { autoAlpha: 1 }, 0, 0.4
						.fromTo $slider, 1, { x: - 0.5 * window.innerWidth * coef}, { x: 0, ease: Power1.easeOut }, 0.3
						.fromTo $sliderNormalText, 0.4, { x: -0.25 * window.innerWidth * coef }, { x: 0, ease: Power1.easeOut }, 0.9
						.staggerFromTo $sliderVerticalText, 0.4, { autoAlpha: 0, rotationX: 90 * coef }, { autoAlpha: 1, rotationX: 0 }, 0.2, 0.4

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
						.staggerTo $blockInners, 0.1, { autoAlpha: 1 }, { autoAlpha: 0 }, 0, 0
						.fromTo $paramsCart.get(0), 0.5, { y: 0 }, { y: -(textHeight + volumeHeight + $paramsPack.outerHeight()), ease: Power0.easeNone }, 0
						.fromTo $paramsPack.get(0), 0.4, { y: 0 }, { y: -(packHeight + volumeHeight), ease: Power0.easeNone }, 0
						.fromTo $paramsVolume.get(0), 0.3, { y: 0 }, { y: -volumeHeight, ease: Power0.easeNone }, 0
					$targetIngredients = $target.removeClass('ingredients-open').find('.product-params__ingredients')
					if $targetIngredients.length
						tl.set $targetIngredients.get(0), { height: 0, autoAlpha: 0 }, 0.5
				setTimeout ->
					isAnimation = false
				, 500

		#
		# resize logic if some block isOpen (active)
		#
		resizeAnimation = ($this) ->
			return if isAnimation
			tl = new TimelineMax()
			$target = $catalog.find($this.attr("data-target"))
			$targetInner = $target.find('.product-params__wrap')

			productCoverHeightClosed = (0.6666 * $this.outerWidth())
			productCoverHeightOpen = productCoverHeightClosed * 1.6

			catalogIndex = $('.catalog__item').index($this.parent()) + 1
			isOddProductCover = catalogIndex % 2
			if isOddProductCover
				coef = -1
			else
				coef = 1

			if isMobile()
				tl
					.set $target.get(0), { height: $targetInner.outerHeight()  }, 0
			else
				tl
					.set $target.get(0), { height: $targetInner.outerHeight()  }, 0
					.set $this.get(0), { paddingBottom: "#{productCoverHeightOpen}px" }, 0

		#
		# hover
		#

		hoverIn = ->
			$this = $(@)
			$video = $this.find('video')
			hasVideo = $video.length
			if (hasVideo and !$this.hasClass('hover')) and !$this.hasClass('active')
				$this.addClass 'hover'
				toX = if $this.hasClass 'right' then "0%" else "-50%"
				$inner = $this.find('.product-cover__wrap-inner')
				onComplete = ->
					$video.get(0).play() if $this.hasClass('hover') and $video.hasClass('is-loaded')

				TweenMax.to $inner.get(0), 0.3, { x: toX, ease: Power0.easeNone, onComplete: onComplete }

		hoverOut = ->
			$this = $(@)
			$video = $this.find('video')
			hasVideo = $video.length
			if (hasVideo and $this.hasClass('hover')) and !$this.hasClass('active')
				$video.get(0).pause()
				$this.removeClass 'hover'
				toX = if $this.hasClass 'right' then "-50%" else "0%"
				$inner = $this.find('.product-cover__wrap-inner')
				TweenMax.to $inner.get(0), 0.3, { x: toX, ease: Power0.easeNone }

		if !touchDevice
			$block.hover hoverIn, hoverOut

		#
		# Click handler
		#

		activeBlock = null

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
				activeBlock = null

				setTimeout ->
					$this.addClass 'active'
					hoverOut.call $openBlock.get(0)
					activeBlock = $this.data 'target'
					animationFunc $this, isOpen
				, 500
			else if !isOpen
				$this.addClass 'active'
				activeBlock = $this.data 'target'
				animationFunc $this, isOpen

		$block.find('.product-cover__close').on 'click touchstart', (e) ->
			e.preventDefault()
			$this = $(@)
			$parent = $this.parents('.product-cover')
			animationFunc $parent, true
			$parent.removeClass 'active'
			activeBlock = null

		controller.resizeSceneActions.push ->
			$openBlock = $('.product-cover.active')
			return unless $openBlock.length or activeBlock
			if $openBlock.length
				resizeAnimation $openBlock
			else if activeBlock
				$activeBlock = $('.catalog').find("[data-target='#{activeBlock}']")
				return unless $activeBlock.length
				$activeBlock.addClass 'active'
				animationFunc $activeBlock, false

	productCoverJS()

	$(document).on 'product-cover', productCoverJS
