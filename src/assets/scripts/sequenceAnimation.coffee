import { Controller, Scene } from 'scrollmagic'
import { TimelineMax, TweenMax, Power0 } from 'gsap'

window.sequenceAnimation = (triggerElement, start, end, options = {}) ->
	$bottle = $('.sequence')
	return unless $bottle.length

	$bottleSeq = $bottle.find('.sequence__image')
	if !$bottleSeq.length
		console.warn 'Sequence block was init, but sequence images were not set'
		return

	tempAnimationObj =
		current: start

	onUpdateFunc = (obj) ->
		return unless obj
		currentChild = Math.round obj.current
		$bottle.find('.active').removeClass 'active'
		$($bottleSeq.get(currentChild)).addClass 'active'

	seqTween = TweenMax.fromTo tempAnimationObj, 0.5,
		current: start,
			current: end,
			onUpdate: onUpdateFunc,
			onUpdateParams: [tempAnimationObj],
			ease: Power0.easeNone,

	controller = new Controller()

	new Scene({
			triggerElement: triggerElement,
			offset: 0,
			triggerHook: options.triggerHook or 1,
			duration: options.duration or '100%'
		})
		.setTween(seqTween)
		.addTo(controller)
		.on 'leave', (ev) ->
			if (options.begin and ev.scrollDirection == "REVERSE") or (options.finish and ev.scrollDirection == "FORWARD")
				TweenMax.to $bottle.get(0), 0.1, { autoAlpha: 0 }
		.on 'enter', (ev) ->
			if (options.begin and ev.scrollDirection == "FORWARD") or (options.finish and ev.scrollDirection == "REVERSE")
				TweenMax.to $bottle.get(0), 0.1, { autoAlpha: 1 }
