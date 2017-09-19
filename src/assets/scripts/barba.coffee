import Barba from 'barba.js'
import { TimelineMax } from 'gsap'

$ ->
	console.log 'initBarba'
	Barba.Pjax.start()

	windowScroll = ->
		return unless window.history
		if !history.state
			window.scrollTo 0, 0
		else
			window.scrollTo 0, history.state.sTop

	HideShowTransition = Barba.BaseTransition.extend({
		start: ->
			Promise
					.all [@.newContainerLoading, @.fadeOut()]
					.then @.fadeIn.bind(@)
		fadeOut: -> new Promise (resolve) ->
				$(document).trigger 'intro-remove'
				$(document).trigger 'taste-button-remove'
				$(document).trigger 'content-heading-remove'
				$(document).trigger 'catalog-remove'
				$(document).trigger 'about-block-remove'
				$('body').css 'overflow', ''
				resolve()
		fadeIn: ->
			tl = new TimelineMax()
			self = @
			onComplete = ->
				self.done()
				windowScroll()

			tl
				.fromTo @.oldContainer, 0.5, { autoAlpha: 1 }, { autoAlpha: 0, onComplete: onComplete }, 0
				.fromTo @.newContainer, 0.5, { autoAlpha: 0 }, { autoAlpha: 1 }, 0.5
	})

	Barba.Pjax.getTransition = -> HideShowTransition

	Barba.Dispatcher.on 'linkClicked', ->
		history.replaceState { sTop: window.pageYOffset }, "page1", window.location.pathname

	Barba.Dispatcher.on 'transitionCompleted', ->
		$(document).trigger 'about-block'
		$(document).trigger 'catalog'
		$(document).trigger 'content-heading'
		$(document).trigger 'gallery'
		$(document).trigger 'media-widget'
		$(document).trigger 'taste-button'
		$(document).trigger 'product-cover'
		$(document).trigger 'product-params'
		$(document).trigger 'payment-chooser'
		$(document).trigger 'sequence-init'
		$(document).trigger 'intro'
