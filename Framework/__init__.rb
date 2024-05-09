#===============================================================================
###	Main project file
### Mod: Cheat Menu Framework
###	Author: Kenny567
#===============================================================================

#Mod namespace
class CheatsMod
  attr_reader :version
  attr_reader :config
  attr_reader :path
  attr_reader :text
  attr_reader :umm
  attr_reader :modid
  attr_accessor :modules

  def initialize
    @version = '1.0rc7'
    @config = nil
    @umm = !$mod_manager.nil?
    @modid = "cheatmenu"
    @path = File.dirname(__FILE__)
    @text = Text.new("#{@path}/text/#{$lang}") unless @umm
    @modules = {}
  end

  def init_config(ini_file)
    @config = CheatsConfig.new(ini_file)
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

  #Include Libraries
  $mod_cheats.imports("scripts/lib")
  
  #Include Other Mods
  $mod_cheats.imports("othermods")
  
  #Include project
  $mod_cheats.import("scripts", "Utils") # CheatUtils
  $mod_cheats.import("scripts", "Config") # Cheat Config
  $mod_cheats.init_config("GameCheats.ini")
  $mod_cheats.import("scripts", "Menu") # Cheat Menu
  
  #Include Cheat Modules
  $mod_cheats.imports("addons")  
end
