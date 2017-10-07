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

		tl = new TimelineMax()
		tl
			.fromTo $desktop.find('.catalog__item:nth-child(2n+1)'), 0.5, { y: 50 }, { y: 0 }, 0
			.fromTo $desktop.find('.catalog__item:nth-child(2n+2)'), 0.5, { y: -100 }, { y: 0 }, 0

		cntrl = controller.get()

		scene = new Scene({
			triggerElement: $block.get(0)
			triggerHook: 1,
			offset: 20,
			duration: "33%"
			})
			.addTo cntrl
			.setTween tl

		scene.enabled false if isMobile()

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
