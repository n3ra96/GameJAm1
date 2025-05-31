extends Node

# Audio player for Hebrew sentences
@onready var audio_player = AudioStreamPlayer.new()

func _ready():
	add_child(audio_player)

func play_sentence(hebrew_text: String):
	# Extract just the Hebrew text from the full string if needed
	var clean_text = hebrew_text.replace("[center][b]Original:[/b] ", "").replace("[/center]", "")
	clean_text = clean_text.split(" (")[0]  # Remove English translation if present
	
	# Convert the clean text to a valid filename
	var audio_file = "res://audio/" + clean_text + ".mp3"
	
	# Try to load and play the audio file
	var audio_stream = load(audio_file)
	if audio_stream:
		audio_player.stream = audio_stream
		audio_player.play()
	else:
		print("No audio file found for: ", clean_text) 