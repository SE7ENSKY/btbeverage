import { TimelineMax, Power0 } from 'gsap'

$ ->
	$block = $(".product-cover")
	return unless $block.length
	$catalog = $(".catalog")

	$block.on "click", (e) ->
		$this = $(@)
		tl = new TimelineMax()
		$target = $catalog.find($this.attr("data-target"))
		$targetInner = $target.find('.product-params__inner')

		if !$this.hasClass('active')
			coverHeight = $this.innerHeight()
			tl
				.fromTo $target.get(0), 0.5, { height: 0 }, { height: $targetInner.outerHeight(),ease: Power0.easeNone  }, 0
				.fromTo $this.get(0), 0.5, { paddingBottom: "#{0.33 * window.innerWidth}px" }, { paddingBottom: "#{100 + $targetInner.outerHeight()}px", ease: Power0.easeNone }, 0
		else
			tl
				.to $target.get(0), 0.5, { height: 0 }, 0
				.to $this.get(0), 0.5, { paddingBottom: "#{0.33 * window.innerWidth}px" , ease: Power0.easeNone  }, 0

		$this.toggleClass 'active'
