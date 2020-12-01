import React, { useEffect, useState } from 'react'
import { useHistory, useParams } from 'react-router-dom'
import useHttp from '../../hooks/http.hook'
import Input from '../../components/UI/Input/Input'
import Button from '../../components/UI/Button/Button'
import Loader from '../../components/UI/Loader/Loader'

const RestoreEmail = () => {
	const [email, setEmail] = useState(null)
	const { loading, request, clearError, error } = useHttp()
	const params = useParams()
	const history = useHistory()


	const changeHandler = event => {
		setEmail(event.target.value)
	}

	const restoreHandler = async () => {
		try {
			const data = await request(`/api/auth/restore`, 'POST', { email })
			clearError()
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
						type={'email'}
						placeholder={'Email'}
						onChange={changeHandler}
						id={'email'}
						name={'email'}
						value={email}
					/>
					{error}
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

export default RestoreEmail