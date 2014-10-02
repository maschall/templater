module Templater
  class Template
    def initialize(template_url)
      @template_url = template_url
    end
    
    def process(output_directory)
      clone_to_temp do |temp_directory|
        template = read_template_file(temp_directory)
        output_to_directory(template, temp_directory, output_directory)
      end
    end
    
    private
    
    def clone_to_temp
      Dir.mktmpdir("templater") do |dir|
        Git.clone(@template_url, dir).pull
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
          template = YAML.load_file(file_path)
          return OpenStruct.new(template).instance_eval { binding }
        end
      end
      
      puts "Template file not found in template"
      exit
    end
    
    def output_to_directory(template, temp_directory, output_directory)
      current_dir = Dir.getwd
      Dir.chdir(temp_directory)
      Dir.glob("**/*") do |file_name|
        if not template_file_names.include?(file_name)
          new_file_name = ERB.new(file_name).result(template)
          rendered_template = ERB.new(File.read(file_name)).result(template)
          destination_path = File.join(output_directory, new_file_name)
          puts destination_path
          FileUtils.mkdir_p(File.dirname(destination_path))
          File.open(destination_path, 'w') do |file|
            file.write(rendered_template)
          end
        end
      end
      Dir.chdir(current_dir)
    end
  end
end