extends Area2D

@export var max_food_amount = 50
@export var food_amount = 50
signal food_depleted(area)


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = str(food_amount)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _to_string():
	return "Food"
	
func update_food_amount(bite):
	var size = 0
	if food_amount <= bite:
		food_amount = 0
		food_depleted.emit(self)
		
	else:
		food_amount = food_amount - bite

	$Label.text = str(food_amount)
	return size
	
func refill():
	food_amount = max_food_amount

