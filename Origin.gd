extends Node2D

var food_scene = preload("res://Food.tscn")

#var food = []
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	for n in 10:
		var food = food_scene.instantiate()
		food.position = Vector2(rng.randi_range(10, 1000), rng.randi_range(10, 1000))
		food.food_depleted.connect(relocate_food_area)
		add_child(food)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_character_body_2d_health_depleted():
	print("Liberado")
	#$CharacterBody2D.queue_free()


func relocate_food_area(area):
	area.position = Vector2(rng.randi_range(10, 1000), rng.randi_range(10, 1000))
	area.refill()
