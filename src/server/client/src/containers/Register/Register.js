import React, { Fragment, useState, useContext } from 'react'
import { Link } from 'react-router-dom'
import classes from './Register.module.css'
import Input from '../../components/UI/Input/Input'
import Button from '../../components/UI/Button/Button'
import logo from '../../images/logo.svg'
import google from '../../images/google.svg'
import facebook from '../../images/facebook.svg'
import vk from '../../images/vk.svg'
import useHttp from '../../hooks/http.hook'
import AuthContext from '../../context/AuthContext'
import Loader from '../../components/UI/Loader/Loader'

const Register = () => {
	const [form, setForm] = useState({
		email: '',
		password: '',
		confirm: ''
	})
	const auth = useContext(AuthContext)
	const { loading, request, clearError, error } = useHttp()

	const changeHandler = event => {
		setForm({
			...form,
			[event.target.name]: event.target.value
		})
	}

	const registerHandler = async () => {
		try {
			const data = await request('/api/auth/register', 'POST', { ...form })
			auth.login(data.token, data.userId)
			clearError()
		} catch (e) { }
	}

	return (
		<Fragment>
			{loading && <Loader />}
			<div className={`row h-100`}>
				<div className={'col-12 col-sm-10 col-md-8 col-lg-5 mx-auto d-flex flex-column justify-content-center h-100'}>
					<div className={`${classes.Register} d-flex flex-column px-5 py-3 justify-content-between`}>
						<div>
							<div className={`text-center ${classes.logo}`} ><img src={logo} alt={'logo'} /></div>
							<h1 className={'text-center'}>Регистрация</h1>
							<Input
								type={'text'}
								placeholder={'Email'}
								onChange={changeHandler}
								id={'email'}
								name={'email'}
							/>
							<Input
								type={'password'}
								placeholder={'Пароль'}
								onChange={changeHandler}
								id={'password'}
								name={'password'}
							/>
							<Input
								type={'password'}
								placeholder={'Повторите пароль'}
								onChange={changeHandler}
								id={'confirm'}
								name={'confirm'}
							/>
							{error && <p className={`text-center ${classes.error}`}>{error}</p>}
						</div>
						<div>
							<p className={'text-justify'}>
								Регистрируясь, вы принимаете наши Условия,
								Политику использования данных и Политику в отношении файлов cookie.
						</p>
							<Button
								type={'primary'}
								onClick={registerHandler}
							>
								Далее
							</Button>
							<hr />
							<Link to={'/login'}>
								<Button
									type={'success'}
								>
									Уже есть аккаунт? Войти
							</Button>
							</Link>
							<div className={`d-flex justify-content-around ${classes.social}`}>
								<img src={google} alt={'google'} />
								<img src={facebook} alt={'facebook'} />
								<img src={vk} alt={'vk'} />
							</div>
						</div>
					</div>
				</div>
			</div>
		</Fragment>
	)
}

export default Register