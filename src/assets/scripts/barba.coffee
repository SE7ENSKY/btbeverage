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
					.all [@.newContainerLoading]
					.then @.fadeIn.bind(@)
		fadeIn: ->
			tl = new TimelineMax()
			self = @
			onComplete = ->
				self.done()

			tl
				.fromTo @.oldContainer, 0.5, { autoAlpha: 1 }, { autoAlpha: 0, onComplete: onComplete}, 0
				.fromTo @.newContainer, 0.5, { autoAlpha: 0 }, { autoAlpha: 1 }, 0.5
	})

	Barba.Pjax.getTransition = -> HideShowTransition

	Barba.Dispatcher.on 'linkClicked', ->
		history.replaceState { sTop: window.pageYOffset }, "page1", window.location.pathname

	Barba.Dispatcher.on 'transitionCompleted', ->
		$(document).trigger 'someEvent'
