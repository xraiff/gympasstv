module Templates
  class HomeController < TemplatesController
    respond_to :js

    def index
      render js: "var Template = function() { return `#{xml}` }"
    end

    protected

    # "<?xml version='1.0' encoding='UTF-8' ?>
    #   <document>
    #     <head>
    #       <style>
    #         .longDescriptionLayout {
    #           max-width: 1280;
    #         }
    #       </style>
    #     </head>
    #     <formTemplate>
    #       <banner>
    #         <title>Title</title>
    #         <description class='longDescriptionLayout'>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</description>
    #       </banner>
    #       <textField>Placeholder text</textField>
    #       <footer>
    #         <button>
    #           <text>Button text</text>
    #         </button>
    #       </footer>
    #     </formTemplate>
    #   </document>"

    def xml
      xml = Builder::XmlMarkup.new( :indent => 2)
      xml.instruct!
      xml.document do |d|
        d.head do |h|
          h.style  '.longDescriptionLayout { max-width: 1280; }'
        end
        d.formTemplate(:id => 'zipform}') do |f|
          f.banner do |b|
            b.img(:src => 'http://localhost:3000/assets/GymPassTv_logo.jpg')
            b.description 'Find gyms in your area.'
          end
          f.textField('Enter Zipcode', :id => 'zipcode', :keyboardType => 'numberPad')
          f.footer do |ft|
            ft.button('tv-align' => 'center', 'class' => 'search', 'data' => 'track', ) do |bu|
              bu.text 'Search'
            end
          end
        end
      end
    end

    def xmlOld
      xml = Builder::XmlMarkup.new( :indent => 2)
      xml.instruct!
      xml.document do |d|
        d.head do |h|
          h.style  '.longDescriptionLayout { max-width: 1280; }'
        end
        d.formTemplate(:id => 'zipform}') do |f|
          f.banner do |b|
            b.img(:src => 'http://localhost:3000/assets/GymPassTv_logo.jpg')
            b.description 'Find gyms in your area.'
          end
          f.textField('Enter Zipcode', :id => 'zipcode', :keyboardType => 'numberPad')
          f.collectionList do |col|
            col.list(:class => 'suggestionListLayout') do |li|
              li.section do |s|
                # s.header do |h|
                #   h.title 'Suggestions'
                # end
                s.listItemLockup(:value => 'grid', :id => 'play', :class => 'play', 'data' => 'track') do |lil|
                  lil.title 'Play'
                end
                s.listItemLockup(:id => 'reload', :class => 'reload') do |lil2|
                  lil2.title 'Reload'
                end
              end
            end
          end
        end
      end
    end

  end
end


