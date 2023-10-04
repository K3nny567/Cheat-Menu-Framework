module Battle_System
	alias_method :take_skill_effect_nofriendlyfire, :take_skill_effect
	def take_skill_effect(user,skill,can_sap=false,force_hit=false)
		#-- Companion is hit by player
		if $game_player.actor == user && self.master == $game_player
			return map_token.perform_dodge unless skill.is_support
		end
		#-- Companion is hit by player's projectile
		if (user.class == Game_PorjectileCharacter || user.class == Game_DestroyableObject) && user.event && user.event.summon_data[:user] == $game_player && self.master == $game_player
			return map_token.perform_dodge unless skill.is_support
		end
		take_skill_effect_nofriendlyfire(user,skill,can_sap,force_hit)
	end
end

class Game_Actor
	alias_method :take_skill_effect_nofriendlyfire, :take_skill_effect
	def take_skill_effect(user,skill,can_sap=false,force_hit=false)
		#-- Companion hits player
		if self == $game_player.actor && user.master == $game_player
			return map_token.perform_dodge unless skill.is_support
		end
		#-- Companion's projectile hits player
		#-- Comment out if bugs
		#if (user.class == Game_PorjectileCharacter || user.class == Game_DestroyableObject) && user.event && user.event.summon_data[:user]
		#	return map_token.perform_dodge unless skill.is_support
		#end
		take_skill_effect_nofriendlyfire(user,skill,can_sap,force_hit)
	end
end
