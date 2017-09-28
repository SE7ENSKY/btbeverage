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

window.isMobile = -> window.innerWidth < 768
window.isPortrait = -> window.innerWidth <= window.innerHeight

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

	window.addEventListener 'resize', ->
		resizeAction() for resizeAction in controller.resizeSceneActions
		return
