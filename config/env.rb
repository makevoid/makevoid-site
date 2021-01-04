require 'bundler'

Encoding.default_internal = Encoding::UTF_8
Encoding.default_external = Encoding::UTF_8

Bundler.require :default

path = File.expand_path '../../', __FILE__
PATH = path
APP_PATH = path

APP_ENV = ENV["RACK_ENV"] || "development"

Oj.default_options = { mode: :object }

require_relative '../lib/env'
Env.load!
GITHUB_TOKEN = Env["GITHUB_TOKEN"]
MIXPANEL_TOKEN = Env["MIXPANEL_TOKEN"]

MIX = Mixpanel::Tracker.new MIXPANEL_TOKEN

require 'tilt/kramdown'
module Haml::Filters
  remove_filter("Markdown")
  register_tilt_filter "Markdown", :template_class => Tilt::KramdownTemplate
end

require "graphql/client/http"
require_relative '../lib/cache'
require_relative '../lib/gh'
