extends Node

class_name CameraController

@export
var camera: Camera3D

@export
var min_camera_range: float = 2

@export
var move_speed_factor: float = 1.1

var target: Node3D

var following: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if not camera:
		camera = get_viewport().get_camera_3d()
	pass # Replace with function body.

func set_target(t: Node3D):
	following = false
	target = t
	camera.get_parent().remove_child(camera)
	target.add_child(camera)
	camera.position = Vector3.ZERO
	camera.rotation =  Vector3.ZERO


func follow_target(t: Node3D):
	# Set camera root to root.
	var pos = camera.global_position
	var rot = camera.global_rotation
	camera.get_parent().remove_child(camera)
	get_tree().root.add_child(camera)
	camera.global_position = pos
	camera.global_rotation = rot
	
	# Follow target mode on
	following = true
	target = t

func _follow(delta):
	# get direction vector
	var dir: Vector3 = target.global_position - camera.global_position

	# Determine how far we need to move the camera
	var velocity = max(0, dir.length() - min_camera_range) ** move_speed_factor * delta
	camera.global_position += dir.normalized() * velocity
	# make camera look at target
	camera.look_at(target.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if following:
		_follow(delta)
