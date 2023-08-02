extends AIController2D


# Stores the action sampled for the agent's policy, running in python
var move_action : float = 0.0
var turn_action : float = 0.0
var interact_action := false

func get_obs() -> Dictionary:
	# gets the observation
	#var ball_pos = to_local(_player.ball.global_position)
	#var ball_vel = to_local(_player.ball.linear_velocity)
	#var obs = [ball_pos.x, ball_pos.z, ball_vel.x/10.0, ball_vel.z/10.0]
		
	var obs = [_player.left_collider_type, _player.center_collider_type, _player.right_collider_type,
	 _player.left_collider_distance, _player.center_collider_distance, _player.right_collider_distance, _player.in_food_area ]

	return {"obs":obs}

func get_reward() -> float:	
	return reward
	
func get_action_space() -> Dictionary:
	return {
		"move_action" : {
			"size": 1,
			"action_type": "continuous"
			},
		"turn_acion" : {
			"size": 1,
			"action_type": "continuous"
		},
		"interact_action" : {
			"size" : 1,
			"action_type": "discrete"
			}
		}
	
func set_action(action) -> void:	
	move_action = clamp(action["move_action"][0], -1.0, 1.0)
	turn_action = clamp(action["turn_acion"][0], -1.0, 1.0)
	interact_action = action["interact_action"] == 1
