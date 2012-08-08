module CleanCode
  class Checker

    def intialize(file)
      file_content = File.open(file).read
      @ruby_parser = RubyParser.new.parse(file_content)
    end

  end
end