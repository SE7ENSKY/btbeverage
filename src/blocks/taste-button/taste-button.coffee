import { Controller, Scene } from 'scrollmagic'
import { TweenMax } from 'gsap'

$ ->
	tasteButtonScene = []
	tasteButtonJS = ->
		$block = $('.taste-button')
		return unless $block.length

		controller = new Controller()

		tasteButtonScene.push(new Scene({
				offset: window.innerHeight,
				duration: "600%",
			})
			.addTo(controller)
			.on 'enter', ->
				TweenMax.fromTo $block, 0.1, { autoAlpha: 0 }, { autoAlpha: 1 }
			.on 'leave', ->
				TweenMax.fromTo $block, 0.1, { autoAlpha: 1 }, { autoAlpha: 0 }
		)

	tasteButtonJS()

	removeScene = ->
		tasteButtonScene.forEach (el) -> el.destroy()
		tasteButtonScene.length = 0

	$(document).on 'taste-button', tasteButtonJS
	$(document).on 'taste-button-remove', removeScene
