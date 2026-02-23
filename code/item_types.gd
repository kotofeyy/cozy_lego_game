class_name ItemTypes
extends Node


enum type {
	REMOVE,
	TILES_BASE,
	CHAIR_BASE,
	TABLE_BASE,
	WINDOW_BASE,
}

const Items = {
	type.REMOVE: {
		"name": "remove",
		"path": null,
		"group": "remove"
	},
	type.TILES_BASE: {
		"name": "tiles_base",
		"path": "res://scenes/blocks/tiles_base.tscn", 
		"group": "tiles_base",
	},
	type.CHAIR_BASE: {
		"name": "chair_base",
		"path": "res://scenes/blocks/chair_base.tscn", 
		"group": "chair_base",
	},
	type.TABLE_BASE: {
		"name": "table_base",
		"path": "res://scenes/blocks/table_base.tscn", 
		"group": "table_base",
	},
	type.WINDOW_BASE: {
		"name": "window_base",
		"path": "res://scenes/blocks/window_base.tscn", 
		"group": "table_base",
	}
}
