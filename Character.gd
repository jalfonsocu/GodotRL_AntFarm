extends CharacterBody2D


@export var speed = 100
@export var rotation_speed = 1.8

@export var max_energy = 100
@export var energy = 100
@export var bite_size = 10

@onready var ai_controller = $AIController2D


var center_collider_type = 0
var left_collider_type = 0
var right_collider_type = 0

var center_collider_distance = -1
var left_collider_distance = -1
var right_collider_distance = -1


# temporary variables for increasing reward if distance to food decreases
var old_center_collider_distance = -1
var old_left_collider_distance = -1
var old_right_collider_distance = -1
# temporary variables for increasing reward if distance to food decreases

var food_area
var in_food_area = false

var rotation_direction = 0

signal health_depleted


func _ready():
	ai_controller.init(self)
	$Timer.start()
	
func game_over():
	ai_controller.done = true
	ai_controller.needs_reset = true

func get_input():
	#rotation_direction = Input.get_axis("left", "right")
	#velocity = transform.x * Input.get_axis("down", "up") * speed
	rotation_direction = ai_controller.turn_action
	velocity = transform.x * ai_controller.move_action * speed
	
	if ai_controller.move_action == 0 :
		$AnimatedSprite2D.stop()
	else:
		$AnimatedSprite2D.play("walk")
		
	if ai_controller.interact_action:
		eat_action()
	
	if Input.is_action_pressed("up"):
		$AnimatedSprite2D.play("walk")
	if Input.is_action_just_released("up"):
		$AnimatedSprite2D.stop()
	if Input.is_action_just_pressed("eat"):
		eat_action()
		
	

func _physics_process(delta):
	if ai_controller.needs_reset:
		ai_controller.reset()
		energy = max_energy
		return
		
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
	
#	for index in get_slide_collision_count():
#		var collision := get_slide_collision(index)
#		var body := collision.get_collider()
#		print("Collided with: ", body.name)

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
	ai_controller.reward -= 0.01
	$Label.text = str(energy)
	
	if old_center_collider_distance > center_collider_distance and center_collider_type == 1:
		ai_controller.reward += 0.01
	if old_left_collider_distance > left_collider_distance and left_collider_type == 1:
		ai_controller.reward += 0.01
	if old_right_collider_distance > right_collider_distance and right_collider_type == 1:
		ai_controller.reward += 0.01
	
	old_center_collider_distance = center_collider_distance
	old_left_collider_distance = left_collider_distance
	old_right_collider_distance = right_collider_distance
	
	if energy <= 0:
		ai_controller.done = true
		ai_controller.needs_reset = true
		health_depleted.emit()
		
func distance_to_collider(ray):
	var distance = -1
	if ray.is_colliding():
		var origin = ray.global_transform.origin
		var collision_point = ray.get_collision_point()
		distance = origin.distance_to(collision_point)
	return distance

func detect_object_type(object):
	if is_instance_valid(object):
		if  object.to_string() == "Food":
			ai_controller.reward += 0.01
			return 1
		if  object.to_string() == "Ant":
			return 2
		else:
			#ai_controller.reward -= 0.01
			return 10
		
func eat_action():
	if in_food_area:
		energy = energy + food_area.update_food_amount(bite_size)
		ai_controller.reward += 5.0
		if energy > max_energy:
			energy = max_energy
		$Label.text = str(energy)
	#in_food_area = false
	


func _on_area_2d_area_entered(area):
	print("Entrada en área")
	if detect_object_type(area) == 1:
		in_food_area = true
		food_area = area
		ai_controller.reward += 0.3
	


func _on_area_2d_area_exited(area):
	print("Salida área")
	print(area.to_string())
	in_food_area = false
	
