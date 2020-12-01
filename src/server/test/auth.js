const chai = require('chai')
const chaiHttp = require('chai-http')
const { after, describe } = require("mocha")

const User = require('../models/User')
const app = require('../index')

const should = chai.should()

chai.use(chaiHttp)

describe('Регистрация', () => {
	beforeEach((done) => {
		User.deleteOne({}, (err) => {
			done()
		})
	})
	describe('/POST auth/register', () => {
		it('Корректные данные', (done) => {
			const user = {
				email: 'xozewitc@yandex.ru',
				password: '12345678',
				name: 'Максим',
				surname: 'Хоцевич',
				birthdate: '959385600',
				weight: '65',
				height: '180'
			}
			chai.request(app)
				.post('/api/auth/register')
				.send(user)
				.end((err, res) => {
					res.should.have.status(201);
					res.body.should.have.property('user')
					res.body.should.have.property('accessToken')
					res.body.user.should.have.property('_id')
					res.body.user.should.have.property('email')
					res.body.user.should.have.property('password')
					res.body.user.should.have.property('name')
					res.body.user.should.have.property('surname')
					res.body.user.should.have.property('birthdate')
					res.body.user.should.have.property('height')
					done()
				})
		})
	})
	describe('/POST auth/register', () => {
		it('Неверный email', (done) => {
			const user = {
				email: 'xozewitcyandex.ru',
				password: '12345678',
				name: 'Максим',
				surname: 'Хоцевич',
				birthdate: '959385600',
				weight: '65',
				height: '180'
			}
			chai.request(app)
				.post('/api/auth/register')
				.send(user)
				.end((err, res) => {
					res.should.have.status(400)
					res.body.should.have.property('message').eql('Некорректный email')
					done()
				})
		})
	})
	describe('/POST auth/register', () => {
		it('Занятый email', (done) => {
			const user1 = new User({
				email: 'xozewitc@yandex.ru',
				password: '12345678',
				name: 'Максим',
				surname: 'Хоцевич',
				birthdate: '959385600',
				weight: '65',
				height: '180'
			})
			const user2 = {
				email: 'xozewitc@yandex.ru',
				password: '1234567890',
				name: 'Maxim',
				surname: 'Khotsevich',
				birthdate: '959385600',
				weight: '70',
				height: '170'
			}
			user1.save(() => {
				chai.request(app)
					.post('/api/auth/register')
					.send(user2)
					.end((err, res) => {
						res.should.have.status(400)
						res.body.should.have.property('message').eql('Пользователь с таким Email уже существует')
						done()
					})
			})
		})
	})
})

describe('Вход', () => {
	beforeEach((done) => {
		User.deleteOne({}, (err) => {
			done()
		})
	})
	describe('/POST auth/login', () => {
		it('Корректные данные', (done) => {
			const user1 = new User({
				email: 'xozewitc@yandex.ru',
				password: '12345678'
			})
			const user2 = {
				email: 'xozewitc@yandex.ru',
				password: '12345678'
			}
			user1.save((err, user) => {
				chai.request(app)
					.post('/api/auth/login')
					.send(user)
					.end((err, res) => {
						console.log(res)
						res.should.have.status(200);
						res.body.should.have.property('user')
						res.body.should.have.property('accessToken')
						res.body.user.should.have.property('_id')
						res.body.user.should.have.property('email')
						res.body.user.should.have.property('password')
						res.body.user.should.have.property('name')
						res.body.user.should.have.property('surname')
						res.body.user.should.have.property('birthdate')
						res.body.user.should.have.property('height')
						done()
					})
			})
		})
	})
	describe('/POST auth/login', () => {
		it('Неверный пароль', (done) => {
			const user1 = new User({
				email: 'maxim@yandex.ru',
				password: bcrypt.hashSync('1234567', 10)
			})
			const user2 = {
				email: 'maxim@yandex.ru',
				password: '12345678'
			}
			user1.save((err, user) => {
				chai.request(app)
					.post('/api/auth/login')
					.send(user2)
					.end((err, res) => {
						res.should.have.status(400);
						res.body.should.have.property('message').eql('Неверный пароль')
						done()
					})
			})
		})
	})
	describe('/POST auth/login', () => {
		it('Неверный email', (done) => {
			const user1 = new User({
				email: 'maxim@yandex.ru',
				password: bcrypt.hashSync('12345678', 10)
			})
			const user2 = {
				email: 'maxim1@yandex.ru',
				password: '12345678'
			}
			user1.save((err, user) => {
				chai.request(app)
					.post('/api/auth/login')
					.send(user2)
					.end((err, res) => {
						res.should.have.status(400);
						res.body.should.have.property('message').eql('Пользователь не найден')
						done()
					})
			})
		})
	})
})