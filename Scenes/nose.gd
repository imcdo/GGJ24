extends RigidBody3D

class_name Nose

signal on_finish(nose: Nose)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()

func end():
	print("fart")
	on_finish.emit(self)

	queue_free()

func _on_timer_timeout():
	end()

func _on_body_entered(body):
	if body is Clown:
		print("HIT")
		freeze = true
		$Timer.paused = true

		on_finish.emit(self)

func _process(delta):
	if linear_velocity.length() < .000001 and angular_velocity.length() < .000001:
		end()
