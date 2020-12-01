import React from 'react'
import classes from './Input.module.css'

const Input = props => {
	const inputType = props.type || 'text'
	return (
		<div className={`${classes.Input} d-flex justify-content-center`}>
			<input
				type={inputType}
				placeholder={props.placeholder}
				value={props.value}
				onChange={props.onChange}
				id={props.id}
				name={props.name}
				disabled={props.disabled}
			>
			</input>
		</div>
	)
}

export default Input