#===============================================================================
###	Main project file
### Mod: Cheat Menu Framework
###	Author: Kenny567
#===============================================================================

#Tracks modules that have had their runonce code executed.
$CHEATSMOD_CHEATMODULES = {} if $CHEATSMOD_CHEATMODULES.nil?

#Mod namespace
module CheatsMod
  #Include a single script
  def self.import(path, file)
    FileGetter.load_from_list(FileGetter.getFileList($mod_manager.get_resource("cheatmenu", "#{path}/#{file}.rb")))
  end

  #Include scripts from path
  def self.import_path(path)
    FileGetter.load_from_list(FileGetter.getFileList($mod_manager.get_resource("cheatmenu", "#{path}/*.rb")))
  end

  #Expand cheat hotkeys
  #overridable function
  def self.cheat_triggers
    #empty so cheatmodules can override
  end
end

#Include Libraries
CheatsMod.import_path("scripts/lib")

#Include Other Mods
CheatsMod.import_path("othermods")

#Include project
CheatsMod.import("scripts", "Utils") # CheatUtils
CheatsMod.import("scripts", "Menu") # Cheat Menu

#Include Cheat Modules
CheatsMod.import_path("addons")
