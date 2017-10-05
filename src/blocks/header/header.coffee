import { Scene } from 'scrollmagic'

$ ->
	$(document).trigger 'updateCartBadge'

	headerFixedOnMobile = ->
		$block = $('.header')
		return unless $block.length and $block.hasClass('header_simple')

		cntrl = controller.get()

		scene = new Scene({
			triggerElement: '.main',
			triggerHook: 0,
			offset: 60
			})
			.addTo cntrl
			.on 'start', (ev) ->
				if ev.scrollDirection == 'FORWARD'
					$block.removeClass('header_simple').addClass('header_default no-padding')
				if ev.scrollDirection == 'REVERSE'
					$block.removeClass('header_default no-padding').addClass('header_simple')


		scene.enabled false unless isMobile()

		controller.resizeSceneActions.push ->
			if isMobile()
				scene.enabled true
			else
				scene.enabled false

	headerFixedOnMobile()

	$(document).on 'header-fix', headerFixedOnMobile
