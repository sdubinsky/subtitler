require 'minitest/autorun'
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
    subtitles = [
      {
        'start-timing' => '0:10.8',
        'text' => 'Hello World'
      }
    ]

    assert_raises Subtitler::ParseException do
      Subtitler.validate(subtitles)
    end

    subtitles = [
      {
        'start-timing' => '0:10.8',
        'end-timin' => '0:20.6',
        'text' => 'Hello World'
      }
    ]

    assert_raises Subtitler::ParseException do
      Subtitler.validate(subtitles)
    end

    subtitles = [
      {
        'start-timing' => '0:10.8',
        'end-timing' => '020.6',
        'text' => 'Hello World'
      }
    ]

    assert_raises Subtitler::ParseException do
      Subtitler.validate(subtitles)
    end
  end

  
end
