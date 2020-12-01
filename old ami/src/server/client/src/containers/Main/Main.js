import React, { Fragment } from 'react'
import Navbar from '../../components/Navbar/Navbar'
import classes from './Main.module.css'
import Article from '../../components/Article/Article'
import test from '../../images/test.jpg'

const Main = () => {
	return (
		<Fragment>
			<Navbar />
			<div className={`mt-4 ${classes.Health}`}>
				<div className={'row'}>
					<div className={'col-12'}>
						<h1 className={'text-center'}>Статьи</h1>
					</div>
				</div>
				<div className={'row mt-3'}>
					<div className={'col-8'}>
						<Article
							title={'Позитивное мышление'}
							image={test}
							id={'fg5434tg4g'}
						/>
					</div>
					<div className={'col-4'}>
						<Article
							title={'Все о воде'}
						/>
					</div>
				</div>
				<div className={'row mt-3'}>
					<div className={'col-4'}>
						<Article
							title={'Что такое S.M.A.R.T?'}
						/>
					</div>
					<div className={'col-8'}>
						<Article
							title={'Все о воде'}
						/>
					</div>
				</div>
			</div>
		</Fragment>
	)
}

export default Main