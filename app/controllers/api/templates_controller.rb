module Api
  class TemplatesController < ApiController
    respond_to :js

    def index
      render js: "var Template = function() { return `#{xml}` }"
    end

    # def show
    #   render js: "var Template = function() { return `#{xml}` }"
    # end

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
        d.formTemplate do |f|
          f.banner do |b|
            b.title 'GymPass TV'
            b.description 'Find gyms in your area.'
          end
          f.textField 'zipcode'
          f.footer do |ft|
            ft.row do |row|
              ft.button('tv-align' => 'center', 'id' => 'track') do |bu|
                bu.text 'Play'
              end
              ft.button('tv-align' => 'center', 'reload' => true) do |re|
                re.text 'Reload'
              end
            end
          end
        end
      end
    end
  end
end


