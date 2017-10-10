# Modèle des streams France TV Pluzz
require 'open-uri'
require 'json'
require 'streamio-ffmpeg'

class Streams::Pluzz < Stream

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

  def extract(video)
    video.clear_images
    Dir.mkdir(Rails.root.join('public', 'export', video.id.to_s))
    url = video.url
    streams = getTsStreams(getTsPlaylist(getIdDiffusion(url)))
    streams.each_with_index do |stream, index|
      index_format = format('%05d', index)
      streamfile_path = Rails.root.join('tmp', 'import', "tmp_streamfile_#{index_format}.mp4").to_s
      # Ecriture du fichier
      tmp_streamfile = open(streamfile_path, 'wb')  do |file|
        open(stream[0]) do |uri|
          file.write(uri.read)
        end
      end
      movie = FFMPEG::Movie.new(streamfile_path)
      # We want to get 1 screenshot every 0.5 seconds, that is a screenshot with fps=1/0.5=2
      fps = 2
      screenshot_path = Rails.root.join('public', 'export', video.id.to_s, "screenshots_#{index_format}_%05d.jpg").to_s
      movie.screenshot(screenshot_path, { vframes: movie.duration.to_i*fps, frame_rate: fps }, validate: false)
    end
    # Ajout des images
    images_hash = Dir[Rails.root.join('public', 'export', video.id.to_s, "screenshots_*.jpg").to_s].map do |screenshot|
      {filename: screenshot, video: video}
    end
    Image.create(images_hash)
  end
end