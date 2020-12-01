const { Schema, model } = require('mongoose')

const userSchema = new Schema({
	email: {
		type: String,
		required: true,
		unique: true
	},
	password: {
		type: String,
		required: true
	},
	name: {
		type: String,
		required: true
	},
	surname: {
		type: String,
		required: true
	},
	birthdate: {
		type: Number,
		required: true
	},
	height: {
		type: Number,
		required: true
	},
	appleId: {
		type: String
	},
	vkId: {
		type: Number
	},
	restoreToken: String,
	restoreTokenExp: Date,
}, {versionKey: false})

module.exports = model('User', userSchema)
