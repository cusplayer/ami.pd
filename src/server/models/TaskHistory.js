const { Schema, Types, model } = require('mongoose')

const taskHistorySchema = new Schema({
	userId: {
		type: Types.ObjectId,
		ref: 'User',
		required: true
	},
	title: {
		type: String,
		required: true
	},
	notifyAt: {
		type: Number,
	},
	createdAt: {
		type: Number,
		default: Date.now(),
		required: true
	}
}, { versionKey: false })

module.exports = model('TaskHistory', taskHistorySchema)
