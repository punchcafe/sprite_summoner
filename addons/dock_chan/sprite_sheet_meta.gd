class_name SpriteSheetMeta
extends Resource

var max_frames: int
var animations := {}

static func from(sheet_name, directory_name):
	var all_frames = _all_animation_frames(sheet_name, directory_name)
	return all_frames.reduce(SpriteSheetMeta._reduce_animation_frames, SpriteSheetMeta.new())
	
static func _reduce_animation_frames(sprite_sheet_meta: SpriteSheetMeta, cell: AnimationCellFile) -> SpriteSheetMeta:
	var cells = sprite_sheet_meta.animations.get(cell.animation_name, [])
	cells.append(cell)
	sprite_sheet_meta.animations[cell.animation_name] = cells
	sprite_sheet_meta.max_frames = max(cell.cell_number, sprite_sheet_meta.max_frames)
	return sprite_sheet_meta

static func _all_animation_frames(animation_name, directory_name):
	print("hello")
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

func animation_count() -> int:
	return self.animations.keys().size()

func _to_string():
	var template = "max_frames: 	{max_frames}\nanimation_count: {animation_count}\nsheet: {sheet}"
	return template.format({"max_frames": self.max_frames, "animation_count": self.animation_count(), "sheet": self.animations})
