import React, { Fragment } from 'react'
import classes from './Person.module.css'

const Person = props => {
	return (
		<Fragment>
			<div className={`mx-3 ${classes.polaroid}`}>
				<p>{props.name}</p>
				<img src={props.avatar} alt={'Максим Хоцевич'} />
			</div>
		</Fragment>
	)
}

export default Person