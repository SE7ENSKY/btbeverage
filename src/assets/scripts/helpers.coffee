window.isMobile = -> window.innerWidth < 768
window.isPortrait = -> window.innerWidth <= window.innerHeight
window.getWidthVariable = ->
	w = window.innerWidth
	if w >= 768 and w < 1000
		return "tablet"
	else if w >= 1000 and w < 1220
		return "sm"
	else if w >= 1220
		return "md"
	return "mobile"
window.convertToArray = (obj) -> Object.keys(obj).map (key) -> { ...obj[key], key: key }

window.detectIE = ->
	ie = undefined
	if /MSIE 10/i.test(navigator.userAgent)
		ie = 'IE10'
	if /rv:11.0/i.test(navigator.userAgent)
		ie = 'isIE11'
	if /Edge\/\d./i.test(navigator.userAgent)
		ie = 'Microsoft Edge'
	ie

window.detectSafari = -> navigator.userAgent.indexOf('Safari') != -1 and navigator.userAgent.indexOf('Chrome') == -1
