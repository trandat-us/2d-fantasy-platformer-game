extends MarginContainer
class_name EquipmentDetailContainer

@onready var max_hp_value_label: Label = %MaxHpValueLabel
@onready var atk_value_label: Label = %AtkValueLabel
@onready var def_value_label: Label = %DefValueLabel
@onready var speed_value_label: Label = %SpeedValueLabel
@onready var atk_speed_value_label: Label = %AtkSpeedValueLabel
@onready var crit_rate_value_label: Label = %CritRateValueLabel
@onready var crit_dmg_value_label: Label = %CritDmgValueLabel

func init_stats(stats: Stats):
	if stats is PlayerStats:
		max_hp_value_label.text = str(stats.max_health.value)
		atk_value_label.text = str(stats.attack)
		def_value_label.text = str(stats.defense)
		speed_value_label.text = str(stats.speed)
		crit_rate_value_label.text = str(stats.crit_rate) + " %"
		crit_dmg_value_label.text = str(stats.crit_damage) + " %"
		
		stats.stat_changed.connect(_on_stat_changed)

func _on_stat_changed(stat_name: StringName, value: Variant):
	match stat_name:
		StatName.MAX_HEALTH:
			max_hp_value_label.text = str(value)
		StatName.DEFENSE:
			def_value_label.text = str(value)
		StatName.ATTACK:
			atk_value_label.text = str(value)
		StatName.SPEED:
			speed_value_label.text = str(value)
		StatName.CRIT_RATE:
			crit_rate_value_label.text = str(value) + " %"
		StatName.CRIT_DAMAGE:
			crit_dmg_value_label.text = str(value) + " %"
