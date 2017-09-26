import { Scene } from 'scrollmagic'
import { TimelineMax } from 'gsap'

$ ->
	mediaWidgetJS = ->
		$block = $('.media-widget')
		return unless $block.length

		cntrl = controller.get()

		getRandomSkew = -> 100 - Math.random() * 20

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

			new Scene({
				triggerElement: $elem.get(0),
				offset: 0,
				duration: "200%"
				})
				.setTween(tl)
				.addTo(cntrl)

			#
			# Video loading
			#
			$video = $elem.find 'video'
			if $video.length
				isVideoCalled = false
				new Scene({
					triggerElement: $elem.get(0),
					offset: -200,
					})
					.on 'enter', ->
						if !isVideoCalled
							isVideoCalled = true
							$mainImage = $elem.find('.media-widget__image_main .media-widget__image-i')
							addVideo $elem, 0, ->
								tl = new TimelineMax()
								tl
									.fromTo $video.get(0), 0.5, { autoAlpha: 0 }, { autoAlpha: 1 }, 0.2
					.addTo(cntrl)

				videoPromise = videoWithPromise $video.get(0)

				new Scene({
					triggerElement: $video.parent().get(0),
					duration: "100%"
					})
					.on 'enter', ->
						$video.show(0)
						videoPromise.play()
					.on 'leave', ->
						videoPromise.pause()
						$video.hide(0)
					.addTo(cntrl)

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
