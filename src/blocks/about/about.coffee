import { Scene } from 'scrollmagic'
import { TimelineMax, TweenMax } from 'gsap'

$ ->

	aboutBlockJS = ->
		$block = $('.about')
		return unless $block.length

		cntrl = controller.get()

		new Scene({
				triggerElement: ".about__text"
				offset: 0,
				duration: '100%'
			})
			.setTween(TweenMax.fromTo '.about__text', 0.5, { autoAlpha: 1 }, { autoAlpha: 0 })
			.addTo(cntrl)

		$listItems = $block.find '.about__list-item'
		$listItems.each ->
			tl = new TimelineMax()
			$icon = $(@).find '.about__list-image'
			tl
				.fromTo @, 0.5, { autoAlpha: 0 }, { autoAlpha: 1 }, 0
				.fromTo $icon.get(0), 0.5, { scale: 0.6 }, { scale: 1 }, 0

			new Scene({
					triggerElement: @,
					triggerHook: 0.8,
					duration: '25%'
				})
				.setTween(tl)
				.addTo(cntrl)

		sequence = $block.data('sequence')
		return if !sequence

		sequenceAnimation '.about__text', sequence[0], sequence[1], { begin: true, triggerHook: 0.5 }

	aboutBlockJS()

	$(document).on 'about-block', aboutBlockJS
