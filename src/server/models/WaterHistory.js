const { Schema, Types, model } = require('mongoose')

const waterHistorySchema = new Schema({
	userId: {
		type: Types.ObjectId,
		ref: 'User',
		required: true
	},
	amount: {
		type: Number,
		required: true
	},
	drinkedAt: {
		type: Number,
		default: Date.now(),
		required: true
	}
}, { versionKey: false })

module.exports = model('WaterHistory', waterHistorySchema)
