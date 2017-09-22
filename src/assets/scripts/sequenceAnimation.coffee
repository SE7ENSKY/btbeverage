import { Scene } from 'scrollmagic'
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
		currentChild = $bottleSeq.get Math.round(obj.current)
		prevActive = $bottle.find('.active').get(0)
		if prevActive != currentChild
			$(currentChild).addClass 'active'
			$(prevActive).removeClass 'active'

	seqTween = TweenMax.fromTo tempAnimationObj, 0.5,
		current: start,
			current: end,
			onUpdate: onUpdateFunc,
			onUpdateParams: [tempAnimationObj],
			ease: Power0.easeNone,

	cntrl = controller.get()

	if options.finish
		$img = $(triggerElement).find '.media-widget__image_center'
		return unless $img.length
		$img.css 'background-image', "url(#{$($bottleSeq.get(end)).data('image')})"

	new Scene({
			triggerElement: triggerElement,
			offset: 0,
			triggerHook: options.triggerHook or 1,
			duration: options.duration or '100%'
		})
		.setTween(seqTween)
		.addTo(cntrl)
		.on 'leave', (ev) ->
			if (options.begin and ev.scrollDirection == "REVERSE") or (options.finish and ev.scrollDirection == "FORWARD")
				setTimeout ->
					TweenMax.set $bottle.get(0), { autoAlpha: 0 }
					$bottle.find('.active').removeClass 'active'
				, 50
			if (options.finish and ev.scrollDirection == "FORWARD")
				return unless $img.length
				TweenMax.set $img, { autoAlpha: 1 }
		.on 'enter', (ev) ->
			if (options.begin and ev.scrollDirection == "FORWARD") or (options.finish and ev.scrollDirection == "REVERSE")
				TweenMax.set $bottle.get(0), { autoAlpha: 1 }
			if (options.finish and ev.scrollDirection == "REVERSE")
				return unless $img.length
				$bottle.find('.active').removeClass 'active'
				TweenMax.set $img, { autoAlpha: 0 }
