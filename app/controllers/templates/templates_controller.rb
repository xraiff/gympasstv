module Templates
  class TemplatesController < ApplicationController

    helper_method :ios_request?

    def ios_request?
      request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(iPhone)|(iPod)|(iPad).*/]
    end

    def safari_request?
      request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Safari).*/]
    end

    protected
  end
end
