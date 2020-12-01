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
					text2={'2020'}
				/>
			</div>
			<div className={'container h-100 w-100 d-flex align-items-center justify-content-center flex-column'}>
				<img src={logo} alt={'logo'} className={'mb-5'} />
				<p className={`text-justify desc`}>
					Многие люди хотят начать вести здоровый образ жизни, но не знают с чего начать.
					Наша цель — помочь им в этом. Мы предоставим возможность вести здоровый образ жизни во всех
					его смыслах, ведь наше приложение универсально и сможет заменить бесчисленное количество
					специализированных только под одну задачу приложений.
					</p>
			</div>
			<div className={'parallax d-flex flex-column justify-content-center align-items-center'}>
				<Person
					avatar={'https://sun9-26.userapi.com/c639429/v639429177/babb4/heaEUjzfciA.jpg'}
					name={'Khotsevich Maxim, Fullstack-developer'}
				/>
			</div>
			<div className={'container h-100 w-100 d-flex align-items-center justify-content-center flex-column tech'}>
				<h2 className={'h1 mb-5'}>Его технологии</h2>
				<div className={'row mb-2'}>
					<div className={'col-4 text-center'}>
						<img src={'https://cdn.svgporn.com/logos/chai.svg'} alt={'chai'} />
					</div>
					<div className={'col-4 text-center'}>
						<img src={'https://cdn.svgporn.com/logos/nodejs-icon.svg'} alt={'nodejs'} />
					</div>
					<div className={'col-4 text-center'}>
						<img src={'https://cdn.svgporn.com/logos/mocha.svg'} alt={'mocha'} />
					</div>
				</div>
				<div className={'row mb-2'}>
					<div className={'col-6 text-center'}>
						<img src={'https://cdn.svgporn.com/logos/express.svg'} alt={'express'} />
					</div>
					<div className={'col-6 text-center'}>
						<img src={'https://cdn.svgporn.com/logos/mongodb.svg'} alt={'mongodb'} />
					</div>
				</div>
				<div className={'row mb-2'}>
					<div className={'col-6 text-center'}>
						<img src={'https://cdn.svgporn.com/logos/sendgrid.svg'} alt={'sendgrid'} />
					</div>
					<div className={'col-6 text-center'}>
						<img src={'https://cdn.svgporn.com/logos/react.svg'} alt={'react'} />
					</div>
				</div>
			</div>
			<div className={'parallax d-flex flex-column justify-content-center align-items-center'}>
				<Person
					avatar={'https://sun1-99.userapi.com/Dgi_k9lUgLjMRpCFkDTedsrt8WXxOv6zWEiAZA/zt1HHvF2zu4.jpg'}
					name={'Kufaev Artem, iOS-developer'}
				/>
			</div>
			<div className={'container h-100 w-100 d-flex align-items-center justify-content-center flex-column tech'}>
				<h2 className={'h1 mb-5'}>Его технологии</h2>
				<div className={'row mb-2'}>
					<div className={'col-6 text-center'}>
						<img src={'https://cdn.svgporn.com/logos/swift.svg'} alt={'swift'} />
					</div>
					<div className={'col-6 text-center'}>
						<img src={'https://cdn.svgporn.com/logos/cocoapods.svg'} alt={'coco'} />
					</div>
				</div>
				<div className={'row mb-2'}>
					<div className={'col-12 text-center'}>
						<img src={'https://www.pvsm.ru/images/Core-Data-dlya-iOS-glava-№4-teoreticheskaya-chast.png'} alt={'coredata'} />
					</div>
				</div>
				<div className={'row mb-2'}>
					<div className={'col-12 text-center'}>
						<img src={'https://cdn.svgporn.com/logos/raml.svg'} alt={'raml'} />
					</div>
				</div>
			</div>
			<div className={'parallax d-flex justify-content-center align-items-center'}>
				<Person
					avatar={'https://sun1-91.userapi.com/LGaQt1EA30DO7q7xdNmENAbrHfflp8vW9QhkBQ/-z_8X_kX7lo.jpg'}
					name={'Davtaev Artur, UX-developer'}
				/>
				<Person
					avatar={'https://sun9-52.userapi.com/c848624/v848624697/17a743/gvnpw38icwo.jpg'}
					name={'Bazhenova Dasha, UI-developer'}
				/>
			</div>
			<div className={'container h-100 w-100 d-flex align-items-center justify-content-center flex-column tech'}>
				<h2 className={'h1 mb-5'}>Их технологии</h2>
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
					<li>Создание iOS-приложения и сайта</li>
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
						<a href='https://github.com/MaximusHeroProger/ami-PD' target={'_blank'}><img src={'https://cdn.svgporn.com/logos/github-icon.svg'} alt={'github'} /></a>
					</div>
					<div className={'col-6 text-center'}>
						<img src={'https://cdn.svgporn.com/logos/youtube.svg'} alt={'youtube'} />
					</div>
				</div>
			</div>
		</Fragment>
	)
}

export default App
