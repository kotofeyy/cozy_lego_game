extends Node3D

@onready var camera_3d: Camera3D = $Camera3D

var rotation_speed := 0.01
var distance := 10.0
var zoom_speed = 1.0
var yaw := 0.0
var pitch := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_released("ui_scroll_up"):
		distance -= zoom_speed
		_update_camera_position()

	if Input.is_action_just_released("ui_scroll_down"):
		distance += zoom_speed
		_update_camera_position()

	if event is InputEventMouseMotion and Input.is_action_pressed("mouse_action"):
		# Двигаем мышь → вращаем вокруг центра
		yaw -= event.relative.x * rotation_speed
		pitch += event.relative.y * rotation_speed

		# Ограничим угол, чтобы не переворачивалась камера
		pitch = clamp(pitch, deg_to_rad(-89), deg_to_rad(89))

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
