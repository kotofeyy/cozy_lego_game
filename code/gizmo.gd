extends MeshInstance3D


func _ready() -> void:
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	
	mesh.surface_add_vertex(Vector3(0, 0, 0))
	mesh.surface_add_vertex(Vector3(0, 2, 0))
	
	mesh.surface_add_vertex(Vector3(0, 0, 0))
	mesh.surface_add_vertex(Vector3(0, 0, 2))
	
	mesh.surface_add_vertex(Vector3(0, 0, 0))
	mesh.surface_add_vertex(Vector3(2, 0, 0))

	mesh.surface_end()
