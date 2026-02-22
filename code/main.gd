extends Node3D

@onready var camera_3d: Camera3D = $Camera3D


#region вращение камеры
var rotation_speed := 0.01
var distance := 15.0
var zoom_speed = 1.0
var yaw := -2.3
var pitch := 0.6
#endregion



func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_released("ui_scroll_up"):
		distance -= zoom_speed
		_update_camera_position()

	if Input.is_action_just_released("ui_scroll_down"):
		distance += zoom_speed
		_update_camera_position()

	if event is InputEventMouseMotion and Input.is_action_pressed("mouse_middle_action"):
		# Двигаем мышь → вращаем вокруг центра
		yaw -= event.relative.x * rotation_speed
		pitch += event.relative.y * rotation_speed
		
		# Ограничим угол, чтобы не переворачивалась камера
		pitch = clamp(pitch, deg_to_rad(-89), deg_to_rad(89))
		print("yaw - ", yaw)
		print('pitch - ', pitch)
		_update_camera_position()


func _update_camera_position():
	# Центр вокруг которого вращаем
	var target = Vector3.ZERO

	# Считаем позицию камеры по углам yaw/pitch
	var offset = Vector3(
		distance * cos(pitch) * sin(yaw),
		distance * sin(pitch),
		distance * cos(pitch) * cos(yaw)
	)

	camera_3d.position = target + offset
	camera_3d.look_at(target)


func _on_tiles_button_pressed() -> void:
	GlobalEvents.change_block.emit(ItemTypes.type.TILES_BASE)


func _on_chair_button_pressed() -> void:
	GlobalEvents.change_block.emit(ItemTypes.type.CHAIR_BASE)
