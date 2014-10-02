module Templater
  class CLI
    def initialize(argv)
      @argv = argv
    end
    
    def run
      parse_command_line_options
    end
    
    private
    
    def parse_command_line_options
      begin
        global_options.parse!(@argv)
      rescue OptionParser::InvalidOption => e
        puts e
        print_help
      end
      
      template_path = get_template_path
      
      directory = @argv.shift ||= Dir.getwd
      directory = Pathname.new(directory).expand_path
      
      Template.new(template_path).process(directory)
    end
    
    def global_options
      OptionParser.new do |opts|
        opts.banner = 'Usage: templater <template url> [-v | --version] [-h | --help]'
        
        opts.on('-v', '--version', 'Display the version and exit') do
          puts "Version: #{VERSION}"
          exit
        end
        
        opts.on('-h', '--help', 'Display this help message') do
          puts opts
          exit
        end
        
      end
    end
    
    def print_help
      global_options.parse!(['-h'])
    end
    
    def get_template_path
      path = @argv.shift
      
      if not path or path.empty?
        puts "Need to specify a template to process"
        print_help
      end
      
      path
    end
  end
end