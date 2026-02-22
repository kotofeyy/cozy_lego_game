extends Node3D

@onready var current_item: Node = $CurrentItem


var build_delay = 0.11  # Пауза между блоками в секундах
var build_timer = 0.0   # Текущий отсчет
var group_of_current_block
var current_block: StaticBody3D


func _ready() -> void:
	GlobalEvents.change_block.connect(change_block)
	var path = ItemTypes.blocks[ItemTypes.type.TILES_BASE]["path"]
	var new_block: PackedScene = load(path)
	current_block = new_block.instantiate()
	clear_current_item()
	current_item.add_child(current_block)
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
		if not group == group_of_current_block:
			place_block()
			build_timer = build_delay # Сбрасываем таймер

	if Input.is_action_just_pressed("mouse_del"):
		if group.has("placeable"):
			object.queue_free()
	
	if Input.is_action_just_pressed("rotate_left"):
		if current_block:
			current_block.rotation_degrees.y += 90
	if Input.is_action_just_pressed("rotate_right"):
		if current_block:
			current_block.rotation_degrees.y -= 90

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
		
		collider = result.collider

		var shape = current_block.get_node("CollisionShape3D").shape
		var height = shape.size.y
		final_pos = hit_pos + (hit_normal * height * 0.5)
		var grid_y = 0.1

	

		final_pos.x = snapped(final_pos.x, 1.0)
		final_pos.z = snapped(final_pos.z, 1.0)
		#final_pos.y = hit_pos.y
		final_pos.y = snapped(hit_pos.y, grid_y)
	
		
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
	clear_current_item()
	current_item.add_child(current_block)
	group_of_current_block = current_block.get_groups()


func clear_current_item() ->void:
	var child = current_item.get_child(0)
	if child:
		child.queue_free()
