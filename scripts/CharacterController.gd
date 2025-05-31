extends Sprite2D
class_name CharacterController

func show_emotion(emotion_type):
	match emotion_type:
		"happy":
			modulate = Color.WHITE
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)
			tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)
		"angry":
			modulate = Color.RED
			var tween = create_tween()
			tween.tween_property(self, "rotation", 0.1, 0.1)
			tween.tween_property(self, "rotation", -0.1, 0.1)
			tween.tween_property(self, "rotation", 0, 0.1)
		"confused":
			modulate = Color.YELLOW
			var tween = create_tween()
			tween.tween_property(self, "position:y", position.y - 10, 0.3)
			tween.tween_property(self, "position:y", position.y, 0.3)
