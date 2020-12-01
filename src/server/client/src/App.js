import React from 'react'
import useRoutes from './routes'
import useAuth from './hooks/auth.hook'
import AuthContext from './context/AuthContext'
import Navbar from './components/Navbar/Navbar'
import Loader from './components/UI/Loader/Loader'

const App = () => {
	const { login, logout, token, userId, ready } = useAuth()
	const isAuthenticated = !!token
	const routes = useRoutes(isAuthenticated, false)

	if (!ready) {
		return <Loader />
	}

	return (
		<AuthContext.Provider value={{ login, logout, token, userId, isAuthenticated }}>
			<div className={'container h-100'}>
				{routes}
			</div>
		</AuthContext.Provider>
	)
}

export default App