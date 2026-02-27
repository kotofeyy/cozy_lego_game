extends CanvasLayer

@onready var h_box_container_base: HBoxContainer = $TabContainer/Base/MarginContainer/HBoxContainer

@onready var h_box_container: HBoxContainer = $Panel/MarginContainer/HBoxContainer
const HAMMER = preload("uid://rd2e3fb3mbye")
const PAINT_ROLLER = preload("uid://cmo7x6vvp8ob5")

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
		ItemTypes.type.KITCHEN_STOVE_BASE,
	],
	"wallpaper": [
		ItemTypes.type.WALLPAPER_BASE,
		ItemTypes.type.WALLPAPER_BROWN,
		ItemTypes.type.WALLPAPER_CORAL,
		ItemTypes.type.WALLPAPER_CORNFLOWER_BLUE,
	]
}


func _ready() -> void:
	generate_base_items()
	#generate_buttons_for_panel()


func generate_base_items() -> void:
	for item in items["base"]:
		var button = Button.new()
		button.text = str(ItemTypes.Items[item]["name"])
		h_box_container_base.add_child(button)


func generate_buttons_for_panel() -> void:
	var button_del = Button.new()
	button_del.text = "remove"
	h_box_container.add_child(button_del)
	button_del.size_flags_horizontal = Control.SIZE_SHRINK_END
	button_del.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button_del.pressed.connect(on_click_to_button_del)
	button_del.icon = HAMMER
	for category in items:
		var menu = MenuButton.new()
		menu.text = str(category)
		h_box_container.add_child(menu)
		for item: ItemTypes.type in items[category]:
			var text = str(ItemTypes.Items[item]["name"])
			if category == "wallpaper":
				# генерирую текстуру налету, присваиваю ей нужный цвет от обоев
				var image = Image.create(16, 16, false, Image.FORMAT_RGBA8) # Создаем изображение
				var color = ItemTypes.Items[item]["color"]
				image.fill(color) # Заливаем цветом
				var texture = ImageTexture.create_from_image(image) # Создаем текстуру
				menu.get_popup().add_icon_radio_check_item(texture, text, item)
				menu.get_popup().id_pressed.connect(on_item_pressed, CONNECT_REFERENCE_COUNTED)
			else:
				
				menu.get_popup().add_icon_radio_check_item(tiles_icon, text, item)
				menu.get_popup().id_pressed.connect(on_item_pressed, CONNECT_REFERENCE_COUNTED)


func on_item_pressed(type) -> void:
	GlobalEvents.change_block.emit(type)


func on_click_to_button_del() -> void:
	GlobalEvents.change_block.emit(ItemTypes.type.REMOVE)
