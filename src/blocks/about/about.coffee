import ScrollMagic from 'scrollmagic'
import { TimelineMax, TweenMax } from 'gsap'

$ ->
	$block = $('.about')
	return unless $block.length

	$bottle = $('.about__bottle')
	$bottleSeq = $bottle.find('img')

	tempAnimationObj =
		current: 0

	prevChild = 0

	onUpdateFunc = (obj) ->
		return unless obj
		currentChild = Math.round obj.current

		if prevChild != currentChild
			$($bottleSeq.get(prevChild)).css("display", "none")
			$($bottleSeq.get(currentChild)).css("display", "block")
			prevChild = currentChild

	seqTween = TweenMax.fromTo tempAnimationObj, 0.5,
		current: 0,
			current: $bottleSeq.length - 1,
			onUpdate: onUpdateFunc,
			onUpdateParams: [tempAnimationObj]

	controller = new ScrollMagic.Controller()
	new ScrollMagic.Scene({
			triggerElement: '.about__list'
			offset: -200,
			duration: window.innerHeight * 4
		})
		.setTween(seqTween)
		.addTo(controller)
		.on 'start', ->
			TweenMax.staggerTo '.about__list-item', 0.5, { autoAlpha: 1 }, 0.2
		.on 'enter', ->
			TweenMax.fromTo $bottle, 0.1, { autoAlpha: 0 }, { autoAlpha: 1 }
		.on 'leave', ->
			TweenMax.fromTo $bottle, 0.1, { autoAlpha: 1 }, { autoAlpha: 0 }
