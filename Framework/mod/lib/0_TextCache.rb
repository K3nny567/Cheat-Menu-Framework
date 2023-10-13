module TextCache
  #--------------------------------------------------------------------------
  # * include?
  #--------------------------------------------------------------------------
  #Check if text has been loaded into the cache
  def self.include?(key)
    @cache[key] && !@cache[key].nil?
  end
  #--------------------------------------------------------------------------
  # * txt_info
  #--------------------------------------------------------------------------
  # Get text from cache (load from file if first time)
  def self.txt_info(path, file, title)
    @cache ||= {}
    @cache[path] = Text.new(path) unless include?(path)
    @cache[path]["#{file}:#{title}"]
  end
end
