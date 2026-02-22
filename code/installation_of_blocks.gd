extends Node3D



var build_delay = 0.11  # Пауза между блоками в секундах
var build_timer = 0.0   # Текущий отсчет
var group_of_current_block
var current_block: StaticBody3D


func _ready() -> void:
	GlobalEvents.change_block.connect(change_block)
	var path = ItemTypes.blocks[ItemTypes.type.TILES_BASE]["path"]
	var new_block: PackedScene = load(path)
	current_block = new_block.instantiate()
	add_child(current_block)
	group_of_current_block = current_block.get_groups()


func _process(delta: float) -> void:
	var info = get_mouse_3d_pos()
	var pos = info["pos"]
	var group = info["type"]
	var object = info["collider"]

	if pos and current_block:
		current_block.global_position = pos
		current_block.visible = true
	else:
		current_block.visible = false

	if build_timer > 0:
		build_timer -= delta
	
	if Input.is_action_pressed("mouse_action") and build_timer <= 0:
		# чтобы плитки не ставились друг на друга, проверяю по группам
		if not group==group_of_current_block:
			place_block()
			build_timer = build_delay # Сбрасываем таймер
	if Input.is_action_just_pressed("mouse_del"):
		if group.has("placeable"):
			object.queue_free()


func place_block() -> void:
	if current_block:
		var new_cube = current_block.duplicate()
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
	
	query.exclude = [current_block.get_rid()] 
	
	var result = space_state.intersect_ray(query)
	
	var final_pos
	var type
	var collider
	if result:
		
		var hit_pos = result.position
		var hit_normal = result.normal # Вектор грани (например, Vector3.UP)
		
		# Высота вашего полублока (замените на реальную, если она не 0.5)
		var block_height = 1 
		
		collider = result.collider

		# Сдвигаем позицию на половину высоты ВДОЛЬ нормали
		# Так блок всегда встанет ПОВЕРХ грани, а не внутрь
		var block_size = current_block.scale
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
		"type": type,
		"collider": collider
	}


func change_block(block) -> void:
	var path = ItemTypes.blocks[block]["path"]
	var new_block: PackedScene = load(path)
	current_block = new_block.instantiate()
	add_child(current_block)
	group_of_current_block = current_block.get_groups()
