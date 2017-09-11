import { TimelineMax, TweenMax, Power2, Circ } from 'gsap'

$ ->
	$block = $(".intro")
	return unless $block.length

	_video = $block.find("video").get(0)
	$(_video).attr "controls", "true" if touchDevice
	# setTimeout ->
	# 	_video.play()
	# , 20

	lettersAnimation = ->
		tl = new TimelineMax()

		tl
			.fromTo '.intro__logo-s_b', 0.4, { autoAlpha: 0, y: -40 }, { autoAlpha: 1, y: 0 } , 0
			.fromTo '.intro__logo-s_line', 0.4, { autoAlpha: 0, y: -40 }, { autoAlpha: 1, y: 0, ease: Power2.easeOut }, 0.1
			.fromTo '.intro__logo-s_t', 0.4, { autoAlpha: 0, y: -40 }, { autoAlpha: 1, y: 0, ease: Power2.easeOut }, 0.15
			.fromTo '.intro__logo-s_e', 0.4, { autoAlpha: 0, y: -40 }, { autoAlpha: 1, y: 0, ease: Power2.easeOut }, 0.2
			.fromTo '.intro__logo-s_a', 0.4, { autoAlpha: 0, y: -40 }, { autoAlpha: 1, y: 0, ease: Power2.easeOut }, 0.25

	sliderAnimation = ->
		tl = new TimelineMax()

		tl
			.fromTo '.intro__more .stop-3', 0.5, { attr: { offset: "0%" } }, { attr: { offset: "100%" } }, 0
			.fromTo '.intro__more .stop-2', 0.5, { attr: { offset: "0%" } }, { attr: { offset: "100%" } }, 0.2
			.fromTo '.intro__more .stop-1', 0.5, { attr: { offset: "0%" } }, { attr: { offset: "100%" } }, 0.4

	headerAnimation = ->
		tl = new TimelineMax()

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

	setTimeout ->
		lettersAnimation()
		sliderAnimation()
		leafAnimation()
	, 1000
