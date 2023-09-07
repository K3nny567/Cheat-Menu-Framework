#===============================================================================
###	Main project file
###
###	Author: Kenny567
#===============================================================================

module CheatsMod
	#defines
	MOD_NAME = "Cheats Mod"

	if ($MODS_PATH.nil?)
		MODS_PATH = "ModScripts/_Mods";
		MOD_FOLDER = "#{MODS_PATH}/#{MOD_NAME}";
	else
		MOD_FOLDER = "#{$MODS_PATH}/#{MOD_NAME}";
	end

	#include a single script
	def self.import(path, file)
		module_list = FileGetter.getFileList("#{MOD_FOLDER}/#{path}/#{file}.rb");
		FileGetter.load_from_list(module_list);
	end

	#include scripts from path
	def self.import_path(path)
		module_list = FileGetter.getFileList("#{MOD_FOLDER}/#{path}/*.rb");
		FileGetter.load_from_list(module_list);
	end
end

#Include Libraries
CheatsMod.import("mod", "Utils");
CheatsMod.import_path("mod/lib");

#Include Other Mods
CheatsMod.import_path("othermods");

#Include project
CheatsMod.import("mod", "CheatsMod");

#Include Cheat Modules
CheatsMod.import_path("addons");