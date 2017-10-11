import { Scene } from 'scrollmagic'
import { TimelineMax, TweenMax, Power0, Power1 } from 'gsap'

$ ->
	productCoverJS = ->
		$block = $(".product-cover")
		return unless $block.length
		$catalog = $(".catalog")

		$col = $catalog.find('.catalog__col')
		if $col.length
			$colLeft = $col.filter(':eq(0)')
			$colRight = $col.filter(':eq(1)')
			$colRight.find($block).addClass 'right'

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
					.to $params, 0.2, { height: $params.outerHeight() + paramsHeightDiff, ease: Power0.easeNone }, 0
				
				if isOpen
					tl.to $paramsIngredient, 0.2, { height: 0, autoAlpha: 0, ease: Power0.easeNone }, 0
				else
					tl.fromTo $paramsIngredient, 0.2, { height: 0 }, { height: ingredientsHeight, autoAlpha: 1, ease: Power0.easeNone }, 0

				$params.toggleClass 'ingredients-open', !isOpen



		#
		# catalog animation
		#

		isAnimation = false

		scrollToViewport = ($this, cb = null) ->
			$target = $catalog.find($this.attr("data-target"))
			return unless $target.length
			if $this.closest($colLeft).length
				scrollOffset = $target.offset().top
			else
				scrollOffset = $this.offset().top

			valY = scrollOffset - $('.header').outerHeight()
			TweenMax.to $(window), .2,
				scrollTo:
					y: valY
					autoKill: true
				ease: Power1.easeOut
				# overwrite: 10
				onComplete: ->
					if $col.length
						thisOffset = $this.offset().top
						targetOffset = $target.offset().top
						diff = Math.abs(thisOffset - targetOffset)
						TweenMax.to $colLeft, .2,
							marginTop: -diff,
							ease: Power1.easeOut
							onComplete: ->
								cb() if cb?
					else
						cb() if cb?

		animationFunc = ($this, isOpen, removeHover = false) ->
			isAnimation = true
			tl = new TimelineMax
				onComplete: ->
					isAnimation = false

			$target = $catalog.find($this.attr("data-target"))
			$targetInner = $target.find('.product-params__wrap')

			productCoverHeightClosed = (0.6666 * $this.outerWidth())
			productCoverHeightOpen = productCoverHeightClosed * 1.6

			coef = if $this.hasClass 'right' then -1 else 1

			$blockInners = $targetInner.find '.stagger'

			$paramsText = $targetInner.find '.product-params__text'
			$paramsTextInner = $targetInner.find '.product-params__text-inner'
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
			$sliderTitle = $this.find '.product-cover__title'

			# open
			if isMobile()
				unless isOpen
					tl
						.to $target, 0.5, { height: $targetInner.outerHeight(), ease: Power0.easeNone  }, 0
						.fromTo $sliderWrapper, 0.2, { autoAlpha: 0 }, { autoAlpha: 1 }, 0.2
						.fromTo $paramsText, 0.5, { y: -(packHeight + volumeHeight + $paramsCart.outerHeight())}, { y: 0, ease: Power0.easeNone }, 0
						.fromTo $paramsCart, 0.4, { y: -(packHeight + volumeHeight) }, { y: 0, ease: Power0.easeNone }, 0.1
						.fromTo $paramsPack, 0.3, { y: -volumeHeight }, { y: 0, ease: Power0.easeNone }, 0.2
						.fromTo $paramsTextInner, 0.1, { autoAlpha: 0 }, { autoAlpha: 1 }, 0.3
						.staggerFromTo $blockInners, 0.1, { autoAlpha: 0 }, { autoAlpha: 1 }, .1, 0.4
						.fromTo $slider, 0.5, { x: -window.innerWidth }, { x: 0, ease: Power1.easeOut }, 0.5
						.fromTo $sliderNormalText, 0.3, { x: -0.5 * window.innerWidth }, { x: 0, ease: Power1.easeOut }, 0.5
				else
					tl
						.to $target, 0.5, { height: 0, ease: Power0.easeNone }, 0
						.to $paramsTextInner, 0.2, { autoAlpha: 0 }, 0, 0
						.to $blockInners, 0.2, { autoAlpha: 0 }, 0, 0
						.fromTo $sliderWrapper, 0.2, { autoAlpha: 1 }, { autoAlpha: 0 }, 0
						.set $slider, { x: -window.innerWidth }, 0.2
						.set $sliderNormalText, { x: -0.5 * window.innerWidth }, 0.2
						.fromTo $paramsText, 0.5, { y: 0 }, { y: -(packHeight + volumeHeight + $paramsCart.outerHeight()), ease: Power0.easeNone }, 0
						.fromTo $paramsCart, 0.4, { y: 0 }, { y: -(textHeight + volumeHeight), ease: Power0.easeNone }, 0
						.fromTo $paramsPack, 0.3, { y: 0 }, { y: -textHeight, ease: Power0.easeNone }, 0
			
			else
				unless isOpen
					tl
						.set $blockInners, { autoAlpha: 1  }
						.fromTo $target, 0.5, { height: 0 }, { height: $targetInner.outerHeight(),ease: Power0.easeNone  }, 0
						.fromTo $this, 0.5, { paddingBottom: "#{productCoverHeightClosed}px" }, { paddingBottom: "#{productCoverHeightOpen}px", ease: Power0.easeNone }, 0
						.fromTo $sliderWrapper, 0.2, { autoAlpha: 0 }, { autoAlpha: 1 }, 0.2
						.fromTo $paramsCart, 0.5, { y: -(textHeight + volumeHeight + packHeight)}, { y: 0, ease: Power0.easeNone }, 0
						.fromTo $paramsPack, 0.4, { y: -(textHeight + volumeHeight) }, { y: 0, ease: Power0.easeNone }, 0.1
						.fromTo $paramsVolume, 0.3, { y: -textHeight }, { y: 0, ease: Power0.easeNone }, 0.2
						.fromTo $paramsTextInner, 0.5, { autoAlpha: 0, y: -100 }, { autoAlpha: 1, y: 0, ease: Power2.easeOut }, 0.3
						.staggerFromTo $blockInners, .3, { x: 100 * coef + '%' }, { x: '0%' }, .1, 0.4
						
						.fromTo $sliderTitle, .5, { autoAlpha: 1}, {autoAlpha: 0}, 0
						.fromTo $slider, 1, { x: - 0.5 * window.innerWidth * coef}, { x: 0, ease: Power1.easeOut }, 0.3
						.fromTo $sliderNormalText, 0.4, { x: -0.25 * window.innerWidth * coef }, { x: 0, ease: Power1.easeOut }, 0.9
						.staggerFromTo $sliderVerticalText, 0.4, { autoAlpha: 0, rotationX: 90 * coef }, { autoAlpha: 1, rotationX: 0 }, 0.2, 0.4
				else
					tl
						.to $target, 0.5, { height: 0, ease: Power0.easeNone }, 0
						.to $this, 0.5, { paddingBottom: "33.33vw" , ease: Power0.easeNone  }, 0
						.to $sliderTitle, .5, { autoAlpha: 1}, 0
						.to $sliderWrapper, 0.2, { autoAlpha: 0 }, 0
						.to $paramsCart, 0.5, { y: -(textHeight + volumeHeight + $paramsPack.outerHeight()), ease: Power0.easeNone }, 0
						.to $paramsPack, 0.4, { y: -(packHeight + volumeHeight), ease: Power0.easeNone }, 0
						.to $paramsVolume, 0.3, { y: -volumeHeight, ease: Power0.easeNone }, 0
						.to $paramsTextInner, 0.2, { autoAlpha: 0 }, 0
						.to $blockInners, 0.2, { autoAlpha: 0 }, 0
						.to $colLeft, .2, {marginTop: 0}, 0
			if isOpen
				$targetIngredients = $target.removeClass('ingredients-open').find('.product-params__ingredients')
				if $targetIngredients.length
					tl.set $targetIngredients, { height: 0, autoAlpha: 0 }, 0.5

		#
		# resize logic if some block isOpen (active)
		#
		resizeAnimation = ($this) ->
			return if isAnimation
			$target = $catalog.find($this.attr("data-target"))
			$targetInner = $target.find('.product-params__wrap')

			if isMobile()
				TweenMax.set $target, { height: $targetInner.outerHeight()  }, 0
			else
				productCoverHeightClosed = (0.6666 * $this.outerWidth())
				productCoverHeightOpen = productCoverHeightClosed * 1.6
				TweenMax.set $this, { paddingBottom: "#{productCoverHeightOpen}px" }, 0
				TweenMax.set $target, { height: $targetInner.outerHeight()  }, 0

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

				TweenMax.to $inner, 0.3, { x: toX, ease: Power0.easeNone, onComplete: onComplete }

		hoverOut = ->
			$this = $(@)
			$video = $this.find('video')
			hasVideo = $video.length
			if (hasVideo and $this.hasClass('hover')) and !$this.hasClass('active')
				$video.get(0).pause()
				$this.removeClass 'hover'
				toX = if $this.hasClass 'right' then "-50%" else "0%"
				$inner = $this.find('.product-cover__wrap-inner')
				TweenMax.to $inner, 0.3, { x: toX, ease: Power0.easeNone }

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

			return if isAnimation || isOpen

			timeout = 1
			# check if other block is opened
			if $openBlock.length
				animationFunc $openBlock, true, true
				$openBlock.removeClass 'active'
				activeBlock = null
				timeout = 500

			setTimeout ->
				scrollToViewport $this, ->
					hoverOut.call $openBlock if $openBlock.length
					$this.addClass 'active'
					activeBlock = $this.data 'target'
					animationFunc $this, isOpen
			, timeout


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
