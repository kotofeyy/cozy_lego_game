extends Camera3D

var target = Vector3(2.0, 0.0, 2.0)
var rotation_speed := 0.01
var distance := 10.0
var zoom_speed = 1.0
var yaw := -2.4
var pitch := 0.6
var dir: Vector3
var move_speed = 10


func _process(delta: float) -> void:
	var dir = Vector3.ZERO

	# Берём направления из pivot (где хранится вращение)
	var forward = -global_transform.basis.z
	var right = global_transform.basis.x

	# Убираем вертикальную составляющую
	forward.y = 0
	right.y = 0

	# Нормализуем после обнуления Y
	forward = forward.normalized()
	right = right.normalized()

	if Input.is_action_pressed("move_forward"):
		dir += forward
	if Input.is_action_pressed("move_back"):
		dir -= forward
	if Input.is_action_pressed("move_left"):
		dir -= right
	if Input.is_action_pressed("move_right"):
		dir += right

	if dir != Vector3.ZERO:
		dir = dir.normalized()
		var move = dir * move_speed * delta
		global_translate(move)
		target += move

func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_released("ui_scroll_up"):
		distance -= zoom_speed
		_update_camera_position()

	if Input.is_action_just_released("ui_scroll_down"):
		distance += zoom_speed
		_update_camera_position()

	if event is InputEventMouseMotion and Input.is_action_pressed("mouse_middle_action"):
		distance = global_position.distance_to(target)
		# Двигаем мышь → вращаем вокруг центра
		yaw -= event.relative.x * rotation_speed
		pitch += event.relative.y * rotation_speed
		
		# Ограничим угол, чтобы не переворачивалась камера
		pitch = clamp(pitch, deg_to_rad(-89), deg_to_rad(89))
		_update_camera_position()


func _update_camera_position():
	# Центр вокруг которого вращаем
	#var target = Vector3.ZERO
	# Считаем позицию камеры по углам yaw/pitch
	var offset = Vector3(
		distance * cos(pitch) * sin(yaw),
		distance * sin(pitch),
		distance * cos(pitch) * cos(yaw)
	)

	position = target + offset
	look_at(target)
