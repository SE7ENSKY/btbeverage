import { TimelineMax } from 'gsap'
import { Controller, Scene } from 'scrollmagic'

$ ->
	catalogBlockJS = ->
		$block = $('.catalog')
		return unless $block.length

		controller = new Controller()
		tl = new TimelineMax()
		tl
			.fromTo '.catalog__item:nth-child(2n+1)', 0.5, { y: 30 }, { y: 0 }, 0
			.fromTo '.catalog__item:nth-child(2n)', 0.5, { y: 100 }, { y: 0 }, 0

		new Scene({
				triggerElement: $block.get(0),
				triggerHook: 1,
				duration: "50%",
				offset: -100
			})
			.setTween(tl)
			.addTo(controller)

	catalogBlockJS()

	$(document).on 'catalog', catalogBlockJS
