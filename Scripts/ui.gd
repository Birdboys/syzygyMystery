extends Control

@onready var inputText = $inputText
@onready var logText = $textStuff/logText
@onready var lookImage = $imagePanel/lookImage
@onready var spaceStrip = RegEx.new()
@onready var lookText = $imagePanel/lookText
signal issue_command(command)
# Called when the node enters the scene tree for the first time.
func _ready():
	spaceStrip.compile('\\s+')
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _on_input_text_text_submitted(new_text):
	var command = new_text.to_lower().strip_edges()
	inputText.clear()
	inputText.insert_text_at_caret('> ')
	command = spaceStrip.sub(command, ' ', true)
	if len(command.split(' ')) > 1:
		emit_signal("issue_command", command)

func addLogText(t, add_space=false):
	if add_space:
		logText.append_text('  '+ t +'\n')
	else:
		logText.append_text(t +'\n')

func updateTheme(t):
	theme = t

func updateLookImage(im, t):
	lookImage.texture = load("res://Assets/temp_rooms/%s/%s.png" % [t, im])

func updateLookText(t):
	lookText.text = t
