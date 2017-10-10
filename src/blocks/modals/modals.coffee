$ ->

	modalsJS = ->
		$block = $(".modals")
		return unless $block.length
		$modalLink = $block.find("[data-toggle='modal']")
		$closeButton = $block.find '.modal-close'
		topScrollPos = window.pageYOffset

		$('.modal').on 'shown.bs.modal', (e) ->
			topScrollPos = window.pageYOffset
			$("html, body").addClass("overflow-hidden-modal")
			$(@).addClass('overflow-hidden')
			$(document).trigger 'update-cart' if @.id == 'cart-modal'
			$(document).trigger 'remove-slow-scroll'

		$('.modal').on 'hide.bs.modal', (e) ->
			$("html, body").removeClass("overflow-hidden-modal")
			$(@).removeClass('overflow-hidden')
			window.scrollTo 0, topScrollPos
			$(document).trigger 'init-slow-scroll'

	modalsJS()

	$(document).on 'modal-init', modalsJS
