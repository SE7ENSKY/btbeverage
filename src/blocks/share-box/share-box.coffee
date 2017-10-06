$ ->

	resetAddThis = ->
		$block = $('.share-box')
		return unless $block.length

		addthis.layers.refresh()

	$(document).on 'reset-addthis', resetAddThis
