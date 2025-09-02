require 'net/https'
require 'bundler'

Encoding.default_internal = Encoding::UTF_8
Encoding.default_external = Encoding::UTF_8

Bundler.require :default

path = File.expand_path '../../', __FILE__
PATH = path
APP_PATH = path

APP_ENV = ENV["RACK_ENV"] || "development"

Oj.default_options = { mode: :object }

require_relative '../lib/env_lib'
Env.load!

# Simple GitHub token loading with specific backup file
def load_github_token
  # 1. Check environment variable first
  token = ENV["GITHUB_TOKEN"]
  return token if token && !token.empty?
  
  # 2. Check .env files
  Env.load! unless defined?(@@env)
  token = @@env["GITHUB_TOKEN"] if defined?(@@env) && @@env
  return token if token && !token.empty?
  
  # 3. Check backup file ~/.github_token_readonly
  backup_file = File.expand_path("~/.github_token_readonly")
  if File.exist?(backup_file)
    return File.read(backup_file).strip
  end
  
  nil
end

GITHUB_TOKEN = load_github_token
MIXPANEL_TOKEN = Env["MIXPANEL_TOKEN"]

# https://youtu.be/<video_id>

VIDEO_IDS = %w(
  JftGnxQI8pI
  YyzI6U4-5VM
  KTTb6DYP8ew
  Y2fO8eD4nvY
  2Knh8DQogaA
  vYThRYmdRW0
  6Kt9tuQlNLw
)

# append new videos to add them

MIX = Mixpanel::Tracker.new MIXPANEL_TOKEN

# require 'tilt/kramdown'
# module Haml::Filters
#   remove_filter("Markdown")
#   register_tilt_filter "Markdown", :template_class => Tilt::KramdownTemplate
# end

require "graphql/client/http"
require_relative '../lib/monkeypatches'
require_relative '../lib/cache'
require_relative '../lib/gh'
require_relative '../lib/icon'
require_relative '../lib/social'
