import { Controller, Scene } from 'scrollmagic'

$ ->
	$block = $('.catalog')
	return unless $block.length

	controller = new Controller()

	new Scene({
			triggerElement: $block.get(0),
			triggerHook: 1
		})
		.addTo(controller)
		.on 'start', (ev) ->
			if ev.scrollDirection == 'FORWARD'
				$block.addClass 'skewed'
			else
				$block.removeClass 'skewed'
