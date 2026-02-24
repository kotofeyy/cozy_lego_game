class_name ItemTypes
extends Node


enum type {
	REMOVE,
	TILES_BASE,
	CHAIR_BASE,
	TABLE_BASE,
	WINDOW_BASE,
	KITCHEN_CABINET_BASE,
	POT_BASE,
	POT_SUPER,
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
	},
	type.KITCHEN_CABINET_BASE: {
		"name": "kitchen_cabinet_base",
		"path": "res://scenes/blocks/kitchen_cabinet_base.tscn",
		"group": "kitchen_kabinet_base"
	},
	type.POT_BASE: {
		"name": "pot_base",
		"path": "res://scenes/blocks/pot_base.tscn",
		"group": "pot_base"
	},
	type.POT_SUPER: {
		"name": "pot_super",
		"path": "res://scenes/blocks/pot_super.tscn",
		"group": "pot_super"
	},
}
