require_relative 'config/env'
require_relative 'lib/roda_utils'
require_relative 'lib/view_helpers'

class App < Roda
  plugin :render, engine: 'haml'
  plugin :multi_route
  plugin :partials
  plugin :all_verbs
  plugin :not_found
  plugin :error_handler
  plugin :public
  plugin :json
  plugin :json_parser


  include RodaUtils
  include ViewHelpers

  route do |r|
    r.root {
      # TODO: use sucker-punch or async
      Thread.new { MIX.track 'anonymous', 'homepage-visit' }

      view 'index'
    }

    r.on("health") {
      r.get {
        { status: "ok" }
      }
      r.head {
        { status: "ok" }
      }
    }

    r.get("videos") {
      Thread.new { MIX.track 'anonymous', 'videos-page-visit' }
      view 'videos'
    }

    r.public if ENV["SERVE_ASSETS"] == "1" || APP_ENV != "production"
  end

  not_found do
    view "not_found"
  end

  error do |err|
    case err
    when nil
      # catch a proper error...
    #
    # when CustomError
    #   "ERR" # like so
    else
      raise err
    end
  end

  freeze

end
