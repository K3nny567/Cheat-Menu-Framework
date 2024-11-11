module DataManager
  self.singleton_class.send(:alias_method, :update_Lang_CHEATMENUFRAMEWORK, :update_Lang)

	def self.update_Lang
    	update_Lang_CHEATMENUFRAMEWORK
		$mod_cheats.updateText
	end
end
