#===============================================================================
###	Main project file
### Mod: Cheat Menu Framework
###	Author: Kenny567
#===============================================================================

#Mod namespace
class CheatsMod
  attr_reader :version
  attr_reader :config
  attr_reader :configDir
  attr_reader :loadorder
  attr_reader :path
  attr_reader :modid
  attr_accessor :modules
  attr_accessor :addons
  attr_accessor :hotkey

  def initialize
    @version = '1.0-rc.11'
    @config = nil
    @configDir = nil
    @addons = nil
    @loadorder = nil
    @modid = "cheatmenu"
    @path = $mod_manager.mods[@modid].path
    @modules = {}
    @hotkey = nil
  end

  def init_configDir
    @configDir = System_Settings::USER_DATA_PATH + @modid

    # Check if the directory exists
    unless Dir.exist?(@configDir)
      # Create the directory if it doesn't exist
      Dir.mkdir(@configDir)
      puts "Directory created: #{@configDir}"
    else
      puts "Directory already exists: #{@configDir}"
    end
  end

  def init_config(ini_file)
    @config = CheatsConfig.new(ini_file)
  end

  def init_addons
    @addons = Plugins.new("#{@path}")
    addons = {
      :path => "#{@addons.root_path}/addons",
      :order => @loadorder,
      :exclude => [
      ]
    }
    @addons.load_files(addons)
  end

  def init_loadorder(file)
    unless File.exist?(file)
      default_loadorder = [
          "UnlockTool", "UnequipItems", "InvEdit", "Summons",
          "Race", "Pregnancy", "StatsEdit", "HairColorEdit",
          "MoralityEdit", "Legacy", "AbomSkills", "DeepSkill", "Dirt",
          "InfiniteMainStats", "AutoBandage", "AutoClean", "InfiniteMoney"
        ]
      
      File.open(file, 'w') {
        |lo_file|

        lo_file.write(JSON.encode(default_loadorder))
        lo_file.close
      }
    end
    json_file = File.open(file)
    @loadorder = JSON.decode(json_file.read())
    @loadorder << :rest
    json_file.close
  end

  def getText(text_flag)
    return $game_text["#{@modid}:#{text_flag}"]
  end

  def getResource(id, resource)
    return $mod_manager.get_resource(id, resource)
  end

  #Include a single script
  def import(dir, file)
    FileGetter.load_from_list(FileGetter.getFileList(getResource("#{@modid}", "#{dir}/#{file}.rb")))
  end

  #Include scripts from path
  def imports(dir)
    FileGetter.load_from_list(FileGetter.getFileList(getResource("#{@modid}", "#{dir}/*.rb")))
  end

  #Expand cheat hotkeys
  #overridable function
  def cheat_triggers
    #empty so cheatmodules can override
  end
end

if $mod_cheats.nil?
  $mod_cheats = CheatsMod.new

  # Initialize Mod Config (Check config folder exists, create if not exist)
  $mod_cheats.init_configDir

  #Import Load Order (creates default if no file)
  $mod_cheats.init_loadorder("#{$mod_cheats.configDir}/loadorder.json")

  #Include Plugins class
  $mod_cheats.import("scripts", "Plugins")

  #Include Libraries
  $mod_cheats.imports("scripts/lib")
  
  #Include Other Mods
  $mod_cheats.imports("othermods")
  
  #Include project
  $mod_cheats.import("scripts", "Utils") # CheatUtils
  $mod_cheats.import("scripts", "Config") # Cheat Config
  $mod_cheats.init_config("#{$mod_cheats.configDir}/config.ini")
  $mod_cheats.config.readHotkey
  $mod_cheats.import("scripts", "Menu") # Cheat Menu
  
  #Include Cheat Modules
  $mod_cheats.init_addons
  $mod_cheats.addons.run
end
