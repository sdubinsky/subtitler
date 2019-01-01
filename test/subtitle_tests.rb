require 'minitest/autorun'
require 'json'

require_relative '../lib/subtitler'
class SubtitleTest < Minitest::Test
  def test_parser_single
    subtitles = [
      {
        'start-timing' => '0:10.8',
        'end-timing' => '0:13.3',
        'text' => 'Hello World'
      }
    ]

    assert_equal "l_text:arial_40:Hello World,so_10.8,eo_13.3", Subtitler.text_transforms(subtitles)
  end

  def test_parser_multiple
    subtitles = [
      {
        'start-timing' => '0:10.8',
        'end-timing' => '0:13.3',
        'text' => 'Hello World'
      },
      {
        'start-timing' => '0:16.2',
        'end-timing' => '0:20.6',
        'text' => 'this is the subtitles tool'
      }
    ]

    assert_equal 'l_text:arial_40:Hello World,so_10.8,eo_13.3/l_text:arial_40:this is the subtitles tool,so_16.2,eo_20.6', Subtitler.text_transforms(subtitles)
  end

  def test_parse_failures
    subtitles = {
      "subtitles" => [
        {
          'start-timing' => '0:10.8',
          'text' => 'Hello World'
        }
      ]
    }

    assert_raises Subtitler::ParseException do
      Subtitler.parse(subtitles.to_json)
    end

    subtitles = {
      "subtitles" => [
        {
          'start-timing' => '0:10.8',
          'end-timin' => '0:20.6',
          'text' => 'Hello World'
        }
      ]
    }

    assert_raises Subtitler::ParseException do
      Subtitler.parse(subtitles.to_json)
    end

    subtitles = {
      "subtitles" => [
        {
          'start-timing' => '0:10.8',
          'end-timing' => '020.6',
          'text' => 'Hello World'
        }
      ]
    }

    assert_raises Subtitler::ParseException do
      Subtitler.parse(subtitles.to_json)
    end
  end

  def test_generates_url
    subtitles = {
      "subtitles" => [
        {
          'start-timing' => '0:10.8',
          'end-timing' => '0:13.3',
          'text' => 'Hello World'
        },
        {
          'start-timing' => '0:16.2',
          'end-timing' => '0:20.6',
          'text' => 'this is the subtitles tool'
        }
      ]
    }
    url = Subtitler.addSubtitlesToVideo "candidate-evaluation", "The_Present", subtitles.to_json
    assert_equal "https://res.cloudinary.com/candidate-evaluation/video/upload/v1545227210/l_text:arial_40:Hello World,so_10.8,eo_13.3/l_text:arial_40:this is the subtitles tool,so_16.2,eo_20.6/The_Present.mp4", url
  end
end
