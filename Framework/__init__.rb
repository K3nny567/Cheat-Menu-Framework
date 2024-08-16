#===============================================================================
###	Main project file
### Mod: Cheat Menu Framework
###	Author: Kenny567
#===============================================================================

#Mod namespace
class CheatsMod
  attr_reader :version
  attr_reader :config
  attr_reader :loadorder
  attr_reader :path
  attr_reader :text
  attr_reader :umm
  attr_reader :modid
  attr_accessor :modules
  attr_accessor :addons
  attr_accessor :hotkey

  def initialize
    @version = '1.0rc8'
    @config = nil
    @addons = nil
    @loadorder = nil
    @umm = !$mod_manager.nil?
    @modid = "cheatmenu"
    @path = File.dirname(__FILE__)
    @text = Text.new("#{@path}/text/#{$lang}") unless @umm
    @modules = {}
    @hotkey = nil
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
    unless File.exist?(getResource("#{@modid}", "#{file}"))
      default_loadorder = [
          "UnlockTool", "UnequipItems", "InvEdit", "Summons",
          "Race", "Pregnancy", "StatsEdit", "HairColorEdit",
          "MoralityEdit", "Legacy", "AbomSkills", "DeepSkill", "Dirt",
          "InfiniteMainStats", "AutoBandage", "AutoClean", "InfiniteMoney"
        ]
      
      File.open(getResource("#{@modid}", "#{file}"), 'w') {
        |lo_file|

        lo_file.write(JSON.encode(default_loadorder))
        lo_file.close
      }
    end
    json_file = File.open(getResource("#{@modid}", "#{file}"))
    @loadorder = JSON.decode(json_file.read())
    @loadorder << :rest
    json_file.close
  end

  def updateText
    @text = Text.new("#{@path}/text/#{$lang}") unless @umm
  end

  def getText(text_block)
    return $game_text["cheatmenu:#{text_block}"] if @umm
    return @text[text_block]
  end

  def getResource(id, resource)
    return $mod_manager.get_resource(id, resource) if @umm
    return "#{@path}/#{resource}"
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

  #Import Load Order (creates default if no file)
  $mod_cheats.init_loadorder("loadorder.json")

  #Include Plugins class
  $mod_cheats.import("scripts", "Plugins")

  #Include Libraries
  $mod_cheats.imports("scripts/lib")
  
  #Include Other Mods
  $mod_cheats.imports("othermods")
  
  #Include project
  $mod_cheats.import("scripts", "Utils") # CheatUtils
  $mod_cheats.import("scripts", "Config") # Cheat Config
  $mod_cheats.init_config("GameCheats.ini")
  $mod_cheats.config.readHotkey
  $mod_cheats.import("scripts", "Menu") # Cheat Menu
  
  #Include Cheat Modules
  $mod_cheats.init_addons
  $mod_cheats.addons.run
end
