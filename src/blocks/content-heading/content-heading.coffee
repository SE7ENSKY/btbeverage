import { TweenMax, TimelineMax } from 'gsap'
import { Controller, Scene } from 'scrollmagic'

$ ->
	contentHeadingScene = []

	contentHeadingJS = ->
		$block = $('.content-heading')
		return unless $block.length

		controller = new Controller()

		tl = new TimelineMax()
		tl
			.staggerFromTo '.content-heading__title span', 0.5, { autoAlpha: 0, rotationX: -90 }, { autoAlpha: 1, rotationX: 0 }, 0.2, 0
			.fromTo '.content-heading__text', 0.5, { autoAlpha: 0 }, { autoAlpha: 1 }, 0.5

		contentHeadingScene.push(new Scene({
				triggerElement: $block.get(0),
				offset: -300,
				duration: '75%'
			})
			.setTween(tl)
			.addTo(controller))

	contentHeadingJS()

	removeScene = ->
		contentHeadingScene.forEach (el) -> el.destroy()
		contentHeadingScene.length = 0

	$(document).on 'content-heading', contentHeadingJS
	$(document).on 'content-heading-remove', removeScene
