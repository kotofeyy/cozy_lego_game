extends MeshInstance3D


func _ready() -> void:
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	
	for x in range(-8, 9):
		for y in range(-8, 9):
			mesh.surface_add_vertex(Vector3(-8, 0, x))
			mesh.surface_add_vertex(Vector3(8, 0, x))
			mesh.surface_add_vertex(Vector3(-8, 0, y))
			mesh.surface_add_vertex(Vector3(8, 0, y))
			
			mesh.surface_add_vertex(Vector3(y, 0, -8))
			mesh.surface_add_vertex(Vector3(y, 0, 8))
			mesh.surface_add_vertex(Vector3(x, 0, -8))
			mesh.surface_add_vertex(Vector3(x, 0, 8))

	mesh.surface_end()
