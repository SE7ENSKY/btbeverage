import { TweenMax, Power1 } from 'gsap'

$ ->
	scrollTime = 0.5
	scrollDistance = 100

	slowScroll = (event) ->
		event.preventDefault()
		delta = event.originalEvent.wheelDelta / 120 or -event.originalEvent.detail / 3
		scrollTop = window.pageYOffset
		delta = 2 if delta > 2
		delta = -2 if delta < -2
		finalScroll = scrollTop - parseInt(delta * scrollDistance)
		TweenMax.to $(window), scrollTime,
			scrollTo:
				y: finalScroll
				autoKill: true
			ease: Power1.easeOut
			overwrite: 5

	initSlowScroll = (elem) ->
		$(elem or window).on 'touchmove mousewheel DOMMouseScroll', slowScroll

	removeSlowScroll = (elem) ->
		$(elem or window).off 'touchmove mousewheel DOMMouseScroll', slowScroll


	$(document).on 'remove-slow-scroll', removeSlowScroll
	$(document).on 'init-slow-scroll', initSlowScroll
