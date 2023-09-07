if !File.exists?("GameCheats.ini")
	new_file = IniFile.new
	new_file.filename = "GameCheats.ini"
	new_file.write()
	sleep 1
end
sleep 0.1
$CheatsINI = IniFile.load("GameCheats.ini")
sleep 0.9

module FileGetter
	def self.cheat_load(section="", cheat="", default_value="")
		return $CheatsINI[section][cheat] if $CheatsINI.has_section?(section)
		return default_value
	end

	def self.cheat_save(section="", cheat="", value)
		$CheatsINI[section][cheat] = value
		$CheatsINI.save
	end
end
