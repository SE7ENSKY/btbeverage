import { Scene } from 'scrollmagic'
import { TweenMax } from 'gsap'

$ ->
	tasteButtonJS = ->
		$block = $('.taste-button')
		return unless $block.length

		cntrl = controller.get()
		$buttonLink = $block.find '.taste-button__link'
		tasteButtonHeight = $block.outerHeight()
		offset = $block.data 'screen-offset'
		duration = $block.data 'duration'

		new Scene({
				offset: if offset then offset * window.innerHeight else 0,
				duration: duration or 0,
			})
			.addTo(cntrl)
			.on 'enter', ->
				TweenMax.fromTo $buttonLink, 0.3, { y: tasteButtonHeight }, { y: 0 }
			.on 'leave', ->
				TweenMax.fromTo $buttonLink, 0.3, { y: 0 }, { y: tasteButtonHeight }

	tasteButtonJS()

	$(document).on 'taste-button', tasteButtonJS
