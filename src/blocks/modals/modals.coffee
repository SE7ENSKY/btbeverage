$ ->

	modalsJS = ->
		$block = $(".modals")
		return unless $block.length
		$modalLink = $block.find("[data-toggle='modal']")
		$closeButton = $block.find '.modal-close'

		$('.modal').on 'shown.bs.modal', (e) ->
			$("html, body").addClass("modal-open")
			$(@).addClass('overflow-hidden')
			$(document).trigger 'update-cart' if @.id == 'cart-modal'
			$(document).trigger 'remove-slow-scroll'

		$('.modal').on 'hidden.bs.modal', (e) ->
			$("body").removeClass("modal-open")
			$("html").removeClass("overflow-hidden")
			$(@).removeClass('overflow-hidden')

		$closeButton.on 'click', (e) ->
			$(document).trigger 'init-slow-scroll'

	modalsJS()

	$(document).on 'modal-init', modalsJS
