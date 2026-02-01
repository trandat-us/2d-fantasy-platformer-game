extends PointLight2D

@export var flicker_intensity: float = 0.3
@export var flicker_speed: float = 2.0

var og_energy: float
var noise: FastNoiseLite
var time: float = 0.0

func _ready() -> void:
	og_energy = energy
	
	# Setup noise
	noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.frequency = 0.5

func _process(delta: float) -> void:
	time += delta * flicker_speed
	
	# Get noise value (-1 to 1) and apply flicker
	var noise_value = noise.get_noise_1d(time)
	energy = og_energy + (noise_value * flicker_intensity)
