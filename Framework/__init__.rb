#===============================================================================
###	Main project file
### Mod: Cheat Menu Framework
###	Author: Kenny567
#===============================================================================

#Mod namespace
module CheatsMod
  attr_reader :version
  attr_reader :config
  attr_reader :path
  attr_reader :text
  attr_reader :umm
  attr_accessor :modules

  def self.initialize(ini_file)
    @version = '1.0rc7'
    @config = CheatsConfig.new(ini_file)
    @umm = !$mod_manager.nil?
    @path = File.dirname(__FILE__)
    @text = Text.new("#{@path}/text") unless @umm
    @modules = {}
  end

  def self.getText(text_block)
    return $game_text["cheatmenu:#{text_block}"] if @umm
    return @text[text_block]
  end

  def self.getResource(id, resource)
    return $mod_manager.get_resource(id, resource) if @umm
    return "#{@path}/#{resource}"
  end

  #Include a single script
  def self.import(dir, file)
    FileGetter.load_from_list(FileGetter.getFileList(getResource("cheatmenu", "#{dir}/#{file}.rb")))
  end

  #Include scripts from path
  def self.import(dir)
    FileGetter.load_from_list(FileGetter.getFileList(getResource("cheatmenu", "#{dir}/*.rb")))
  end

  #Expand cheat hotkeys
  #overridable function
  def self.cheat_triggers
    #empty so cheatmodules can override
  end
end

$mod_cheats = CheatsMod.new("GameCheats.ini")

#Include Libraries
$mod_cheats.import("scripts/lib")

#Include Other Mods
$mod_cheats.import("othermods")

#Include project
$mod_cheats.import("scripts", "Utils") # CheatUtils
$mod_cheats.import("scripts", "Menu") # Cheat Menu

#Include Cheat Modules
$mod_cheats.import("addons")
