extends Control

var animation_name := ""
var height := 0
var width := 0

func _ready():
	$SelectSheetDir.connect("button_up", call_me)
	$Generate.connect("button_up", on_press_generate)
	$SelectOutDir.connect("button_up", on_select_out_dir_click)
	$FileDialog.connect("dir_selected", on_project_dir_selected)
	$SelectOutDirDialogue.connect("dir_selected", on_out_dir_selected)
	$SheetName.connect("text_changed", on_sheet_name_update)
	$HeightBox.connect("text_changed", on_height_update)
	$WidthBox.connect("text_changed", on_width_update)

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
	
func on_width_update():
	self.width = int($WidthBox.text)
	_maybe_enable_generate()

func on_height_update():
	self.height = int($HeightBox.text)
	_maybe_enable_generate()
	
func on_select_out_dir_click():
	$SelectOutDirDialogue.visible = !$SelectOutDirDialogue.visible	
	
func on_press_generate():
	var sprite_sheet = SpriteSheetMeta.from(self.animation_name, $SheetDirectory.text)
	print(sprite_sheet)
	var out_file = $OutDirectory.text + "/" + sprite_sheet.name + ".png" 
	_render_image(sprite_sheet).save_png(out_file)

func _maybe_enable_generate():
	var should_enable = $SheetDirectory.text != "" and animation_name != "" and $OutDirectory.text
	if should_enable:
		$Generate.disabled = false
	else:
		$Generate.disabled = true

func _process(delta):
	pass
	
func _render_image(sprite_sheet: SpriteSheetMeta):
	var width = sprite_sheet.max_frames * self.width
	var height = sprite_sheet.animation_count() * self.height
	var image = Image.create(width, height, false, Image.FORMAT_RGBA8)
	var animations = sprite_sheet.animations
	for i in animations.keys().size():
		var animation_key = animations.keys()[i]
		var animation = animations.get(animation_key)
		for cell in animation:
			var cell_image = Image.load_from_file(cell.path)
			cell_image.resize(self.width, self.height)
			var x = (cell.cell_number - 1) * self.width
			var y = i * self.height
			var cell_rect = Rect2i(0, 0, self.width, self.height)
			image.blend_rect(cell_image, cell_rect, Vector2i(x, y))
	return image
	
func _regex_expression(sheet_name):
	return "^" + sheet_name + "\\.([^\\.]+)\\.(\\d+)\\.(png)" + "$"

