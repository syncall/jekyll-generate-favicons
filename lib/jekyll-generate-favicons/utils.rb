module Jekyll
  module GenerateFavicons
    def find_icon_file(site, file)
      # extension = File.extname(src_file)
      # basename = File.basename(src_file, extension)
      try_file = File.join(site.source, file)
      if File.file?(try_file)
        return file, try_file
      end
      guess = File.join(site.source, "assets", "img", file)
      if File.file?(guess)
        return File.join("assets", "img", file), guess
      end
      throw "Could not find file #{file}"
    end
    module_function :find_icon_file
  end
end
