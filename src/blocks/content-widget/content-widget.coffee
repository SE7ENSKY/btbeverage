import { Scene } from 'scrollmagic'
import { TimelineMax } from 'gsap'

$ ->

	initContentWidget = ->
		$block = $('.content-widget')
		return unless $block.length

		cntrl = controller.get()

		getRandomSkew = (param) -> 80 - Math.random() * param

		yRangeImage = getRandomSkew 20
		yRangeBody = getRandomSkew 20

		$block.each ->

			$this = $(@)
			$image = $this.find '.content-widget__image'
			$body = $this.find '.content-widget__body'

			tl = new TimelineMax()
			tl
				.fromTo $image, 0.5, { y: -yRangeImage }, { y: yRangeImage }, 0
				.fromTo $body, 0.5, { y: yRangeBody }, { y: -yRangeBody }, 0

			scene = new Scene({
				triggerElement: @,
				triggerHook: 1,
				offset: 10,
				duration: '200%'
				})
				.addTo cntrl
				.setTween tl

			if isMobile()
				scene.enabled false
				tlt = new TimelineMax()
				tlt
					.set $image, { y: 0 }
					.set $body, { y: 0 }

			controller.resizeSceneActions.push ->
				if isMobile()
					scene.enabled false
					tlt = new TimelineMax()
					tlt
						.set $image, { y: 0 }
						.set $body, { y: 0 }
				else
					scene.enabled true

	initContentWidget()

	$(document).on 'init-content-widget', initContentWidget
