extends Node3D

class_name Cannon

signal on_fire(nose: Nose)

@export
var horizontal_rotation_speed: float = .2

@export
var vertical_rotation_speed: float = 1

@export
var nose_scene: PackedScene = preload("res://Scenes/nose.tscn")

@export_range(0.0, 0.5)
var aim_percent: float = .75

@export_range(0.0, 0.5)
var max_aim_percent: float = .5

@onready
var wheels_obj: Node3D = $Wheels

@onready
var cannon_obj: Node3D = $Wheels/Cannon

@onready
var viewport: Viewport = get_viewport()

@onready
var _max_mouse_radius: float = min(get_viewport().size.x, get_viewport().size.y)

@onready
var _max_viewport_size: Vector2 = Vector2(viewport.size.x, viewport.size.y)

var aim_radius: float
var max_aim_radius: float

var active: bool = true

@export
var default_power: float = 20
@export
var max_power: float = 100
@export
var min_power: float = 10

var power: float:
	get:
		return default_power
	set(value):
		default_power = value
		

func _get_mouse_aim() -> Vector2:
	var mouse_position: Vector2 = viewport.get_mouse_position()
	var dir: Vector2 = mouse_position - (_max_viewport_size / 2)
	
	var length = dir.length()
	# Not aiming enough, skip
	if length < aim_radius:
		return Vector2.ZERO

	var mag = ((min(length, _max_mouse_radius) - aim_radius) / max_aim_radius)
	mag = min(mag, 1)
	
	return dir.normalized() * mag

func fire():
	if nose_scene:
		# var new_bullet: Node2D = bullet.instantiate()
		var nose = nose_scene.instantiate() as Nose
		get_tree().get_root().add_child(nose)
		nose.global_position = $Wheels/Cannon/NoseSpawn.global_position
		nose.rotation_degrees = $Wheels/Cannon/NoseSpawn.rotation_degrees
		nose.linear_velocity = -cannon_obj.get_global_transform().basis.z.normalized() * power
		on_fire.emit(nose)

# Called when the node enters the scene tree for the first time.
func _ready():
	_recalculate_values()
	
func _recalculate_values():
	_max_viewport_size = viewport.get_visible_rect().size
	var offset: Vector2 = _max_viewport_size * (1.0 - aim_percent)
	# calculate the radius
	aim_radius = min(offset.x, offset.y) / 2

	var max_offset: Vector2 = _max_viewport_size - _max_viewport_size * max_aim_percent
	max_aim_radius = min(max_offset.x, max_offset.y)
	
	_max_mouse_radius = min(get_viewport().size.x, get_viewport().size.y)
	_max_viewport_size = Vector2(viewport.size.x, viewport.size.y)

func get_camera_target() -> Node3D:
	return $Wheels/Cannon/CameraPos

func _aim_camera():
	var space_state = get_world_3d().direct_space_state
	var cannon_forward = - cannon_obj.get_global_transform().basis.z * 1000

	var origin = cannon_obj.global_position
	var end = origin + cannon_forward
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = true

	var result = space_state.intersect_ray(query)
	$Wheels/Cannon/CameraPos.look_at(result.get("position", cannon_forward))


func _physics_process(delta):
	_aim_camera()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		_recalculate_values()
		var aim: Vector2 = _get_mouse_aim() * delta
		wheels_obj.rotate_y(-aim.x)
		if abs(aim.x) < 0.001:
			cannon_obj.rotate_x(-aim.y)

		if Input.is_action_just_pressed("Fire"):
			fire()
			
		if Input.is_action_just_pressed("PowerUp"):
			power = min(power + 1, max_power)
		if Input.is_action_just_pressed("PowerDown"):
			power = max(power - 1, min_power)

		# clamp rotation
		cannon_obj.rotation.x = clamp(cannon_obj.rotation.x, deg_to_rad(-20), deg_to_rad(50))
