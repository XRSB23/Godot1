extends Node
class_name Formatting

static func SpaceNumbers(n : int) -> String:
	if n == null : return ""
	
	var _str = str(n)
	_str = _str.reverse()
	var array = _str.split()
	
	@warning_ignore("integer_division")
	var count = array.size() / 3
	for i in range(count, 0, -1) :
		array.insert(3*i, " ")

	_str = "".join(array)
	_str = _str.reverse()
	
	return _str
