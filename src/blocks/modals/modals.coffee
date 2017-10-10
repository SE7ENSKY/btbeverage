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
					$("html, body").addClass("overflow-hidden-modal")
					onComplete()
			else
				onComplete()

		$('.modal').on 'hide.bs.modal', (e) ->
			$("html, body").removeClass("overflow-hidden-modal")
			$(@).removeClass('overflow-hidden')
			window.scrollTo 0, topScrollPos
			if wasSlowScroll
				$(document).trigger 'init-slow-scroll'
				wasSlowScroll = false

	modalsJS()

	$(document).on 'modal-init', modalsJS
