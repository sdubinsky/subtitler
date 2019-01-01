require 'json'
require 'uri'

class Subtitler
  class ParseException < StandardError;  end
  def self.addSubtitlesToVideo cloud_name, video_id, subtitles_json
    cloud_name = "candidate-evaluation"
    subtitles = parse subtitles_json
    subtitles = text_transforms subtitles
    "https://res.cloudinary.com/#{cloud_name}/video/upload/#{subtitles}/#{video_id}.mp4"
  end

  private

  #URLencoding commas doesn't seem to work
  def self.text_transforms subtitles
    transformations = subtitles.map do |subtitle|
      start_time = parse_time subtitle['start-timing']
      end_time = parse_time subtitle['end-timing']
      text = URI.escape subtitle['text'].gsub(",", ""), "?!' "
      "l_text:arial_40:#{text},so_#{start_time},eo_#{end_time}"
    end.join "/"
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

  def self.parse_time time
    time = time.split ":"
    time[0].to_i * 60 + time[1].to_i
  end
end

