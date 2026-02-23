extends Node3D

@onready var current_item: Node = $CurrentItem


var build_delay = 0.11  # Пауза между блоками в секундах
var build_timer = 0.0   # Текущий отсчет
var group_of_current_block
var current_block: StaticBody3D
var delete_mode := false


func _ready() -> void:
	GlobalEvents.change_block.connect(change_block)


func _process(delta: float) -> void:
	var info = get_mouse_3d_pos()
	var pos = info["pos"]
	var group = info["type"]
	var object = info["collider"]
	if current_block:
		if pos:
			current_block.global_position = pos
			current_block.visible = true
		else:
			current_block.visible = false

	if build_timer > 0:
		build_timer -= delta
	
	if Input.is_action_pressed("mouse_action") and build_timer <= 0:
		if get_viewport().gui_get_hovered_control():
			return
		
		if delete_mode:
			if group:
				if group.has("placeable"):
					object.queue_free()
		else:
			# чтобы плитки не ставились друг на друга, проверяю по группам
			if not group == group_of_current_block:
				draw_select_color(false)
				place_block()
				build_timer = build_delay # Сбрасываем таймер
				draw_select_color(true)


	# вращение
	if Input.is_action_just_pressed("rotate_left"):
		if current_block:
			current_block.rotation_degrees.y += 90
			print("rotation - ", current_block.rotation_degrees)
	if Input.is_action_just_pressed("rotate_right"):
		if current_block:
			current_block.rotation_degrees.y -= 90
			print("rotation - ", current_block.rotation_degrees)


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
	if current_block:
		query.exclude = [current_block.get_rid()] 
	
	var result = space_state.intersect_ray(query)
	
	var final_pos
	var type
	var collider

	if result:
		var hit_pos = result.position
		var hit_normal = result.normal # Вектор грани (например, Vector3.UP)
		
		collider = result.collider
		if current_block:
			var shape = current_block.get_node("CollisionShape3D").shape
			var height = shape.size.y
			final_pos = hit_pos + (hit_normal * height * 0.5)
			var grid_y = 0.1
			var grid_z = 0.5
			var grid_x = 0.5
		

			final_pos.x = snapped(final_pos.x, grid_x)
			final_pos.z = snapped(final_pos.z, grid_z)
			#final_pos.y = hit_pos.y
			final_pos.y = snapped(hit_pos.y, grid_y)
		
			
			type = collider.get_groups()
		type = collider.get_groups()
	return {
		"pos": final_pos,
		"type": type,
		"collider": collider
	}


func change_block(block) -> void:
	if block == ItemTypes.type.REMOVE:
		clear_current_item()
		delete_mode = true
	else:
		delete_mode = false
		var path = ItemTypes.Items[block]["path"]
		var new_block: PackedScene = load(path)
		current_block = new_block.instantiate()
		clear_current_item()
		current_item.add_child(current_block)
		draw_select_color(true)
		current_block.add_to_group("placeable")
		group_of_current_block = current_block.get_groups()


func clear_current_item() ->void:
	var child = current_item.get_child(0)
	if child:
		child.queue_free()


func draw_select_color(enable: bool) -> void:
	if current_block:
		for child in current_block.get_children():
			if child is MeshInstance3D:
				var material: StandardMaterial3D = child.get_surface_override_material(0).duplicate()
				if enable:
					material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
					material.albedo_color.a = 0.6
				else:
					material.albedo_color.a = 1.0
					material.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED
				child.set_surface_override_material(0, material)
