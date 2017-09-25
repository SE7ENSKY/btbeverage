import FastClick from 'fastclick';
import Modernizr from 'modernizr';
import { Controller } from 'scrollmagic'
import { TweenMax, Power1 } from 'gsap'

window.controller =
	controller: null,
	get: ->
		if @.controller
			return @.controller
		@.controller = new Controller()
		return @.controller
	,
	destroy: ->
		if @.controller
			@.controller.destroy()
			@.controller = null

$ ->
	unless Modernizr.touchevents
		# replace tel: links to callto:
		$("a[href^='tel:']").each ->
			$(@).attr 'href', $(@).attr('href').replace('tel:', 'callto:')
		window.touchDevice = false
	else
		window.touchDevice = true

	FastClick.attach(document.body)

	$(".form-control").on 'blur', (e) ->
		$this = $(e.target)
		value = $this.val()
		if value
			$this.addClass('has-value')
		if $this.hasClass('has-value')
			$this.removeClass('has-value') unless value

	$window = $(window)
	scrollTime = 0.5
	scrollDistance = 130
	$window.on 'mousewheel DOMMouseScroll', (event) ->
		event.preventDefault()
		delta = event.originalEvent.wheelDelta / 120 or -event.originalEvent.detail / 3
		scrollTop = $window.scrollTop()
		delta = 2 if delta > 2
		delta = -2 if delta < -2
		finalScroll = scrollTop - parseInt(delta * scrollDistance)
		TweenMax.to $window, scrollTime,
			scrollTo:
				y: finalScroll
				autoKill: true
			ease: Power1.easeOut
			overwrite: 5
