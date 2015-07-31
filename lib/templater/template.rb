module Templater
  class Template
    def self.process(template_url, output_directory)
      TemplateFetcher.pull_down_template(template_url) do |template_directory|
        config = TemplateConfig.load_config_in_directory(template_directory)
        if !config
          puts "Template file not found in template"
          exit
        end
        config = config.prompt_for_values
        self.output_to_directory(config, template_directory, output_directory)
      end
    end
    
    def self.create(source_directory)
      config = TemplateConfig.create_config_in_directory(source_directory)
    end
    
    private
    
    def self.output_to_directory(config, temp_directory, output_directory)
      Dir.glob(File.join(temp_directory, "**", "*"), File::FNM_DOTMATCH) do |file_name|
        relative_file_name = Pathname.new(file_name).relative_path_from(Pathname.new(temp_directory)).to_path
        if not TemplateConfig.template_file_names.include?(relative_file_name)
          if not File.directory?(file_name)
            new_file_name = ERB.new(relative_file_name).result(config.get_binding)
            rendered_template = ERB.new(File.read(file_name)).result(config.get_binding)
            destination_path = File.join(output_directory, new_file_name)
            FileUtils.mkdir_p(File.dirname(destination_path))
            File.open(destination_path, 'w', File.new(file_name).stat.mode) do |file|
              file.write(rendered_template)
            end
            ## TODO support empty folders
          end
        end
      end
    end
  end
end