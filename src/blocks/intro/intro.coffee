import { TimelineMax, TweenMax, Power2, Power1, Sine } from 'gsap'
import ScrollMagic from 'scrollmagic';

isLoaded = false

window.addEventListener 'load', ->
	isLoaded = true

$ ->
	$block = $(".intro")
	return unless $block.length

	$('body').css 'overflow', 'hidden'
	sliderAnimationOver = false

	#
	# Animation
	#

	$leaf = $(".about__title-image")

	preloaderBgAnimation = (startTime) ->
		tl = new TimelineMax()
		tl
			.to '.intro__preloader', 0.9, { height: 0 }, startTime

	bLetterAnimation = (startTime)->
		setTimeout ->
			$('.intro__logo').addClass 'active'
		, startTime * 1000

	lettersAnimation = (startTime) ->
		tl = new TimelineMax()
		tl
			.fromTo '.intro__logo-s_b', 0.5, { autoAlpha: 0, y: -40 }, { autoAlpha: 1, y: 0, ease: Power2.easeOut } , startTime
			.fromTo '.intro__logo-s_line', 0.5, { autoAlpha: 0, y: -40 }, { autoAlpha: 1, y: 0, ease: Power2.easeOut },  startTime + 0.1
			.fromTo '.intro__logo-s_t', 0.5, { autoAlpha: 0, y: -40 }, { autoAlpha: 1, y: 0, ease: Power2.easeOut }, startTime + 0.15
			.fromTo '.intro__logo-s_e', 0.5, { autoAlpha: 0, y: -40 }, { autoAlpha: 1, y: 0, ease: Power2.easeOut }, startTime + 0.2
			.fromTo '.intro__logo-s_a', 0.5, { autoAlpha: 0, y: -40 }, { autoAlpha: 1, y: 0, ease: Power2.easeOut }, startTime + 0.25

	sliderAnimation = (startTime, onComplete) ->
		tl = new TimelineMax()
		delay = startTime + 1
		tl
			.set '.intro__more', { autoAlpha: 0 }
			.to '.intro__more', 0.5, { autoAlpha: 1 }, startTime
			.fromTo '.intro__more .stop-3', 0.5, { attr: { offset: "0%" } }, { attr: { offset: "100%" } }, delay
			.fromTo '.intro__more .stop-2', 0.5, { attr: { offset: "0%" } }, { attr: { offset: "100%" } }, delay + 0.2
			.fromTo '.intro__more .stop-1', 0.5, { attr: { offset: "0%" } }, { attr: { offset: "100%" }, onComplete: onComplete }, delay + 0.4

	headerAnimation = (startTime) ->
		tl = new TimelineMax()
		tl
			.set '.header__menu', { y: -60 }
			.set '.header__shadow', { autoAlpha: 0 }
			.to '.header__menu', 0.5, { y: 0 }, startTime
			.to '.header__shadow', 0.5, { autoAlpha: 1 }, startTime

	leafPreloaderAnimation = ->
		tl = new TimelineMax()

		tl
			.fromTo $leaf, 2.2,
				y: - window.innerHeight / 2 - 40,
				rotation: -90,
					y: "-100%",
					ease: Power1.easeOut
				, 0
			.fromTo $leaf, 0.8, { rotation: -90 }, { rotation: 25 }, 0
			.fromTo $leaf, 0.8, { x: "-50%" }, { x: "-53%" }, 0
			.fromTo $leaf, 0.6, { x: "-53%" }, { x: "-45%" }, 0.8
			.fromTo $leaf, 0.4, { rotation: 25 }, { rotation: -5 }, 1
			.fromTo $leaf, 0.6, { rotation: -5 }, { rotation: 5 }, 1.6
			.fromTo $leaf, 0.6, { x: "-45%" }, { x: "-50%" }, 1.6

	leafScrollAnimation = ->
		controller = new ScrollMagic.Controller()
		basicConfig =
			rotation: 5,
			x: "-50%",
			y: "-100%",
			scale: 1

		hideTween =
			TweenMax.fromTo $leaf, 0.5,
				rotation: 60,
				scale: 1.15
					rotation: 30,
					ease: Sine.easeIn
					scale: 1.15

		tween =
			TweenMax.fromTo $leaf, 0.5, basicConfig,
				rotation: 60,
				x: -25,
				y: -35,
				scale: 1.15,
				ease: Power1.easeIn

		new ScrollMagic.Scene({
				offset: 0
				duration: "100%"
			})
			.setTween(tween)
			.addTo(controller)

		new ScrollMagic.Scene({
				offset: Math.max(window.innerHeight, 650),
				duration: "50%",
			})
			.setTween(hideTween)
			.addTo(controller)
			.on 'leave', (ev) ->
				$leaf.hide(0) if ev.scrollDirection == "FORWARD"
			.on 'enter', (ev) ->
				$leaf.show(0) if ev.scrollDirection == "REVERSE"

	startAnimation = ->
			$leaf.show(0)
			window.scrollTo(0, 0)
			# preloader animation
			leafPreloaderAnimation()
			preloaderBgAnimation 1.3
			bLetterAnimation 2
			lettersAnimation 2.5
			headerAnimation 3.5
			sliderAnimation 3.5, ->
				$('body').css 'overflow', '' if isLoaded
				sliderAnimationOver = true
			# add leaf scrolling animation
			leafScrollAnimation()

	startAnimation()

	if !isLoaded
		window.addEventListener 'load', ->
			addVideo $block, 5000
			$('body').css 'overflow', '' if sliderAnimationover
	else
		addVideo $block, 5000
