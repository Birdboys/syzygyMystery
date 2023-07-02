extends Node2D

@onready var UI = $UILAYER/UI
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_ui_issue_command(command):
	UI.addLogText("[b]%s[/b]" %(command))
	var parsed_command = Parser.parseCommand(command)
	if parsed_command == null:	
		UI.addLogText("I don't know what you mean")
		return
	match parsed_command['operation']:
		'help': executeHelp(parsed_command)
		'look': executeLook(parsed_command)
		'talk': executeTalk(parsed_command)
		'use': executeUse(parsed_command)
		'go': executeGo(parsed_command)
		'map': executeMap(parsed_command)
		'inventory': executeInventory(parsed_command)
		'examine': executeExamine(parsed_command)
		_ : print("THE FUCK JUST HAPPENED")
	

#['help','go','look','use','examine','map','inventory','talk']
func executeLook(command_data):
	print("EXECUTING LOOK COMMAND")
func executeHelp(command_data):
	print("EXECUTING HELP COMMAND")
func executeMap(command_data):
	print("EXECUTING MAP COMMAND")
func executeUse(command_data):
	print("EXECUTING USE COMMAND")
func executeGo(command_data):
	print("EXECUTING GO COMMAND")
func executeExamine(command_data):
	print("EXECUTING EXAMINE COMMAND")
func executeInventory(command_data):
	print("EXECUTING INVENTORY COMMAND")
func executeTalk(command_data):
	print("EXECUTING TALK COMMAND")

