import { Controller, Scene } from 'scrollmagic'
import { TweenMax } from 'gsap'

$ ->
	$block = $('.taste-button')
	return unless $block.length

	controller = new Controller()

	new Scene({
			offset: window.innerHeight,
			duration: "600%",
		})
		.addTo(controller)
		.on 'enter', ->
			TweenMax.fromTo $block, 0.1, { autoAlpha: 0 }, { autoAlpha: 1 }
		.on 'leave', ->
			TweenMax.fromTo $block, 0.1, { autoAlpha: 1 }, { autoAlpha: 0 }
