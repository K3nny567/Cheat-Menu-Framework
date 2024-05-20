#==============================================================================
# ** TDD Plugins Module
#------------------------------------------------------------------------------
# Version:  1.1.1
# Date:     06/12/2014
# Author:   Galenmereth / Tor Damian Design
#
# Revision: 1.1.1.1
# Revision Author: Kenny567
#
# Revision Changelog
# ==================
# Revision 1.1.1.1: Modified for use inside Cheat Menu Framework
#
# Changelog
# =========
# Version 1.1.1: Implemented the :rest symbol feature in order arrays
# Version 1.1.0: Introduced the exclude option, and the load_recursive method
# Version 1.0.1: Fixed various smaller bugs
# 
# Description
# ===========
# This class allows you to load script files in a more intuitive and organized
# manner than in the default editor in RPG Maker VXAce. You can sort your
# scripts in folders and subfolders, specify order independent of filename,
# and exclude specific files.
#==============================================================================
class Plugins
  @@plugins_register = []
  @@bootstrap_file = "bootstrap.rb"
  @@root_path = ""
  @@current_path = ""
  @@scripts = []

  def initialize(path)
    @@root_path = path
  end

  # Get the current path for the plugin being loaded
  # Used in bootstrap files by plugins
  def current_path
    @@current_path
  end

  # Register this plugin id in the plugin register
  # Used in bootstrap files by plugins
  # Params:
  #   id:   String object identifying the plugin
  def register(id)
    @@plugins_register << id
    prp "Plugin registered: #{id}"
  end

  # Check if a plugin is loaded
  # Used in bootstrap files to check if another plugin is loaded
  # Params:
  #   id:   String object identifying the plugin
  def has_plugin?(id)
    @@plugins_register.include?(id)
  end

  # Require a bootstrap file
  # Used by the Plugin module to register the current path and load a bootstrap file, making Plugin.current_path relevant to that loaded bootstrap file
  # Params:
  #   bootstrap: String object identifying bootstrap file to load, with full path
  def load_bootstrap(bootstrap)
    current_path = bootstrap.chomp(bootstrap_file)
    load_script bootstrap
  end

  # Load plugins from a path in a given order
  # Used to load all plugin folders in a given path
  # Params hash:
  #   :path => String object of folder path to look for plugin subfolders
  #   :order => Array object specifying a list of plugin folders to load before all others (optional)
  #   :exclude => Array object specifiying a list of plugin folders to exclude (optional)
  def load_plugins(opts={})
    opts = {
      :path => "",
      :order => []
    }.merge(opts)

    path = opts[:path]
    order = opts[:order]
    loaded = []

    if order && order.any?
      order.each do |f|
        self.load_bootstrap("#{root_path}/#{f}/#{bootstrap_file}")
        loaded << "#{root_path}/#{f}/"
      end
    end

    Dir.glob("#{root_path}/#{path}/#{bootstrap_file}") do |bootstrap|
      next if loaded.include?(bootstrap.chomp(bootstrap_file))
      self.load_bootstrap(bootstrap)
    end
  end

  # Require files from a given path
  # Used in bootstrap files to require plugin files
  # Params hash:
  #   :path => String object of folder path to look in (optional, will then look in bootstrap path)
  #   :order => Array object specifying list of files to load before all others (optional)
  #   :exclude => Array object specifiying a list of files to exclude (optional)
  def load_files(opts={})
    opts = {
      :path => "",
      :order => [],
      :exclude => []
    }.merge(opts)

    path = current_path + opts[:path]
    order = opts[:order]
    exclude = opts[:exclude] || []
    loaded = []
    
    insert_spot = nil

    if order.any?
      order.each do |f|
        next if exclude.include?(f)
        if f == :rest
          insert_spot = @@scripts.count
          next
        end
        file = "#{path}/#{f}.rb"
        loaded << file
        @@scripts << file
      end
    end

    insert_spot ||= @@scripts.count 

    Dir.glob("#{path}/*.rb") do |f|
      next if exclude.include?(f.chomp(".rb").split("/").last)
      next if loaded.include?(f)
      next if f.gsub("#{path}/", "") == bootstrap_file
      @@scripts.insert(insert_spot, f)
      loaded << f
      insert_spot += 1
    end
  end

  def run

    @@scripts.each do |s|
      begin
        load_script(s)
      rescue
        # Do nothing
      end
    end

  end

  # def package
  #   scripts = ""
  #   @@scripts.each do |s|
  #     begin
  #       scripts += File.open(s).read + "\n"
  #     rescue
  #       # Do nothing
  #     end
  #   end

  #   begin
  #     file = File.open("#{root_path}/scripts.rb", 'w')
  #   rescue
  #     # We are in encrypted mode, do nothing
  #   end

  #   return if file.nil? # If file is nil, it cannot be accessed, which means the game is running with an encrypted archive. If so, we do not write the scripts file.

  #   begin
  #     file.write(scripts)
  #   rescue IOError => e
  #     raise "Could not write scripts file; is the plugins folder writable?"
  #   ensure
  #     file.close unless file == nil
  #   end
    
  # end

  # Set root path of plugins
  # used to specify root folder for all plugins. Should only be set once, at setup
  # Params:
  #   path:   String object; root path of plugins directory
  def root_path=(path)
    @@root_path = "#{path}"
  end

  # Get root path of plugins
  def root_path
    @@root_path
  end

  # Set bootstrap file name
  # Used to specify the filename for bootstrap files in plugins. Should only be set once, at setup
  # Params:
  #   filename:   String object; the filename of bootstrap files
  def bootstrap_file=(filename)
    @@bootstrap_file = filename
  end

  # Get filename of bootstrap files
  def bootstrap_file
    @@bootstrap_file
  end

  private

  # Set current path
  # Used to specify the current path, for use in bootstrap files and to require plugin files at the correct path.
  # Params:
  #   path: String object
  def current_path=(path)
    @@current_path = path
  end

end
