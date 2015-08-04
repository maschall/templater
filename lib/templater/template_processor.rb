module Templater
  class TemplateProcessor
    def self.process(template_url, output_directory)
      TemplateFetcher.pull_down_template(template_url) do |template_directory|
        config = TemplateConfig.load_config_in_directory(template_directory)
        if !config
          puts "Template file not found in template"
          exit
        end
        config.prompt_for_values
        self.output_to_directory(config, template_directory, output_directory)
      end
    end
    
    private
    
    def self.output_to_directory(config, temp_directory, output_directory)
      Dir.glob(File.join(temp_directory, "**", "*"), File::FNM_DOTMATCH) do |file_name|
        if not File.directory?(file_name)
          relative_file_name = Pathname.new(file_name).relative_path_from(Pathname.new(temp_directory)).to_path
          file = File.new(file_name)
          self.process_file(config, file, relative_file_name, output_directory)
        end
      end
    end
    
    def self.process_file(config, file, relative_file_name, output_directory)
      if not TemplateConfig.template_file_names.include?(relative_file_name)
        destination_path = self.generate_destination_path(config, relative_file_name, output_directory)
        rendered_template = self.generate_file_contents(config, file.read)
        self.generate_file(rendered_template, destination_path, file.stat.mode)
      end
    end
    
    def self.generate_destination_path(config, relative_file_name, output_directory)
      new_file_name = ERB.new(relative_file_name).result(config.get_binding)
      destination_path = File.join(output_directory, new_file_name)
    end
    
    def self.generate_file_contents(config, file_contents)
      rendered_template = ERB.new(file_contents).result(config.get_binding)
    end
    
    def self.generate_file(rendered_template, destination_path, mode)
      FileUtils.mkdir_p(File.dirname(destination_path))
      File.open(destination_path, 'w', mode) do |file|
        file.write(rendered_template)
      end
    end
  end
end