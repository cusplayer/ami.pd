import React from 'react'
import classes from './Header.module.css'

const Header = props => {
	return (
		<div className={'row w-100'}>
			<div className={`col-12 text-center ${classes.glitch}`}>
				<h1 className={`my-0 ${classes.title}`} contenteditable="true">{props.text1}<br />{props.text2}</h1>
			</div>
		</div>
	)
}

export default Header