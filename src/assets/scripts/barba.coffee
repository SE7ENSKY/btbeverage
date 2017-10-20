import FastClick from 'fastclick'
import Barba from 'barba.js'
import { TimelineMax, TweenMax, Power1 } from 'gsap'

$ ->
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
				controller.destroy()
				controller.resizeSceneActions.length = 0
				$(document).trigger 'remove-slow-scroll'
				$('html, body').removeClass 'overflow-hidden'
				$('.header').removeClass 'no-padding'
				$('body'). removeClass 'bg-white'
				resolve()
		fadeIn: ->
			tl = new TimelineMax()
			oldPageHeaderClasses = $(@.oldContainer).data('header-classes').join(' ')
			newPageHeaderClasses = $(@.newContainer).data('header-classes').join(' ')
			self = @
			newBodyClass = $(self.newContainer).data('body-class')

			onComplete = ->
				self.done()
				windowScroll()

				$('body').addClass newBodyClass.join(" ") if newBodyClass

				if oldPageHeaderClasses != newPageHeaderClasses
					$('.header').removeClass(oldPageHeaderClasses).addClass(newPageHeaderClasses)

			tl
				.fromTo @.oldContainer, 0.5, { autoAlpha: 1 }, { autoAlpha: 0, onComplete: onComplete }, 0
				.fromTo @.newContainer, 0.5, { autoAlpha: 0 }, { autoAlpha: 1 }, 0.5
	})

	Barba.Pjax.originalPreventCheck = Barba.Pjax.preventCheck

	Barba.Pjax.preventCheck = (evt, element) ->
		href = $(element).attr('href')
		linkWithHash = href && href.indexOf('#') > -1
		data = $(element).data()
		# if special scroll2id is set - jump to it
		if data and data.id and $("##{data.id}").length
			evt.preventDefault()
			window.scrollTo 0, $("##{data.id}").offset().top - $('.header').outerHeight()
			return false
		# prevent all actions if we are on the same page
		if window.location.pathname == href
			evt.preventDefault()
			return false
		# analyze hash action
		if linkWithHash
			pos = href.indexOf('#')
			if pos == 0
				return false
			else if (window.location.pathname == href.substring(0, pos))
				return false
			else
				return true
		else
			return Barba.Pjax.originalPreventCheck(evt, element)

	Barba.Pjax.getTransition = -> HideShowTransition

	Barba.Dispatcher.on 'linkClicked', ->
		history.replaceState { sTop: window.pageYOffset }, "page1", window.location.pathname

	Barba.Dispatcher.on 'transitionCompleted', ->
		FastClick.attach(document.body)
		$(document).trigger 'init-lazy-load'
		$(document).trigger 'catalog-init'
		$(document).trigger 'about-block'
		$(document).trigger 'content-heading'
		$(document).trigger 'gallery'
		$(document).trigger 'sequence-widget'
		$(document).trigger 'taste-button'
		$(document).trigger 'product-cover'
		$(document).trigger 'product-params'
		$(document).trigger 'payment-chooser'
		$(document).trigger 'intro'
		$(document).trigger 'update-cart'
		$(document).trigger 'modal-init'
		$(document).trigger 'header-fix'
		$(document).trigger 'reset-addthis'
		$(document).trigger 'init-content-widget'
		$(document).trigger 'init-product-page'
