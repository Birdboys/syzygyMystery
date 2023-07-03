extends Node

@onready var operations = ['help','go','look','use','examine','map','inventory','speak','take']
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func parseCommand(command): #PARSE USER COMMAND
	var tokens = command.to_lower().split(' ').slice(1,) #split string and slice to get tokens
	var op = tokens[0] #first thing should be command
	if op not in operations:
		return null
	else:
		return {'operation':op,'data':tokens.slice(1,)}
