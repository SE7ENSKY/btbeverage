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
			pixi.sprite.height = h
			this.app.renderer.resize w, h

	document.getElementsByClassName('sequence')[0].appendChild(pixi.app.view)

	window.addEventListener 'resize', ->
		pixi.resize window.innerWidth, window.innerHeight
		if pixi.sprite
			pixi.sprite.position.x = pixi.app.renderer.width / 2;
			pixi.sprite.position.y = 0
		pixi.rerender()
