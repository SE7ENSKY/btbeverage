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

			needCalcDuration = !isMobile()
			durationValue = 0

			offsetFunc = -> $('.about__list-item').outerHeight(true) * 0.75

			calcDuration = ->
				return durationValue unless needCalcDuration
				durationValue = Math.max($('.sequence-widget').outerHeight() -  80 - offsetFunc(), 0)
				needCalcDuration = false
				return durationValue



			$(window).on 'resize', ->
				needCalcDuration = !isMobile()
				TweenMax.set $('.sequence canvas'), { x: "-50%" }

			sequenceAnimation $elem.get(0), sequence[0], sequence[1], { finish: isFinish, offset: offsetFunc, duration: calcDuration, shiftToX: "-25vw" }

	sequenceWidgetJS()

	$(document).on 'sequence-widget', sequenceWidgetJS
