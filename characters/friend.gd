extends CharacterBody2D

@export var character_type: String = "friend"  # "friend" or "date"
var current_state: String = "idle"
var is_talking: bool = false

# Reference to the AnimatedSprite2D child node
@onready var animated_sprite = $Sprite2D

func _ready():
	if animated_sprite:
		animated_sprite.play("idle")

func set_animation_state(state: String):
	if not animated_sprite:
		print("Error: No AnimatedSprite2D child found!")
		return
		
	if current_state == state:
		return  # Don't restart same animation
		
	current_state = state
	is_talking = false
	
	match state:
		"idle":
			animated_sprite.play("idle")
		"wait":
			animated_sprite.play("wait")
		"talk":
			animated_sprite.play("talk")
			is_talking = true
		"walk":
			animated_sprite.play("walk")
		"punch":
			if character_type == "date":
				animated_sprite.play("punch")
				# Return to wait after punch
				await animated_sprite.animation_finished
				set_animation_state("wait")

func show_emotion(emotion_type: String):
	if not animated_sprite:
		return
		
	match emotion_type:
		"happy":
			animated_sprite.modulate = Color.WHITE
			# Add subtle bounce effect
			var tween = create_tween()
			tween.tween_property(animated_sprite, "scale", Vector2(1.05, 1.05), 0.2)
			tween.tween_property(animated_sprite, "scale", Vector2(1.0, 1.0), 0.2)
			
		"angry":
			animated_sprite.modulate = Color.RED
			# Add shake effect
			var tween = create_tween()
			for i in range(3):
				tween.tween_property(self, "position", position + Vector2(5, 0), 0.1)
				tween.tween_property(self, "position", position - Vector2(5, 0), 0.1)
			tween.tween_property(self, "position", position, 0.1)
				
		"confused":
			animated_sprite.modulate = Color.YELLOW
			# Add head tilt effect
			var tween = create_tween()
			tween.tween_property(animated_sprite, "rotation", 0.2, 0.3)
			tween.tween_interval(0.5)
			tween.tween_property(animated_sprite, "rotation", 0, 0.3)
			
		"neutral":
			animated_sprite.modulate = Color.WHITE

func start_talking():
	set_animation_state("talk")

func stop_talking():
	set_animation_state("idle")

func set_waiting():
	set_animation_state("wait")

func walk_animation():
	set_animation_state("walk")
