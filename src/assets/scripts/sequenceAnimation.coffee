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
		state = seqScene.state()
		shouldUpdate = state == "DURING" or (state == "BEFORE" and options.begin) or (state == "AFTER" and options.finish)
		if prevActive != currentChild and shouldUpdate
			pixi.sprite.texture = currentChild
			pixi.rerender()

	seqTween = new TimelineMax()
	seqTween.fromTo tempAnimationObj, 1,
		current: start,
			current: end,
			onUpdate: onUpdateFunc,
			onUpdateParams: [tempAnimationObj],
			ease: Power0.easeNone,
	, 0

	if options.shiftToX
		seqTween.to $seq, 1,
			transform: "translateX(#{options.shiftToX})"
			ease: Power0.easeNone
			force3D: false
		, 0

	cntrl = controller.get()
	scene = null
	offset = () -> if options.offset then options.offset() else 0
	$el =  $(triggerElement)

	$menuHeight = 80

	setSeqTop = () ->
		$seq.css 'top', $el.offset().top + $el.outerHeight() - $seq.find('canvas').outerHeight() - $menuHeight

	$(window).on 'resize', ->
		if $seq.css('position') == 'absolute'
			setSeqTop()

	seqScene = new Scene({
			triggerElement: triggerElement,
			offset: 0 + offset(),
			triggerHook: options.triggerHook or 1,
			duration: options.duration or '100%'
		})
		.setTween(seqTween)
		.addTo(cntrl)
		.on 'leave', (ev) ->
			if options.begin and ev.scrollDirection == "REVERSE" and !isResize
				TweenMax.set $seq.get(0), { autoAlpha: 0 }
			if options.finish and ev.scrollDirection == "FORWARD" and !isResize
				$seq.css 'position', 'absolute'
				setSeqTop()
		.on 'enter', (ev) ->
			if options.begin and ev.scrollDirection == "FORWARD"
				TweenMax.set $seq.get(0), { autoAlpha: 1 }
			if options.finish and ev.scrollDirection == "REVERSE"
				$seq.css 'position', 'fixed'
				$seq.css 'top', $menuHeight

	seqScene.enabled false if isMobile() or isPortrait()

	controller.resizeSceneActions.push ->
		if isMobile() or isPortrait()
			seqScene.enabled false
			TweenMax.set $seq.get(0), { autoAlpha: 0 }
		else
			state = seqScene.state()
			if state == "BEFORE" and options.begin and seqScene.progress() != 1
				TweenMax.set $seq.get(0), { autoAlpha: 0 }
			else if options.finish and !(state == "BEFORE") or options.begin
				TweenMax.set $seq.get(0), { autoAlpha: 1 }

			if state == "AFTER" and options.finish and seqScene.progress() == 1
				$seq.css 'position', 'absolute'
				setSeqTop()

			if options.begin or ((state == "DURING" or state == "BEFORE" ) and options.finish)
				$seq.css 'position', 'fixed'
				$seq.css 'top', $menuHeight

			if options.shiftToX
				seqTween = new TimelineMax()
				seqTween.fromTo tempAnimationObj, 0.5,
					current: start,
						current: end,
						onUpdate: onUpdateFunc,
						onUpdateParams: [tempAnimationObj],
						ease: Power0.easeNone,
				, 0
				seqTween.fromTo $seq, 0.5,
					transform: "translateX(0)",
						transform: "translateX(#{options.shiftToX})"
						force3D: false
						ease: Power0.easeNone
				, 0
				seqScene.removeTween().setTween seqTween
			seqScene.enabled true
