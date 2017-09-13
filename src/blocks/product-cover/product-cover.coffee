import { TimelineMax, Power0 } from 'gsap'

$ ->
	$block = $(".product-cover")
	return unless $block.length
	$catalog = $(".catalog")

	$block.on "click", (e) ->
		$this = $(@)
		tl = new TimelineMax()
		$target = $catalog.find $this.attr("data-target")
		$staggers = $target.find '.product-params__wrapper'

		if !$this.hasClass('active')
			coverHeight = $this.outerHeight()
			tl
				.set $target.get(0), { display: 'block' }, 0
				.staggerTo $staggers, 0, { height: "auto" }, 0, 0
				.set $this.get(0), { paddingBottom: "#{coverHeight}px"}, 0
				.to $this.get(0), 0.5, { paddingBottom: "#{coverHeight + $target.outerHeight()}px", ease: Power0.easeNone }, 0
				.staggerFrom $staggers, 0.5, { height: 0, ease: Power0.easeNone  }, 0, 0
		else
			tl
				.staggerTo $staggers, 0.5, { height: 0, ease: Power0.easeNone  }, 0, 0
				.set $target.get(0), { display: 'none' }, 0.5
				.to $this.get(0), 0.5, { paddingBottom: "66%", ease: Power0.easeNone  }, 0

		$this.toggleClass 'active'
