module GIM_CHCG
  def combat_remove_random_equip_exec(tar_name,eqp_target=rand(10),summon=true)
		$game_player.actor.change_equip(eqp_target, nil)
		weaponSlots = System_Settings::EQUIP::WEAPON_SLOTS
		tarType = weaponSlots.include?(eqp_target) ? "Weapon" : "Armor"
		#$game_party.drop_tgt_item_and_summon(tarType,tar_name,1,summon)
		if weaponSlots.include?(eqp_target) && summon
			SndLib.sound_combat_sword_hit_sword(vol=80,effect=65+rand(10))
		else
			SndLib.sound_DressTear(vol=80,effect=75+rand(10))
		end
		$game_player.actor.update_state_frames
		$game_player.update
	end #def
end
