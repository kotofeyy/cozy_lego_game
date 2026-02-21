extends Node3D


var build_delay = 0.11  # Пауза между блоками в секундах
var build_timer = 0.0   # Текущий отсчет

@onready var tiles: StaticBody3D = $Tiles


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	var pos = get_mouse_3d_pos()
	if pos:
		# Сетка шагом 1.0 (размер куба)
		tiles.global_position = pos.snapped(Vector3.ONE)
		tiles.visible = true
	else:
		tiles.visible = false
	if build_timer > 0:
		build_timer -= delta
	
	if Input.is_action_pressed("mouse_action")and build_timer <= 0:
		place_block()
		build_timer = build_delay # Сбрасываем таймер


func place_block() -> void:
	var new_cube = tiles.duplicate()
	new_cube.name = "Tiles"
	add_child(new_cube)


func get_mouse_3d_pos():
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera_3d()
	
	# Начало и направление луча
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 2000 # длина луча 1000м
	
	# Параметры запроса к физике
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	
	query.exclude = [tiles.get_rid()] 
	
	var result = space_state.intersect_ray(query)
	
	
	if result:
		print("result - ", result.collider.name)
		
		var hit_pos = result.position
		var hit_normal = result.normal # Вектор грани (например, Vector3.UP)
		
		# Высота вашего полублока (замените на реальную, если она не 0.5)
		var block_height = 1 
		if result.collider.is_in_group("tiles"):
			print("Это один из моих блоков!")
			block_height = 0.2
		
		# Сдвигаем позицию на половину высоты ВДОЛЬ нормали
		# Так блок всегда встанет ПОВЕРХ грани, а не внутрь
		var final_pos = hit_pos + (hit_normal * Vector3.ONE)
		
		# Применяем сетку (snapping)
		# Если высота 0.5, то и шаг сетки по Y должен быть 0.5
		final_pos.x = snapped(final_pos.x, 1.0)
		final_pos.z = snapped(final_pos.z, 1.0)
		final_pos.y = snapped(final_pos.y, 1.0) 
		
		# Проверка на дубликат через словарь (как обсуждали раньше)
		return hit_pos
	return null
