@tool
extends Camera3D
class_name ProVehicleCamera

@export_group("Target Tracking")
@export var follow_this: Node3D
@export var follow_distance: float = 5.0
@export var follow_height: float = 2.0

@export_group("Physics & Elasticity")
@export var speed: float = 20.0

@export_group("Dynamic FOV")
@export var enable_fov_warp: bool = true
@export var minimum_fov: float = 70.0
@export var maximum_fov: float = 85.0
@export var top_speed_threshold: float = 40.0
@export var fov_smooth_speed: float = 5.0

@export_group("Visual Juice")
@export var enable_banking: bool = true
@export var banking_intensity: float = 0.5
@export var enable_look_back: bool = true
@export var look_back_action: String = "look_back"

var _shake_intensity: float = 0.0
var _shake_duration: float = 0.0
var _shake_timer: float = 0.0

func _ready() -> void:
	set_as_top_level(true)

func _physics_process(delta: float) -> void:
	if not follow_this: return
	
	# Skip logic if in editor and not running game
	if Engine.is_editor_hint(): return

	var car_origin: Vector3 = follow_this.global_transform.origin
	var car_basis: Basis = follow_this.global_transform.basis
	
	var is_looking_back: bool = false
	if enable_look_back and InputMap.has_action(look_back_action):
		is_looking_back = Input.is_action_pressed(look_back_action)
	
	# 1. ELASTIC TETHER
	if is_looking_back:
		var forward_vector = car_basis.z * follow_distance
		forward_vector.y = follow_height
		global_position = global_position.lerp(car_origin + forward_vector, speed * delta)
	else:
		var drift_vector = (global_position - car_origin)
		drift_vector.y = 0.0
		if drift_vector.is_zero_approx():
			drift_vector = -car_basis.z
		else:
			drift_vector = drift_vector.normalized()
			if drift_vector.dot(-car_basis.z) < -0.99:
				drift_vector = drift_vector.rotated(Vector3.UP, 0.05)
			drift_vector = drift_vector.slerp(-car_basis.z, 2.0 * delta)
		var target_position: Vector3 = car_origin + (drift_vector * follow_distance)
		target_position.y = car_origin.y + follow_height
		global_position = global_position.lerp(target_position, speed * delta)
	
	# 2. DYNAMIC FOV
	if enable_fov_warp:
		var car_speed: float = 0.0
		if "linear_velocity" in follow_this: car_speed = follow_this.linear_velocity.length()
		elif "current_speed" in follow_this: car_speed = follow_this.current_speed
		var target_fov: float = lerp(minimum_fov, maximum_fov, clamp(car_speed / top_speed_threshold, 0.0, 1.0))
		fov = lerp(fov, target_fov, fov_smooth_speed * delta)
	
	# 3. LOOK DIRECTION
	look_at(car_origin, Vector3.UP)
	
	# 4. CORNER BANKING
	if enable_banking:
		var tilt_target = 0.0
		if "steering" in follow_this: tilt_target = follow_this.steering * banking_intensity
		rotation.z = lerp(rotation.z, -tilt_target * 0.2, speed * delta)
		
	# 5. CAMERA SHAKE
	if _shake_timer > 0.0:
		_shake_timer -= delta
		var random_offset: Vector3 = Vector3(
			randf_range(-_shake_intensity, _shake_intensity),
			randf_range(-_shake_intensity, _shake_intensity),
			randf_range(-_shake_intensity, _shake_intensity)
		)
		global_position += random_offset
		_shake_intensity = lerp(_shake_intensity, 0.0, delta * (1.0 / _shake_duration))

func trigger_shake(intensity: float, duration: float) -> void:
	_shake_intensity = intensity
	_shake_duration = duration
	_shake_timer = duration
