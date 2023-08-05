class_name AnimationCellFile
extends Resource

static func from_file(file_name: String, directory: String):
	var regex = RegEx.new()
	regex.compile(_regex_expression())
	print(file_name)
	var search = regex.search(file_name)
	assert(search)
	var sheet_name = search.get_string(1)
	var animation_name = search.get_string(2)
	var cell_number = int(search.get_string(3))
	return AnimationCellFile.new(cell_number, animation_name, sheet_name, directory)
	
static func is_sheet_cell(sheet_name: String, file_name: String):
	var regex = RegEx.new()
	regex.compile(_regex_expression())
	var search = regex.search(file_name)
	return true if search and search.get_string(1) == sheet_name else false
	
static func _regex_expression():
	return "^([^\\.]+)\\.([^\\.]+)\\.(\\d+)\\.(png)" + "$"
	
var cell_number: int
var animation_name: String
var sheet_name: String
var directory: String

func _init(cell_number: int, animation_name: String, sheet_name: String, directory: String):
	self.cell_number = cell_number
	self.animation_name = animation_name
	self.sheet_name = sheet_name
	self.directory = directory
	
	
func _to_string():
	var template = "\nsheet: {sheet}	animation: {animation}	cell: {cell}	dir: {dir}"
	return template.format({"sheet": self.sheet_name, "animation": self.animation_name, "cell": self.cell_number, "dir": self.directory})
