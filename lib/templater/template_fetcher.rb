module Templater
  class TemplateFetcher
    def self.pull_down_template(template_url)
      Dir.mktmpdir("templater") do |dir|
        Git.clone(template_url, dir, :depth => 1)
        FileUtils.rm_r(File.join(dir,".git"))
        yield dir
      end
    end
  end
end