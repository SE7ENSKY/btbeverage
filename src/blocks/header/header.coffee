import { Scene } from 'scrollmagic'

$ ->
	$(document).trigger 'updateCartBadge'

	headerFixed = ->
		$block = $('.header')
		return unless $block.length and $block.hasClass('header_simple')

		cntrl = controller.get()

		scene = new Scene({
			triggerElement: '.main',
			triggerHook: 0,
			offset: $block.outerHeight()
			})
			.addTo cntrl
			.on 'start', (ev) ->
				if ev.scrollDirection == 'FORWARD'
					$block.removeClass('header_simple').addClass('header_default no-padding')
				if ev.scrollDirection == 'REVERSE'
					$block.removeClass('header_default no-padding').addClass('header_simple')

		controller.resizeSceneActions.push ->
			scene.offset $block.outerHeight()

	headerFixed()

	$(document).on 'header-fix', headerFixed
