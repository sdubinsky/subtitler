require 'json'
require 'pry'

class Subtitler
  def self.addSubtitlesToVideo video_id, subtitles_json
    cloud_name = "candidate-evaluation"
    puts "adding subtitles"
    subtitles = JSON.parse(subtitles_json)['Subtitles']
  end

  private

  def self.text_transforms subtitles
    subtitles.map do |subtitle|
      start_time = subtitle['start-timing'].split(":")[1]
      end_time = subtitle['end-timing'].split(":")[1]
      text = subtitle['text']
      "l_text:arial_40:#{text},so_#{start_time},eo_#{end_time}"
    end.join("/")
  end

  def self.parse_time time
    
  end
end
