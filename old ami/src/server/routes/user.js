const { Router } = require('express')
const User = require('../models/User')
const auth = require('../middleware/auth.middleware')

const router = Router()


// /api/user
router.get('/', auth, async (req, res) => {
	try {
		const user = await User.findById(req.user.userId)
		if (!user) return res.status(404).json({ message: "Пользователь не найден" })

		delete user._doc.password
		return res.status(200).json({
			...user._doc,
		})
	} catch (e) {
		console.log(e)
		return res.status(500).json({ message: 'Что-то пошло не так, попробуйте позже' })
	}
})
router.put('/', auth, async (req, res) => {
	try {
		const { email, password, name, surname, birthdate, height, appleId, vkId } = req.body

		const user = await User.findById(req.user.userId)

		if (!user) return res.status(404).json({ message: "Пользователь не найден" })

		user.email = email || user.email
		user.password = password || user.password
		user.name = name || user.name
		user.surname = surname || user.surname
		user.birthdate = birthdate || user.birthdate
		user.height = height || user.height
		user.appleId = appleId || user.appleId
		user.vkId = vkId || user.vkId

		await user.save()

		delete user._doc.password
		return res.status(200).json({
			...user._doc,
		})
	} catch (e) {
		console.log(e)
		return res.status(500).json({ message: 'Что-то пошло не так, попробуйте позже' })
	}
})

module.exports = router