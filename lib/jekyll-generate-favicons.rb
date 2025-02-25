require "jekyll"
require "shellwords"
require 'fileutils'

require "jekyll-generate-favicons/utils"

module Jekyll
  module GenerateFavicons
    class FaviconTag < Liquid::Tag

      DEFAULT_PATH = "assets/img/favicons".freeze

      def render(context)
        site = context.registers[:site]
        baseurl = site.config["baseurl"]

        icon_file = site.config["icon"]

        apple_icon_file = site.config["apple_touch_icon"]

        s = StringIO.new
        if icon_file
          icon_path, _ = Jekyll::GenerateFavicons::find_icon_file(site, icon_file)
          s << "<link rel=\"icon\" type=\"image/x-icon\" sizes=\"48x48\" href=\"#{baseurl}/favicon.ico\"/>\n"
          s << "<link rel=\"icon\" type=\"image/svg+xml\" sizes=\"any\" href=\"#{baseurl}/#{icon_path}\"/>\n"
        end

        if apple_icon_file
          # apple_icon_file, _ = Jekyll::GenerateFavicons::find_icon_file(site, apple_icon_file)
          default_path = Jekyll::GenerateFavicons::FaviconTag::DEFAULT_PATH

          [76, 120, 152, 180, 192].each { |size|
            icon_url = "#{site.baseurl}/#{default_path}/apple-touch-icon-#{size}.png"
            icon_url = "#{site.baseurl}/apple-touch-icon.png" if size == 192
            s << "<link rel=\"apple-touch-icon\" sizes=\"#{size}x#{size}\" href=\"#{icon_url}\">\n"
          }
        end
        apple_mask_icon = site.config["apple_mask_icon"]
        if apple_mask_icon
          mask_src = apple_mask_icon["src"]
          mask_color = apple_mask_icon["color"]
          mask_color = "black" unless mask_color

          mask_src = apple_mask_icon unless mask_src

          icon_path, _ = Jekyll::GenerateFavicons::find_icon_file(site, mask_src)
          s << "<link rel=\"mask-icon\" href=\"#{baseurl}/#{icon_path}\" color=\"#{mask_color}\">"
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
    icon_size = 48
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

    dst_default_file = File.join(site.dest, "apple-touch-icon.png")

    dst_dir = File.join(site.dest, Jekyll::GenerateFavicons::FaviconTag::DEFAULT_PATH)
    FileUtils.mkdir_p dst_dir

    [76, 120, 152, 180, 192].each { |size|
      dst_file = File.join(dst_dir, "apple-touch-icon-#{size}.png")
      # Default is big
      dst_file = dst_default_file if size == 192
      unless File.exist?(dst_file)
        cmd = "magick #{src_file.shellescape} -resize #{size}x#{size} #{dst_file.shellescape}"
        system(cmd)
      end
    }

  end

end
