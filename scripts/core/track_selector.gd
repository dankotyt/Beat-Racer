class_name TrackSelector
extends RefCounted

# Паттерн "Стратегия"
class TrackSelectionStrategy extends RefCounted:
	func select_track(tracks: Array) -> String: 
		return ""

class RandomStrategy extends TrackSelectionStrategy:
	func select_track(tracks: Array) -> String: 
		return tracks.pick_random()

class FirstTrackStrategy extends TrackSelectionStrategy:
	func select_track(tracks: Array) -> String:
		return tracks[0] if tracks.size() > 0 else ""

# Фабричный метод создания стратегий
static func create_strategy(mode: String) -> TrackSelectionStrategy:
	match mode:
		"random": return RandomStrategy.new()
		"first": return FirstTrackStrategy.new()
		_: return null
