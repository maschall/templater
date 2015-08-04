module Templater
  class TemplateAttribute

    attr_accessor :attribute, :replaces, :default_value

    def self.prompt_for_values
      template_attribute = TemplateAttribute.new
      puts "Attribute name: "
      template_attribute.attribute = STDIN.gets.chomp
      puts "Replaces: "
      template_attribute.replaces = STDIN.gets.chomp
      puts "Default value: "
      template_attribute.default_value = STDIN.gets.chomp
      return template_attribute
    end
    
    def erb_format
      return "<%= #{attribute} %>"
    end
    
    def pattern
      return /(?<!<%= )#{replaces}(?! %>)/
    end
  end
end