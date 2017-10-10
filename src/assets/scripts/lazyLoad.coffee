import lozad from 'lozad'

$ ->
	observer = lozad();
	videoObserver = lozad '.video-lozad',
		load: (el) ->
			$this = $(el)
			{ poster } = $this.data()
			$this.attr 'poster', poster

	initLazyLoad = ->
		observer.observe()
		videoObserver.observe()

	initLazyLoad()

	$(document).on 'init-lazy-load', initLazyLoad
