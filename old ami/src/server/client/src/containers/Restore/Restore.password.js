import React, { useEffect, useState } from 'react'
import { useHistory, useParams } from 'react-router-dom'
import useHttp from '../../hooks/http.hook'
import Input from '../../components/UI/Input/Input'
import Button from '../../components/UI/Button/Button'
import Loader from '../../components/UI/Loader/Loader'

const RestorePassword = () => {
	const [token, setToken] = useState(null)
	const [userId, setUserId] = useState(null)
	const [password, setPassword] = useState('')
	const { loading, request, clearError, error } = useHttp()
	const params = useParams()
	const history = useHistory()

	const verifyToken = async () => {
		try {
			const data = await request(`/api/auth/restore/${params.token}`, 'GET')
			setToken(data.token)
			setUserId(data.userId)
		} catch (e) {
			history.push('/')
		}
	}

	useEffect(() => {
		verifyToken()
	}, [])

	const changeHandler = event => {
		setPassword(event.target.value)
	}

	const restoreHandler = async () => {
		try {
			const data = await request(`/api/auth/restore/password`, 'POST', {
				password,
				userId,
				token
			})
		} catch (e) { }
	}

	return (
		<div>
			{loading ?
				<Loader />
				:
				<>
					<h1>Restore</h1>
					<Input
						type={'text'}
						placeholder={'password'}
						onChange={changeHandler}
						id={'password'}
						name={'password'}
						value={password}
					/>
					<Button
						type={'primary'}
						onClick={restoreHandler}
					>
						Изменить
					</Button>
				</>
			}
		</div>
	)
}

export default RestorePassword