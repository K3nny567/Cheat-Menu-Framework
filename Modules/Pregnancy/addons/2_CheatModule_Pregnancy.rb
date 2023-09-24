# Cheats Mod Module - Pregnancy advancement

$CHEATSMOD_CHEATMODULES["Pregnancy"] = true

module CheatsMod
	module Pregnancy
		COMMANDS = [
			["#{CheatsMod.getTextInfo("modules/pregnancy:commands_preg/human")}",		:pregCurrent,	true,	"Human"],
			["#{CheatsMod.getTextInfo("modules/pregnancy:commands_preg/moot")}",		:pregCurrent,	true,	"Moot"],
			["#{CheatsMod.getTextInfo("modules/pregnancy:commands_preg/deepone")}",		:pregCurrent,	true,	"Deepone"],
			["#{CheatsMod.getTextInfo("modules/pregnancy:commands_preg/fishkind")}",	:pregCurrent,	true,	"Fishkind"],
			["#{CheatsMod.getTextInfo("modules/pregnancy:commands_preg/orkind")}",		:pregCurrent,	true,	"Orkind"],
			["#{CheatsMod.getTextInfo("modules/pregnancy:commands_preg/goblin")}",		:pregCurrent,	true,	"Goblin"],
			["#{CheatsMod.getTextInfo("modules/pregnancy:commands_preg/abom")}",		:pregCurrent,	true,	"Abomination"],
		]
	end
end

##---------------------------------------------------------------------------
## Pregnancy Menu
##---------------------------------------------------------------------------
class Window_DebugPreg < Window_Command
	
	#--------------------------------------------------------------------------
	# initialize
	#-------------------------------------------------------------------------
	def initialize
		super(160, 0)
		deactivate
		hide
		refresh
	end
	
	#--------------------------------------------------------------------------
	# window_width
	#--------------------------------------------------------------------------
	def window_width; return Graphics.width - 160; end
	
	#--------------------------------------------------------------------------
	# window_height
	#--------------------------------------------------------------------------
	def window_height; return Graphics.height - 120; end
	
	#--------------------------------------------------------------------------
	# make_command_list
	#--------------------------------------------------------------------------
	def make_command_list
		for command in CheatsMod::Pregnancy::COMMANDS
			add_command(command[0], command[1], command[2], command[3])
		end
		if ($game_player.actor.preg_level >= 1) then
			add_command("#{CheatsMod.getTextInfo("modules/pregnancy:window/babyRace")}: #{$game_player.actor.baby_race}", :pregCurrent,	false,	"separator")
			add_command("#{CheatsMod.getTextInfo("modules/pregnancy:window/daysTillBirth")}: #{$game_player.actor.preg_whenGiveBirth?}", :pregCurrent,	false,	"separator")
			add_command("#{CheatsMod.getTextInfo("modules/pregnancy:window/pregplus")}",	:pregCurrent,	 true,	"PregPlusOneDay")
			add_command("#{CheatsMod.getTextInfo("modules/pregnancy:window/birthInOneDay")}",	:pregCurrent,	 true,	"BirthOneDay")
		end
	end
	
	def pregCurrent
		name = current_ext
		begin
			if !name.nil? then
				case name
				when "PregPlusOneDay"
					if ($game_player.actor.preg_level >= 1) then 
						if ($game_player.actor.preg_whenGiveBirth? > 1) then
							current_preg_date = $game_player.actor.preg_date
							if(current_preg_date[2] > 1) then
								current_preg_date[2] = current_preg_date[2] - 1
							else
								if(current_preg_date[1] > 1)then
									current_preg_date[2] = 16
									current_preg_date[1] = current_preg_date[1] - 1
								else
									current_preg_date[1] = 12
									current_preg_date[2] = 16
								end
							end
							$game_player.actor.preg_date = current_preg_date
							$game_player.actor.update_pregnancy
							case $game_player.actor.preg_level
								when 2
									$game_player.actor.stat["PregState"] = 0
								when 3
									$game_player.actor.stat["PregState"] = 1
								when 4
									$game_player.actor.stat["PregState"] = 2
							end
						end
					end
				when "BirthOneDay"
					if ($game_player.actor.preg_level >= 1) then 
						if ($game_player.actor.preg_whenGiveBirth? > 1) then
							daysTillBirth = $game_player.actor.preg_whenGiveBirth?
							current_preg_date = $game_player.actor.preg_date
							while daysTillBirth > 1
								if(current_preg_date[2] > 1) then
									current_preg_date[2] = current_preg_date[2] - 1
								else
									if(current_preg_date[1] > 1)then
										current_preg_date[2] = 16
										current_preg_date[1] = current_preg_date[1] - 1
									else
										current_preg_date[1] = 12
										current_preg_date[2] = 16
									end
								end
								daysTillBirth = daysTillBirth - 1
							end
							$game_player.actor.preg_date = current_preg_date
							$game_player.actor.update_pregnancy
							$game_player.actor.stat["PregState"] = 2
						end
					end
				else
					raceChoice = System_Settings::CROSS_BREEDING_RESULT[$game_player.actor.race][name]
					tmpRaceChoice = {name => 100}
					System_Settings::CROSS_BREEDING_RESULT[$game_player.actor.race][name] = tmpRaceChoice
					$game_player.actor.cleanup_after_birth
					$game_player.actor.set_preg(name, days = 0)
					System_Settings::CROSS_BREEDING_RESULT[$game_player.actor.race][name] = raceChoice
				end
				SndLib.sys_ok
			end
		rescue => e
			p "Oops, something gone wrong: cannot do event #{name} because #{e.message}"
			SndLib.sys_buzzer
		end
	end
	
	def cursor_left(wrap = false)
		cursor_pageup
	end
	
	def cursor_right(wrap = false)
		cursor_pagedown
	end
end # Window_DebugPreg

module YEA
	module DEBUG
		COMMANDS.insert(3, [:make_pregnant,	"#{CheatsMod.getTextInfo("modules/pregnancy:commands/preg")}"])
	end
end


class Scene_Debug
	alias_method :create_command_window_MODULE_PREGNANCY, :create_command_window
	def create_command_window
		create_command_window_MODULE_PREGNANCY
		@command_window.set_handler(:make_pregnant, method(:command_pregnant)) if CheatUtils.ingame?
	end

	# Pregnancy Window
	def create_preg_window
		@preg_window = Window_DebugPreg.new
		@preg_window.set_handler(:ok, method(:on_preg_ok))
		@preg_window.set_handler(:cancel, method(:on_preg_cancel))
	end
	
	def on_preg_ok
		@preg_window.activate
		@preg_window.pregCurrent
	end
	
	def on_preg_cancel
		@dummy_window.show
		@preg_window.hide
		@command_window.activate
		refresh_help_window(:cancel, "")
	end
	
	def command_pregnant
		create_preg_window if @preg_window == nil
		@dummy_window.hide
		@preg_window.show
		@preg_window.activate
		refresh_help_window(:make_pregnant, "#{CheatsMod.getTextInfo("modules/pregnancy:command_help/preg_0")}\n#{CheatsMod.getTextInfo("modules/pregnancy:window/selectInfo")}\n#{CheatsMod.getTextInfo("modules/pregnancy:command_help/preg_1")}\n\n")
	end # Pregnancy Window
end