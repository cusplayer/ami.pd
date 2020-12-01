const config = require('config')

// TODO: сделать шаблон письма
module.exports = function (email) {
	return {
		to: email,
		from: config.get('OUR_EMAIL'),
		subject: 'Аккаунт создан',
		html: `
		<h1>Тест письма</h1>
		`
	}
}