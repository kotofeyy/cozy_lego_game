class_name ItemTypes
extends Node


enum type {
	REMOVE,
	WALLPAPER_BASE,
	WALLPAPER_BROWN,
	WALLPAPER_CORAL,
	WALLPAPER_CORNFLOWER_BLUE,
	TILES_BASE,
	CHAIR_BASE,
	TABLE_BASE,
	WINDOW_BASE,
	KITCHEN_CABINET_BASE,
	POT_BASE,
	POT_SUPER,
	KITCHEN_STOVE_BASE,
}

const Items = {
	type.REMOVE: {
		"name": "remove",
		"path": null,
		"group": "remove"
	},
	type.WALLPAPER_BASE: {
		"name": "wallpaper_base",
		"path": null, 
		"group": "wallpaper",
		"color": Color.BISQUE
	},
	type.WALLPAPER_BROWN: {
		"name": "wallpaper_brown",
		"path": null, 
		"group": "wallpaper",
		"color": Color.BROWN
	},
	type.WALLPAPER_CORAL: {
		"name": "wallpaper_coral",
		"path": null, 
		"group": "wallpaper",
		"color": Color.CORAL
	},
	type.WALLPAPER_CORNFLOWER_BLUE: {
		"name": "wallpaper_cornflower_blue",
		"path": null, 
		"group": "wallpaper",
		"color": Color.CORNFLOWER_BLUE
	},
	type.TILES_BASE: {
		"name": "tiles_base",
		"path": "res://scenes/blocks/base/tiles_base.tscn", 
		"group": "tiles_base",
	},
	type.CHAIR_BASE: {
		"name": "chair_base",
		"path": "res://scenes/blocks/base/chair_base.tscn", 
		"group": "chair_base",
	},
	type.TABLE_BASE: {
		"name": "table_base",
		"path": "res://scenes/blocks/base/table_base.tscn", 
		"group": "table_base",
	},
	type.WINDOW_BASE: {
		"name": "window_base",
		"path": "res://scenes/blocks/base/window_base.tscn", 
		"group": "table_base",
	},
	type.KITCHEN_CABINET_BASE: {
		"name": "kitchen_cabinet_base",
		"path": "res://scenes/blocks/base/kitchen_cabinet_base.tscn",
		"group": "kitchen_kabinet_base"
	},
	type.POT_BASE: {
		"name": "pot_base",
		"path": "res://scenes/blocks/base/pot_base.tscn",
		"group": "pot_base"
	},
	type.POT_SUPER: {
		"name": "pot_super",
		"path": "res://scenes/blocks/base/pot_super.tscn",
		"group": "pot_super"
	},
	type.KITCHEN_STOVE_BASE: {
		"name": "kitchen_stove_base",
		"path": "res://scenes/blocks/base/kitchen_stove_base.tscn",
		"group": "kitchen_stove_base"
	}
}
