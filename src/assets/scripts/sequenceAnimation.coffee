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
		seqTween.to $seq, 0.5,
			transform: "translateX(#{options.shiftToX})"
			ease: Power0.easeNone
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
			if (options.begin and ev.scrollDirection == "REVERSE")
				TweenMax.set $seq.get(0), { autoAlpha: 0 }
			if (options.finish and ev.scrollDirection == "FORWARD")
				$seq.css 'position', 'absolute'
				setSeqTop()
		.on 'enter', (ev) ->
			if (options.begin and ev.scrollDirection == "FORWARD")
				TweenMax.set $seq.get(0), { autoAlpha: 1 }
			if (options.finish and ev.scrollDirection == "REVERSE")
				$seq.css 'position', 'fixed',
				$seq.css 'top', $menuHeight

	seqScene.enabled false if isMobile() or isPortrait()

	controller.resizeSceneActions.push ->
		if isMobile() or isPortrait()
			seqScene.enabled false
			TweenMax.set $seq.get(0), { autoAlpha: 0 }
		else
			TweenMax.set $seq.get(0), { autoAlpha: 1 }
			seqScene.enabled true
