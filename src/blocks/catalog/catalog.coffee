import { Scene } from 'scrollmagic'
import { TimelineMax } from 'gsap'

$ ->

	catalogStructureJS = ->
		$block = $('.catalog')
		return unless $block.length
		firstInitIsMobile = isMobile()
		desktopEventConnected = !firstInitIsMobile
		mobileEventConnected = firstInitIsMobile

		$desktop = $block.find('.catalog__desktop')
		$mobile = $block.find('.catalog__mobile')

		tween = TweenMax.fromTo $desktop.find('.catalog__col').first(), 0.5, { y: '+=80' }, { y: '+=400', ease: Power0.easeNone, force3D: false }
		cntrl = controller.get()

		needCalcDuration = true
		durationValue = 0
		calcDuration = ->
			return durationValue unless needCalcDuration
			durationValue = $block.outerHeight() + window.innerHeight
			needCalcDuration = false
			return durationValue

		$(window).on 'resize', ->
			needCalcDuration = true

		scene = new Scene({
				triggerElement: $block.get(0)
				triggerHook: 1,
				duration: calcDuration
			})
			.addTo cntrl
			.setTween tween

		scene.enabled false if isMobile()

		$(document).on 'catalog-parallax', (e, value) ->
			if !isMobile()
				scene.enabled value

		handleStructure = ->
			if isMobile()
				scene.enabled false
				$desktop = $desktop.detach() if $block.find('.catalog__desktop').length
				$mobile.appendTo('.catalog') if !$block.find('.catalog__mobile').length
				if !mobileEventConnected
					$(document).trigger 'product-cover'
					$(document).trigger 'product-params'
					mobileEventConnected = true
			else
				$mobile = $mobile.detach() if $block.find('.catalog__mobile').length
				$desktop.appendTo('.catalog') if !$block.find('.catalog__desktop').length
				if !desktopEventConnected
					$(document).trigger 'product-cover'
					$(document).trigger 'product-params'
					desktopEventConnected = true
				scene.enabled true

		handleStructure()

		controller.resizeSceneActions.push ->
			handleStructure()

	catalogStructureJS()

	$(document).on 'catalog-init', catalogStructureJS
