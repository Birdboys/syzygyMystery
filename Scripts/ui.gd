extends Control

@onready var inputText = $textStuff/inputText
@onready var logText = $textStuff/logBackground/logText

@onready var spaceStrip = RegEx.new()
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

func addLogText(t):
	logText.append_text('  '+ t +'\n')
