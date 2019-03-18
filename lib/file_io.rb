# frozen_string_literals: true
class FileIO

  GAME_STATUS_DIR = "#{__dir__}/../game_status_files"

  def self.read(filename)
    puts "#{GAME_STATUS_DIR}/#{filename}"
    File.open("#{GAME_STATUS_DIR}/#{filename}") do |file|
      file.seek(0)
      file.read
    end
  end

  def self.write(filename, string)
    string_io = string.is_a?(StringIO) ? string : StringIO.new(string)
    File.open("#{GAME_STATUS_DIR}/#{filename}", 'w') do |file|
      file.write(string_io.string)
      file.close
    end
  end

  private

  def self.exist?(filename)
    File.exist?("#{GAME_STATUS_DIR}/#{filename}")
  end
end