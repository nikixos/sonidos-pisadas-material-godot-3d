extends Node

const STEP_GRASS = {
	0: preload("res://Player/FootstepSounds/grass/Fantozzi-SandL1.ogg"),
	1: preload("res://Player/FootstepSounds/grass/Fantozzi-SandL2.ogg"),
	2: preload("res://Player/FootstepSounds/grass/Fantozzi-SandL3.ogg"),
	3: preload("res://Player/FootstepSounds/grass/Fantozzi-SandR1.ogg"),
	4: preload("res://Player/FootstepSounds/grass/Fantozzi-SandR2.ogg"),
	5: preload("res://Player/FootstepSounds/grass/Fantozzi-SandR3.ogg")
}

const STEP_STONE =  {
	0: preload("res://Player/FootstepSounds/grass/Fantozzi-StoneL1.ogg"),
	1: preload("res://Player/FootstepSounds/grass/Fantozzi-StoneR1.ogg"),
	2: preload("res://Player/FootstepSounds/grass/Fantozzi-StoneL3.ogg"),
	3: preload("res://Player/FootstepSounds/grass/Fantozzi-StoneR1.ogg"),
	4: preload("res://Player/FootstepSounds/grass/Fantozzi-StoneR2.ogg"),
	5: preload("res://Player/FootstepSounds/grass/Fantozzi-StoneR3.ogg")
}
const STEP_WOOD = {}
const STEP_TILE = {}
const STEP_METAL = {}
const STEP_FABRIC = {}
const STEP_SNOW = {}

func get_stepsound(profile :String):
	match profile:
		"GRASS":
			return STEP_GRASS[randi() % STEP_GRASS.size()]
		"STONE":
			return STEP_STONE[randi() % STEP_STONE.size()]
		"WOOD":
			return STEP_WOOD[randi() %STEP_WOOD.size()]
		"TILE":
			return STEP_TILE[randi() % STEP_TILE.size()]
		"METAL":
			return STEP_METAL[randi() % STEP_METAL.size()]
		"FABRIC":
			return STEP_FABRIC[randi() % STEP_FABRIC.size()]
		"SNOW":
			return STEP_SNOW[randi() % STEP_SNOW.size()]
