extends Control

@onready var inputText = $inputText
@onready var logText = $textStuff/logText
@onready var lookImage = $imagePanel/lookImage
@onready var spaceStrip = RegEx.new()
@onready var bbStrip = RegEx.new()
@onready var lookText = $imagePanel/Panel/lookText
@onready var scrollVal := 0.05
signal issue_command(command) 
signal map_pressed(dude)
signal inventory_pressed(dude)
signal menu_closed
# Called when the node enters the scene tree for the first time.
func _ready():
	spaceStrip.compile('\\s+')
	bbStrip.compile("\\[.*?\\]")
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
		

func addLogText(t, reset=false):
	#logText.text += 
	
	logText.finishTyping()
	var length = len(bbStrip.sub(t, "", true))
	var ratio = float(length)/(len(logText.get_parsed_text()) + length)
	var time_step = ratio/length
	
	#print(len(com), ratio, time_step)
	logText.append_text(t +'\n')
	if reset:
		logText.finishTyping()
		return
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
	
func enterInventory(theme_name, lines):
	$inventoryPanel.visible = true
	$imagePanel.visible = false
	$inventoryPanel/inventoryText.clear()
	
	for item in lines:
		var res = TextLoader.getLookText(item[1], item[0], "inv", "at")
		print(res)
		$inventoryPanel/inventoryText.append_text("[b]%s[/b] found in [b]%s[/b]: %s\n" %[item[0].to_upper(),item[1].to_upper(),res])

func closeMenu(menu):
	$imagePanel.visible = true
	match menu:
		1: $mapPanel.visible = false; addLogText("Closed map")
		2: $inventoryPanel.visible = false; addLogText("Closed inventory")

func _on_log_text_done_typing():
	$typewriterTimer.stop()
	pass # Replace with function body.

func _on_map_button_pressed():
	emit_signal("map_pressed", null)
func _on_inventory_button_pressed():
	emit_signal("inventory_pressed", null)


func _on_close_map_button_down():
	emit_signal("menu_closed")
	closeMenu(1)
	pass # Replace with function body.

func _on_close_inventory_pressed():
	emit_signal("menu_closed")
	closeMenu(2)
	pass # Replace with function body.
