import React, { useState, Fragment } from 'react'
import { NavLink } from 'react-router-dom'
import classes from './Health.module.css'
import Cup from '../../components/Svg/Cup'
import Navbar from '../../components/Navbar/Navbar'

const Health = () => {
	const [amountCups, setAmountCups] = useState(10)
	const [currentCups, setCurrentCups] = useState(0)


	const addCupHandler = () => {
		setCurrentCups(currentCups + 1)
	}

	const renderCups = () => {
		return [...Array(amountCups).keys()]
			.map(number =>
				<div key={number} className={'col-3 text-center mb-4'}>
					<Cup
						id={number}
						currentCupNumber={currentCups}
					/>
				</div>

			)
	}

	return (
		<Fragment>
			<Navbar />
			<div className={`mt-4 ${classes.Health}`}>
				<div className={'row'}>
					<div className={'col-12'}>
						<h1 className={'text-center'}>Здоровье</h1>
					</div>
				</div>
				<div className={'row mt-4'}>
					<div className={`col-3 d-flex flex-column justify-content-center mt-5 ${classes.sidebar}`}>
						<NavLink to={'/health/water'} activeClassName={classes.active}>Трекер водички</NavLink>
						<NavLink to={'/health/sleep'} activeClassName={classes.active}>Трекер сна</NavLink>
						<NavLink to={'/health/tasks'} activeClassName={classes.active}>Таск менеджер</NavLink>
					</div>
					<div className={'col-6'}>
						<div className={'row d-flex flex-wrap px-5'}>
							{renderCups()}
						</div>
						<div className={'row'}>
							<div className={'col-12 text-center'}>
								<button
									className={classes.waterBtn}
									onClick={addCupHandler}
								>
									Выпил<br />водички
							</button>
							</div>
						</div>
					</div>
					<div className={'col-3'}>

					</div>
				</div>
			</div>
		</Fragment>

	)
}

export default Health