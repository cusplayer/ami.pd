import React, { Fragment, useState, useContext } from 'react'
import { Link } from 'react-router-dom'
import classes from './Login.module.css'
import Input from '../../components/UI/Input/Input'
import Button from '../../components/UI/Button/Button'
import logo from '../../images/logo.svg'
import google from '../../images/google.svg'
import facebook from '../../images/facebook.svg'
import vk from '../../images/vk.svg'
import useHttp from '../../hooks/http.hook'
import AuthContext from '../../context/AuthContext'
import Loader from '../../components/UI/Loader/Loader'

const Login = () => {
	const [form, setForm] = useState({
		email: '',
		password: '',
	})
	const auth = useContext(AuthContext)
	const { loading, request, clearError, error } = useHttp()

	const changeHandler = event => {
		setForm({
			...form,
			[event.target.name]: event.target.value
		})
	}

	const loginHandler = async () => {
		try {
			const data = await request('/api/auth/login', 'POST', { ...form })
			auth.login(data.accessToken, data.user._id)
			clearError()
		} catch (e) { }
	}

	return (
		<Fragment>
			{loading && <Loader />}
			<div className={`row h-100`}>
				<div className={'col-12 col-sm-10 col-md-8 col-lg-5 mx-auto d-flex flex-column justify-content-center h-100'}>
					<div className={`${classes.Login} d-flex flex-column px-5 py-3 justify-content-between`}>
						<div>
							<div className={`text-center ${classes.logo}`} ><img src={logo} alt={'logo'} /></div>
							<h1 className={'text-center'}>Вход</h1>
							<Input
								type={'text'}
								placeholder={'Email'}
								onChange={changeHandler}
								id={'email'}
								name={'email'}
								value={form.email}
							/>
							<Input
								type={'password'}
								placeholder={'Пароль'}
								onChange={changeHandler}
								id={'password'}
								name={'password'}
								value={form.password}
							/>
							<div className={'text-center'}><Link to={'/restore'}>Забыли пароль?</Link></div>
							{error && <p className={`text-center ${classes.error}`}>{error}</p>}
						</div>
						<div>
							<Button
								type={'primary'}
								onClick={loginHandler}
							>
								Войти
							</Button>
							<hr />
							<Link to={'/register'}>
								<Button
									type={'success'}
								>
									Еще нет аккаунта? Зарегистрируйтесь!
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

export default Login