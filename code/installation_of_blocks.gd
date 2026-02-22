extends Node3D

@onready var tiles: StaticBody3D = $Tiles

var build_delay = 0.11  # Пауза между блоками в секундах
var build_timer = 0.0   # Текущий отсчет



func _ready() -> void:
	pass


func _process(delta: float) -> void:
	var info = get_mouse_3d_pos()
	var pos = info["pos"]
	var type = info["type"]
	print("type - ", type)
	if pos:
		tiles.global_position = pos
		tiles.visible = true
	else:
		tiles.visible = false
	if build_timer > 0:
		build_timer -= delta
	
	if Input.is_action_pressed("mouse_action")and build_timer <= 0:
		if not type.has("tiles"):
			place_block()
			build_timer = build_delay # Сбрасываем таймер


func place_block() -> void:
	var new_cube = tiles.duplicate()
	add_child(new_cube)


func get_mouse_3d_pos():
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera_3d()
	
	# Начало и направление луча
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000 # длина луча 1000м
	
	# Параметры запроса к физике
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	
	query.exclude = [tiles.get_rid()] 
	
	var result = space_state.intersect_ray(query)
	
	var final_pos
	var type
	if result:
		
		var hit_pos = result.position
		var hit_normal = result.normal # Вектор грани (например, Vector3.UP)
		
		# Высота вашего полублока (замените на реальную, если она не 0.5)
		var block_height = 1 
		
		var collider = result.collider

		# Сдвигаем позицию на половину высоты ВДОЛЬ нормали
		# Так блок всегда встанет ПОВЕРХ грани, а не внутрь
		var block_size = tiles.scale
		final_pos = hit_pos + (hit_normal * block_size * 0.5)
			
		# Применяем сетку (snapping)
		# Если высота 0.5, то и шаг сетки по Y должен быть 0.5
		final_pos.x = snapped(final_pos.x, 1.0)
		final_pos.z = snapped(final_pos.z, 1.0)
		final_pos.y = snapped(final_pos.y, block_size.y) 
			
		# Проверка на дубликат через словарь (как обсуждали раньше)
		
		type = collider.get_groups()
	return {
		"pos": final_pos,
		"type": type
	}
