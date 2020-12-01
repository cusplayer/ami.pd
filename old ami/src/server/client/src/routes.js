import React from 'react'
import { Switch, Route, Redirect } from 'react-router-dom'
import Login from './containers/Login/Login'
import Register from './containers/Register/Register'
import Main from './containers/Main/Main'
import Health from './containers/Health/Health'
import Profile from './containers/Profile/Profile'
import RestorePassword from './containers/Restore/Restore.password'
import RestoreEmail from './containers/Restore/Restore.email'
import Article from './containers/Article/Article'

const useRoutes = (isAuthenticated, isAdmin) => {
	if (isAuthenticated) {
		if (isAdmin) {
			// return (
			// 	<Switch>
			// 		<Route path={'/'} component={} />
			// 	</Switch>
			// )
		}
		return (
			<Switch>
				<Route path={'/health'} component={Health} />
				<Route path={'/profile'} component={Profile} />
				<Route path={'/articles/:id'} component={Article} />
				<Route path={'/'} exact component={Main} />
				<Redirect to={'/'} />
			</Switch>
		)
	}
	return (
		<Switch>
			<Route path={'/login'} component={Login} />
			<Route path={'/register'} component={Register} />
			<Route path={'/restore/:token'} component={RestorePassword} />
			<Route path={'/restore'} component={RestoreEmail} />
			<Route path={'/articles/:id'} component={Article} />
			<Route path={'/'} exact component={Main} />
			<Redirect to={'/'} />
		</Switch>
	)
}

export default useRoutes