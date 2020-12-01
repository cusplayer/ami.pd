const { Schema, Types, model } = require('mongoose')

const sleepHistorySchema = new Schema({
	userId: {
		type: Types.ObjectId,
		ref: 'User',
		required: true
	},
	endAt: {
		type: Number,
		required: true
	},
	riseAt: {
		type: Number,
		required: true
	}
}, { versionKey: false })

module.exports = model('SleepHistory', sleepHistorySchema)
