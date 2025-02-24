# frozen_string_literal: true

require_relative "lib/jekyll-generate-favicons/version"

Gem::Specification.new do |s|
  s.name = "jekyll-generate-favicons"
  s.version = Jekyll::GenerateFavicons::VERSION
  s.authors = ["Markus Sosnowski"]
  s.summary = "A small plugin that generates common favicon formats with imagemagick."
  s.license = "AGPL-3.0-only"

  s.homepage = "https://github.com/syncall/jekyll-generate-favicons"

  s.platform = Gem::Platform::RUBY

  s.required_ruby_version = ">= 3.0.0"

  s.files = `git ls-files -z`.split("\x0").select do |file|
    file.match(%r!(^lib/)|LICENSE|README.md!)
  end

  s.require_paths = ["lib"]

  s.add_dependency "jekyll", ">= 4.0", "< 5.0"
  s.add_development_dependency "bundler", "~> 2.6"
  s.add_development_dependency "minitest", "~> 5.0"
  s.add_development_dependency "rubocop-jekyll", "~> 0.14.0"
end
