extends Node

@onready var operations = ['help','go','look','use','map','inventory','speak','take']
@onready var prepositions = ['above, at, behind, below, on, beneath, in, to, under, with']
@onready var closers = ['close','c','quit','q','exit']
@onready var real_words = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func parseCommand(command): #PARSE USER COMMAND
	var tokens = command.to_lower().split(' ').slice(1,) #split string and slice to get tokens
	var parsed_command = []
	var command_data = {'verb':null,'prep':null,'direct_object':null,'indirect_object':null}
	if tokens[0] not in operations: #make sure first thing is operation verb
		print("NOT A COMMAND VERB")
		return null
	for token in tokens: #get word data from list of real words
		if token in TextLoader.real_words:
			parsed_command.append([token,TextLoader.real_words[token], false])
	if len(parsed_command) == 0: #EMPTY
		return null
	if len(parsed_command) == 1: #ONLY VERB COMMAND
		if 'command' in parsed_command[0][1]:
			command_data['verb'] = parsed_command[0][0]
			print('parsable command')
			return command_data
		else:
			print('not parsable command')
			return null
			
	if 'command' in parsed_command[0][1] and 'noun' in parsed_command[len(parsed_command)-1][1]: #if first verb is command (SHOULD ALWAYS BE)
		parsed_command[0][2] = true
		command_data['verb'] = parsed_command[0][0]
		command_data['direct_object'] = parsed_command[len(parsed_command)-1][0]
		parsed_command[len(parsed_command)-1][2] = true
	for x in range(2,len(parsed_command)-1):
		if 'prep' in parsed_command[x][1] and 'noun' in parsed_command[x-1][1]: #if preposition set direct and indirect objects
			print("ENTERED THE PREP PIT")
			command_data['direct_object'] = parsed_command[x-1][0]
			parsed_command[x-1][2] = true
			command_data['indirect_object'] = parsed_command[len(parsed_command)-1][0]
			parsed_command[len(parsed_command)-1][2] = true
			command_data['prep'] = parsed_command[x][0]
			parsed_command[x][2] = true
			break
	if 'prep' in parsed_command[1][1]: #if preposition is second word
		if command_data['prep'] == null:
			command_data['prep'] = parsed_command[1][0]
		parsed_command[1][2] = true
		
			
	print(command_data)
	#print(parsed_command)
	if len(parsed_command.filter(func(data): return data[2] == false)) == 0:
		#print('parsable command')
		return command_data
	else:
		#print('not parsable command')
		return null

func parseCloseCommand(command):
	var tokens = command.to_lower().split(' ').slice(1,) #split string and slice to get tokens
	print(tokens)
	return tokens[0] in closers and len(tokens) == 1
