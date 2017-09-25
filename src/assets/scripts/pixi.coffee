$ ->
	window.pixi =
		app: new PIXI.Application
			width: window.innerWidth
			height: window.innerHeight
			transparent: true
		frames: []
		sprite: null
		rerender: ->
			this.app.renderer.render this.app.stage
		resize: (w, h)->
			{ width, height } = pixi.sprite.texture.orig
			realHeight = Math.max h, 650
			realWidth = width / height * realHeight
			pixi.sprite.height = realHeight
			pixi.sprite.width = realWidth
			this.app.renderer.resize w, h

	document.getElementsByClassName('sequence')[0].appendChild(pixi.app.view)

	window.addEventListener 'resize', ->
		pixi.resize window.innerWidth, window.innerHeight
		if pixi.sprite
			pixi.sprite.position.x = pixi.app.renderer.width / 2;
			pixi.sprite.position.y = pixi.app.renderer.height / 2;
		pixi.rerender()
