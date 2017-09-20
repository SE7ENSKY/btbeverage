import { Controller, Scene } from 'scrollmagic'
import { TweenMax } from 'gsap'

$ ->
	tasteButtonScene = []
	tasteButtonJS = ->
		$block = $('.taste-button')
		return unless $block.length

		controller = new Controller()
		$buttonLink = $block.find '.taste-button__link'
		tasteButtonHeight = $block.outerHeight()
		offset = $block.data 'screen-offset'
		duration = $block.data 'duration'

		tasteButtonScene.push(new Scene({
				offset: if offset then offset * window.innerHeight else 0,
				duration: duration or 0,
			})
			.addTo(controller)
			.on 'enter', ->
				TweenMax.fromTo $buttonLink, 0.3, { y: tasteButtonHeight }, { y: 0 }
			.on 'leave', ->
				TweenMax.fromTo $buttonLink, 0.3, { y: 0 }, { y: tasteButtonHeight }
		)

	tasteButtonJS()

	removeScene = ->
		tasteButtonScene.forEach (el) -> el.destroy()
		tasteButtonScene.length = 0

	$(document).on 'taste-button', tasteButtonJS
	$(document).on 'taste-button-remove', removeScene
