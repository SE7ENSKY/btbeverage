import { Scene } from 'scrollmagic'
import { TweenMax, Power0 } from 'gsap'

window.sequenceAnimation = (triggerElement, start, end, options = {}) ->
	$seq = $('.sequence')
	return unless $seq.length

	$canvas = $seq.find 'canvas'

	tempAnimationObj =
		current: start

	onUpdateFunc = (obj) ->
		return unless obj && pixi.sprite
		currentChild = pixi.frames[Math.round(obj.current)]
		prevActive = pixi.sprite.texture
		if prevActive != currentChild
			pixi.sprite.texture = currentChild
			pixi.rerender()

	seqTween = TweenMax.fromTo tempAnimationObj, 0.5,
		current: start,
			current: end,
			onUpdate: onUpdateFunc,
			onUpdateParams: [tempAnimationObj],
			ease: Power0.easeNone,

	cntrl = controller.get()

	if options.finish
		seqArr = $('.sequence__seq').data 'image'
		imgUrl = seqArr[seqArr.length - 1]
		$img = $(triggerElement).find '.media-widget__image_center'
		return unless $img.length
		$img.css 'background-image', "url(#{imgUrl})"

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
				TweenMax.set $canvas.get(0), { autoAlpha: 0 }
				TweenMax.set $seq.get(0), { autoAlpha: 0 }
			if (options.finish and ev.scrollDirection == "FORWARD")
				return unless $img.length
				TweenMax.set $img, { autoAlpha: 1 }
		.on 'enter', (ev) ->
			if (options.begin and ev.scrollDirection == "FORWARD") or (options.finish and ev.scrollDirection == "REVERSE")
				TweenMax.set $canvas.get(0), { autoAlpha: 1 }
				TweenMax.set $seq.get(0), { autoAlpha: 1 }
			if (options.finish and ev.scrollDirection == "REVERSE")
				return unless $img.length
				TweenMax.set $img, { autoAlpha: 0 }
