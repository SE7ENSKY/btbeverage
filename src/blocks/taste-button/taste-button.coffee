import { Scene } from 'scrollmagic'
import { TweenMax } from 'gsap'

$ ->
	tasteButtonJS = ->
		$block = $('.taste-button')
		return unless $block.length

		cntrl = controller.get()
		$buttonLink = $block.find '.taste-button__link'
		tasteButtonHeight = $block.outerHeight()
		triggerClass = $block.data 'trigger-class'
		stopClass = $block.data 'stop-class'

		$trigger = $("." + triggerClass)
		$stopper = $("." + stopClass)

		tasteButtonShow = new Scene({
				triggerElement: $trigger.get(0),
				triggerHook: 0.5,
			})
			.setTween TweenMax.fromTo $buttonLink, 0.3, { y: tasteButtonHeight }, { y: 0 }
			.addTo cntrl

		tasteButtonHide = new Scene({
				triggerElement: $stopper.get(0),
				triggerHook: 1
			})
			.addTo cntrl
			.setTween TweenMax.fromTo $buttonLink, 0.3, { y: 0 }, { y: tasteButtonHeight }

		TweenMax.set $buttonLink, { y: tasteButtonHeight }

		if isMobile()
			tasteButtonHide.enabled false
			tasteButtonShow.enabled false

		controller.resizeSceneActions.push ->
			if isMobile()
				tasteButtonHide.enabled false
				tasteButtonShow.enabled false
			else
				tasteButtonHide.enabled true
				tasteButtonShow.enabled true

	tasteButtonJS()

	$(document).on 'taste-button', tasteButtonJS
