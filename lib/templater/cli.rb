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
      directory = get_directory_path(destination)
      TemplateProcessor.process(template, directory)
    end
    
    desc "create [SOURCE]", "create a new template from the source or current directory"
    def create(source=nil)
      directory = get_directory_path(source)
      TemplateCreator.create(directory)
    end
    
    default_task :cli
    
    private
    
    def get_directory_path(directory=nil)
      directory = directory ||= Dir.getwd
      directory = Pathname.new(directory).expand_path
    end
  end
end