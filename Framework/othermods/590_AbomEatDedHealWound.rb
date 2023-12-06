class Game_Actor
  alias_method :check_Abom_heal_HealthSta_HEALWOUND, :check_Abom_heal_HealthSta

  def check_Abom_heal_HealthSta(tmpCost = 10)
    self.heal_wound
    check_Abom_heal_HealthSta_HEALWOUND(tmpCost)
  end
end
