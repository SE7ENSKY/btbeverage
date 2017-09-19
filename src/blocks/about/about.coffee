import { Controller, Scene } from 'scrollmagic'
import { TimelineMax, TweenMax, Power0 } from 'gsap'

$ ->
	aboutBlockScene = []

	aboutBlockJS = ->
		$block = $('.about')
		return unless $block.length

		controller = new Controller()

		aboutBlockScene.push(new Scene({
				triggerElement: ".about__text"
				offset: 0,
				duration: '100%'
			})
			.setTween(TweenMax.fromTo '.about__text', 0.5, { autoAlpha: 1 }, { autoAlpha: 0 })
			.addTo(controller))

		$listItems = $block.find '.about__list-item'
		$listItems.each ->
			new Scene({
					triggerElement: $(@).get(0),
					triggerHook: 1,
					offset: 50,
					duration: '50%'
				})
				.setTween(TweenMax.fromTo @, 0.5, { autoAlpha: 0 }, { autoAlpha: 1 })
				.addTo(controller)

		sequence = $block.data('sequence')
		return if !sequence

		sequenceAnimation '.about__text', sequence[0], sequence[1], { begin: true, triggerHook: 0.5 }

	aboutBlockJS()

	removeScene = ->
		aboutBlockScene.forEach (el) -> el.destroy()
		aboutBlockScene.length = 0

	$(document).on 'about-block', aboutBlockJS
	$(document).on 'about-block-remove', removeScene
