module Templater
  class TemplateCreator
    def initialize(source_directory)
      @config = TemplateConfig.create_config_in_directory(source_directory)
    end
    
    def self.create(source_directory)
      #TODO check if source_directory exists
      creator = TemplateCreator.new(source_directory)
      creator.add_attribute(source_directory)
    end
    
    def add_attribute(source_directory)
      template_attribute = TemplateAttribute.prompt_for_values
      process_new_attribute(template_attribute, source_directory)
      @config.add_attribute(template_attribute)
      @config.save(source_directory)
    end
    
    private
    
    def process_new_attribute(template_attribute, source_directory)
      Dir.glob(File.join(source_directory, "**", "*"), File::FNM_DOTMATCH) do |file_name|
        if not File.directory?(file_name)
          relative_file_name = Pathname.new(file_name).relative_path_from(Pathname.new(source_directory)).to_path
          if not TemplateConfig.template_file_names.include?(relative_file_name)
            new_file_path = process_file_name(template_attribute, relative_file_name, source_directory)
            file = File.new(file_name)
            new_file_contents = process_file_contents(template_attribute, file.read)
            #TODO handle directory name change
            replace_file_with_new_content(file, new_file_path, new_file_contents)
          end
        end
      end
    end
    
    def process_file_name(template_attribute, relative_file_name, source_directory)
      new_file_name = relative_file_name.gsub(template_attribute.pattern, template_attribute.erb_format)
      destination_path = File.join(source_directory, new_file_name)
    end
    
    def process_file_contents(template_attribute, file_contents)
      file_contents.gsub(template_attribute.pattern, template_attribute.erb_format)
    end
    
    def replace_file_with_new_content(file, new_file_path, new_file_contents)
      FileUtils.mkdir_p(File.dirname(new_file_path))
      File.delete(file.path)
      File.open(new_file_path, 'w', file.stat.mode) do |file|
        file.write(new_file_contents)
      end
    end
  end
end
