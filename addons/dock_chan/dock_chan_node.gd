extends Control

var animation_name := ""

func _ready():
	$SelectSheetDir.connect("button_up", call_me)
	$Generate.connect("button_up", on_press_generate)
	$SelectOutDir.connect("button_up", on_select_out_dir_click)
	$FileDialog.connect("dir_selected", on_project_dir_selected)
	$SelectOutDirDialogue.connect("dir_selected", on_out_dir_selected)
	$SheetName.connect("text_changed", on_sheet_name_update)

func call_me():
	$FileDialog.visible = !$FileDialog.visible

func on_project_dir_selected(dir):
	$SheetDirectory.text = dir
	_maybe_enable_generate()
	
func on_out_dir_selected(dir):
	$OutDirectory.text = dir
	_maybe_enable_generate()

func on_sheet_name_update():
	self.animation_name = $SheetName.text
	_maybe_enable_generate()
	
func on_select_out_dir_click():
	$SelectOutDirDialogue.visible = !$SelectOutDirDialogue.visible	
	
func on_press_generate():
	print(_all_animation_frames(self.animation_name, $SheetDirectory.text))

func _maybe_enable_generate():
	var should_enable = $SheetDirectory.text != "" and animation_name != "" and $OutDirectory.text
	if should_enable:
		$Generate.disabled = false
	else:
		$Generate.disabled = true

func _process(delta):
	pass
	
func _regex_expression(sheet_name):
	return "^" + sheet_name + "\\.([^\\.]+)\\.(\\d+)\\.(png)" + "$"
	
func _all_animation_frames(animation_name, directory_name):
	var regex = RegEx.new()
	regex.compile(_regex_expression(animation_name))
	
	var dir = DirAccess.open(directory_name)
	var accumulator = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var full_file_name = directory_name + "/" + file_name
		while file_name != "":
			if dir.current_is_dir():
				accumulator += accumulator + _all_animation_frames(animation_name, full_file_name)
			else:
				if AnimationCellFile.is_sheet_cell(animation_name, file_name):
					accumulator.append(AnimationCellFile.from_file(file_name, directory_name))
			file_name = dir.get_next()
			full_file_name = directory_name + "/" + file_name
	else:
		print("An error occurred when trying to access the path. " + directory_name)
	return accumulator

