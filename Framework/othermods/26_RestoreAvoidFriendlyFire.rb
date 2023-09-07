class Game_Actor
	def avoid_friendly_fire?(skill)
		return false if skill.blocking? || skill.is_support
		return false if [2,3].include?(skill.projectile_type)
		skill.hit_detection.any_friendly_inrange?(map_token)
	end
end
