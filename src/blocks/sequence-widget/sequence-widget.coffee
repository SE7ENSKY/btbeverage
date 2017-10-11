$ ->
	sequenceWidgetJS = ->
		$block = $('.sequence-widget')
		return unless $block.length

		$block.each ->
			$elem = $(@)

			#
			# Sequence
			#
			sequence = $elem.data('sequence')
			return unless sequence
			isFinish = $elem.data('sequence-fin')
			duration = $elem.data('sequence-duration')

			sequenceAnimation $elem.get(0), sequence[0], sequence[1], { finish: isFinish, duration: duration, shiftToX: -300 }

	sequenceWidgetJS()

	$(document).on 'sequence-widget', sequenceWidgetJS
