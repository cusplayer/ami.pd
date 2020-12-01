const compression = require('compression')
const mongoose = require('mongoose')
const express = require('express')
const helmet = require('helmet')
const morgan = require('morgan')
const config = require('config')
const path = require('path')
const https = require("https")
const http = require('http')
const fs = require("fs")

const httpApp = express()
const app = express()

const HTTP_PORT = config.get('HTTP_PORT')
const HTTPS_PORT = config.get('HTTPS_PORT')

const httpsOptions = { key: fs.readFileSync('server.key'), cert: fs.readFileSync('server.crt') }

httpApp.get('*', (req, res) => res.redirect(`https://${req.headers.host}${req.path}`))

app.use(express.json({ extended: true, type: 'application/json' }))
app.use(express.urlencoded({ extended: true }));
app.use(express.text());


app.use(helmet())
app.use(compression())

app.use('/api/v1/auth', require('./routes/auth'))
app.use('/api/v1/user', require('./routes/user'))
app.use('/api/v1/history/water', require('./routes/water'))
app.use('/api/v1/history/sleep', require('./routes/sleep'))
app.use('/api/v1/history/weight', require('./routes/weight'))
app.use('/api/v1/history/tasks', require('./routes/tasks'))
app.use('/api/v1/articles', require('./routes/articles'))


if (process.env.NODE_ENV !== 'test') app.use(morgan('combined'))

if (process.env.NODE_ENV === 'production') {
	app.use('/', express.static(path.join(__dirname, 'client', 'build')))
	app.get('*', (req, res) => res.sendFile(path.resolve(__dirname, 'client', 'build', 'index.html')))
}

async function start() {
	try {
		await mongoose.connect(config.get('MONGODB_URI'), {
			useNewUrlParser: true,
			useUnifiedTopology: true,
			useCreateIndex: true
		})

		if (process.env.NODE_ENV === 'production') {
			http.createServer(httpApp).listen(HTTP_PORT, () => console.log(`HTTP server has been started on PORT ${HTTP_PORT}`))
			https.createServer(httpsOptions, app).listen(HTTPS_PORT, () => console.log(`HTTPS server has been started on PORT ${HTTPS_PORT}`))
		} else {
			app.listen(HTTP_PORT, () => console.log(`HTTPS server has been started on PORT ${HTTP_PORT}`))
		}
		
	} catch (e) {
		console.log('Неизвестная ошибка', e.message)
		process.exit(1)
	}
}

start()

module.exports = app