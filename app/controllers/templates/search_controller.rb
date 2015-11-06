module Templates
  class SearchController < TemplatesController
    respond_to :js

    def index
      baseurl = "http://localhost:3000"
      results = [{:img => "#{baseurl}/assets/umc_logo3.png", :movie => true, :title => 'Title 1'},
                {:img => "#{baseurl}/assets/GymPassTv_logo.jpg", :title => 'Title 2'},
                {:img => "#{baseurl}/assets/scooby1.jpg", :title => 'Scooby User', :link => 'https://www.youtube.com/user/scooby1961'},
                {:img => "#{baseurl}/assets/scooby2.jpg", :title => 'Scooby Channel', :link => 'https://www.youtube.com/channel/UC1XHNZDn3btv7454Pkz7THg'},
                {:img => "#{baseurl}/assets/scooby3.jpg", :title => 'Scooby Video', :link => 'https://www.youtube.com/watch?v=mRznU6pzez0'},
                {:img => "#{baseurl}/assets/movie_3.lcr", :title => 'Title 3'},
                {:img => "#{baseurl}/assets/movie_4.lcr", :title => 'Title 4'},
                {:img => "#{baseurl}/assets/movie_5.lcr", :title => 'Title 5'},
                {:img => "#{baseurl}/assets/movie_6.lcr", :title => 'Title 6'},
                {:img => "#{baseurl}/assets/movie_7.lcr", :title => 'Title 7'}]
      render js: "var Template = function() { return `#{xml(results)}` }"
    end

    protected

    # col.list(:class => 'suggestionListLayout') do |li|
    #   li.section do |s|
    #     # s.header do |h|
    #     #   h.title 'Suggestions'
    #     # end
    #     s.listItemLockup(:value => 'grid', :id => 'play', :class => 'play', 'data' => 'track') do |lil|
    #       lil.title 'Play'
    #     end
    #     s.listItemLockup(:id => 'reload', :class => 'reload') do |lil2|
    #       lil2.title 'Reload'
    #     end
    #   end
    # end

    def xml(results)
      xml = Builder::XmlMarkup.new( :indent => 2)
      xml.instruct!
      xml.document do |d|
        d.head do |h|
          h.style  '.longDescriptionLayout { max-width: 1280; }'
        end
        d.searchTemplate do |f|
          f.searchField('Enter Zipcode', :keyboardType => 'numberPad', :id => 'zipcode')
          f.collectionList do |col|
            col.shelf do |sh|
              sh.header do |h|
                h.title 'Results'
              end
              sh.section do |sec|
                results.each do |result|
                  if result[:movie]
                    blob = {title: "UMC Bootcamps",
                        subtitle: "no workout is the same",
                        description: "",
                        artworkImageURL: "",
                        contentRatingDomain: "movie",
                        contentRatingRanking: 400,
                        url: "https://s3.amazonaws.com/gympasstv/umc/640/prog.m3u8" }
                    sec.lockup(:class => 'play', :data => blob.to_json) do |lck|
                      lck.img(:src => result[:img], :width => 500, :height => 281)
                      lck.title result[:title]
                    end
                  elsif result[:link]
                    sec.lockup(:class => 'link', :data => result[:link]) do |lck|
                      lck.img(:src => result[:img], :width => 500, :height => 281)
                      lck.title result[:title]
                    end
                  else
                    sec.lockup do |lck|
                      lck.img(:src => result[:img], :width => 350, :height => 520)
                      lck.title result[:title]
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end


