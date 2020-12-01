const { Schema, model } = require('mongoose')

const articleSchema = new Schema({
	title: {
		type: String,
		required: true
	},
	content: {
		type: String,
		required: true
	},
	createdAt: {
		type: Number,
		default: Date.now(),
		required: true
	}
}, { versionKey: false })

module.exports = model('Article', articleSchema)
