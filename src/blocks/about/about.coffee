import { Scene } from 'scrollmagic'
import { TimelineMax, TweenMax } from 'gsap'

$ ->

	aboutBlockJS = ->
		$block = $('.about')
		return unless $block.length

		cntrl = controller.get()

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

		bottleScene = new Scene({
				triggerElement: '.about__bottle',
				triggerHook: 1,
				offset: -20,
				duration: "50%"
			})
			.setTween TweenMax.fromTo '.about__bottle', 0.5, { autoAlpha: 0 }, { autoAlpha: 1 }
			.addTo cntrl

		bottleScene.enabled false unless isMobile() or isPortrait()

		controller.resizeSceneActions.push ->
			if isMobile() or isPortrait()
				bottleScene.enabled true
			else
				bottleScene.enabled false

		sequence = $block.data('sequence')
		return if !sequence

		needCalcDuration = true
		durationValue = 0

		calcDuration = ->
			return durationValue unless needCalcDuration
			durationValue = $('.sequence-widget').offset().top - $('.about__title').offset().top - $('.about__title').outerHeight(true) - 2 * 80 - window.innerHeight / 2
			needCalcDuration = false
			return durationValue

		$(window).on 'resize', ->
			needCalcDuration = true

		sequenceAnimation '.about__title', sequence[0], sequence[1], { begin: true, triggerHook: 0.05, duration: calcDuration }

	aboutBlockJS()

	$(document).on 'about-block', aboutBlockJS
