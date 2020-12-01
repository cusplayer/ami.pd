import React from 'react'
import classes from './Article.module.css'
import { Link } from 'react-router-dom'

const Article = props => {

	const style = {
		background: `no-repeat center / cover url(${props.image})`
	}

	return (
		<Link to={`/articles/${props.id}`} className={`p-3 ${classes.Article}`} style={style}>
			<h2>{props.title}</h2>
		</Link>
	)
}

export default Article