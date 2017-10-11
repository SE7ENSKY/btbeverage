$ ->
	widthRatio = 0.625 # 720 x 450

	isSequenceLoaded = false

	sequenceJS = ->
		$block = $('.sequence')
		if !$block.length or isMobile() or isPortrait() or isSequenceLoaded
			$(document).trigger 'sequence-loaded'
			$(document).trigger 'connect-pixi' if isSequenceLoaded
			return

		$(document).trigger 'connect-pixi'

		pixi.frames = []

		onPixiSetup = (loader, resources) ->
			$(document).trigger 'sequence-loaded'

			for i, item of resources.seq.textures
				pixi.frames.push(item)

			pixi.sprite = new PIXI.Sprite pixi.frames[0]
			realHeight = window.innerHeight
			realWidth = realHeight * widthRatio
			pixi.sprite.height = realHeight
			pixi.sprite.width = realWidth
			pixi.sprite.anchor.set(0.5, 0.5)

			pixi.sprite.position.x = pixi.app.renderer.width / 2
			pixi.sprite.position.y = pixi.app.renderer.height / 2

			pixi.app.stage.addChild pixi.sprite

			isSequenceLoaded = true

		loader = new PIXI.loaders.Loader()
		loader
			.add 'seq', '/assets/i/seq/btseq_sm.json'
			.load onPixiSetup

	$(document).on 'sequence-init', sequenceJS
