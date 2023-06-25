extends CharacterBody2D


@export var speed = 100
@export var rotation_speed = 1.8

@export var energy = 100
var center_collider_type = 0
var left_collider_type = 0
var right_collider_type = 0

var center_collider_distance = -1
var left_collider_distance = -1
var right_collider_distance = -1

var rotation_direction = 0

signal health_depleted
signal eat


func _ready():
	$Timer.start()

func get_input():
	rotation_direction = Input.get_axis("left", "right")
	velocity = transform.x * Input.get_axis("down", "up") * speed
	
	if Input.is_action_pressed("up"):
		$AnimatedSprite2D.play("walk")
	if Input.is_action_just_released("up"):
		$AnimatedSprite2D.stop()

func _physics_process(delta):
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()

func _process(delta):
	if $RayCast2D_Center.is_colliding():
		center_collider_type = detect_object_type($RayCast2D_Center.get_collider())
		center_collider_distance = distance_to_collider($RayCast2D_Center)
	else:
		center_collider_distance = -1
		center_collider_type = 0
		
	if $RayCast2D_CenterLeft.is_colliding():
		left_collider_type = detect_object_type($RayCast2D_CenterLeft.get_collider())
		left_collider_distance = distance_to_collider($RayCast2D_CenterLeft)
	else:
		left_collider_distance = -1
		left_collider_type = 0
	
	if $RayCast2D_CenterRight.is_colliding():
		right_collider_type = detect_object_type($RayCast2D_CenterRight.get_collider())
		right_collider_distance = distance_to_collider($RayCast2D_CenterRight)
	else:
		right_collider_distance = -1
		right_collider_type = 0



func _on_timer_timeout():
	energy = energy -1
	$Label.text = str(energy)
	if energy <= 0:
		health_depleted.emit()
		
func distance_to_collider(ray):
	var distance = -1
	if ray.is_colliding():
		var origin = ray.global_transform.origin
		var collision_point = ray.get_collision_point()
		distance = origin.distance_to(collision_point)
	return distance

func detect_object_type(object):
	if  object.to_string() == "Food":
		return 1
	else:
		return 10
		
func eat_action():
	eat.emit()
	
