module GIM_CHCG
  def combat_remove_random_equip(eqp_target=rand(10),summon=true)
    return if $game_player.actor.equips[eqp_target].nil?
    return if !$game_player.actor.equips[eqp_target].item_name
    return if $game_player.actor.equips[eqp_target].addData["key"]
    return if $game_player.actor.equips[eqp_target].type_tag.eql?("Bondage")
    return if $game_player.actor.equips[eqp_target].type_tag.eql?("Hair")
    return if $game_player.actor.equips[eqp_target].type_tag.eql?("Debug")
    tar_name = $game_player.actor.equips[eqp_target].item_name
    $game_player.actor.change_equip(eqp_target, nil)
    tarType = eqp_target==0 ? "Weapon" : "Armor"
    # $game_party.drop_tgt_item_and_summon(tarType,tar_name,1,summon)
    $game_player.actor.update_state_frames
    $game_player.update
  end #def
end
