import { Controller, Scene } from 'scrollmagic'
import { TimelineMax } from 'gsap'

$ ->
	mediaWidgetJS = ->
		$block = $('.media-widget')
		return unless $block.length

		controller = new Controller()

		getRandomSkew = -> 100 - Math.random() * 20

		#
		# Video
		#

		window.addEventListener 'load', ->
			$block.each ->
				addVideo $(@)

		#
		# Animation
		#

		$block.each ->
			$elem = $(@)

			$contentBg = $elem.find '.media-widget__content-bg'
			$mainImage = $elem.find '.media-widget__image_main .media-widget__image-i'
			$secondImage = $elem.find '.media-widget__image_add .media-widget__image-i'

			contentBlockHeight = $elem.find('.media-widget__content').outerHeight()

			yRangeMain = getRandomSkew()
			yRangeSecond = getRandomSkew()

			tl = new TimelineMax()
			tl
				.fromTo $contentBg, 0.5, { height: "60%" }, { height: "140%" }, 0
				.fromTo $mainImage, 0.5, { y: -yRangeMain }, { y: yRangeMain }, 0
				# .fromTo $secondImage, 0.5, { y: -yRangeSecond }, { y: yRangeSecond }, 0

			new Scene({
				triggerElement: $elem.get(0),
				offset: 0,
				duration: "200%"
				})
				.setTween(tl)
				.addTo(controller)

			#
			# Sequence
			#
			sequence = $elem.data('sequence')
			return if !sequence
			isFinish = $elem.data('sequence-fin')
			duration = $elem.data('sequence-duration')

			sequenceAnimation $elem.get(0), sequence[0], sequence[1], { finish: isFinish, duration: duration }

	mediaWidgetJS()

	$(document).on 'media-widget', mediaWidgetJS
