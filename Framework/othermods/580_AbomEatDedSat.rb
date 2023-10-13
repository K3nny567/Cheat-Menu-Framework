class Game_Actor
  def check_Abom_heal_HealthSta(tmpCost = 10)
    tmpSuccess = false
    tmpSTA = self.sta
    tmpStaMax = self.battle_stat.get_stat("sta", 2)
    tmpStaVS = ((tmpSTA - tmpStaMax).abs).to_i
    tmpHp = self.health
    tmpHpMax = self.battle_stat.get_stat("health", 2)
    tmpHpVS = 0
    tmpHpVS = ((tmpHp - tmpHpMax).abs).to_i
    tmpSat = self.sat
    tmpSatMax = self.battle_stat.get_stat("sat", 2)
    tmpSatVS = ((tmpSat - tmpSatMax).abs).to_i

    #self.sat -= tmpCost
    if $story_stats["Setup_Hardcore"] >= 1
      satScore = (tmpCost * 0.5).round
    else
      satScore = (tmpCost * 0.8).round
    end

    if tmpSatVS != 0 && satScore > 0
      tmpSatInc = ([tmpSatVS, satScore].min).to_i
      satScore -= tmpSatInc
      self.sat += tmpSatInc
    end
    if tmpStaVS != 0 && satScore > 0
      tmpStaInc = ([tmpStaVS, satScore].min).to_i
      satScore -= tmpStaInc
      self.sta += tmpStaInc
    end
    if tmpHpVS != 0 && satScore > 0
      tmpHpInc = ([tmpHpVS, satScore].min).to_i
      satScore -= tmpHpInc
      self.health += tmpHpInc
    end

    tmpSuccess = true
    tmpSuccess
  end
end

class Game_Event
  def abomEatDed
    user = @summon_data[:user]
    chkedNPC = $game_map.events_xy(user.x, user.y).select { |event|
      next if event == user
      next if event.deleted?
      next if !event.npc?
      next if event.actor.is_object
      next if event.actor.race == "Undead"
      next if !event.actor.dedAnimPlayed
      event
    }
    user.actor.add_state(160)
    if chkedNPC.empty?
      $game_map.popup(0, "QuickMsg:Lona/CannotWorks#{rand(2)}", 0, 0)
      SndLib.sys_buzzer
      return delete
    else
      @zoom_x = 1
      @zoom_y = 1
    end
    abomGrabSkillHoldEFX
    if !chkedNPC.empty?
      if user.actor.last_holding_count >= @summon_data[:skill].launch_max
        user.actor.remove_state_stack(49) #Sickly
        user.actor.remove_state_stack(30) #FeelsSick
        tmpTarHP = chkedNPC[0].actor.battle_stat.get_stat("health", 3) / 4
        tmpTarSAT = chkedNPC[0].actor.battle_stat.get_stat("sat", 3) / 5
        tmpTarSTA = chkedNPC[0].actor.battle_stat.get_stat("sta", 3) / 6
        bounsPointsToLona = tmpTarHP + tmpTarSTA + tmpTarSAT
        user.actor.check_Abom_heal_HealthSta(bounsPointsToLona)
        tmpHowManyBall = bounsPointsToLona / 50
        summonTimes = [tmpHowManyBall, 6].min
        summonTimes.times {
          EvLib.sum(["WasteJumpBloodToPlayer", "WasteJumpBloodToPlayer2"].sample, user.x, user.y)
        }
      else
        tmpTarHP = chkedNPC[0].actor.battle_stat.get_stat("health", 3)
        tmpTarSAT = chkedNPC[0].actor.battle_stat.get_stat("sat", 3)
        tmpTarSTA = chkedNPC[0].actor.battle_stat.get_stat("sta", 3)
        tmpTarATK = chkedNPC[0].actor.battle_stat.get_stat("def", 3)
        tmpTarDEF = chkedNPC[0].actor.battle_stat.get_stat("atk", 3)
        tmpTarSUR = chkedNPC[0].actor.battle_stat.get_stat("survival", 3)
        tmpData = {
          :user => user,
          :HP => tmpTarHP,
          :SAT => tmpTarSAT,
          :STA => tmpTarSTA,
          :ATK => tmpTarATK,
          :DEF => tmpTarDEF,
          :SUR => tmpTarSUR,
        }
        EvLib.sum("ProjAbomSumTentacle", user.x, user.y, tmpData)
        tmpBakDir = user.direction
        user.combat_jump_reverse
        user.direction = tmpBakDir
      end
      EvLib.sum("EffectOverKillReverse", chkedNPC[0].x, chkedNPC[0].y)
      chkedNPC[0].effects = ["ZoomOutDelete", 0, false, nil, nil, [true, false].sample]
      if $game_player.actor.stat["BloodLust"] == 1 || $game_player.actor.stat["Cannibal"] == 1
        $game_player.actor.mood += 50
      else
        $game_player.actor.mood -= 10
      end
    end
  end
end
