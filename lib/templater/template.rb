module Templater
  class Template
    def self.process(template_url, output_directory)
      TemplateFetcher.pull_down_template(template_url) do |template_directory|
        config = TemplateConfig.config_in_directory(template_directory)
        self.prompt_for_config_values(config)
        self.output_to_directory(config, template_directory, output_directory)
      end
    end
    
    private
    
    def self.prompt_for_config_values(config)
      config.hash.each_pair do |attribute, default_value|
        puts "#{attribute} (#{default_value}): "
        value = STDIN.gets.chomp
        config.hash[attribute] = value.empty? ? default_value : value
      end
    end
    
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