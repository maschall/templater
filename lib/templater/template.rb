module Templater
  class Template
    def initialize(template_url)
      @template_url = template_url
    end
    
    def process(output_directory)
      pull_down_template do |template_directory|
        config = read_template_file(template_directory)
        prompt_for_config_values(config)
        output_to_directory(config, template_directory, output_directory)
      end
    end
    
    private
    
    def pull_down_template
      Dir.mktmpdir("templater") do |dir|
        Git.clone(@template_url, dir, :depth => 1)
        FileUtils.rm_r(File.join(dir,".git"))
        yield dir
      end
    end
    
    def template_file_names
      [ ".templater" ]
    end
    
    def read_template_file(temp_directory)
      for file_name in template_file_names
        file_path = "#{temp_directory}/#{file_name}"
        if File.exists?(file_path)
          return TemplateConfig.new(file_path)
        end
      end
      
      puts "Template file not found in template"
      exit
    end
    
    def prompt_for_config_values(config)
      config.hash.each_pair do |attribute, default_value|
        puts "#{attribute} (#{default_value}): "
        value = gets.chomp
        config.hash[attribute] = value.empty? ? default_value : value
      end
    end
    
    def output_to_directory(config, temp_directory, output_directory)
      Dir.glob(File.join(temp_directory, "**", "*"), File::FNM_DOTMATCH) do |file_name|
        relative_file_name = Pathname.new(file_name).relative_path_from(Pathname.new(temp_directory)).to_path
        if not template_file_names.include?(relative_file_name)
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