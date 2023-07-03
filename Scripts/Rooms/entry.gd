extends defaultRoom
class_name entryRoom
#LIST OF ROOMS - [entry, closet, bathroom, kitchen, living room, balcony]

func _init():
	name = 'entry'
	adjacent = ['kitchen','closet','bathroom','bedroom']
	outside = false
	objects = [defaultObject.new('door',['door'])]
	look_text = 'entry_default'

