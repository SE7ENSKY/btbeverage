const Cookie = {
	set(name, value, options) {
		const propOptions = { ...options };
		const { expires } = options;

		if (typeof propOptions.expires === 'number' && propOptions.expires) {
			const d = new Date();
			d.setTime(d.getTime() + (expires * 60 * 1000));
			propOptions.expires = d;
		}
		if (propOptions.expires && propOptions.expires.toUTCString) {
			propOptions.expires = propOptions.expires.toUTCString();
		}

		const updatedCookie = `${name}=${encodeURIComponent(value)};Path=/;`;

		document.cookie = Object.keys(propOptions)
			.reduce((prev, curr) => {
				const propValue = options[curr];
				const cookieValue = propValue !== true ? `=${propValue}` : '';

				return `${prev};${curr}${cookieValue}`;
			}, updatedCookie);
	},

	get(name) {
		const regexp = new RegExp(`(?:^|; )${name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1')}=([^;]*)`);
		const matches = document.cookie.match(regexp);
		return matches ? decodeURIComponent(matches[1]) : undefined;
	},

	delete(name) {
		document.cookie = `${name}=;Path=/;expires=Thu, 01 Jan 1970 00:00:01 GMT;`;
	}
};

export const getJSON = (str) => {
	try { return JSON.parse(str); } catch (e) { return null; }
};

export default Cookie;
