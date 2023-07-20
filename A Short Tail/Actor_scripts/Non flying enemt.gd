extends KinematicBody

var velocity := Vector3.ZERO

export var speed := 500.0

onready var sprite : Sprite3D = $Sprite3D
onready var sprite_1 : Sprite3D = $Sprite3D2
onready var sprite_2 : Sprite3D = $Sprite3D3
onready var sprite_3 : Sprite3D = $Sprite3D4

onready var anim : AnimationPlayer = $AnimationPlayer

onready var model = $MeshInstance

onready var timer = $Timer

var health = 10
var player_health = 10

var space_state
var target

var dead = false
var ent_1 = false

var attacks = [1, 2, 3, 4]
var attack : int

var ent : bool = false

func _ready():
	space_state = get_world().direct_space_state

func _rand_attack() -> void:
	randomize()
	
	var item
	
	item = randi() % attacks.size()
	
	if item == 0:
		sprite.show()
		sprite_1.hide()
		sprite_2.hide()
		sprite_3.hide()
		anim.play("sword")
		attack = 0
	
	elif item == 1:
		sprite.hide()
		sprite_1.show()
		sprite_2.hide()
		sprite_3.hide()
		anim.play("bow")
		attack = 1
	
	elif item == 2:
		sprite.hide()
		sprite_1.hide()
		sprite_2.show()
		sprite_3.hide()
		anim.play("rod")
		attack = 2
	
	elif item == 3:
		sprite.hide()
		sprite_1.hide()
		sprite_2.hide()
		sprite_3.show()
		anim.play("wand")
		attack = 3

var r_a : int

func _input(_event):
	
		if attack == 0:
			if ent == true:
				if Input.is_action_pressed("A") and Input.is_action_pressed("X"):
					health -= 5
					if dead == false and ent == true:
						_rand_attack()
	
		if attack == 1:
			if ent == true:
				if Input.is_action_pressed("Y") and Input.is_action_pressed("D_L"):
					health -= 5
					if dead == false and ent == true:
						_rand_attack()
	
		if attack == 2:
			if ent == true:
				if Input.is_action_pressed("X") and Input.is_action_pressed("D_R"):
					health -= 5
					if dead == false and ent == true:
						_rand_attack()
	
		if attack == 3:
			if ent == true:
				if Input.is_action_pressed("Y") and Input.is_action_pressed("X"):
					health -= 5
					if dead == false and ent == true:
						_rand_attack()

func _process(delta):
	if health == 0:
		dead = true
		self.queue_free()
	
	if target:
		var result = space_state.intersect_ray(global_transform.origin, target.global_transform.origin)
		if result.collider.is_in_group("player"):
			look_at(target.global_transform.origin, Vector3.UP)
			set_color_red()
			move_to_target(delta)
		else:
			set_color_green()

func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		ent = true

func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		ent = false

func set_color_red():
	model.get_surface_material(0).set_albedo(Color(1, 0, 0)) #sets the color to re

func set_color_green():
	model.get_surface_material(0).set_albedo(Color(0, 1, 0)) #sets to color to green

func _on_FOV_body_entered(body):
	if body.is_in_group("player"):
		target = body
		set_color_green()
		_rand_attack()
		timer.start()

func _on_FOV_body_exited(body):
	if body.is_in_group("player"):
		target = null
		set_color_red()
		timer.stop()

func move_to_target(delta):
	var direction = target.transform.origin - transform.origin #the direction is the distance between these two points
	direction.y = 0
	direction = direction.normalized()
	
	var threshold = 5.0
	var distance = (target.transform.origin - transform.origin).length()
	
	if distance >  threshold:
		move_and_slide(direction * speed * delta, Vector3.UP)

func _on_Timer_timeout():
	Signals.emit_signal("damage_player")
