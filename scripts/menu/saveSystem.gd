extends Node

const SAVE_PATH := "user://savegame.dat"
const SALT_PATH := "user://save_salt.dat"  # Отдельный файл для хранения соли

var player_data := {
	"unlocked_levels": 1,
	"scores": {},
	"version": "1.0"
}

var _data_salt := ""  

func _ready():
	load_salt()     
	load_game()    

func load_salt():
	if FileAccess.file_exists(SALT_PATH):
		var file = FileAccess.open(SALT_PATH, FileAccess.READ)
		if file != null:
			_data_salt = file.get_as_text()
			file.close()
		else:
			generate_new_salt()
	else:
		generate_new_salt()

func generate_new_salt():
	_data_salt = generate_random_string(64)
	var file = FileAccess.open(SALT_PATH, FileAccess.WRITE)
	if file != null:
		file.store_string(_data_salt)
		file.close()

func generate_random_string(length: int) -> String:
	var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()"
	var random = RandomNumberGenerator.new()
	random.randomize()
	var result = ""
	for i in range(length):
		result += chars[random.randi() % chars.length()]
	return result

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		save_game()
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("Failed to load save file")
		return
	
	var encrypted_data = file.get_as_text()
	file.close()
	
	if not validate_save_data(encrypted_data):
		push_error("Save data validation failed - possible tampering detected!")
		reset_save_data()
		return
	
	var json_data = encrypted_data.split("|")[0]
	var json = JSON.new()
	var result = json.parse(json_data)
	
	if result == OK:
		player_data = json.get_data()
	else:
		push_error("Error parsing save data: " + json.get_error_message())
		reset_save_data()

func reset_save_data():
	player_data = {
		"unlocked_levels": 1,
		"scores": {},
		"version": "1.0"
	}
	save_game()
	print("Save data reset to defaults due to validation failure")

func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Failed to save game")
		return
	
	var json_data = JSON.stringify(player_data)
	var checksum = calculate_checksum(json_data)
	var save_data = json_data + "|" + checksum
	
	file.store_string(save_data)
	file.close()

func validate_save_data(data: String) -> bool:
	var parts = data.split("|")
	if parts.size() != 2:
		return false
	
	var save_data = parts[0]
	var provided_checksum = parts[1]
	var calculated_checksum = calculate_checksum(save_data)
	
	return provided_checksum == calculated_checksum

func calculate_checksum(data: String) -> String:
	var hasher = HashingContext.new()
	hasher.start(HashingContext.HASH_SHA256)
	hasher.update((data + _data_salt).to_utf8_buffer())
	return hasher.finish().hex_encode()

# === Методы для работы с прогрессом ===

func unlock_next_level():
	player_data["unlocked_levels"] += 1
	save_game()

func get_unlocked_levels() -> int:
	return player_data["unlocked_levels"]

func save_level_score(level_name: String, score: int):
	if not player_data["scores"].has(level_name) or player_data["scores"][level_name] < score:
		player_data["scores"][level_name] = score
		save_game()

func get_level_score(level_name: String) -> int:
	return player_data["scores"].get(level_name, 0)

func get_save_identifier() -> String:
	return _data_salt.md5_text().substr(0, 8)
