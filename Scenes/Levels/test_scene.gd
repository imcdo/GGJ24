extends Node3D

@onready
var camera_controller: CameraController = $Controllers/CameraController as CameraController

@onready
var cannon: Cannon = $Cannon as Cannon


# Called when the node enters the scene tree for the first time.
func _ready():
	camera_controller.set_target(cannon.get_camera_target())

func _process(_delta):
	$AimCircle.set_radius(cannon.aim_radius)

func _on_nose_finish(nose: Nose):
	print("reset")
	camera_controller.set_target(cannon.get_camera_target())
	cannon.active = true
	$AimCircle.toggle()

func _on_cannon_on_fire(nose: Nose):
	camera_controller.follow_target(nose)
	nose.on_finish.connect(_on_nose_finish)
	cannon.active = false
	$AimCircle.toggle()
