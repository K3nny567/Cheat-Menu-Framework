# Cheats Mod Module - Unequip Items

#

module CheatUtils
  def self.unequipall(force)
    if self.ingame?
      $game_player.actor.equip_slots.size.times do |i|
        $game_player.actor.change_equip(i, nil) if $game_player.actor.equip_change_ok?(i) or force
        SndLib.sound_equip_armor
      end
    end
  end
end

module CheatsMod
  self.singleton_class.send(:alias_method, :cheat_triggers_CHEATSMODULE_UNEQUIPITEMS, :cheat_triggers)

  ##---------------------------------------------------------------------------
  ## Hotkeys
  ##---------------------------------------------------------------------------
  def self.cheat_triggers
    cheat_triggers_CHEATSMODULE_UNEQUIPITEMS
    if Input.trigger?(Input::F3)
      CheatUtils.unequipall(false)
    end
    if Input.press?(:SHIFT) && Input.trigger?(Input::F3)
      CheatUtils.unequipall(true)
    end
  end
end

$mod_cheats.modules["Unequip Items"] = true
