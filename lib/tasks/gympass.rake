namespace :gympass do

  # Backup database to AWS
  task :backup => :environment do
    dateStr = DateTime.now.strftime('%Y-%m-%d')
    filename = "fastfit-backup-#{dateStr}.sql"
    filepath = Rails.root.join('tmp').join(filename)
    aws_path = dateStr.split('-').push(filename).join('/')

    # don't do this if already doing this
    # if !File.exists?(filepath)
    #   params = "-u #{ENV['MYSQL_USERNAME']} -p#{ENV['MYSQL_PASSWORD']} fastfit_prod > #{filepath}"
    #   `mysqldump #{params}`
    # end

    # WorkoutSystem::s3_bucket.objects[aws_path].write(WorkoutSystem::s3_options.merge(:file => Pathname.new(filepath)))
    # File.unlink(filepath)
  end

  task :upload, [:dirpath] => :environment do |args, arghash|
    dirpath = arghash[:dirpath]
    upload(Rails.root.join('tmp').join(dirpath), dirpath)
  end

  # Convert and import a movie
  # Upload them to S3
  task :import => :environment do
    perform('dummy')
  end

  def perform(dummy)
    dir = Rails.root.join('tmp')
    convert(dir, 'soccer.mp4', '640')
    upload(dir.join('640'), 'test/640')
  end

  # Reference Information
  # ffmpeg -y -framerate 24 -i 720/sintel_trailer_2k_%4d.png -i sintel_trailer-audio.flac -c:a aac -strict experimental -ac 2 -b:a 64k -ar 44100 -c:v libx264 -pix_fmt yuv420p -profile:v baseline -level 1.3 -maxrate 192K -bufsize 1M -crf 18 -r 10 -g 30 -f hls -hls_time 9 -hls_list_size 0 -s 320x180 ts/320x180.m3u8
  # ffmpeg -y -framerate 24 -i 720/sintel_trailer_2k_%4d.png -i sintel_trailer-audio.flac -c:a aac -strict experimental -ac 2 -b:a 64k -ar 44100 -c:v libx264 -pix_fmt yuv420p -profile:v baseline -level 2.1 -maxrate 500K -bufsize 2M -crf 18 -r 10 -g 30  -f hls -hls_time 9 -hls_list_size 0 -s 480x270 ts/480x270.m3u8
  # ffmpeg -y -framerate 24 -i 720/sintel_trailer_2k_%4d.png -i sintel_trailer-audio.flac -c:a aac -strict experimental -ac 2 -b:a 96k -ar 44100 -c:v libx264 -pix_fmt yuv420p -profile:v baseline -level 3.1 -maxrate 1M -bufsize 3M -crf 18 -r 24 -g 72 -f hls -hls_time 9 -hls_list_size 0 -s 640x360 ts/640x360.m3u8
  # ffmpeg -y -framerate 24 -i 720/sintel_trailer_2k_%4d.png -i sintel_trailer-audio.flac -c:a aac -strict experimental -ac 2 -b:a 96k -ar 44100 -c:v libx264 -pix_fmt yuv420p -profile:v main -level 3.2 -maxrate 2M -bufsize 6M -crf 18 -r 24 -g 72 -f hls -hls_time 9 -hls_list_size 0 -s 1280x720 ts/1280x720.m3u8

  def convert(movie_path, movie_name, width)
    require 'fileutils'
    require 'aws-sdk'

    movie_path_name = movie_path.join(movie_name)

    output_dir = movie_path.join(width)
    index_file = 'prog.m3u8'

    FileUtils.rm_rf output_dir if Dir.exists?(output_dir)
    Dir.mkdir(output_dir)

    # params = "-y -i #{movie_path} -pix_fmt yuv420p -profile:v baseline -level 2.1 -maxrate 1M -bufsize 2M -crf 18 -r 10 -g 30 -f hls -hls_time 9 -hls_list_size 0 #{output_dir}/prog.m3u8"
    params = "-y -i #{movie_path_name} -pix_fmt yuv420p -profile:v baseline -level 3.1 -maxrate 1M -bufsize 3M -crf 18 -r 24 -g 72 -f hls -hls_time 9 -hls_list_size 0 -s #{width}x360 #{output_dir.join(index_file)}"
    `ffmpeg #{params}`
  end


  # From: http://docs.aws.amazon.com/AmazonS3/latest/dev/UploadObjSingleOpRuby.html
  # require 'aws-sdk'
  # s3 = Aws::S3::Resource.new(region:'us-west-2')
  # obj = s3.bucket('bucket-name').object('key')
  # obj.upload_file('/path/to/source/file')

  def upload(source_dir, s3_dest_dir)
    require 'fileutils'
    require 'aws-sdk'

    s3 = Aws::S3::Resource.new(region:ENV['AWS_REGION'])

    Dir.foreach(source_dir) do |filename|
      #s3_bucket.objects["#{s3_dest_dir}/#{filename}"].write(s3_options('video/MP2T').merge(:file => Pathname.new(source_dir.join(filename))))

      if !filename.match(/^\./)
        obj = s3.bucket(ENV['AWS_BUCKET']).object("#{s3_dest_dir}/#{filename}")
        options = filename.match(/\.m3u8$/) ? s3_options('application/x-mpegURL') : s3_options('video/MP2T')
        obj.upload_file(source_dir.join(filename), options)
      end
    end
  end

  def s3_client
    @s3_client ||= Aws::S3::Client.new(region: ENV['AWS_REGION'])
  end

  def s3_bucket
    #@s3_bucket ||= AWS::S3.new(:access_key_id => ENV['AWS_S3_KEY'],
    #                               :secret_access_key => ENV['AWS_S3_SECRET']).buckets[ENV['AWS_S3_BUCKET']]
    @s3_bucket ||= Aws::S3.new(region: ENV['AWS_REGION']).buckets[ENV['AWS_S3_BUCKET']]
  end

  def s3_options(mime_type)
    {
        acl: :public_read,
        content_type: mime_type,
        cache_control: "max-age=#{1.week.to_i}"
    }
  end

end
