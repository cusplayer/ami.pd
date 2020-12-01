const { Schema, Types, model } = require('mongoose')

const weightHistorySchema = new Schema({
	userId: {
		type: Types.ObjectId,
		ref: 'User',
		required: true
	},
	amount: {
		type: Number,
		required: true
	},
	weighedAt: {
		type: Number,
		default: Date.now(),
		required: true
	}
}, { versionKey: false })

module.exports = model('WeightHistory', weightHistorySchema)
