require 'thor'

module Templater
  class CLI < Thor
    desc "TEMPLATE_GIT", "Templater is a tool for using and making project templates."
    method_option :version, :aliases => "-v", :type => :boolean, :desc => "Display the version"
    method_option :help, :aliases => "-h", :type => :boolean, :desc => "Display the help"
    def cli(template_path=nil)
      if options[:version]
        puts "Version: #{VERSION}"
        exit
      elsif template_path != nil
        directory = @argv.shift ||= Dir.getwd
        directory = Pathname.new(directory).expand_path
        Template.new(template_path).process(directory)
      else
        CLI.help
        exit
      end
    end
    
    default_task :cli
  end
end