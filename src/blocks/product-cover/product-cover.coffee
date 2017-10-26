import { Scene } from 'scrollmagic'
import { TimelineMax, TweenMax, Power0, Power1, Power2 } from 'gsap'

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

		#
		# catalog animation
		#

		isAnimation = false

		scrollToViewport = ($this, cb = null) ->
			# $target = $catalog.find($this.attr("data-target"))
			# return unless $target.length
			# if $this.closest($colLeft).length
			# 	scrollOffset = $target.offset().top
			# else
			# 	scrollOffset = $this.offset().top
			scrollOffset = $this.offset().top
			valY = scrollOffset - $('.header').outerHeight()

			# scrollVal =
			# 	y: window.scrollY
			# TweenMax.to scrollVal, 1.3,
			# 	y: valY
			# 	ease: Power2.easeOut
			# 	onUpdate: ->
			# 		window.scroll 0, scrollVal.y
			TweenMax.to window, 1.3,
				scrollTo:
					y: valY
				ease: Power2.easeOut			
				onStart: ->
					cb() if cb?
					# if $col.length
					# 	thisOffset = $this.offset().top
					# 	targetOffset = $target.offset().top
					# 	diff = Math.abs(thisOffset - targetOffset)
					# 	TweenMax.to $colLeft, .2,
					# 		marginTop: -diff,
					# 		ease: Power1.easeOut
					# 		onComplete: ->
					# 			cb() if cb?
					# else
					# 	cb() if cb?

		animationFunc = ($this, isOpen, cb) ->
			isAnimation = true
			tl = new TimelineMax
				onComplete: ->
					isAnimation = false
					cb() if cb?

			tl.timeScale(.55)

			$target = $catalog.find($this.attr("data-target"))
			
			$targetInner = $target.find('.product-params__wrap')
			TweenMax.set $targetInner, {scaleY: 1}
			targetInnerHeight = $targetInner.outerHeight()

			productCoverHeightClosed = (0.54 * $this.outerWidth())
			productCoverHeightOpen = productCoverHeightClosed * 1.6

			coef = if $this.hasClass 'right' then -1 else 1

			$blockInners = $targetInner.find '.stagger'

			$paramsTextInner = $targetInner.find '.product-params__text-inner'

			$sliderWrapper = $this.find '.product-cover__slider-wrapper'
			$slider = $this.find '.product-cover__slider'
			$sliderVerticalText = $this.find '.product-cover__text-vertical span'
			$sliderTitle = $this.find '.product-cover__title'


			# open
			unless isOpen
				unless isMobile()
					tl
						.set $sliderWrapper, { height: "#{productCoverHeightOpen}px", bottom: 'auto' }, 0
						.fromTo $this, 0.5, { paddingBottom: "#{productCoverHeightClosed}px" }, { paddingBottom: "#{productCoverHeightOpen}px", ease: Power2.easeOut }, 0
						.fromTo $sliderTitle, .5, { autoAlpha: 1}, {autoAlpha: 0}, 0
				tl	
					.fromTo $target, .5, { height: 0 }, { height: targetInnerHeight, ease: Power2.easeOut  }, 0
					.fromTo $targetInner, .5, {y: '20%', autoAlpha: 1}, {y: '0%', ease: Power2.easeOut, force3D: false}, 0
					.fromTo [$blockInners, $paramsTextInner], .5, { y: '-30%' }, { y: '0%', force3D: false}, .1, 0
				unless isMobile()
					tl
						.staggerFromTo $sliderVerticalText, 0.3, { autoAlpha: 0, rotationX: 90 * coef }, { autoAlpha: 1, rotationX: 0 , force3D: false}, 0.2, 0
						.set $sliderWrapper, { height: "auto", bottom: '0' }
				else
					coef = 2
				tl.fromTo $slider, .5, { x: - 0.5 * window.innerWidth * coef, autoAlpha: 0}, { x: 0, autoAlpha: 1, ease: Power1.easeOut }, 0
			
			# close
			else
				tl
					.to $target, .3, { height: 0, ease: Power2.easeOut }, 0
					.to $targetInner, .3, {y: '-50%', autoAlpha: 0, ease: Power2.easeOut, force3D: false}, 0
					.to $sliderVerticalText, .3, { autoAlpha: 0}, 0
				unless isMobile()
					tl
						.set $sliderWrapper, { height: "#{productCoverHeightOpen}px", bottom: 'auto' }, 0
						.to $this, 0.3, { paddingBottom: "27vw" , ease: Power2.easeOut  }, 0
						.to $sliderTitle, .3, { autoAlpha: 1}, 0
						# .to $colLeft, .2, {marginTop: 0}, 0
				else
					coef = 2
				tl.to $slider, .3, { x: - 0.5 * window.innerWidth * coef / 4, autoAlpha: 0, ease:Power1.easeOut }, 0

			# if isOpen
			# 	$targetIngredients = $target.removeClass('ingredients-open').find('.product-params__ingredients')
			# 	if $targetIngredients.length
			# 		tl.set $targetIngredients, { height: 0, autoAlpha: 0 }, 0.5

		#
		# resize logic if some block isOpen (active)
		#
		resizeAnimation = ($this) ->
			return if isAnimation
			$target = $catalog.find($this.attr("data-target"))
			$targetInner = $target.find('.product-params__wrap')
			TweenMax.set $targetInner, {scaleY: 1}
			targetInnerHeight = $targetInner.outerHeight()

			if isMobile()
				TweenMax.set $target, { height: targetInnerHeight  }, 0
			else
				productCoverHeightClosed = (0.54 * $this.outerWidth())
				productCoverHeightOpen = productCoverHeightClosed * 1.6
				TweenMax.set $this, { paddingBottom: "#{productCoverHeightOpen}px" }, 0
				TweenMax.set $target, { height: targetInnerHeight  }, 0

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
				animationFunc $openBlock, true
				$openBlock.removeClass 'active'
				removeHash()
				activeBlock = null
				timeout = 600

			setTimeout ->
				hoverOut.call $openBlock if $openBlock.length and !touchDevice
				$this.addClass 'active'
				activeBlock = $this.data 'target'
				scrollToViewport $this, ->
					animationFunc $this, isOpen, ->
						setHash $this.attr('id')
			, timeout


		$block.find('.product-cover__close').on 'click touchstart', (e) ->
			e.preventDefault()
			removeHash()
			$this = $(@)
			$parent = $this.parents('.product-cover')
			animationFunc $parent, true
			$parent.removeClass 'active'
			activeBlock = null

		#
		# add location hash handler for Product page
		#

		$(document)
			.unbind 'catalog-handle-hash'
			.on 'catalog-handle-hash', (e, $this) ->
				scrollToViewport $this, ->
					hoverIn.call $this unless isMobile()
					$this.addClass 'active'
					activeBlock = $this.data 'target'
					animationFunc $this, false

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
