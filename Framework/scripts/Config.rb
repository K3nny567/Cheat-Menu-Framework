class CheatsConfig

  attr_reader :ini

  def initialize(ini_file)
    unless File.exists?(ini_file)
      @ini = IniFile.new
      @ini.filename = ini_file
      @ini.write()
      sleep 1
    end
    sleep 0.1
    @ini = IniFile.load(ini_file)
    sleep 0.9
  end

  def read(section = "", cheat = "", default_value = "")
    @ini.read
    return @ini[section][cheat] if @ini.has_section?(section)
    return default_value
  end

  def write(section = "", cheat = "", value)
    @ini[section][cheat] = value
    @ini.save
  end

  def readHotkey
    hotkey = read("Cheats Mod - Hotkeys", "CheatMenu", "Agrave")
    $mod_cheats.hotkey = hotkey.to_sym
  end
  def writeHotkey
    write("Cheats Mod - Hotkeys", "CheatMenu", $mod_cheats.hotkey.to_s)
  end
end
