extends Control

@onready var inputText = $inputText
@onready var logText = $textStuff/logText
@onready var lookImage = $imagePanel/lookImage
@onready var spaceStrip = RegEx.new()
@onready var lookText = $imagePanel/Panel/lookText
@onready var scrollVal := 0.05
signal issue_command(command)
# Called when the node enters the scene tree for the first time.
func _ready():
	spaceStrip.compile('\\s+')
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _on_input_text_text_submitted(new_text):
	logText.finishTyping()
	var command = new_text.to_lower().strip_edges()
	inputText.clear()
	inputText.insert_text_at_caret('> ')
	command = spaceStrip.sub(command, ' ', true)
	if len(command.split(' ')) > 1:
		emit_signal("issue_command", command)
		

func addLogText(t):
	#logText.text += 
	logText.finishTyping()
	var com = t +'\n'
	var ratio = float(len(com))/(len(logText.get_parsed_text()) + len(com))
	var time_step = ratio/len(com)
	#print(len(com), ratio, time_step)
	logText.append_text(t +'\n')
	$typewriterTimer.start(scrollVal)
	logText.startTyping(1-ratio, time_step)

func updateTheme(t):
	theme = t

func updateLookImage(im, t):
	lookImage.texture = load("res://Assets/temp_rooms/%s/%s.png" % [t, im])
func updateShopImage(t):
	$mapPanel/mapImage.texture = load("res://Assets/maps/map_%s.png" % t)
func updateLookText(t):
	lookText.text = t

func enterMap(theme_name):
	$mapPanel/mapImage.texture = load("res://Assets/maps/map_%s.png" % theme_name)
	$mapPanel.visible = true
	$imagePanel.visible = false

func closeMenu(menu):
	$imagePanel.visible = true
	match menu:
		1: $mapPanel.visible = false

func _on_log_text_done_typing():
	$typewriterTimer.stop()
	pass # Replace with function body.
