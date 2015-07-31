module Templater
  class TemplateConfig
    
    def self.template_file_names
      [ ".templater" ]
    end
    
    def self.load_config_in_directory(template_directory)
      for file_name in self.template_file_names
        file_path = "#{template_directory}/#{file_name}"
        if File.exists?(file_path)
          return TemplateConfig.new(file_path)
        end
      end
      return nil
    end
    
    def self.create_config_in_directory(template_directory)
      config = self.load_config_in_directory(template_directory)
      if !config
        config = TemplateConfig.new()
        config.save("#{template_directory}/#{self.template_file_names.first}")
      end
      config
    end
    
    def prompt_for_values
      config = TemplateConfig.new()
      hash.each_pair do |attribute, default_value|
        puts "#{attribute} (#{default_value}): "
        value = STDIN.gets.chomp
        config.hash[attribute] = value.empty? ? default_value : value
      end
      config
    end
    
    def save(config_path)
      File.open(config_path, 'w') {|file| file.write @hash.to_yaml }
    end
    
    attr_accessor :hash
    
    def initialize(config_path=nil)
      if config_path
        @hash = YAML.load_file(config_path)
      else
        @hash = Hash.new
      end
    end
    
    def get_binding
      OpenStruct.new(@hash).instance_eval { binding }
    end
  end
end