extends StaticBody

onready var anim = $AnimationPlayer

func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		anim.play("pressed")
		Signals.emit_signal("pressed")

func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		anim.play_backwards("pressed")
