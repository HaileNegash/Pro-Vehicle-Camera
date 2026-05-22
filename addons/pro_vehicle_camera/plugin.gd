@tool
extends EditorPlugin

func _enter_tree():
	# Registers the node. 'null' is used since there is no icon file.
	add_custom_type("ProVehicleCamera", "Camera3D", preload("pro_vehicle_camera.gd"), null)

func _exit_tree():
	remove_custom_type("ProVehicleCamera")
