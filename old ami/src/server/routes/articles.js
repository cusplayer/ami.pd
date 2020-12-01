const Article = require('../models/Article')
const auth = require('../middleware/auth.middleware')
const { Router } = require('express')

const router = Router()

router.get('/', async (req, res) => {
	try {
		const articles = await Article.find()

		res.status(200).json(articles)

	} catch (e) {
		console.log(e)
		return res.status(500).json({ message: 'Что-то пошло не так, попробуйте позже' })
	}
})
router.get('/:id', async (req, res) => {
	try {
		const article = await Article.findById(req.params.id)

		res.status(200).json(article)

	} catch (e) {
		console.log(e)
		return res.status(500).json({ message: 'Что-то пошло не так, попробуйте позже' })
	}
})

router.post('/', auth, async (req, res) => {
	try {
		const { title, content } = req.body

		const article = new Article({ title, content })
		await article.save()

		res.status(201).json({ article })

	} catch (e) {
		console.log(e)
		return res.status(500).json({ message: 'Что-то пошло не так, попробуйте позже' })
	}
})

module.exports = router