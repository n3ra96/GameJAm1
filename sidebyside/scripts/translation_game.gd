extends Control

# Game state variables
var relationship_score = 50  # 0-100 scale
var tension_level = 0
var current_conversation = 0
var game_over = false

# UI References
@onready var friend_sprite = $/root/BarLevel/friend
@onready var date_sprite = $/root/BarLevel/date
@onready var dialogue_box = $/root/BarLevel/UI/DialoguePanel
@onready var original_text = $/root/BarLevel/UI/DialoguePanel/VBoxContainer/OriginalTextPanel/OriginalText
@onready var choice_container = $/root/BarLevel/UI/DialoguePanel/VBoxContainer/ChoiceContainer
@onready var relationship_bar = $/root/BarLevel/UI/StatusPanel/HBoxContainer/RelationshipSection/RelationshipBar
@onready var tension_bar = $/root/BarLevel/UI/StatusPanel/HBoxContainer/TensionSection/TensionBar
@onready var friend_reaction = $/root/BarLevel/UI/StatusPanel/HBoxContainer/ReactionSection/FriendReaction

# Character positions
var friend_center_pos = Vector2(496.0, 233.0)  # Friend stands to the left of center
var date_center_pos = Vector2(79, 234)    # Date stands to the right of center

# Conversation data
var conversations = [
	{
		"original": "שלום, נעים להכיר (Hello, nice to meet you)",
		"context": "Your friend's date just greeted him",
		"choices": [
			{"text": "She says hello and nice to meet you", "score": 2, "reaction": "Good start!"},
			{"text": "She's asking about your salary", "score": -5, "reaction": "WHAT?! Why would you..."},
			{"text": "She wants to know if you're single", "score": -2, "reaction": "Dude, we just met..."},
			{"text": "She says you look like her ex", "score": -8, "reaction": "*glares at you*"}
		]
	},
	{
		"original": "אני אוהבת לטייל בטבע (I love hiking in nature)",
		"context": "She's talking about her hobbies",
		"choices": [
			{"text": "She loves hiking and being in nature", "score": 3, "reaction": "Nice! I love hiking too!"},
			{"text": "She wants to climb mountains with you", "score": 1, "reaction": "That's... specific?"},
			{"text": "She hates staying indoors", "score": -1, "reaction": "Hmm, that's not quite..."},
			{"text": "She says you look out of shape", "score": -6, "reaction": "WHY would she say that?!"}
		]
	},
	{
		"original": "המשפחה שלי מאוד חשובה לי (My family is very important to me)",
		"context": "She's getting more personal",
		"choices": [
			{"text": "Family is really important to her", "score": 4, "reaction": "That's beautiful"},
			{"text": "She wants to meet your parents soon", "score": -3, "reaction": "Isn't it too early for that?"},
			{"text": "She comes from a big family", "score": 1, "reaction": "That's nice to know"},
			{"text": "She thinks your family is weird", "score": -7, "reaction": "She doesn't even know them!"}
		]
	}
]

func _ready():
	setup_initial_positions()
	await walk_to_center()
	setup_ui()
	# Wait a bit before starting first conversation
	await get_tree().create_timer(1.0).timeout
	start_conversation()

func setup_initial_positions():
	# Position characters off-screen for walking entrance
	date_sprite.position = Vector2(-400, 248.0)    # Date starts from far left
	friend_sprite.position = Vector2(1000, 244.0)   # Friend starts from far right
	
	# Set initial animation states
	date_sprite.set_animation_state("idle")
	friend_sprite.set_animation_state("idle")

func walk_to_center():
	print("Characters walking to center...")
	
	# Start walking animations
	date_sprite.set_animation_state("walk")
	friend_sprite.set_animation_state("walk")
	
	# Create tween for smooth movement
	var tween = create_tween()
	tween.parallel().tween_property(date_sprite, "position", date_center_pos, 2.0)
	tween.parallel().tween_property(friend_sprite, "position", friend_center_pos, 2.0)
	
	# Wait for walking to complete
	await tween.finished
	
	# Set to idle after walking
	date_sprite.set_animation_state("idle")
	friend_sprite.set_animation_state("idle")
	
	print("Characters reached center positions")

func setup_ui():
	relationship_bar.value = relationship_score
	tension_bar.value = tension_level
	# Hide dialogue initially
	dialogue_box.visible = false

func start_conversation():
	if current_conversation < conversations.size():
		print("Starting conversation ", current_conversation + 1)
		
		# Show dialogue box
		dialogue_box.visible = true
		
		# Set characters to wait state
		friend_sprite.set_animation_state("wait")
		date_sprite.set_animation_state("wait")
		
		# Small pause before date starts talking
		await get_tree().create_timer(0.5).timeout
		
		display_conversation(conversations[current_conversation])
	else:
		end_game()

func display_conversation(conv_data):
	print("Displaying conversation: ", conv_data.original)
	
	# Clear previous choices
	for child in choice_container.get_children():
		child.queue_free()
	
	# Date starts talking
	date_sprite.set_animation_state("talk")
	
	# Set original text
	original_text.text = conv_data.original + "\n\n" + conv_data.context
	
	# Let the date talk for a moment before showing choices
	await get_tree().create_timer(2.5).timeout
	
	# Date stops talking and waits
	date_sprite.set_animation_state("wait")
	
	# Create choice buttons
	for i in range(conv_data.choices.size()):
		var button = Button.new()
		button.text = conv_data.choices[i].text
		button.pressed.connect(_on_choice_selected.bind(i))
		choice_container.add_child(button)
	
	print("Choices displayed, waiting for player selection...")

func _on_choice_selected(choice_index):
	print("Choice selected: ", choice_index)
	
	var choice_data = conversations[current_conversation].choices[choice_index]
	
	# Hide choice buttons immediately
	for child in choice_container.get_children():
		child.queue_free()
	
	# Friend (translator) starts talking
	friend_sprite.set_animation_state("talk")
	
	# Update scores
	relationship_score += choice_data.score
	relationship_score = clamp(relationship_score, 0, 100)
	
	if choice_data.score < 0:
		tension_level += abs(choice_data.score)
		tension_level = clamp(tension_level, 0, 100)
	
	# Show friend's reaction while friend is talking
	show_friend_reaction(choice_data.reaction)
	
	# Update status bars
	update_status_bars()
	
	# Let friend talk for a moment
	await get_tree().create_timer(2.0).timeout
	
	# Friend stops talking
	friend_sprite.set_animation_state("wait")
	
	# Show character emotions based on response
	await show_character_reactions(choice_data.score)
	
	# Wait before checking game over or continuing
	await get_tree().create_timer(1.0).timeout
	
	# Check for game over conditions
	if relationship_score <= 10 or tension_level >= 80:
		print("Game over condition met")
		await get_tree().create_timer(1.0).timeout
		end_game()
		return
	
	# Move to next conversation
	current_conversation += 1
	
	# Wait before starting next conversation
	await get_tree().create_timer(1.5).timeout
	start_conversation()

func show_character_reactions(score_change: int):
	print("Showing character reactions for score change: ", score_change)
	
	# Determine emotions based on score
	if score_change > 2:
		friend_sprite.show_emotion("happy")
		date_sprite.show_emotion("happy")
	elif score_change < -3:
		friend_sprite.show_emotion("angry")
		date_sprite.show_emotion("angry")
	elif score_change < 0:
		friend_sprite.show_emotion("confused")
		date_sprite.show_emotion("confused")
	else:
		friend_sprite.show_emotion("neutral")
		date_sprite.show_emotion("neutral")
	
	# Wait for emotions to be displayed
	await get_tree().create_timer(1.5).timeout
	
	# Return to neutral waiting state
	friend_sprite.set_animation_state("wait")
	date_sprite.set_animation_state("wait")

func show_friend_reaction(reaction_text):
	friend_reaction.text = reaction_text
	friend_reaction.modulate = Color.WHITE
	
	if "!" in reaction_text and ("WHAT" in reaction_text or "WHY" in reaction_text):
		friend_reaction.modulate = Color.RED
	elif "Nice" in reaction_text or "Good" in reaction_text:
		friend_reaction.modulate = Color.GREEN
	
	# Fade out after delay
	var tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_property(friend_reaction, "modulate:a", 0.0, 0.5)

func update_status_bars():
	var tween = create_tween()
	tween.parallel().tween_property(relationship_bar, "value", relationship_score, 0.5)
	tween.parallel().tween_property(tension_bar, "value", tension_level, 0.5)

func get_ending_text(score: int) -> String:
	if score >= 80:
		return "Perfect! They're planning a second date!\nYour friend: 'You're the best wingman ever!'"
	elif score >= 60:
		return "Good job! They exchanged numbers.\nYour friend: 'Thanks for the help!'"
	elif score >= 40:
		return "Not bad. They're still talking.\nYour friend: 'Could have been better...'"
	elif score >= 20:
		return "Awkward... but salvageable.\nYour friend: 'Next time, maybe Google Translate?'"
	else:
		return "Disaster! She left early.\nYour friend: *gives you THE LOOK*"

func end_game():
	print("Game ending with relationship score: ", relationship_score)
	game_over = true
	
	# Special animation if tension is maxed
	if tension_level >= 80:
		date_sprite.show_emotion("angry")
		friend_sprite.show_emotion("angry")
		await get_tree().create_timer(2.0).timeout
	
	# Clear any remaining choices
	for child in choice_container.get_children():
		child.queue_free()
	
	# Show ending based on score
	var ending_text = get_ending_text(relationship_score)
	original_text.text = ending_text
	
	# Set final character states based on outcome
	if relationship_score >= 60:
		friend_sprite.show_emotion("happy")
		date_sprite.show_emotion("happy")
	elif relationship_score >= 20:
		friend_sprite.show_emotion("confused")
		date_sprite.set_animation_state("wait")
	else:
		friend_sprite.show_emotion("angry")
		date_sprite.show_emotion("angry")
	
	# Wait before showing restart button
	await get_tree().create_timer(2.0).timeout
	
	# Add restart button
	var restart_btn = Button.new()
	restart_btn.text = "Try Again?"
	restart_btn.pressed.connect(restart_game)
	choice_container.add_child(restart_btn)

func restart_game():
	print("Restarting game...")
	relationship_score = 50
	tension_level = 0
	current_conversation = 0
	game_over = false
	
	# Reset characters to starting positions
	setup_initial_positions()
	
	# Clear dialogue
	dialogue_box.visible = false
	for child in choice_container.get_children():
		child.queue_free()
	
	# Restart the sequence
	await walk_to_center()
	setup_ui()
	await get_tree().create_timer(1.0).timeout
	start_conversation()
