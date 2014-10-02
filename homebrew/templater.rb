require 'formula'

class Templater < Formula
  homepage 'https://github.com/maschall/templater'
  url 'https://maschall.github.io/templater/Templater-__VERSION__.tar.gz'
  sha1 '__SHA__'

  def install
    prefix.install 'defaults', 'vendor'
    prefix.install 'lib' => 'rubylib'

    bin.install 'src/templater'
  end

  test do
    system "#{bin}/templater", '--version'
  end
end
