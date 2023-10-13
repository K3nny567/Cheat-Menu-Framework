#===============================================================================
###	Main project file
### Mod: Cheat Menu Framework
###	Author: Kenny567
#===============================================================================

#Tracks modules that have had their runonce code executed.
$CHEATSMOD_CHEATMODULES = {} if $CHEATSMOD_CHEATMODULES.nil?

#Mod namespace
module CheatsMod
  #Mod Name
  #Used as part of the Mod Folder Path
  MOD_NAME = "Cheats Mod"

  #
  if ($MODS_PATH.nil?)
    MODS_PATH = "ModScripts/_Mods"
    MOD_FOLDER = "#{MODS_PATH}/#{MOD_NAME}"
  else
    MOD_FOLDER = "#{$MODS_PATH}/#{MOD_NAME}"
  end

  #Include a single script
  def self.import(path, file)
    module_list = FileGetter.getFileList("#{MOD_FOLDER}/#{path}/#{file}.rb")
    FileGetter.load_from_list(module_list)
  end

  #Include scripts from path
  def self.import_path(path)
    module_list = FileGetter.getFileList("#{MOD_FOLDER}/#{path}/*.rb")
    FileGetter.load_from_list(module_list)
  end

  #Expand cheat hotkeys
  #overridable function
  def self.cheat_triggers
    #empty so cheatmodules can override
  end
end

#Include Libraries
CheatsMod.import_path("mod/lib")

#Include Other Mods
CheatsMod.import_path("othermods")

#Include project
CheatsMod.import("mod", "Utils") # CheatUtils
CheatsMod.import("mod", "Menu") # Cheat Menu

#Include Cheat Modules
CheatsMod.import_path("addons")
