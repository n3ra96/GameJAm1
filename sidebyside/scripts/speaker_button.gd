extends TextureButton

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	# For now, just print that the button was pressed
	# Later this can be connected to actual text-to-speech functionality
	print("Speaker button pressed - Text to speech would play here") 