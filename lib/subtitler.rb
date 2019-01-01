require 'json'

class Subtitler
  class ParseException < StandardError;  end
  def self.addSubtitlesToVideo cloud_name, video_id, subtitles_json
    cloud_name = "candidate-evaluation"
    subtitles = parse subtitles_json
    subtitles = text_transforms subtitles
    "https://res.cloudinary.com/#{cloud_name}/video/upload/#{subtitles}/#{video_id}.mp4"
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

  def self.parse json
    subtitles = JSON.parse json
    raise ParseException unless subtitles.keys == ['subtitles']
    subtitles = subtitles['subtitles']
    subtitles.each do |subtitle|
      raise ParseException unless subtitle.keys.sort == ['end-timing', 'start-timing', 'text']
      validate_time subtitle['start-timing']
      validate_time subtitle['end-timing']
    end
  end

  #The time format validation is probably stricter than really necessary.
  def self.validate_time time
    raise ParseException unless /\A\d:\d\d.\d\z/ =~ time
  end
end

