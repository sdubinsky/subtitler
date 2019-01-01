# Subtitler

This is a gem created to generate urls for the CLoudinary API to add subtitles to a previously uploaded video based on a given json-formatted subtitles file.

There is one file, `lib/subtitler.rb`.  It contains a class with one public method, `addSubtitlestoVideo`.  Pass it the `cloud_name`, `video_id`, and the json containing the subtitles.  If there are any issues in your JSON, it will throw an exception.  Numbers must be formatted as `\d:\d\d.\d`.
