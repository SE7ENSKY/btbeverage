import { Scene } from 'scrollmagic'

$ ->

	loadImage = ($this) ->
		{ src } = $this.data()
		img = new Image()
		img.onload = ->
			$this.css 'background-image', "url(#{src})"
		img.src = src

	initLazyLoad = ->
		$imageLoad = $('.lazy-image')
		return unless $imageLoad.length

		cntrl = controller.get()

		$imageLoad.each ->
			$this = $(@)
			loadScene = new Scene({
				triggerElement: @,
				triggerHook: 1,
				offset: -200,
				})
				.addTo cntrl
				.on 'start', (ev) ->
					if ev.scrollDirection == "FORWARD"
						loadScene = loadScene.destroy()
						loadImage $this

			controller.resizeSceneActions.push ->
				loadScene.refresh() if loadScene

	initLazyLoad()

	$(document).on 'init-lazy-load', initLazyLoad
