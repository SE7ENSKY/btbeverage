import ScrollMagic from 'scrollmagic'
import { TimelineMax, TweenMax, Power0 } from 'gsap'

$ ->
	$block = $('.about')
	return unless $block.length

	$bottle = $('.about__bottle')
	$bottleSeq = $bottle.find('.about__bottle-img')

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
			triggerElement: '.about__text'
			offset: 0,
			duration: '50%'
		})
		.setTween(TweenMax.fromTo '.about__text', 0.5, { autoAlpha: 1 }, { autoAlpha: 0 })
		.addTo(controller)

	new ScrollMagic.Scene({
			triggerElement: '.about__text'
			offset: 90,
			duration: '500%'
		})
		.setTween(seqTween)
		.addTo(controller)
		.on 'start', ->
			TweenMax.staggerTo '.about__list-item', 0.5, { autoAlpha: 1 }, 0.2
		.on 'enter', ->
			TweenMax.set $bottle, { autoAlpha: 1 }
		.on 'leave', ->
			TweenMax.set $bottle, { autoAlpha: 0 }
