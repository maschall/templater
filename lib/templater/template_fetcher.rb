module Templater
  class TemplateFetcher
    def self.pull_down_template(template_url)
      Dir.mktmpdir("templater") do |dir|
        if template_url.end_with? ".git"
          Git.clone(template_url, dir, :depth => 1)
        else
          FileUtils.rm_r(dir)
          source_directory = Pathname.new(template_url).expand_path
          FileUtils.cp_r(source_directory, dir)
        end
        FileUtils.rm_r(File.join(dir,".git"), :force => true)
        yield dir
      end
    end
  end
end