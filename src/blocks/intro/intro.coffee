import { TimelineMax, TweenMax, Power2, Circ } from 'gsap'

$ ->
	$block = $(".intro")
	return unless $block.length

	_video = $block.find("video").get(0)
	$(_video).attr "controls", "true" if touchDevice
	# setTimeout ->
	# 	_video.play()
	# , 20

	preloaderAnimation = (startTime) ->
		tl = new TimelineMax()
		tl
			.to '.intro__preloader', 0.9, { height: 0 }, startTime

	bLetterAnimation = (startTime) ->
		tl = new TimelineMax()
		$symbol = $(".intro__logo-s_symbol").get(0)
		pathLength = $symbol.getTotalLength()

	lettersAnimation = (startTime) ->
		tl = new TimelineMax()
		tl
			.fromTo '.intro__logo-s_b', 0.5, { autoAlpha: 0, y: -40 }, { autoAlpha: 1, y: 0 } , startTime
			.fromTo '.intro__logo-s_line', 0.5, { autoAlpha: 0, y: -40 }, { autoAlpha: 1, y: 0, ease: Power2.easeOut },  startTime + 0.1
			.fromTo '.intro__logo-s_t', 0.5, { autoAlpha: 0, y: -40 }, { autoAlpha: 1, y: 0, ease: Power2.easeOut }, startTime + 0.15
			.fromTo '.intro__logo-s_e', 0.5, { autoAlpha: 0, y: -40 }, { autoAlpha: 1, y: 0, ease: Power2.easeOut }, startTime + 0.2
			.fromTo '.intro__logo-s_a', 0.5, { autoAlpha: 0, y: -40 }, { autoAlpha: 1, y: 0, ease: Power2.easeOut }, startTime + 0.25

	sliderAnimation = (startTime) ->
		tl = new TimelineMax()
		delay = startTime + 1
		tl
			.set '.intro__more', { autoAlpha: 0 }
			.to '.intro__more', 0.5, { autoAlpha: 1 }, startTime
			.fromTo '.intro__more .stop-3', 0.5, { attr: { offset: "0%" } }, { attr: { offset: "100%" } }, delay
			.fromTo '.intro__more .stop-2', 0.5, { attr: { offset: "0%" } }, { attr: { offset: "100%" } }, delay + 0.2
			.fromTo '.intro__more .stop-1', 0.5, { attr: { offset: "0%" } }, { attr: { offset: "100%" } }, delay + 0.4

	headerAnimation = (startTime) ->
		tl = new TimelineMax()
		tl
			.set '.header__menu', { y: -60 }
			.set '.header__shadow', { autoAlpha: 0 }
			.to '.header__menu', 0.5, { y: 0 }, startTime
			.to '.header__shadow', 0.5, { autoAlpha: 1 }, startTime

	leafAnimation = ->
		$leaf = $(".about__title-image")
		tl = new TimelineMax()

		tl
			.fromTo $leaf, 2, { y: -90, rotation: -90 }, { y: window.innerHeight / 2 - 85 }, 0
			.fromTo $leaf, 0.3, { rotation: -90 }, { rotation: 0, ease: Power0.easeNone }, 0
			.fromTo $leaf, 0.3, { x: -45 }, { x: -80 }, 0

			.fromTo $leaf, 0.6, { rotation: 0 }, { rotation: 25 }, 0.4
			.fromTo $leaf, 1, { x: -80 }, { x: -50 }, 0.6
			.fromTo $leaf, 0.8, { rotation: 25 }, { rotation: -5, ease: Power0.easeNone }, 0.8
			.fromTo $leaf, 0.4, { rotation: -5 }, { rotation: 5, ease: Power0.easeNone }, 1.6
			.fromTo $leaf, 0.4, { x: -50 }, { x: -62 }, 1.6

	playPreloaderAnimation = ->
		leafAnimation()
		preloaderAnimation(1.3)
		bLetterAnimation()
		lettersAnimation(2.5)
		sliderAnimation(3.5)
		headerAnimation(3.5)

	playPreloaderAnimation()
