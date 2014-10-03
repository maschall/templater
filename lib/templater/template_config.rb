module Templater
  class TemplateConfig
    
    attr_accessor :hash
    
    def initialize(config_path)
      @hash = YAML.load_file(config_path)
    end
    
    def get_binding
      OpenStruct.new(@hash).instance_eval { binding }
    end
  end
end