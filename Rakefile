require_relative 'config/env'
require 'pp'

task :deploy do
  # use new docker swarm rake based deployment
end

desc 'Run app with rerun'
task :run do
  sh "rerun -p \"**/*.{rb}\" -- bundle exec rackup"
end

desc "Dump graphql schema to json"
task :graphql_dump do
  GraphQL::Client.dump_schema GH::HTTP, "data/github_schema.json"
end

desc "Repos test call"
task :repos do
  repos = GH.repos
  pp repos
end

def basic_auth
  user, pass = Env["RANCHER_ACCESS_KEY"], Env["RANCHER_SECRET_KEY"]
  "Basic #{["#{user}:#{pass}"].pack("m*").gsub /\n/, ''}"
end

def get(url)
  uri = URI url
  req = Net::HTTP::Get.new uri
  req['Authorization'] = basic_auth
  resp = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }
  Oj.load resp.body
end

def post(url, params)
  params = Oj.dump params
  uri = URI url
  req = Net::HTTP::Post.new uri
  req.body = params
  req["Content-Type"]  = "application/json"
  req['Authorization'] = basic_auth
  resp = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }
  resp = Oj.load resp.body
  resp
end
