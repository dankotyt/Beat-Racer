class_name TrackSelector
extends RefCounted

class TrackSelectionStrategy:
	func select_track(tracks: Array) -> String: return ""

class RandomStrategy extends TrackSelectionStrategy:
	func select_track(tracks: Array) -> String: return tracks.pick_random()

static func create_strategy(mode: String) -> TrackSelectionStrategy:
	return RandomStrategy.new() if mode == "random" else null
