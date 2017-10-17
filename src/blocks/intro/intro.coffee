import { TimelineMax, TweenMax, Power2, Power1, Sine } from 'gsap'
import { Scene } from 'scrollmagic';

$ ->
	introScrollScene = []
	isSequenceLoaded = false
	sliderAnimationOver = false

	window.isPreloaderPlayedBefore = false

	introJS = ->
		$block = $(".intro")
		return unless $block.length
		window.scrollTo 0, 0
		#
		# handle logo SVG animation on IE/Edge
		#

		if !detectIE()
			$('.intro__logo').addClass 'not-ie'

		#
		# init background Video
		#

		$video = $block.find('video')
		videoPromise = videoWithPromise $video.get(0)

		cntrl = controller.get()
		backgroundVideo = new Scene({
			triggerElement: $block.get(0)
			triggerHook: 0,
			offset: 200,
			duration: if window.innerHeight >= 420 then "100%" else 420
			})
			.on 'leave', (event) ->
				return unless $video.length
				{ scrollDirection } = event
				if scrollDirection == "FORWARD"
					videoPromise.pause()
					$video.hide(0)
			.on 'enter', (event) ->
				return unless $video.length
				{ scrollDirection } = event
				if scrollDirection == "REVERSE"
					$video.show(0)
					videoPromise.play()
			.addTo(cntrl)

		backgroundVideo.enabled false if isMobile()

		controller.resizeSceneActions.push ->
			backgroundVideo.duration(if window.innerHeight >= 420 then "100%" else 420)
			$block.find('video').show(0)
			if isMobile()
				backgroundVideo.enabled false
			else
				backgroundVideo.enabled true

		#
		# set basic configs
		#
		isSequenceLoaded = false
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
			if $('.intro__logo').hasClass 'not-ie'
				setTimeout ->
					$('.intro__logo').addClass 'active'
				, startTime * 1000

		lettersAnimation = (startTime) ->
			return unless $('.intro__logo').hasClass 'not-ie'
			tl = new TimelineMax()
			tl
				.fromTo '.intro__logo-s_b', 0.5, { autoAlpha: 0, y: -40 }, { autoAlpha: 1, y: 0, ease: Power2.easeOut } , startTime
				.fromTo '.intro__logo-s_line', 0.5, { autoAlpha: 0, y: -40 }, { autoAlpha: 1, y: 0, ease: Power2.easeOut },  startTime + 0.1
				.fromTo '.intro__logo-s_t', 0.5, { autoAlpha: 0, y: -40 }, { autoAlpha: 1, y: 0, ease: Power2.easeOut }, startTime + 0.15
				.fromTo '.intro__logo-s_e', 0.5, { autoAlpha: 0, y: -40 }, { autoAlpha: 1, y: 0, ease: Power2.easeOut }, startTime + 0.2
				.fromTo '.intro__logo-s_a', 0.5, { autoAlpha: 0, y: -40 }, { autoAlpha: 1, y: 0, ease: Power2.easeOut }, startTime + 0.25

		sliderAnimation = (startTime) ->
			tl = new TimelineMax()
			tl1 = new TimelineMax()
			delay = startTime + 1
			tl
				.set '.intro__more', { autoAlpha: 0 }
				.to '.intro__more', 0.5, { autoAlpha: 1 }, startTime

			setTimeout ->
				tl1
					.set '.intro__more .stop-3', { attr: { offset: "0%" } }, 0
					.set '.intro__more .stop-2', { attr: { offset: "0%" } }, 0
					.set '.intro__more .stop-1', { attr: { offset: "0%" } }, 0
					.to '.intro__more .stop-3', 0.5, { attr: { offset: "100%" } }, 0
					.to '.intro__more .stop-2', 0.5, { attr: { offset: "100%" } }, 0.2
					.to '.intro__more .stop-1', 0.5, { attr: { offset: "100%" } }, 0.4
					.repeat(-1)
					.repeatDelay(2)
			, (startTime + 1) * 1000

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
						y: "-100%",
						ease: Power1.easeOut
					, 0
				.fromTo $leaf, 0.8, { rotation: -90 }, { rotation: 25 }, 0
				.fromTo $leaf, 0.8, { x: "-50%" }, { x: "-53%" }, 0
				.to $leaf, 0.6, { x: "-45%" }, 0.8
				.to $leaf, 0.4, { rotation: -5 }, 1
				.to $leaf, 0.6, { rotation: 0 }, 1.6
				.to $leaf, 0.6, { x: "-50%" }, 1.6

		leafScrollAnimation = ->
			basicConfig =
				rotation: 0,
				x: "-50%",
				y: "-100%",
				scale: 1

			hideTween =
				TweenMax.fromTo $leaf, 0.5,
					rotation: 60,
					autoAlpha: 1,
					scale: 1.15
						rotation: 30,
						autoAlpha: 0,
						overwrite: 'allOnStart',
						ease: Sine.easeIn
						scale: 1.15

			tween =
				TweenMax.fromTo $leaf, 0.5, basicConfig,
					rotation: 60,
					x: -25,
					y: -35,
					scale: 1.15,
					ease: Power1.easeIn
					overwrite: 'allOnStart'

			scrollScene = null

			new Scene({
					offset: 0
					duration: "80%"
				})
				.setTween(tween)
				.addTo(cntrl)

			needUpdateDuration = true
			duration = 0
			calcDuration = ->
				return duration unless needUpdateDuration
				duration = if isMobile() then "30%" else "50%"
				needUpdateDuration = false
				return duration

			leafHideScene = new Scene({
					offset: window.innerHeight * 0.8,
					duration: calcDuration,
				})
				.setTween(hideTween)
				.addTo(cntrl)
				.on 'leave', (ev) ->
					$leaf.hide(0) if ev.scrollDirection == "FORWARD"
				.on 'enter', (ev) ->
					$leaf.show(0) if ev.scrollDirection == "REVERSE"

			controller.resizeSceneActions.push ->
				leafHideScene
					.offset(window.innerHeight * 0.8)
				needUpdateDuration = true

		#
		# video add callback
		#

		addVideoCallback = ->
			$(document).trigger 'sequence-init'

		#
		# Combine animation func
		#

		startAnimation = ->
			$leaf.show(0)
			# preloader animation
			leafPreloaderAnimation()
			preloaderBgAnimation 2
			bLetterAnimation 2.2
			lettersAnimation 2.7
			headerAnimation 3.7
			sliderAnimation 3.7
			$('html, body').addClass 'overflow-hidden'
			setTimeout ->
				if isSequenceLoaded
					$('html, body').removeClass 'overflow-hidden'
					$(document).trigger 'init-slow-scroll'
					scrollToHash()
				sliderAnimationOver = true
				if isMobile()
					$(document).trigger 'sequence-init'
				else
					addVideo $block, 0, addVideoCallback
			, 5000
			window.isPreloaderPlayedBefore = true

		if window.isPreloaderPlayedBefore
			$leaf.show(0)
			$('html, body').addClass 'overflow-hidden'
			sliderAnimationOver = true
			$('.intro__preloader').hide(0)
			$('.intro__logo').addClass 'done'
			addVideo $block, 0, addVideoCallback
		else
			startAnimation()

		leafScrollAnimation()

	#
	# scroll to element with id if location.hash exists
	# after scrolling is available
	#

	scrollToHash = ->
		hash = location.hash
		location.hash = ''
		location.hash = hash if hash
		$product = $('.catalog').find(hash)
		return unless $product.length

		$(document).trigger 'catalog-handle-hash', [ $product ]

	#
	# handle when sequence is loaded
	#

	handleSequenceLoad = ->
		isSequenceLoaded = true
		$('.intro__more text').text 'Scroll to discover'
		if sliderAnimationOver
			$('html, body').removeClass 'overflow-hidden'
			$(document).trigger 'init-slow-scroll'

			scrollToHash()

	introJS()

	$(document).on 'intro', introJS
	$(document).on 'sequence-loaded', handleSequenceLoad
