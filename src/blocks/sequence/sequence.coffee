import ScrollMagic from 'scrollmagic'
import { TimelineMax, TweenMax, Power0 } from 'gsap'

$ ->
	$block = $('.sequence')
	return unless $block.length

	$block.each ->
		$this = $(@)

		$bottle = $('.sequence')
		triggerElementClass = $bottle.data('trigger')
		$triggerElement = $(".#{triggerElementClass}")
		if !$triggerElement.get(0)
			$triggerElement = $bottle.parent()

		$bottleSeq = $bottle.find('.sequence__image')

		tempAnimationObj =
			current: 0

		prevChild = 0

		onUpdateFunc = (obj) ->
			return unless obj
			currentChild = Math.round obj.current

			if prevChild != currentChild
				$bottleSeq.get(prevChild).style.display = "none"
				$bottleSeq.get(currentChild).style.display = "block"
				prevChild = currentChild

		seqTween = TweenMax.fromTo tempAnimationObj, 0.5,
			current: 0,
				current: $bottle.children().length - 1,
				onUpdate: onUpdateFunc,
				onUpdateParams: [tempAnimationObj],
				ease: Power0.easeNone,

		controller = new ScrollMagic.Controller()

		new ScrollMagic.Scene({
				triggerElement: $triggerElement.get(0),
				offset: 0,
				triggerHook: 0,
				duration: '100%'
			})
			.setTween(seqTween)
			.addTo(controller)
			.on 'leave', ->
				TweenMax.to $bottle.get(0), 0.1, { autoAlpha: 0 }
			.on 'enter', ->
				TweenMax.to $bottle.get(0), 0.1, { autoAlpha: 1 }
