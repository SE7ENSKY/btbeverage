$ ->

	modalsJS = ->
		$block = $(".modals")
		return unless $block.length
		$modalLink = $block.find("[data-toggle='modal']")
		$closeButton = $block.find '.modal-close'

		$modalLink.on "click", (e) ->
			setTimeout ->
				$("body").addClass("modal-open")
			, 400



		$('.modal').on 'shown.bs.modal', (e) ->
			$(document).trigger 'update-cart-modal' if @.id == 'cart-modal'
			$(document).trigger 'remove-slow-scroll'

		$closeButton.on 'click', (e) ->
			$(document).trigger 'init-slow-scroll'

	modalsJS()

	$(document).on 'modal-init', modalsJS
