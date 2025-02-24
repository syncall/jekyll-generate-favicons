require "jekyll"
require "shellwords"
require 'fileutils'

require "jekyll-generate-favicons/utils"

module Jekyll
  module GenerateFavicons
      class FaviconTag < Liquid::Tag

        def initialize(tag_name, text, tokens)
          super
        end

        def render(context)
          site = context.registers[:site]
          baseurl = site.config["baseurl"]

          icon_file = site.config["icon"]

          apple_icon_file = site.config["apple_touch_icon"]

          s = StringIO.new
          if icon_file
            icon_path, _ = Jekyll::GenerateFavicons::find_icon_file(site, icon_file)
            s << "<link rel=\"icon\" type=\"image/x-icon\" sizes=\"48x48\" href=\"#{baseurl}/favicon.ico\">\n"
            s << "<link rel=\"icon\" type=\"image/svg+xml\" sizes=\"any\" href=\"#{baseurl}/#{icon_path}\">\n"
          end

          if apple_icon_file
            # apple_icon_file, _ = Jekyll::GenerateFavicons::find_icon_file(site, apple_icon_file)

            [120, 152, 167, 180].each { |size|
              s << "<link rel=\"apple-touch-icon\" sizes=\"#{size}x#{size}\" href=\"#{site.baseurl}/assets/img/favicons/apple-touch-icon-#{size}.png\">\n"
            }
          end

          s.string
        end
      end
    end

end

Liquid::Template.register_tag('favicons', Jekyll::GenerateFavicons::FaviconTag)


Jekyll::Hooks.register :site, :post_write do |site|
  # code to call after Jekyll renders a page
  icon_file = site.config["icon"]
  if icon_file
    unless icon_file.end_with?(".svg")
      throw "Currently only supports SVG icons to generate foavicons. Feel free to open a pull request for additional logic."
    end

    _, src_file = Jekyll::GenerateFavicons::find_icon_file(site, icon_file)

    # We use a small size for legacy browser for now, modern ones should work with svgs
    dst_file = File.join(site.dest, "favicon.ico")
    icon_size = 32
    unless File.exist?(dst_file)
      cmd = "magick #{src_file.shellescape} -alpha off -resize #{icon_size}x#{icon_size} #{dst_file.shellescape}"
      system(cmd)
    end
  end

  # Apple supports only png
  apple_icon_file = site.config["apple_touch_icon"]
  if apple_icon_file
    unless apple_icon_file.end_with?(".svg")
      throw "Currently only supports SVG icons to generate apple_icon_file. Feel free to open a pull request for additional logic."
    end

    _, src_file = Jekyll::GenerateFavicons::find_icon_file(site, apple_icon_file)

    dst_dir = File.join(site.dest, "assets/img/favicons")
    FileUtils.mkdir_p dst_dir

    [120, 152, 167, 180].each { |size|
      dst_file = File.join(dst_dir, "apple-touch-icon-#{size}.png")
      unless File.exist?(dst_file)
        cmd = "magick #{src_file.shellescape} -resize #{size}x#{size} #{dst_file.shellescape}"
        system(cmd)
      end
    }

  end

end
