const WaterHistory = require('../models/WaterHistory')
const auth = require('../middleware/auth.middleware')
const { Router } = require('express')

const router = Router()

router.get('/', auth, async (req, res) => {
	try {
		const waterHistory = await WaterHistory.find({ userId: req.user.userId }).select('_id amount drinkedAt')
		res.status(200).json(waterHistory)
	} catch (e) {
		console.log(e)
		return res.status(500).json({ message: 'Что-то пошло не так, попробуйте позже' })
	}
})

router.post('/', auth, async (req, res) => {
	try {
		const { amount, drinkedAt } = req.body

		const waterHistory = new WaterHistory({
			userId: req.user.userId,
			amount,
			drinkedAt
		})
		await waterHistory.save()

		delete waterHistory._doc.userId
		res.status(201).json({
			...waterHistory._doc
		})
	} catch (e) {
		console.log(e)
		return res.status(500).json({ message: 'Что-то пошло не так, попробуйте позже' })
	}
})

router.put('/:id', auth, async (req, res) => {
	try {
		const { amount, drinkedAt } = req.body

		const waterHistory = await WaterHistory.findOne({
			_id: req.params.id,
			userId: req.user.userId
		}, (err) => {
			if (err) return res.status(404).json({ message: 'Объект с данным ID не найден' })
		}).select('amount drinkedAt')

		if (!waterHistory) return res.status(404).json({ message: 'Объект с данным ID не найден' })

		waterHistory.amount = amount || waterHistory.amount
		waterHistory.drinkedAt = drinkedAt || waterHistory.drinkedAt

		await waterHistory.save()

		res.status(200).json({
			...waterHistory._doc
		})
	} catch (e) {
		console.log(e)
		return res.status(500).json({ message: 'Что-то пошло не так, попробуйте позже' })
	}
})

router.delete('/:id', auth, async (req, res) => {
	try {

		await WaterHistory.deleteOne({ _id: req.params.id }, (err) => {
			if (err) return res.status(404).json({ message: 'Объект с данным ID не найден' })
		})

		res.status(200).json({ message: "Успешно" })
	} catch (e) {
		console.log(e)
		return res.status(500).json({ message: 'Что-то пошло не так, попробуйте позже' })
	}
})

module.exports = router