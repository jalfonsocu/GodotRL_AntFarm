extends CharacterBody2D


@export var speed = 100
@export var rotation_speed = 1.8

@export var energy = 100

var rotation_direction = 0

signal health_depleted


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
		print($RayCast2D_Center.get_collider())
		print(distance_to_collider($RayCast2D_Center))
	if $RayCast2D_CenterLeft.is_colliding():
		print($RayCast2D_CenterLeft.get_collider())
		print(distance_to_collider($RayCast2D_CenterLeft))
	if $RayCast2D_CenterRight.is_colliding():
		print($RayCast2D_CenterRight.get_collider())
		print(distance_to_collider($RayCast2D_CenterRight))
		


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


