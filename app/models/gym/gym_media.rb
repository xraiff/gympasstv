module Gym
  class Stream < ActiveRecord::Base

    # allows Mass-Assignment
    # attr_accessible :id, :size, :mime_type, :is_animated, :width, :height, :path, :name

    def s3_url
      ENV['AWS_S3_URL']
    end

    def s3_bucket
      @s3_bucket ||= AWS::S3.new(:access_key_id => ENV['AWS_S3_KEY'],
                           :secret_access_key => ENV['AWS_S3_SECRET']).buckets[ENV['AWS_S3_BUCKET']]
    end

    def s3_key
      "#{path}/#{name}"
    end

    def s3_obj
      s3_bucket.objects[s3_key]
    end

    def bucket
      ENV['AWS_S3_BUCKET']
    end

    def basepath
      "#{s3_url}/#{bucket}"
    end

    def url
      "#{s3_url}/#{bucket}/#{path}/#{name}"
    end

    def self.movie_suffixes
      ['.mov', '.mp4', '.mpg', '.mpeg', '.m4a', '.h264', '.webm', '.avi', '.3gp', '.3g2', '.aac', '.ac3']
    end

    def s3_options
      {
          acl: :public_read,
          content_type: mime_type,
          cache_control: "max-age=#{1.week.to_i}"
      }
    end
  end
end
