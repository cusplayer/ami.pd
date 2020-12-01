const sendgrid = require('nodemailer-sendgrid-transport')
const { validationResult } = require('express-validator')
const nodemailer = require('nodemailer')
const { Router } = require('express')
const jwt = require('jsonwebtoken')
const config = require('config')
const crypto = require('crypto')

const { registerValidators } = require('../utils/validators')
const registrationEmail = require('../emails/registration')
const WeigthHistory = require('../models/WeightHistory')
const restoreEmail = require('../emails/restore')
const User = require('../models/User')

const router = Router()
const transporter = nodemailer.createTransport(sendgrid({ auth: { api_key: config.get('SENDGRID_API_KEY') } }))

// api/auth/login
router.post('/login', async (req, res) => {
	try {
		const { email, password, appleId, vkId } = req.body

		if (email && password) {
			const candidate = await User.findOne({ email })

			if (candidate) {
				if (password === candidate.password) {
					const accessToken = jwt.sign({ userId: candidate._id }, config.get('JWT_SECRET'), { expiresIn: '30d' })
					return res.status(200).json({ accessToken, user: candidate })
				} else {
					return res.status(400).json({ message: 'Неверный пароль' })
				}
			} else {
				return res.status(400).json({ message: 'Пользователь с таким Email не найден' })
			}
		} else if (appleId) {
			const candidate = await User.findOne({ appleId })

			if (candidate) {
				const accessToken = jwt.sign({ userId: candidate._id }, config.get('JWT_SECRET'), { expiresIn: '30d' })
				return res.status(200).json({ accessToken, user: candidate })
			} else {
				return res.status(400).json({ message: 'Пользователь с таким appleId не найден' })
			}
		} else if (vkId) {
			const candidate = await User.findOne({ vkId })

			if (candidate) {
				const accessToken = jwt.sign({ userId: candidate._id }, config.get('JWT_SECRET'), { expiresIn: '30d' })
				return res.status(200).json({ accessToken, user: candidate })
			} else {
				return res.status(400).json({ message: 'Пользователь с таким vkId не найден' })
			}
		} else {
			return res.status(400).json({ message: 'Данные некорректны' })
		}

	} catch (e) {
		console.log(e)
		return res.status(500).json({ message: 'Что-то пошло не так, попробуйте позже' })
	}
})

// api/auth/register
router.post('/register', registerValidators, async (req, res) => {
	try {
		const errors = validationResult(req)
		if (!errors.isEmpty()) return res.status(400).json({ message: errors.array()[0].msg })

		const { email, password, name, surname, birthdate, weight, height, appleId, vkId } = req.body

		const user = new User({ email, password, name, surname, birthdate, height, appleId, vkId })
		await user.save()

		const newUser = await User.findOne({ email })
		const weigthHistory = new WeigthHistory({ userId: newUser._id, amount: weight })
		await weigthHistory.save()

		const accessToken = jwt.sign({ userId: newUser._id }, config.get('JWT_SECRET'), { expiresIn: '30d' })

		await transporter.sendMail(registrationEmail(email))
		res.status(201).json({ accessToken, user: newUser })
	} catch (e) {
		console.log(e)
		return res.status(500).json({ message: 'Что-то пошло не так, попробуйте позже' })
	}
})

// api/auth/restore
router.post('/restore', (req, res) => {
	try {
		crypto.randomBytes(32, async (err, buffer) => {
			if (err) {
				return res.status(500).json({ message: 'Что-то пошло не так, попробуйте позже' })
			}

			const token = buffer.toString('hex')
			const candidate = await User.findOne({ email: req.body.email })

			if (candidate) {
				candidate.restoreToken = token
				candidate.restoreTokenExp = Date.now() + 3600 * 1000
				await candidate.save()
				await transporter.sendMail(restoreEmail(candidate.email, token))
				res.status(200).json({ message: `Ссылка для восстановления пароля была отправлена на ${candidate.email}` })
			} else {
				return res.status(400).json({ message: 'Пользователь с таким Email не найден' })
			}
		})
	} catch (e) {
		console.log(e)
		return res.status(500).json({ message: 'Что-то пошло не так, попробуйте позже' })
	}
})

// api/auth/restore/:token
router.get('/restore/:token', async (req, res) => {
	try {
		if (!req.params.token) return res.status(400).json()

		const user = await User.findOne({
			restoreToken: req.params.token,
			restoreTokenExp: { $gt: Date.now() }
		})

		if (!user) {
			return res.status(400).json()
		} else {
			return res.status(200).json({
				userId: user._id.toString(),
				token: req.params.token
			})
		}
	} catch (e) {
		console.log(e)
		return res.status(500).json({ message: 'Что-то пошло не так, попробуйте позже' })
	}
})

// api/auth/restore/:token
router.post('/restore/:token', async (req, res) => {
	try {
		const user = await User.findOne({
			_id: req.body.userId.toString(),
			restoreToken: req.body.token,
			restoreTokenExp: { $gt: Date.now() }
		})

		if (user) {
			user.password = req.body.password
			user.restoreToken = undefined
			user.restoreTokenExp = undefined
			await user.save()

			return res.status(200).json({ message: 'Пароль изменен' })
		} else {
			return res.status(400).json({ message: 'Время жизни токена истекло, попробуйте еще раз' })
		}
	} catch (e) {
		console.log(e)
		return res.status(500).json({ message: 'Что-то пошло не так, попробуйте позже' })
	}
})

module.exports = router