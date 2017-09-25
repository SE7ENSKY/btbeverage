$ ->
	sequenceJS = ->
		$block = $('.sequence')
		if !$block.length
			$(document).trigger 'sequence-loaded'
			return

		pixi.frames = []

		onPixiSetup = (loader, resources) ->
			$(document).trigger 'sequence-loaded'

			Object.keys(resources).forEach (key) ->
				pixi.frames.push resources[key].texture

			pixi.sprite = new PIXI.Sprite pixi.frames[0]
			{ width, height } = pixi.sprite.texture.orig
			realHeight = Math.max window.innerHeight, 650
			realWidth = width / height * realHeight
			pixi.sprite.height = realHeight
			pixi.sprite.width = realWidth
			pixi.sprite.anchor.set(0.5, 0.5)

			pixi.sprite.position.x = pixi.app.renderer.width / 2
			pixi.sprite.position.y = pixi.app.renderer.height / 2

			pixi.app.stage.addChild pixi.sprite

		$this = $('.sequence__seq')
		loader = new PIXI.loaders.Loader()
		loader
			.add $this.data('image')
			.load onPixiSetup

	$(document).on 'sequence-init', sequenceJS
