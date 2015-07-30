require 'thor'

module Templater
  class CLI < Thor
    desc "", "Templater is a tool for using and making project templates."
    method_option :version, :aliases => "-v", :type => :boolean, :desc => "Display the version"
    method_option :help, :aliases => "-h", :type => :boolean, :desc => "Display the help"
    def cli
      if options[:version]
        puts "Version: #{VERSION}"
      else
        CLI.help
      end
    end

    desc "clone [TEMPLATE] [DESTINATION?]", "Clones template to destination or current directory"
    def clone(template, destination=nil)
      directory = destination ||= Dir.getwd
      directory = Pathname.new(directory).expand_path
      Template.process(template, directory)
    end
    
    desc "create [DIRECTORY]", "create a new template from the directory or current directory"
    def create(directory=nil)
      
    end
    
    default_task :cli
  end
end