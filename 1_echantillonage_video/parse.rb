require 'open-uri'
require 'json'
require 'streamio-ffmpeg' # Remember to install first ffmpeg with apt-get install ffmpeg or brew install ffmpeg

# First we fetch the idDiffusion of the France TV video
def getIdDiffusion(url)
  html = open(url)
  res = html.read
  # The id is in the URL of the content
  idDiffusion = /videos.francetv.fr\/video\/(\d*)/.match(res)
  idDiffusion[1]
end

# Then we fetch the TS playlists for our content
def getTsPlaylist(idDiffusion)
  url = "http://sivideo.webservices.francetelevisions.fr/tools/getInfosOeuvre/v2/?idDiffusion=#{idDiffusion}&catalogue=Info-web&callback=_jsonp_loader_callback_request_0"
  html = open(url)
  res = html.read
  # We have to fetch the JSON result from the webservice, without the Javascript around it
  json = '{'+res.split('{')[1..-1].join('{').split('}')[0..-2].join('}')+'}'
  JSON.parse(json)['videos'].each do |video|
    if video['format'] == 'm3u8-download'
      url = video['url']
    end
  end
  html = open(url)
  # The best video quality is at the last line of the file
  html.readlines[-1..-1][0]
end

def getTsStreams(tsPlaylist)
  html = open(tsPlaylist)
  res = html.read
  tsStreams = res.scan(/^(http:.*)$/)
end


# Full Example
url = 'http://www.francetvinfo.fr/replay-jt/france-2/20-heures/jt-de-20h-du-jeudi-29-decembre-2016_1981905.html'
streams = getTsStreams(getTsPlaylist(getIdDiffusion(url)))

streams.each_with_index do |stream, index|
  index_format = format('%05d', index)
  tmp_streamfile = open("tmp/import/tmp_streamfile_#{index_format}.mp4", 'wb')  do |file|
    open(streams[index][0]) do |uri|
      file.write(uri.read)
    end
  end
  video = FFMPEG::Movie.new("tmp/import/tmp_streamfile_#{index_format}.mp4")
  # We want to get 1 screenshot every 0.5 seconds, that is a screenshot with fps=1/0.5=2
  fps = 2
  video.screenshot("tmp/export/screenshots_#{index_format}_%05d.jpg", { vframes: video.duration.to_i*fps, frame_rate: fps }, validate: false)
end