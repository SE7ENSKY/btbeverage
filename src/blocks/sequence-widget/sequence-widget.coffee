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

			needCalcDuration = true
			durationValue = 0

			calcDuration = ->
				return durationValue unless needCalcDuration
				durationValue = $('.sequence-widget').outerHeight() -  80
				needCalcDuration = false
				return durationValue

			$(window).on 'resize', ->
				needCalcDuration = true
				TweenMax.set $('.sequence canvas'), { x: "-50%" }

			sequenceAnimation $elem.get(0), sequence[0], sequence[1], { finish: isFinish, duration: calcDuration, shiftToX: "-25vw" }

	sequenceWidgetJS()

	$(document).on 'sequence-widget', sequenceWidgetJS
