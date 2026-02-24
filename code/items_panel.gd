extends CanvasLayer

@onready var h_box_container: HBoxContainer = $Panel/MarginContainer/HBoxContainer
const HAMMER = preload("uid://rd2e3fb3mbye")

const tiles_icon = preload("uid://c4ecwde2bx4wa")

var items = {
	"base": [
		ItemTypes.type.TILES_BASE,
		ItemTypes.type.CHAIR_BASE,
		ItemTypes.type.TABLE_BASE,
		ItemTypes.type.WINDOW_BASE,
		ItemTypes.type.KITCHEN_CABINET_BASE,
		ItemTypes.type.POT_BASE,
		ItemTypes.type.POT_SUPER,
	]
}


func _ready() -> void:
	generate_buttons_for_panel()


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
		button_del.icon = HAMMER

		for item: ItemTypes.type in items[category]:
			var text = str(ItemTypes.Items[item]["name"])
			menu.get_popup().add_icon_radio_check_item(tiles_icon, text, item)
			menu.get_popup().id_pressed.connect(on_item_pressed)


func on_item_pressed(type) -> void:
	GlobalEvents.change_block.emit(type)


func on_click_to_button_del() -> void:
	GlobalEvents.change_block.emit(ItemTypes.type.REMOVE)
