class_name ItemTypes
extends Node


enum type {
	TILES_BASE,
	CHAIR_BASE,
}

const blocks = {
	type.TILES_BASE: {
		"name": "tiles_base",
		"path": "res://scenes/blocks/tiles_base.tscn", 
		"group": "tiles_base",
	},
	type.CHAIR_BASE: {
		"name": "tiles_base",
		"path": "res://scenes/blocks/base_chair.tscn", 
		"group": "chair_base",
	}
}
