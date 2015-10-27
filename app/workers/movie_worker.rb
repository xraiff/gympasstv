class MovieWorker
  include Sidekiq::Worker
  require 'fileutils'
  # require 'streamio-ffmpeg'

  def perform(dummy)
    dir = Rails.root.join('tmp')
    convert_and_upload(dir, 'soccer.mp4', 'test')
  end

  # Reference Information
  # ffmpeg -y -framerate 24 -i 720/sintel_trailer_2k_%4d.png -i sintel_trailer-audio.flac -c:a aac -strict experimental -ac 2 -b:a 64k -ar 44100 -c:v libx264 -pix_fmt yuv420p -profile:v baseline -level 1.3 -maxrate 192K -bufsize 1M -crf 18 -r 10 -g 30 -f hls -hls_time 9 -hls_list_size 0 -s 320x180 ts/320x180.m3u8
  # ffmpeg -y -framerate 24 -i 720/sintel_trailer_2k_%4d.png -i sintel_trailer-audio.flac -c:a aac -strict experimental -ac 2 -b:a 64k -ar 44100 -c:v libx264 -pix_fmt yuv420p -profile:v baseline -level 2.1 -maxrate 500K -bufsize 2M -crf 18 -r 10 -g 30  -f hls -hls_time 9 -hls_list_size 0 -s 480x270 ts/480x270.m3u8
  # ffmpeg -y -framerate 24 -i 720/sintel_trailer_2k_%4d.png -i sintel_trailer-audio.flac -c:a aac -strict experimental -ac 2 -b:a 96k -ar 44100 -c:v libx264 -pix_fmt yuv420p -profile:v baseline -level 3.1 -maxrate 1M -bufsize 3M -crf 18 -r 24 -g 72 -f hls -hls_time 9 -hls_list_size 0 -s 640x360 ts/640x360.m3u8
  # ffmpeg -y -framerate 24 -i 720/sintel_trailer_2k_%4d.png -i sintel_trailer-audio.flac -c:a aac -strict experimental -ac 2 -b:a 96k -ar 44100 -c:v libx264 -pix_fmt yuv420p -profile:v main -level 3.2 -maxrate 2M -bufsize 6M -crf 18 -r 24 -g 72 -f hls -hls_time 9 -hls_list_size 0 -s 1280x720 ts/1280x720.m3u8

  def convert_and_upload(movie_path, movie_name, dest_path)
    movie_path_name = movie_path.join(movie_name)

    width = '640'
    output_dir = movie_path.join(width)

    # params = "-y -i #{movie_path} -pix_fmt yuv420p -profile:v baseline -level 2.1 -maxrate 1M -bufsize 2M -crf 18 -r 10 -g 30 -f hls -hls_time 9 -hls_list_size 0 #{output_dir}/prog.m3u8"
    params = "-y -i #{movie_path_name} -pix_fmt yuv420p -profile:v baseline -level 3.1 -maxrate 1M -bufsize 3M -crf 18 -r 24 -g 72 -f hls -hls_time 9 -hls_list_size 0 -s #{width}x360 #{output_dir.join('prog.m3u8')}"
    `ffmpeg #{params}`

    s3_bucket.objects["#{dest_path}/#{movie_name}"].write(image.s3_options.merge(:file => Pathname.new(movie_path_name)))
  end

  def s3_bucket
    @s3_bucket ||= AWS::S3.new(:access_key_id => ENV['AWS_S3_KEY'],
                               :secret_access_key => ENV['AWS_S3_SECRET']).buckets[ENV['AWS_S3_BUCKET']]
  end

  def s3_options
    {
        acl: :public_read,
        content_type: mime_type,
        cache_control: "max-age=#{1.week.to_i}"
    }
  end

  def upload(streamdir)

  end

end
