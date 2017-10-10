$ ->

	modalsJS = ->
		$block = $(".modals")
		return unless $block.length
		$modalLink = $block.find("[data-toggle='modal']")
		$closeButton = $block.find '.modal-close'
		topScrollPos = window.pageYOffset

		$('.modal').on 'shown.bs.modal', (e) ->
			topScrollPos = window.pageYOffset
			self = @

			onComplete = ->
				$("html, body").addClass("overflow-hidden-modal")
				$(self).addClass('overflow-hidden')
				$(document).trigger 'update-cart' if self.id == 'cart-modal'

			if isMobile()
				$('.main').css 'opacity', 0
				$('html, body').animate
					scrollTop: 0
				, 50, ->
					$('.main').css 'opacity', 'initial'
					onComplete()
			else
				onComplete

		$('.modal').on 'hide.bs.modal', (e) ->
			$("html, body").removeClass("overflow-hidden-modal")
			$(@).removeClass('overflow-hidden')
			window.scrollTo 0, topScrollPos

	modalsJS()

	$(document).on 'modal-init', modalsJS
