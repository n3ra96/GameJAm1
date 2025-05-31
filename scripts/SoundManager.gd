extends AudioStreamPlayer

var success_sound = preload("res://sounds/success.ogg")
var failure_sound = preload("res://sounds/failure.ogg")
var tension_sound = preload("res://sounds/tension.ogg")

func play_feedback(score_change):
	if score_change > 0:
		stream = success_sound
	elif score_change < -3:
		stream = failure_sound
	else:
		stream = tension_sound
	
	play()
