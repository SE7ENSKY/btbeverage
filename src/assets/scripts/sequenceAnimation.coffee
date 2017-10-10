import { Scene } from 'scrollmagic'
import { TweenMax, Power0 } from 'gsap'

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

	seqTween = TweenMax.fromTo tempAnimationObj, 0.5,
		current: start,
			current: end,
			onUpdate: onUpdateFunc,
			onUpdateParams: [tempAnimationObj],
			ease: Power0.easeNone,

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
				TweenMax.set $canvas.get(0), { autoAlpha: 0 }
				TweenMax.set $seq.get(0), { autoAlpha: 0 }
			if (options.finish and ev.scrollDirection == "FORWARD") and !scene
				scene = new Scene({
					triggerElement: triggerElement,
					offset: window.innerHeight,
					triggerHook: options.triggerHook or 1,
					duration: "100%"
					})
					.setTween TweenMax.fromTo '.sequence', 0.5, { y: '0%', x: '-50%' }, { y: '-100%', x: '-50%', ease: Power0.easeNone }
					.addTo(cntrl)
		.on 'enter', (ev) ->
			if (options.begin and ev.scrollDirection == "FORWARD")
				$canvas = $seq.find 'canvas'
				TweenMax.set $canvas.get(0), { autoAlpha: 1 }
				TweenMax.set $seq.get(0), { autoAlpha: 1 }
			if (options.finish and ev.scrollDirection == "REVERSE") and scene
				scene.destroy()
				scene = null

	seqScene.enabled false if isMobile() or isPortrait()

	controller.resizeSceneActions.push ->
		scene.offset(window.innerHeight) if scene
		if isMobile() or isPortrait()
			scene.enabled false if scene
			seqScene.enabled false
		else
			scene.enabled true if scene
			seqScene.enabled true
