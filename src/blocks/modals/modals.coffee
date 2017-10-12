$ ->

	modalsJS = ->
		$block = $(".modals")
		return unless $block.length
		$modalLink = $block.find("[data-toggle='modal']")
		$closeButton = $block.find '.modal-close'
		topScrollPos = window.pageYOffset
		wasSlowScroll = false

		$('.modal').on 'shown.bs.modal', (e) ->
			topScrollPos = window.pageYOffset
			self = @

			onComplete = ->
				$(self).addClass('overflow-hidden')
				$('body').addClass('overflow-hidden-modal')
				$(document).trigger 'update-cart' if self.id == 'cart-modal'
				if isSlowScroll
					$(document).trigger 'remove-slow-scroll'
					wasSlowScroll = true

			if isMobile()
				$('.main').css 'opacity', 0
				$('html, body').animate
					scrollTop: 0
				, 50, ->
					$('.main').css 'opacity', 'initial'
					$("html").addClass("overflow-hidden-modal")
					onComplete()
			else
				onComplete()

		$('.modal').on 'hidden.bs.modal', (e) ->
			$("body").removeClass("overflow-hidden-modal")

		$('.modal').on 'hide.bs.modal', (e) ->
			if isMobile()
				$("html").removeClass("overflow-hidden-modal")
				window.scrollTo(0, topScrollPos)
			$(@).removeClass('overflow-hidden')

			if wasSlowScroll
			# 	$(document).trigger 'init-slow-scroll'
				wasSlowScroll = false
				setTimeout ->
					$(document).trigger 'init-slow-scroll'
				, 50

	modalsJS()

	$(document).on 'modal-init', modalsJS
