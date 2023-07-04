extends defaultRoom
class_name entryRoom
#LIST OF ROOMS - [entry, closet, bathroom, kitchen, living room, balcony]

func _init():
	name = 'entry'
	adjacent = ['kitchen','closet','bathroom','bedroom']
	outside = false
	objects = [defaultObject.new('door',['door'],['under']),
	defaultObject.new('coat_rack',['coat','coats','rack','hanger']),
	defaultObject.new('mail_slot',['mail','slot']),
	#defaultObject.new('peephole', ['peep','hole','peephole']),
	defaultObject.new('floor_mat',['mat', 'rug'], ['under'])]
	look_text = 'entry_default'

