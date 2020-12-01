const TaskHistory = require('../models/TaskHistory')
const auth = require('../middleware/auth.middleware')
const { Router } = require('express')

const router = Router()

router.get('/', auth, async (req, res) => {
	try {
		const taskHistory = await TaskHistory.find({ userId: req.user.userId }).select('title notifyAt createdAt')

		res.status(200).json(taskHistory)
	} catch (e) {
		console.log(e)
		return res.status(500).json({ message: 'Что-то пошло не так, попробуйте позже' })
	}
})
router.post('/', auth, async (req, res) => {
	try {
		const { title, notifyAt, createdAt } = req.body

		const taskHistory = new TaskHistory({
			userId: req.user.userId,
			title,
			notifyAt,
			createdAt
		})
		await taskHistory.save()

		delete taskHistory._doc.userId
		res.status(201).json(taskHistory)
	} catch (e) {
		console.log(e)
		return res.status(500).json({ message: 'Что-то пошло не так, попробуйте позже' })
	}
})

router.put('/:id', auth, async (req, res) => {
	try {
		const { title, notifyAt, createdAt } = req.body

		const taskHistory = await TaskHistory.findOne({
			_id: req.params.id,
			userId: req.user.userId
		}, (err) => {
			if (err) return res.status(404).json({ message: 'Объект с данным ID не найден' })
		}).select('title notifyAt createdAt')

		taskHistory.title = title || taskHistory.title
		taskHistory.notifyAt = notifyAt || taskHistory.notifyAt
		taskHistory.createdAt = createdAt || taskHistory.createdAt

		await taskHistory.save()

		res.status(200).json(taskHistory)
	} catch (e) {
		console.log(e)
		return res.status(500).json({ message: 'Что-то пошло не так, попробуйте позже' })
	}
})

router.delete('/:id', auth, async (req, res) => {
	try {
		await TaskHistory.deleteOne({
			_id: req.params.id,
			userId: req.user.userId
		}, (err) => {
			if (err) return res.status(404).json({ message: 'Объект с данным ID не найден' })
		})

		res.status(200).json({ message: "Успешно" })
	} catch (e) {
		console.log(e)
		return res.status(500).json({ message: 'Что-то пошло не так, попробуйте позже' })
	}
})

module.exports = router