import React, { Fragment } from 'react'
import Header from './containers/header/Header'
import logo from './logo.svg'
import Person from './containers/person/Person'


const App = () => {
	return (
		<Fragment>
			<div className={'parallax d-flex flex-column justify-content-center align-items-center'}>
				<Header
					text1={`Проектная деятельность`}
					text2={'зима 2020'}
				/>
			</div>
			<div className={'container h-100 w-100 d-flex align-items-center justify-content-center flex-column'}>
				<img src={logo} alt={'logo'} className={'mb-5'} />
				<p className={`text-justify desc`}>
					Многие люди хотят начать следить за своим образом жизни,
					но не знают с чего начать, ведь для каждой частички здорового и правильного образа жизни существует
					своё приложение с множеством рекомендаций и правил, которые нужно знать и держать в голове.
					Наша цель — помочь им в этом. Мы предоставим возможность вести здоровый образ жизни
					во всех его смыслах именно так, как будет удобно пользователю, ведь наше приложение
					будет универсально и сможет объединить бесчисленное количество, специализированных
					только под одну задачу, приложений в одно удобное и понятное каждому.
					</p>
			</div>
			<div className={'parallax d-flex justify-content-center align-items-center'}>
				<Person
					avatar={'images/atur.jpg'}
					name={'Davtaev Artur'}
				/>
				<Person
					avatar={'images/n.jpg'}
					name={'Zlobin Nikita'}
				/>
			</div>
			<div className={'container h-100 w-100 d-flex align-items-center justify-content-center flex-column tech'}>
				<h2 className={'h1 mb-5'}>Используемые технологии</h2>
				<div className={'row'}>
					<div className={'col-4 text-center'}>
						<img src={'https://cdn.worldvectorlogo.com/logos/photoshop-cc-4.svg'} alt={'photoshop'} />
					</div>
					<div className={'col-4 text-center'}>
						<img src={'https://cdn.worldvectorlogo.com/logos/adobe-illustrator-cs6.svg'} alt={'illustrator'} />
					</div>
					<div className={'col-4 text-center'}>
						<img src={'https://cdn.svgporn.com/logos/figma.svg'} alt={'figma'} />
					</div>
					<div className={'col-4 text-center'}>
						<img src={'images/flutter.png'} alt={'flutter'} />
					</div>
					<div className={'col-4 text-center'}>
						<img src={'images/dart.png'} alt={'dart'} />
					</div>
					<div className={'col-4 text-center'}>
						<img src={'images/firebase.png'} alt={'firebase'} />
					</div>
				</div>
			</div>
			<div className={'parallax d-flex flex-column justify-content-center align-items-center'}>
				<Header
					text1={'Ход работы'}
				/>
			</div>
			<div className={'container h-100 w-100 d-flex align-items-center justify-content-center flex-column tech'}>
				<ul className="push">
					<li>Определение функционала</li>
					<li>Разработка макетов</li>
					<li>Программирование REST API</li>
					<li>Создание кросс-платформенного приложения</li>
				</ul>
			</div>
			<div className={'parallax d-flex flex-column justify-content-center align-items-center'}>
				<Header
					text1={'Ссылки'}
				/>
			</div>
			<div className={'container h-100 w-100 d-flex align-items-center justify-content-center flex-column tech'}>
				<div className={'row'}>
					<div className={'col-6 text-center'}>
						<a href='https://github.com/cusplayer/ami.pd' target={'_blank'}><img src={'https://cdn.svgporn.com/logos/github-icon.svg'} alt={'github'} /></a>
					</div>
				</div>
			</div>
		</Fragment>
	)
}

export default App
