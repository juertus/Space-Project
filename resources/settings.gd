class_name UserSettings extends Resource

@export_range(0, 1, .05) var music_volume_level: float = 1.0
@export_range(0, 1, .05) var sfx_volume_level: float = 1.0

func save() -> void:
	ResourceSaver.save(self, "user://settings.tres")

static func load_or_create() -> UserSettings:
	var res: UserSettings = load("user://settings.tres") as UserSettings
	if !res:
		res = UserSettings.new()
	return res



