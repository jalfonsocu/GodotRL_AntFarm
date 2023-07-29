extends Area2D

@export var food_amount = 20


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = str(food_amount)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _to_string():
	return "Food"
	
func update_label():
	$Label.text = str(food_amount)


