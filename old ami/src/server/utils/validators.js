const { body } = require('express-validator')
const User = require('../models/User')

// TODO: Сделать валидаторы для регистрации
exports.registerValidators = [
	body('email', 'Некорректный email')
		.isEmail()
		.custom(async (value, { req }) => {
			try {
				const user = await User.findOne({ email: value })
				if (user) return Promise.reject('Пользователь с таким Email уже существует')
			} catch (e) {
				console.log(e)
			}
		})
		.normalizeEmail(),
	body('password', 'Вы не указали пароль').exists(),
	body('name', 'Вы не указали имя').exists(),
	body('surname', 'Вы не указали фамилию').exists(),
	body('birthdate', 'Вы не указали дату рождения').exists(),
	body('weight', 'Вы не указали вес').exists(),
	body('height', 'Вы не указали рост').exists(),
]
