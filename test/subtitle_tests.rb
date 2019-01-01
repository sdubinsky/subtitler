require 'minitest/autorun'
require_relative '../lib/subtitler'
class SubtitleTest < Minitest::Test
  def test_parser
    subtitles = [
      {
        'start-timing' => '0:10.8',
        'end-timing' => '0:13.3',
        'text' => 'Hello World'
      }
    ]

    puts Subtitler.text_transforms subtitles
  end
end
