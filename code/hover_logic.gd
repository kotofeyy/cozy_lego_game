class_name HoverLogic
extends StaticBody3D


func _ready() -> void:
	mouse_entered.connect(_on_hover_on_item)
	mouse_exited.connect(_on_unhover_on_item)


func _on_hover_on_item() -> void:
	for child in get_children():
		if child is MeshInstance3D:
			var new_material = child.get_surface_override_material(0).duplicate()
			new_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			new_material.albedo_color.a = 0.7
			child.set_surface_override_material(0, new_material)


func _on_unhover_on_item() -> void:
	for child in get_children():
		if child is MeshInstance3D:
			var new_material = child.get_surface_override_material(0).duplicate()
			new_material.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED
			child.set_surface_override_material(0, new_material)
