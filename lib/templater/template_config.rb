module Templater
  class TemplateConfig
    
    def self.template_file_names
      [ ".templater" ]
    end
    
    def self.config_in_directory(template_directory)
      for file_name in self.template_file_names
        file_path = "#{template_directory}/#{file_name}"
        if File.exists?(file_path)
          return TemplateConfig.new(file_path)
        end
      end
      
      puts "Template file not found in template"
      exit
    end
    
    attr_accessor :hash
    
    def initialize(config_path)
      @hash = YAML.load_file(config_path)
    end
    
    def get_binding
      OpenStruct.new(@hash).instance_eval { binding }
    end
  end
end