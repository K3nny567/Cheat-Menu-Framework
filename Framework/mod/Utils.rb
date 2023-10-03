
##---------------------------------------------------------------------------
## CheatUtils Module
##---------------------------------------------------------------------------
module CheatUtils
	def self.ingame?
		return (!$game_system.menu_disabled or $loading_screen.nil?)
	end
end

# Add text buffer
module TextCache
    #--------------------------------------------------------------------------
    # * Check Cache Existence
    #--------------------------------------------------------------------------
    def self.include?(key)
        @cache[key] && !@cache[key].nil?
    end
    #--------------------------------------------------------------------------
    # * Txt info
    #--------------------------------------------------------------------------
    def self.txt_info(path, file, title)
        @cache ||={}
        @cache[path] = Text.new(path) unless include?(path)
        @cache[path]["#{file}:#{title}"]
    end
end

module CheatsMod
	#Get info from text file
	def self.getTextInfo(_info)
		fileName    = _info.split(':')[0];
		title       = _info.split(':')[1];
		return TextCache.txt_info("#{MOD_FOLDER}/text/#{$lang}", fileName, title)
	end
end