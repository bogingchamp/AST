extends KinematicBody

var can_jump = true

var pos

var health_var = 10

export var jump_force := 20.0
export var speed := 9.0
export var grav := 60.0

var velocity := Vector3.ZERO

var camera_speed := 0.07

onready var model: MeshInstance = $MeshInstance
onready var spring_arm: SpringArm = $SpringArm
onready var ray = $RayCast
onready var hearts = $Label

func _ready():
	set_physics_process(false)
	if model and spring_arm and ray != null:
		set_physics_process(true)
	Signals.connect("damage_player", self, "health")

func _process(_delta):
	if health_var == 0:
		get_tree().change_scene("res://Scenes/GO.tscn")
	hearts = str(health_var)

func _physics_process(_delta: float): 
	var move_direction := Vector3()
	
	move_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	move_direction.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	move_direction = move_direction.rotated(Vector3.UP, spring_arm.rotation.y).normalized() 
	
	pos = move_direction
	
	if velocity.length() > 0.2: 
		var look_direction = Vector2(velocity.z, velocity.x)
		model.rotation.y = look_direction.angle()
	
	velocity.x = move_direction.x * speed
	velocity.z = move_direction.z * speed
	
	velocity.y -= grav * _delta 
	
	if Input.get_action_strength("B") and is_on_floor():
		_jump()
	
	velocity = move_and_slide(velocity, Vector3.UP) 
	if Input.get_action_strength("l_d"): 
		spring_arm.rotation.x -= camera_speed
	elif Input.get_action_strength("l_u"):
		spring_arm.rotation.x += camera_speed
	elif Input.get_action_strength("l_r"):
		spring_arm.rotation.y -= camera_speed
	elif Input.get_action_strength("l_l"):
		spring_arm.rotation.y += camera_speed
	
	spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg2rad(-75), deg2rad(30))

func health():
	health_var -= 5

func _jump():
	velocity.y += jump_force
