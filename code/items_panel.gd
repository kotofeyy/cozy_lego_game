extends CanvasLayer

@onready var h_box_container: HBoxContainer = $Panel/MarginContainer/HBoxContainer


var items = {
	"base": [
		ItemTypes.type.TILES_BASE,
		ItemTypes.type.CHAIR_BASE,
		ItemTypes.type.TABLE_BASE,
		ItemTypes.type.WINDOW_BASE
	]
	
}


func _ready() -> void:
	generate_buttons_for_panel()



func _process(delta: float) -> void:
	pass


func generate_buttons_for_panel() -> void:
	for category in items:
		var menu = MenuButton.new()
		menu.text = str(category)
		h_box_container.add_child(menu)
		var button_del = Button.new()
		button_del.text = "remove"
		h_box_container.add_child(button_del)
		button_del.size_flags_horizontal = Control.SIZE_SHRINK_END
		button_del.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button_del.pressed.connect(on_click_to_button_del)

		for item: ItemTypes.type in items[category]:
			var text = str(ItemTypes.Items[item]["name"])
			menu.get_popup().add_check_item(text, item)
			menu.get_popup().id_pressed.connect(on_item_pressed)


func on_item_pressed(type) -> void:
	GlobalEvents.change_block.emit(type)


func on_click_to_button_del() -> void:
	GlobalEvents.change_block.emit(ItemTypes.type.REMOVE)
