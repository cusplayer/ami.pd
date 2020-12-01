const config = require('config')

// TODO: сделать шаблон письма
module.exports = function (email, token) {
	return {
		to: email,
		from: config.get('OUR_EMAIL'),
		subject: 'Восстановление пароля',
		html: `
		<h1>Тест восстановления пароля еп</h1>
		<a href="${config.get('BASE_URL')}/restore/${token}">Cvc</a>
		`
	}
}