import FastClick from 'fastclick';
import Modernizr from 'modernizr';
import { Controller } from 'scrollmagic'

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
	,
	resizeSceneActions: []

$ ->
	unless Modernizr.touchevents
		# replace tel: links to callto:
		$("a[href^='tel:']").each ->
			$(@).attr 'href', $(@).attr('href').replace('tel:', 'callto:')
		window.touchDevice = false
	else
		window.touchDevice = true

	if detectIE()
		$('body').addClass 'no-objectfit ie'
	else
		$('body').addClass 'no-ie'

	FastClick.attach(document.body)
	# fix for FastClick on email type
	originalSetSelectionRange = HTMLInputElement.prototype.setSelectionRange
	HTMLInputElement.prototype.setSelectionRange = ->
		try originalSetSelectionRange.apply @, arguments
		catch e then return

	$(".form-control").on 'blur', (e) ->
		$this = $(e.target)
		value = $this.val()
		if value
			$this.addClass('has-value')
		if $this.hasClass('has-value')
			$this.removeClass('has-value') unless value

	window.isResize = null
	window.addEventListener 'resize', ->
		clearTimeout(isResize) if isResize
		isResize = setTimeout ->
			isResize = null
			resizeAction() for resizeAction in controller.resizeSceneActions
			controller.get(0).update(true)
		, 200

		resizeAction() for resizeAction in controller.resizeSceneActions
		return
