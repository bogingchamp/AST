extends KinematicBody

func _ready():
	Signals.connect("pressed", self, "_on_pressed")

func _on_pressed():
	$AnimationPlayer.play("open")
