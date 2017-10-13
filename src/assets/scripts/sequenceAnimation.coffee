import { Scene } from 'scrollmagic'
import { TimelineMax, TweenMax, Power0, Power1 } from 'gsap'

window.sequenceAnimation = (triggerElement, start, end, options = {}) ->
	$seq = $('.sequence')
	return unless $seq.length

	tempAnimationObj =
		current: start

	onUpdateFunc = (obj) ->
		return unless obj && pixi.sprite
		currentChild = pixi.frames[Math.round(obj.current)]
		prevActive = pixi.sprite.texture
		if prevActive != currentChild
			pixi.sprite.texture = currentChild
			pixi.rerender()

	seqTween = new TimelineMax()
	seqTween.fromTo tempAnimationObj, 0.5,
		current: start,
			current: end,
			onUpdate: onUpdateFunc,
			onUpdateParams: [tempAnimationObj],
			ease: Power0.easeNone,
	, 0

	if options.shiftToX
		seqTween.fromTo $seq, 0.5,
			transform: "translate3d(0, 0, 0)",
				transform: "translate3d(#{options.shiftToX}, 0, 0)"
				ease: Power0.easeNone
		, 0

	cntrl = controller.get()
	scene = null

	seqScene = new Scene({
			triggerElement: triggerElement,
			offset: 0,
			triggerHook: options.triggerHook or 1,
			duration: options.duration or '100%'
		})
		.setTween(seqTween)
		.addTo(cntrl)
		.on 'leave', (ev) ->
			if (options.begin and ev.scrollDirection == "REVERSE")
				$canvas = $seq.find 'canvas'
				return unless $canvas.length
				TweenMax.set $canvas.get(0), { autoAlpha: 0 }
				TweenMax.set $seq.get(0), { autoAlpha: 0 }
			if (options.finish and ev.scrollDirection == "FORWARD") and !scene
				$canvas = $('.sequence canvas')
				scene = new Scene({
					triggerElement: triggerElement
					triggerHook: 0,
					offset: -40,
					duration: $canvas.outerHeight()
					})
					.setTween TweenMax.fromTo $canvas, 0.5, { y: 0 }, { y: "-100%", ease: Power0.easeNone }
					.addTo(cntrl)
		.on 'enter', (ev) ->
			if (options.begin and ev.scrollDirection == "FORWARD")
				$canvas = $seq.find 'canvas'
				return unless $canvas.length
				TweenMax.set $canvas.get(0), { autoAlpha: 1 }
				TweenMax.set $seq.get(0), { autoAlpha: 1 }
			if (options.finish and ev.scrollDirection == "REVERSE") and scene
				scene.destroy()
				scene = null

	seqScene.enabled false if isMobile() or isPortrait()

	controller.resizeSceneActions.push ->
		if scene
			scene.offset( -40 )
			scene.duration $('.sequence canvas').outerHeight()
		if isMobile() or isPortrait()
			scene.enabled false if scene
			seqScene.enabled false
		else
			scene.enabled true if scene
			seqScene.enabled true
