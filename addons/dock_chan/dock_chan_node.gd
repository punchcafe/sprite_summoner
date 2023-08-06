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
	print(SpriteSheetMeta.from(self.animation_name, $SheetDirectory.text))

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

