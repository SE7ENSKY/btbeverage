import lozad from 'lozad'

$ ->
	observer = lozad();
	videoObserver = lozad '.video-lozad',
		load: (el) ->
			$this = $(el)
			{ poster, video, type } = $this.data()
			$this.attr 'poster', poster
			tempSource = document.createElement('source')
			tempSource.src = video
			tempSource.type = type
			el.appendChild tempSource

			el.addEventListener 'canplaythrough', ->
				$this.addClass 'is-loaded'

	initLazyLoad = ->
		observer.observe()
		videoWasInit = false
		if !isMobile()
			videoWasInit = true
			videoObserver.observe()

		controller.resizeSceneActions.push ->
			if !isMobile() and !videoWasInit
				videoWasInit = true
				videoObserver.observe()

	initLazyLoad()

	$(document).on 'init-lazy-load', initLazyLoad
